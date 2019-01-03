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
function Covert:write(path)
	local file=io.open(path,"w+")
	self:writeLine(file,"<?xml version=\"1.0\" encoding=\"utf-8\"?>")
	self:writeLine(file,"<Profile>")
	self:writeLine(file,"\t<IgnoreZAxis />")

	self:writeLine(file,"\t<Hotspots>")
	for i,v in ipairs(self.waypoints) do
		local t=self:split(v," ")
		self:writeLine(file,"\t\t<Hotspot>")
		self:writeLine(file,"\t\t\t<X>"..t[1].."</X>")
		self:writeLine(file,"\t\t\t<Y>"..t[2].."</Y>")
		self:writeLine(file,"\t\t\t<Z>0</Z>")
		self:writeLine(file,"\t\t\t<Type>Hotspot</Type>")
		self:writeLine(file,"\t\t</Hotspot>")
	end
	self:writeLine(file,"\t</Hotspots>")

	if #self.ghostwaypoints>0 then
		self:writeLine(file,"\t<GhostHotspots>")
		for i,v in ipairs(self.ghostwaypoints) do
			local t=self:split(v," ")
			self:writeLine(file,"\t\t<GhostHotspot>")
			self:writeLine(file,"\t\t\t<X>"..t[1].."</X>")
			self:writeLine(file,"\t\t\t<Y>"..t[2].."</Y>")
			self:writeLine(file,"\t\t\t<Z>0</Z>")
			self:writeLine(file,"\t\t\t<Type>Hotspot</Type>")
			self:writeLine(file,"\t\t</GhostHotspot>")
		end
		self:writeLine(file,"\t</GhostHotspots>")
	end

	if #self.mods>0 then
		self:writeLine(file,"\t<Factions>")
		local factions=self:split(self.mods," ")
		for i,v in ipairs(factions) do
			self:writeLine(file,"\t\t<Faction>"..v.."</Faction>")
		end
		self:writeLine(file,"\t</Factions>")
	end
	self:writeLine(file,"</Profile>")
	file:close()

end
function Covert:covert( filein,fileout )
	-- body
	local input=self:read(filein)
	self.mods=string.match(input,'<Factions>(.*)</Factions>')
	-- if not self.mods or self.mods=="" then
	-- 	self.mods="0"
	-- end
	self.waypoints = {}
	self.ghostwaypoints = {}
	local p=string.gmatch(input,'<Waypoint>([^<]+)')
	local g=string.gmatch(input,'<GhostWaypoint>([^<]+)')
	for i in p do
		self.waypoints[#self.waypoints+1]=i
	end
	for i in g do
		self.ghostwaypoints[#self.ghostwaypoints+1]=i
	end
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