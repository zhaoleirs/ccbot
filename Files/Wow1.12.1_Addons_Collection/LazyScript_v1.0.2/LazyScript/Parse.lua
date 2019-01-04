lazyScript.metadata:updateRevisionFromKeyword("$Revision: 716 $")

function lazyScript.negWrapper(maskFunc, negate)
   if not negate then
      return maskFunc
   end

   return function(sayNothing)
      local maskResult = maskFunc(sayNothing)
      return ((maskResult and not negate) or (not maskResult and negate))
   end
end

-- returns a special mask group:  Returns true if any of the given masks are true (an "OR").
-- however if negate is true, then returns true only if ALL of then given masks are false ("AND")
function lazyScript.orWrapper(masks, negate)
   if table.getn(masks) == 1 then
      return lazyScript.negWrapper(masks[1], negate)
   end

   return function(sayNothing)
             if (not negate) then
                for idx, mask in ipairs(masks) do
                   if (mask(sayNothing)) then
                      return true
                   end
                end
                return false
             else
                for idx, mask in ipairs(masks) do
                   if (mask(sayNothing)) then
                      return false
                   end
                end
                return true
             end
          end
end

-- to make the player's life easier, we'll go ahead and escape certain words
-- that we know have dashes in them.
function lazyScript.EscapeKnownDashedWords(line)
   local knownDashedWords = {
      "Mind-numbing Poison",
      "Anti-Venom",
   }
   for idx, word in ipairs(knownDashedWords) do
      local percentEscapedWord = string.gsub(word, "%-", "%%-")
      local slashEscapedWord = string.gsub(word, "%-", "\\-")
      line = string.gsub(line, percentEscapedWord, slashEscapedWord)
   end
   return line
end

function lazyScript.ParseLine(line)
   local bits = lazyScript.split(line, "%-")

   local actions = {}
   local masks = {}

   for idx, bit in ipairs(bits) do
      bit = string.gsub(bit, "\\%-", "-")  -- unescape escaped '-'s

      local target = ""
      if (lazyScript.rebit(bit, "(.*)@([%a%d]+)")) then
         bit = lazyScript.match1
         target = lazyScript.match2
      end

      local rank
      if (lazyScript.rebit(bit, "(.*)%(rank(%d+)%)")) then
         bit = lazyScript.match1
         rank = tonumber(lazyScript.match2)
      end

      local foundBit = false
      for key, bitParser in pairs(lazyScript.bitParsers) do
         local bitResult = bitParser(bit, actions, masks)
         if (bitResult) then
            -- success
            foundBit = true
            break
         elseif (bitResult == nil) then
            -- syntax error
            lazyScript.p("Syntax error found in: "..bit)
            return nil
         end
      end

      -- Did not find a bitParser, is it an action?
      if (not foundBit) then
         relaxedBit = lazyScript.relax(bit)
         for key, action in pairs(lazyScript.actions) do
            if (lazyScript.relax(key) == relaxedBit) then
               table.insert(actions, action)
               foundBit = true
               break
            end
         end
      end

      if (not foundBit) then
         lazyScript.p("Syntax error: cannot parse bit: "..bit)
         return nil
      end

      if target == "self" then
         target = "player"
      end

      if (target ~= "" and (not lazyScript.validateUnitId(target))) then
         lazyScript.p("The UnitId '"..target.."' is not valid.")
         return nil
      end

      if rank then
         local lastActionObj = actions[table.getn(actions)]
         local rankAction = lazyScript.castSpellByRankActions[lastActionObj.code..rank.."@"..target]
         if not rankAction then
            local spellIndexStart, rankCount, maxRank = lastActionObj:FindSpellRanks(sayNothing)
            if not maxRank then
               lazyScript.p("It is not possible to specify a rank for "..lastActionObj.name..".")
               return nil
            elseif (rankCount ~= maxRank) and (rank ~= maxRank) then
               lazyScript.p("You can only use the maximum rank of "..lastActionObj.name..".")
               return nil
            end

            if rank <1 or rank > maxRank then
               lazyScript.p("Rank "..rank.." exceeds maximum of "..maxRank.." for "..lastActionObj.name.." or is invalid.")
               return nil
            end
            rankAction = lazyScript.CastSpellByRankAction:New(lastActionObj, rank, target)
         end
         table.remove(actions, table.getn(actions))
         table.insert(actions, rankAction)

      elseif (not rank) and target ~= "" then
         local lastActionObj = actions[table.getn(actions)]
         local rankAction = lazyScript.castSpellByRankActions[lastActionObj.code.."@"..target]

         if not rankAction then
            local spellIndexStart, rankCount, maxRank = lastActionObj:FindSpellRanks(sayNothing)

            -- For spells that have no rank
            if not maxRank then
               maxRank = 1
            end

            rankAction = lazyScript.CastSpellByRankAction:New(lastActionObj, maxRank, target)
         end
         table.remove(actions, table.getn(actions))
         table.insert(actions, rankAction)
      end
   end

   lazyScript.d("Parsed "..table.getn(actions).." actions and "..table.getn(masks).." masks")

   -- Filter out nil masks which may exist due to errors
   local i = 1
   while i <= table.getn(masks) do
      local mask = masks[i]
      if mask == nil then
         lazyScript.p("WARNING! A 'nil' mask was found when parsing the form line \""..line.."\". This may be due to LazyScript being incompatible with your class' Lazy-addon or it may be a legitimate bug. Please report this error and the full form line to lazytest@googlegroups.com.")
         table.remove(masks, i)
      else
         i = i + 1
      end
   end

   -- Remove duplicate masks
   local origMaskCount = table.getn(masks)
   local seenMasks = {}
   local i = 1
   while i <= table.getn(masks) do
      local mask = masks[i]
      if seenMasks[mask] then
         table.remove(masks, i)
      else
         seenMasks[mask] = true
         i = i + 1
      end
   end

   if origMaskCount - table.getn(masks) > 0 then
      lazyScript.d("Removed "..(origMaskCount - table.getn(masks)).." duplicate masks.")
   end

   -- Check that we only have one action which triggers the global cooldown
   local triggerActions = 0
   local printTrigger
   if table.getn(actions) > 1 then
      for _, actionObj in ipairs(actions) do
         if (actionObj.triggersGlobal) then printTrigger = "true" elseif (not actionObj.triggersGlobal) then printTrigger = "false" else printTrigger = "nil" end
         lazyScript.d("Action: "..actionObj.code..", TriggersGlobal: "..printTrigger)
         if (actionObj.triggersGlobal) then
            triggerActions = triggerActions + 1
            if triggerActions > 1 then
               lazyScript.p("Syntax error: cannot have multiple actions that activate the global cooldown in the same line.")
               return nil
            end
         end
      end
   end

   return { actions, masks }

end

function lazyScript.ParseForm(formName, lines)
   local totalMaskCount = 0
   local actions = {}
   local dependencies = {}
   for idx, line in ipairs(lines) do
      -- remove comments: # .... or // .... or -- ....
      -- trim leading/trailing whitespace
      -- ignore blank lines
      line = string.gsub(line, "#.*", "")
      line = string.gsub(line, "//.*", "")
      line = string.gsub(line, "%-%-.*", "")
      line = string.gsub(line, "^%s+", "")
      line = string.gsub(line, "%s+$", "")

      -- If the line wasn't just a comment, parse it
      if (line ~= "") then
         line = lazyScript.EscapeKnownDashedWords(line)

         -- Check for includeForm
         if lazyScript.rebit(line, "^includeForm=(.+)$") then
            local includeFormName = lazyScript.match1

            if includeFormName == formName then
               lazyScript.p(formName..": Cannot include form "..includeFormName.." in itself!")
               return nil
            end

            if not lazyScript.FindForm(includeFormName) then
               lazyScript.p(formName..": Could not include form "..includeFormName.." because it does not exist!")
               return nil
            end

            lazyScript.d(formName..": Including form: "..includeFormName)
            local parsedForm = lazyScript.FindParsedForm(includeFormName, false)
            if not parsedForm then
               lazyScript.p(formName..": Could not include form "..includeFormName.." because it contains errors!")
               return nil
            end
            for _, parsedLine in ipairs(parsedForm) do
               table.insert(actions, parsedLine)
               totalMaskCount = totalMaskCount + table.getn(parsedLine[2])
            end

            table.insert(dependencies, includeFormName)
         else
            -- Run it through bitParsers
            local parsedLine = lazyScript.ParseLine(line)
            if (not parsedLine) then
               lazyScript.p(formName..": Could not parse form line: "..line)
               return nil
            else
               table.insert(actions, parsedLine)
               totalMaskCount = totalMaskCount + table.getn(parsedLine[2])
            end
         end
      end
   end
   lazyScript.d(formName..": Total masks: "..totalMaskCount)

   -- Optimization hack: Trigger the caching of slots and spell indexes on actions which have
   -- them, so that the searching for slot/spell index doesn't lag the first execution of the
   -- form in combat.
   for idx, actionLine in ipairs(actions) do
      for idx, action in ipairs(actionLine[1]) do
         if action.GetSlot ~= nil then
            action:GetSlot(true)
         end
         if action.FindSpellRanks ~= nil then
            action:FindSpellRanks(true)
         end
      end
   end

   return actions, dependencies
end

function lazyScript.FindForm(formName)
   if (not formName) then
      return nil
   end
   for thisFormName, actions in pairs(lazyScript.perPlayerConf.forms) do
      if (thisFormName == formName) then
         return actions
      end
   end
   return nil
end

-- speed optimization, skip parsing and regexes every time
function lazyScript.FindParsedForm(formName, noParse)
   if (not formName) then
      return nil
   end
   local startTime = GetTime()
   if (lazyScript.parsedFormCache[formName] == nil) then
      if (not noParse) then
         local actions = lazyScript.FindForm(formName)
         if (actions) then
            lazyScript.d("Parsing form "..formName)
            local parsedForm, dependencies = lazyScript.ParseForm(formName, actions)
            lazyScript.parsedFormCache[formName] = parsedForm
            lazyScript.parsedFormDependencies[formName] = dependencies
            lazyScript.ReparseDependentForms(formName)
         end
      else
         return nil
      end
   end
   --lazyScript.d("FindParsedForm: time: "..string.format("%f", (GetTime() - startTime)).."s")
   return lazyScript.parsedFormCache[formName]
end

function lazyScript.ClearParsedForm(formName)
   lazyScript.parsedFormCache[formName] = nil
   lazyScript.parsedFormDependencies[formName] = nil
end

-- Find forms which depend on the given form name and reparse them
-- Returns a table of the form names which were reparsed
function lazyScript.ReparseDependentForms(formName)
   local reparsed = {}
   for eachFormName, dependencies in pairs(lazyScript.parsedFormDependencies) do
      if eachFormName ~= formName and dependencies ~= nil then
         for _, dependency in ipairs(dependencies) do
            if dependency == formName then
               lazyScript.d("Reparsing form "..eachFormName.." which depends on form "..formName)
               lazyScript.ClearParsedForm(eachFormName)
               lazyScript.FindParsedForm(eachFormName, false)
               table.insert(reparsed, eachFormName)
               break
            end
         end
      end
   end
   return reparsed
end


-- Find forms which depend on the given form name and remove them from the parsedFormCache
-- Returns a table of the form names which were cleared
function lazyScript.ClearDependentForms(formName)
   local cleared = {}
   for eachFormName, dependencies in pairs(lazyScript.parsedFormDependencies) do
      if eachFormName ~= formName and dependencies ~= nil then
         for _, dependency in ipairs(dependencies) do
            if dependency == formName then
               lazyScript.d("Clearing cache for form "..eachFormName.." which depends on form "..formName)
               lazyScript.ClearParsedForm(eachFormName)
               table.insert(cleared, eachFormName)
               break
            end
         end
      end
   end
   return cleared
end
