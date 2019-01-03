local filein=...
local fileout = "wrobot_"..filein
local Covert = {}
function Covert:read(path)
	local file=io.open(path)
	local content=file:read("*a")
	file:close()
	return content
end
function Covert:writeLine(file,content)
	file:write(content)
	file:write("\n")
end
function Covert:split(s, delim)
    if type(delim) ~= "string" or string.len(delim) <= 0 then
        return
    end

    local start = 1
    local t = {}
    while true do
    local pos = string.find (s, delim, start, true) -- plain find
        if not pos then
          break
        end

        table.insert (t, string.sub (s, start, pos - 1))
        start = pos + string.len (delim)
    end
    table.insert (t, string.sub (s, start))

    return t
end
function Covert:write(path)
	local file=io.open(path,"w+")
	self:writeLine(file,"<?xml version=\"1.0\" encoding=\"utf-8\"?>")
	self:writeLine(file,"<Profile>")
	self:writeLine(file,"\t<IgnoreZAxis />")

	self:writeLine(file,"\t<Hotspots>")
	for i in self.hotspots do
		self:writeLine(file,"\t\t<Hotspot>")
		for ik,iv in string.gmatch(i,'(%w)=\"([^ ]+)\"') do
			self:writeLine(file,"\t\t\t<"..ik..">"..iv.."</"..ik..">")
		end
		self:writeLine(file,"\t\t\t<Type>Hotspot</Type>")
		self:writeLine(file,"\t\t</Hotspot>")
	end
	self:writeLine(file,"\t</Hotspots>")
		self:writeLine(file,"\t<Factions>")
		if self.mods then
			local factions=self:split(self.mods," ")
			for i,v in ipairs(factions) do
				self:writeLine(file,"\t\t<Faction>"..v.."</Faction>")
			end
		else
			self:writeLine(file,"\t\t<Faction>0</Faction>")
		end
		self:writeLine(file,"\t</Factions>")
	self:writeLine(file,"</Profile>")
	file:close()

end
function Covert:covert( filein,fileout )
	-- body
	local input=self:read(filein)
	self.hotspots=string.gmatch(input,'<Hotspot ([^/]+)')
	
	self:write(fileout)
end
Covert.covert(Covert,filein,fileout)

-- <?xml version="1.0" encoding="utf-8"?>
-- <Profile>
-- 	<IgnoreZAxis />
-- 	<Hotspots>
-- 		<Hotspot>
-- 			<!-- Pos: 29/65 -->
-- 			<X>1858.127</X>
-- 			<Y>1680.838</Y>
-- 			<Z>93.32436</Z>
-- 			<Type>Hotspot</Type>
-- 		</Hotspot>
-- 		<Hotspot>
-- 			<!-- Pos: 29/65 -->
-- 			<X>1858.127</X>
-- 			<Y>1680.838</Y>
-- 			<Z>93.32436</Z>
-- 			<Type>Hotspot</Type>
-- 		</Hotspot>
-- 		<Hotspot>
-- 			<!-- Pos: 29/65 -->
-- 			<X>1858.127</X>
-- 			<Y>1680.838</Y>
-- 			<Z>93.32436</Z>
-- 			<Type>Hotspot</Type>
-- 		</Hotspot>
-- 	</Hotspots>
-- 	<Factions>
-- 		<Faction>32</Faction>
-- 		<Faction>7</Faction>
-- 	</Factions>
-- </Profile>