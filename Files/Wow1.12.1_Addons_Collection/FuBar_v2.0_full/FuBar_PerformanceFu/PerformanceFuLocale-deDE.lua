local L = AceLibrary("AceLocale-2.2"):new("FuBar_PerformanceFu")

L:RegisterTranslations("deDE", function() return {
	["Show framerate"] = "Bildwiederholrate anzeigen",
	["Toggle whether to framerate"] = "Anzeige der Wiederholrate ein/ausschalten",
	["Show latency"] = "Latenz anzeigen",
	["Toggle whether to latency (lag)"] = "Anzeige der Latenz ein/ausschalten",
	["Show memory usage"] = "Speicherverbrauch anzeigen",
	["Toggle whether to show current memory usage"] = "Anzeige des aktuellen Speicherverbrauchs ein/ausschalten",
	["Show rate of increasing memory usage"] = "Ver\195\164nderung des Speicherverbrauchs anzeigen",
	["Toggle whether to show increasing rate of memory"] = "Anzeige der aktuellen Steigerung des Speicherverbrauchs ein/ausschalten",
	["Warn on garbage collection"] = "Warnung bei Abfallsammler",
	["Toggle whether to warn on an upcoming garbage collection"] = "Warnung vor Abfallsammler ein/ausschalten",
	["Force garbage collection"] = "Erzwinge Abfallsammler",
	["Force a garbage collection to happen"] = "Erzwinge die Durchf\195\188hrung der Abfallsammlung",
	["Garbage collection occurred"] = "Abfallsammler aktiviert",
	["Garbage collection in %s"] = "Abfallsammler in %s",
	["Framerate:"] = "Wiederholrate:",
	["Network status"] = "Netzwerkstatus",
	["Latency:"] = "Latenz:",
	["Bandwidth in:"] = "Eingehende Bandbreite:",
	["Bandwidth out:"] = "Ausgehende Bandbreite:",
	["Memory usage"] = "Speicherverbrauch",
	["Current memory:"] = "Aktueller Speicher:",
	["Initial memory:"] = "Speicher zu Beginn:",
	["Increasing rate:"] = "Aktuelle Steigerungsrate:",
	["Average increasing rate:"] = "Mittlere Steigerungsrate:",
	["Garbage collection"] = "Abfallsammler",
	["Threshold:"] = "Grenzwert",
	["Time to next:"] = "Zeit bis zum n\195\164chsten",
	
	["AceConsole-options"] = {"/perffu", "/performancefu"},
} end)