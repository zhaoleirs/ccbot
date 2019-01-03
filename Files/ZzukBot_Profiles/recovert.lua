local filein=...
local fileout = "zzuk_"..filein
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
function Covert:covert( filein,fileout )
	-- body
	local input=self:read(filein)
	local wp=string.match(input,'<Hotspots>(.*)</Hotspots>')
	local xs=string.gmatch(wp,'<X>(.-)</X>')
	local ys=string.gmatch(wp,'<Y>(.-)</Y>')
	local xsa={}
	local xya={}
	for x in xs do
		xsa[#xsa+1]=x
	end
	for y in ys do
		xya[#xya+1]=y
	end
	for i,v in ipairs(xsa) do
		print("<Waypoint>"..xsa[i].." "..xya[i].."</Waypoint>")
	end
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