local AceLocale = LibStub ("AceLocale-3.0")
local Loc = AceLocale:GetLocale ("Details_Threat")

local _GetNumSubgroupMembers = GetNumSubgroupMembers --> wow api
local _GetNumGroupMembers = GetNumGroupMembers --> wow api
local _UnitIsFriend = UnitIsFriend --> wow api
local _UnitName = UnitName --> wow api
--local _UnitDetailedThreatSituation = UnitDetailedThreatSituation
local _IsInRaid = IsInRaid --> wow api
local _IsInGroup = IsInGroup --> wow api
--local _UnitGroupRolesAssigned = DetailsFramework.UnitGroupRolesAssigned --> wow api
local GetUnitName = GetUnitName

local ANIMATION_TIME_DILATATION = 1.005321

local _UnitGroupRolesAssigned = function (unitId) 
	if (type (unitId) == "string") then
		local guid = UnitGUID (unitId)
		if (guid) then
			local playerSpec = Details.cached_specs [guid]
			if (playerSpec) then
				
				local role = Details:GetRoleFromSpec (playerSpec, guid) or "NONE"
				--print ("tt:24", "playerSpec", playerSpec, "role", role)
				return role
			end
		end
		return "NONE"
	end
end

local _DEBUG = true

local _ipairs = ipairs --> lua api
local _table_sort = table.sort --> lua api
local _cstr = string.format --> lua api
local _unpack = unpack
local _math_floor = math.floor
local _math_abs = math.abs
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

--> Create the plugin Object
local ThreatMeter = _detalhes:NewPluginObject ("Details_TinyThreat")
--> Main Frame
local ThreatMeterFrame = ThreatMeter.Frame

ThreatMeter:SetPluginDescription ("Small tool for track the threat you and other raid members have in your current target.")

--threat stuff from: https://github.com/EsreverWoW/ClassicThreatMeter by EsreverWoW
--EsreverWoW is MIA at the moment
--local ThreatLib = LibStub:GetLibrary ("ThreatClassic-1.0")

--threat stuff from: https://github.com/dfherr/LibThreatClassic2 by dfherr
local ThreatLib = LibStub:GetLibrary("LibThreatClassic2")

local _UnitThreatSituation = function (unit, mob)
    return ThreatLib:UnitThreatSituation (unit, mob)
end

local _UnitDetailedThreatSituation = function (unit, mob)
    return ThreatLib:UnitDetailedThreatSituation (unit, mob)
end

--[=
	local CheckStatus = function(...)
		--print (...)
	end

	ThreatLib:RegisterCallback("Activate", CheckStatus)
    ThreatLib:RegisterCallback("Deactivate", CheckStatus)
    ThreatLib:RegisterCallback("ThreatUpdated", CheckStatus)
    ThreatLib:RequestActiveOnSolo (true)
--]=]

local _

local function CreatePluginFrames (data)
	
	--> catch Details! main object
	local _detalhes = _G._detalhes
	local DetailsFrameWork = _detalhes.gump

	--> data
	ThreatMeter.data = data or {}
	
	--> defaults
	ThreatMeter.RowWidth = 294
	ThreatMeter.RowHeight = 14
	--> amount of row wich can be displayed
	ThreatMeter.CanShow = 0
	--> all rows already created
	ThreatMeter.Rows = {}
	--> current shown rows
	ThreatMeter.ShownRows = {}
	-->
	ThreatMeter.Actived = false
	
	--> localize functions
	ThreatMeter.percent_color = ThreatMeter.percent_color
	
	ThreatMeter.GetOnlyName = ThreatMeter.GetOnlyName
	
	--> window reference
	local instance
	local player
	
	--> OnEvent Table
	--when an event happens on Details and it triggers a callback on registered details events on this plugin
	function ThreatMeter:OnDetailsEvent (event, ...)
	
		if (event == "DETAILS_STARTED") then
			ThreatMeter:RefreshRows()
			
		elseif (event == "HIDE") then --> plugin hidded, disabled
			ThreatMeter.Actived = false
			ThreatMeter:Cancel()
		
		--the window hosting tiny threat is shown is shown
		elseif (event == "SHOW") then
		
			instance = ThreatMeter:GetInstance (ThreatMeter.instance_id)
			
			ThreatMeter.RowWidth = instance.baseframe:GetWidth()-6
			
			ThreatMeter:UpdateContainers()
			ThreatMeter:UpdateRows()
			
			ThreatMeter:SizeChanged()
			
			player = GetUnitName ("player", true)
			
			ThreatMeter.Actived = false

			if (ThreatMeter:IsInCombat() or UnitAffectingCombat ("player")) then
				--check if the plugin is already initialized
				if (not ThreatMeter.initialized) then
					return
				end
				ThreatMeter.Actived = true
				ThreatMeter:Start()
			end
		
		elseif (event == "COMBAT_PLAYER_ENTER") then
			if (not ThreatMeter.Actived) then
				ThreatMeter.Actived = true
				ThreatMeter:Start()
			end
		
		elseif (event == "DETAILS_INSTANCE_ENDRESIZE" or event == "DETAILS_INSTANCE_SIZECHANGED") then
		
			local what_window = select (1, ...)
			if (what_window == instance) then
				ThreatMeter:SizeChanged()
				ThreatMeter:RefreshRows()
			end
			
		elseif (event == "DETAILS_OPTIONS_MODIFIED") then
			local what_window = select (1, ...)
			if (what_window == instance) then
				ThreatMeter:RefreshRows()
			end
		
		elseif (event == "DETAILS_INSTANCE_STARTSTRETCH") then
			ThreatMeterFrame:SetFrameStrata ("TOOLTIP")
			ThreatMeterFrame:SetFrameLevel (instance.baseframe:GetFrameLevel()+1)
		
		elseif (event == "DETAILS_INSTANCE_ENDSTRETCH") then
			ThreatMeterFrame:SetFrameStrata ("MEDIUM")
			
		elseif (event == "PLUGIN_DISABLED") then
			ThreatMeterFrame:UnregisterEvent ("PLAYER_TARGET_CHANGED")
			ThreatMeterFrame:UnregisterEvent ("PLAYER_REGEN_DISABLED")
			ThreatMeterFrame:UnregisterEvent ("PLAYER_REGEN_ENABLED")
				
		elseif (event == "PLUGIN_ENABLED") then
			ThreatMeterFrame:RegisterEvent ("PLAYER_TARGET_CHANGED")
			ThreatMeterFrame:RegisterEvent ("PLAYER_REGEN_DISABLED")
			ThreatMeterFrame:RegisterEvent ("PLAYER_REGEN_ENABLED")
		end
	end
	
	ThreatMeterFrame:SetWidth (300)
	ThreatMeterFrame:SetHeight (100)
	
	--instance is the window showing the plugin
	function ThreatMeter:UpdateContainers()
		for _, row in _ipairs (ThreatMeter.Rows) do
			row:SetContainer (instance.baseframe)
		end
	end
	
	--rows are the bars showing the threat
	function ThreatMeter:UpdateRows()
		for _, row in _ipairs (ThreatMeter.Rows) do
			row.width = ThreatMeter.RowWidth
		end
	end
	
	function ThreatMeter:HideBars()
		for _, row in _ipairs (ThreatMeter.Rows) do 
			row:Hide()
		end
	end

	--if two player has the same amount of threat
	function ThreatMeter:GetNameOrder (playerName)
		local name = string.upper (playerName .. "zz")
		local byte1 = math.abs (string.byte (name, 2)-91)/1000000
		return byte1 + math.abs (string.byte (name, 1)-91)/10000
	end
	
	local target = nil
	local timer = 0
	local interval = 1.0
	
	local RoleIconCoord = {
		["TANK"] = {0, 0.28125, 0.328125, 0.625},
		["HEALER"] = {0.3125, 0.59375, 0, 0.296875},
		["DAMAGER"] = {0.3125, 0.59375, 0.328125, 0.625},
		["NONE"] = {0.3125, 0.59375, 0.328125, 0.625}
	}


	function ThreatMeter.UpdateWindowTitle (newTitle)
		local windowInstance = ThreatMeter:GetPluginInstance()
		if (windowInstance and windowInstance.menu_attribute_string) then
			if (not newTitle) then
				windowInstance.menu_attribute_string.text = "Tiny Threat"

			else
				windowInstance.menu_attribute_string:SetTextTruncated (newTitle, windowInstance.baseframe:GetWidth() - 60)
			end
		end
	end
	
	--> animation with acceleration ~animation ~healthbaranimation
	function ThreatMeter.AnimateLeftWithAccel (self, deltaTime)
		local distance = (self.AnimationStart - self.AnimationEnd) / self.CurrentPercentMax * 100	--scale 1 - 100
		local minTravel = min (distance / 10, 3) -- 10 = trigger distance to max speed 3 = speed scale on max travel
		local maxTravel = max (minTravel, 0.45) -- 0.45 = min scale speed on low travel speed
		local calcAnimationSpeed = (self.CurrentPercentMax * (deltaTime * ANIMATION_TIME_DILATATION)) * maxTravel --re-scale back to unit health, scale with delta time and scale with the travel speed
		
		self.AnimationStart = self.AnimationStart - (calcAnimationSpeed)
		self:SetValue (self.AnimationStart)
		self.CurrentPercent = self.AnimationStart
		
		if (self.Spark) then
			self.Spark:SetPoint ("center", self, "left", self.AnimationStart / self.CurrentPercentMax * self:GetWidth(), 0)
			self.Spark:Show()
		end
		
		if (self.AnimationStart-1 <= self.AnimationEnd) then
			self:SetValue (self.AnimationEnd)
			self.CurrentPercent = self.AnimationEnd
			self.IsAnimating = false
			if (self.Spark) then
				self.Spark:Hide()
			end
		end
	end

	function ThreatMeter.AnimateRightWithAccel (self, deltaTime)
		local distance = (self.AnimationEnd - self.AnimationStart) / self.CurrentPercentMax * 100	--scale 1 - 100 basis
		local minTravel = math.min (distance / 10, 3) -- 10 = trigger distance to max speed 3 = speed scale on max travel
		local maxTravel = math.max (minTravel, 0.45) -- 0.45 = min scale speed on low travel speed
		local calcAnimationSpeed = (self.CurrentPercentMax * (deltaTime * ANIMATION_TIME_DILATATION)) * maxTravel --re-scale back to unit health, scale with delta time and scale with the travel speed
		
		self.AnimationStart = self.AnimationStart + (calcAnimationSpeed)
		self:SetValue (self.AnimationStart)
		self.CurrentPercent = self.AnimationStart
		
		if (self.AnimationStart+1 >= self.AnimationEnd) then
			self:SetValue (self.AnimationEnd)
			self.CurrentPercent = self.AnimationEnd
			self.IsAnimating = false
		end
	end

	--when the size of the window has changed
	function ThreatMeter:SizeChanged()

		--instance = details! window holding the plugin
		local instance = ThreatMeter:GetPluginInstance()
	
		--set the size of the plugin frame to be equal as the window
		local w, h = instance.baseframe:GetSize()
		ThreatMeterFrame:SetWidth (w)
		ThreatMeterFrame:SetHeight (h)
		
		--calculate how tall is each bar
		local rowHeight = instance and instance.row_info.height or 20

		--this is the amount of bars the window can show
		ThreatMeter.CanShow = math.floor ( h / (rowHeight + 1))
		for i = #ThreatMeter.Rows+1, ThreatMeter.CanShow do
			ThreatMeter:NewRow (i)
		end

		ThreatMeter.ShownRows = {}
		
		--show the bars
		for i = 1, ThreatMeter.CanShow do
			ThreatMeter.ShownRows [#ThreatMeter.ShownRows + 1] = ThreatMeter.Rows[i]
			if (_detalhes.in_combat) then
				ThreatMeter.Rows[i]:Show()
			end
			ThreatMeter.Rows[i].width = w - 5
		end
		
		--hide the rest of the bars which couldn't fit in the window
		for i = #ThreatMeter.ShownRows + 1, #ThreatMeter.Rows do
			ThreatMeter.Rows [i]:Hide()
		end
		
	end
	
	local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")

	--update row info getting information from details options
	function ThreatMeter:RefreshRow (row)
	
		local instance = ThreatMeter:GetPluginInstance()
		
		if (instance) then
			local font = SharedMedia:Fetch ("font", instance.row_info.font_face, true) or instance.row_info.font_face
			
			row.textsize = instance.row_info.font_size
			row.textfont = font
			row.texture = instance.row_info.texture
			row.shadow = instance.row_info.textL_outline
			
			local rowHeight = instance and instance.row_info.height or 20
			rowHeight = - ( (row.rowId - 1) * (rowHeight + 1) )

			row:ClearAllPoints()
			row:SetPoint ("topleft", ThreatMeterFrame, "topleft", 1, rowHeight)
			row:SetPoint ("topright", ThreatMeterFrame, "topright", -1, rowHeight)
		end
	end
	
	function ThreatMeter:RefreshRows()
		for i = 1, #ThreatMeter.Rows do
			ThreatMeter:RefreshRow (ThreatMeter.Rows [i])
		end
	end

	local onUpdateRow = function (self, deltaTime)
		self = self.MyObject
		if (self.IsAnimating and self.AnimateFunc) then
			self.AnimateFunc (self, deltaTime)
		end
	end
	
	--creates a new bar
	function ThreatMeter:NewRow (i)

		local instance = ThreatMeter:GetPluginInstance()
		local rowHeight = instance and instance.row_info.height or 20

		local newrow = DetailsFrameWork:NewBar (ThreatMeterFrame, nil, "DetailsThreatRow"..i, nil, 300, rowHeight)
		newrow:SetPoint (3, -((i-1)*(rowHeight+1)))
		newrow.lefttext = "bar " .. i
		newrow.color = "skyblue"
		newrow.fontsize = 9.9
		newrow.fontface = "GameFontHighlightSmall"
		newrow:SetIcon ("Interface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES", RoleIconCoord ["DAMAGER"])
		newrow.rowId = i

		newrow.widget:SetScript ("OnUpdate", onUpdateRow)

		ThreatMeter.Rows [#ThreatMeter.Rows+1] = newrow
		
		ThreatMeter:RefreshRow (newrow)
		
		newrow:Hide()
		
		return newrow
	end
	
	--sort threat DESC
	local sort = function (table1, table2)
		if (table1[2] > table2[2]) then
			return true
		else
			return false
		end
	end

	--update the threat of each player
	local Threater = function()

		local options = ThreatMeter.options
	
		if (ThreatMeter.Actived and UnitExists ("target") and not _UnitIsFriend ("player", "target")) then

			ThreatMeter.UpdateWindowTitle (UnitName ("target"))

			if (_IsInRaid()) then
				for i = 1, _GetNumGroupMembers(), 1 do
				
					local thisplayer_name = GetUnitName ("raid"..i, true)
					local threat_table_index = ThreatMeter.player_list_hash [thisplayer_name]
					local threat_table = ThreatMeter.player_list_indexes [threat_table_index]
				
					if (not threat_table) then
						--> some one joined the group while the player are in combat
						ThreatMeter:Start()
						return
					end
				
					local isTanking, status, threatpct, rawthreatpct, threatvalue = _UnitDetailedThreatSituation ("raid"..i, "target")

					isTanking = isTanking or false
					threatpct = threatpct or 0
					rawthreatpct = rawthreatpct or 0

					if (status) then
						threat_table [2] = threatpct
						threat_table [3] = isTanking
						threat_table [6] = threatvalue
					else
						threat_table [2] = 0
						threat_table [3] = false
						threat_table [6] = 0
					end

				end
				
			elseif (_IsInGroup()) then
				for i = 1, _GetNumGroupMembers()-1, 1 do
					local thisplayer_name = GetUnitName ("party"..i, true)
					local threat_table_index = ThreatMeter.player_list_hash [thisplayer_name]
					local threat_table = ThreatMeter.player_list_indexes [threat_table_index]
				
					if (not threat_table) then
						--> some one joined the group while the player are in combat
						ThreatMeter:Start()
						return
					end
				
					local isTanking, status, threatpct, rawthreatpct, threatvalue = ThreatLib:UnitDetailedThreatSituation ("party"..i, "target")
					--returns nil, 0, nil, nil, 0
					--	print (isTanking, status, threatpct, rawthreatpct, threatvalue)

					local nameOrder = ThreatMeter:GetNameOrder (thisplayer_name or "zzzzzzz")

					isTanking = isTanking or false
					threatpct = threatpct or 0
					rawthreatpct = rawthreatpct or (0 + nameOrder)

					if (status) then
						threat_table [2] = threatpct + nameOrder
						threat_table [3] = isTanking
						threat_table [6] = threatvalue + nameOrder
					else
						threat_table [2] = 0 + nameOrder
						threat_table [3] = false
						threat_table [6] = 0 + nameOrder
					end
				end
				
				local thisplayer_name = GetUnitName ("player", true)
				local threat_table_index = ThreatMeter.player_list_hash [thisplayer_name]
				local threat_table = ThreatMeter.player_list_indexes [threat_table_index]
				local nameOrder = ThreatMeter:GetNameOrder (thisplayer_name or "zzzzzzz")

				local isTanking, status, threatpct, rawthreatpct, threatvalue = _UnitDetailedThreatSituation ("player", "target")

				isTanking = isTanking or false
				threatpct = threatpct or 0
				rawthreatpct = rawthreatpct or (0 + nameOrder)

				if (status) then
					threat_table [2] = threatpct + nameOrder
					threat_table [3] = isTanking
					threat_table [6] = threatvalue + nameOrder
				else
					threat_table [2] = 0 + nameOrder
					threat_table [3] = false
					threat_table [6] = 0 + nameOrder
				end

				--player pet
				--> pet
				if (UnitExists ("pet") and not IsInInstance() and false) then --disabled
					local thisplayer_name = GetUnitName ("pet", true) .. " *PET*"
					local threat_table_index = ThreatMeter.player_list_hash [thisplayer_name]
					local threat_table = ThreatMeter.player_list_indexes [threat_table_index]

					if (threat_table) then

						local isTanking, status, threatpct, rawthreatpct, threatvalue = _UnitDetailedThreatSituation ("pet", "target")

						--threatpct, rawthreatpct are nil on single player, dunno with pets
						threatpct = threatpct or 0
						rawthreatpct = rawthreatpct or 0

						if (status) then
							threat_table [2] = threatpct
							threat_table [3] = isTanking
							threat_table [6] = threatvalue
						else
							threat_table [2] = 0
							threat_table [3] = false
							threat_table [6] = 0
						end
					end
				end
				
			else
			
				--> player
				local thisplayer_name = GetUnitName ("player", true)
				local threat_table_index = ThreatMeter.player_list_hash [thisplayer_name]
				local threat_table = ThreatMeter.player_list_indexes [threat_table_index]
				local isTanking, status, threatpct, rawthreatpct, threatvalue = _UnitDetailedThreatSituation ("player", "target")

				local nameOrder = ThreatMeter:GetNameOrder (thisplayer_name or "zzzzzzz")

				--threatpct, rawthreatpct are nil on single player
				threatpct = threatpct or 0
				rawthreatpct = rawthreatpct or (0 + nameOrder)

				if (status) then
					threat_table [2] = threatpct
					threat_table [3] = isTanking
					threat_table [6] = threatvalue + nameOrder
				else
					threat_table [2] = 0
					threat_table [3] = false
					threat_table [6] = 0 or nameOrder
				end
				
				if (_DEBUG) then
					for i = 1, 10 do

					end
				end

				--> pet
				if (UnitExists ("pet")) then
					local thisplayer_name = GetUnitName ("pet", true) .. " *PET*"
					local threat_table_index = ThreatMeter.player_list_hash [thisplayer_name]
					local threat_table = ThreatMeter.player_list_indexes [threat_table_index]

					if (threat_table) then

						local isTanking, status, threatpct, rawthreatpct, threatvalue = _UnitDetailedThreatSituation ("pet", "target")

						--threatpct, rawthreatpct are nil on single player, dunno with pets
						threatpct = threatpct or 0
						rawthreatpct = rawthreatpct or 0

						if (status) then
							threat_table [2] = threatpct
							threat_table [3] = isTanking
							threat_table [6] = threatvalue
						else
							threat_table [2] = 0
							threat_table [3] = false
							threat_table [6] = 0
						end
					end
				end
			end
			
			--> sort
			_table_sort (ThreatMeter.player_list_indexes, sort)
			for index, t in _ipairs (ThreatMeter.player_list_indexes) do
				ThreatMeter.player_list_hash [t[1]] = index
			end
			
			--> no threat on this enemy
			if (ThreatMeter.player_list_indexes [1] [2] < 1) then
				ThreatMeter:HideBars()
				return
			end
			
			local lastIndex = 0
			local shownMe = false
			
			local pullRow = ThreatMeter.ShownRows [1]
			local me = ThreatMeter.player_list_indexes [ ThreatMeter.player_list_hash [player] ]
			if (me) then
			
				local myThreat = me [6] or 0
				local myRole = me [4]
				
				local topThreat = ThreatMeter.player_list_indexes [1]
				local aggro = topThreat [6] * (CheckInteractDistance ("target", 3) and 1.1 or 1.3)
				
				pullRow:SetLeftText ("Pull Aggro At")
				local realPercent = _math_floor (aggro / max (topThreat [6], 0.01) * 100)
				pullRow:SetRightText ("+" .. ThreatMeter:ToK2 (aggro - myThreat) .. " (" .. _math_floor (_math_abs ((myThreat / aggro * 100) - realPercent)) .. "%)") --
				pullRow:SetValue (100)
				
				local myPercentToAggro = myThreat / aggro * 100
				
				local r, g = ThreatMeter:percent_color (myPercentToAggro)
				pullRow:SetColor (r, g, 0)
				pullRow._icon:SetTexture ([[Interface\PVPFrame\Icon-Combat]])
				pullRow._icon:SetTexCoord (0, 1, 0, 1)
				
				pullRow:Show()
			else
				if (pullRow) then
					pullRow:Hide()
				end
			end
			
			for index = 2, #ThreatMeter.ShownRows do
				local thisRow = ThreatMeter.ShownRows [index]
				local threat_actor = ThreatMeter.player_list_indexes [index-1]
				
				if (threat_actor) then
					local role = threat_actor [4]
					thisRow._icon:SetTexCoord (_unpack (RoleIconCoord [role]))
					
					thisRow:SetLeftText (ThreatMeter:GetOnlyName (threat_actor [1]))
					
					local oldPct = thisRow:GetValue() or 0
					local pct = threat_actor [2]
					
					thisRow:SetRightText (ThreatMeter:ToK2 (threat_actor [6]) .. " (" .. _cstr ("%.1f", pct) .. "%)")

					--do healthbar animation ~animation ~healthbar
						thisRow.CurrentPercentMax = 100
						thisRow.AnimationStart = oldPct
						thisRow.AnimationEnd = pct

						thisRow:SetValue (oldPct)
						
						thisRow.IsAnimating = true
						
						if (thisRow.AnimationEnd > thisRow.AnimationStart) then
							thisRow.AnimateFunc = ThreatMeter.AnimateRightWithAccel
						else
							thisRow.AnimateFunc = ThreatMeter.AnimateLeftWithAccel
						end

					--if no animations
					--thisRow:SetValue (pct)
					
					if (options.useplayercolor and threat_actor [1] == player) then
						thisRow:SetColor (_unpack (options.playercolor))
						
					elseif (options.useclasscolors) then
						local color = RAID_CLASS_COLORS [threat_actor [5]]
						if (color) then
							thisRow:SetColor (color.r, color.g, color.b)
						else
							thisRow:SetColor (1, 1, 1, 1)
						end
					else
						if (index == 2) then
							thisRow:SetColor (pct*0.01, _math_abs (pct-100)*0.01, 0, 1)
						else
							local r, g = ThreatMeter:percent_color (pct, true)
							thisRow:SetColor (r, g, 0, 1)
						end
					end
					
					if (not thisRow.statusbar:IsShown()) then
						thisRow:Show()
					end
					if (threat_actor [1] == player) then
						shownMe = true
					end
				else
					thisRow:Hide()
				end
			end
			
			if (not shownMe) then
				--> show my self into last bar
				local threat_actor = ThreatMeter.player_list_indexes [ ThreatMeter.player_list_hash [player] ]
				if (threat_actor) then
					if (threat_actor [2] and threat_actor [2] > 0.1) then
						local thisRow = ThreatMeter.ShownRows [#ThreatMeter.ShownRows]
						thisRow:SetLeftText (player)
						--thisRow.textleft:SetTextColor (unpack (RAID_CLASS_COLORS [threat_actor [5]]))
						local role = threat_actor [4]
						thisRow._icon:SetTexCoord (_unpack (RoleIconCoord [role]))
						thisRow:SetRightText (ThreatMeter:ToK2 (threat_actor [6]) .. " (" .. _cstr ("%.1f", threat_actor [2]) .. "%)")
						thisRow:SetValue (threat_actor [2])
						
						if (options.useplayercolor) then
							thisRow:SetColor (_unpack (options.playercolor))
						else
							local r, g = ThreatMeter:percent_color (threat_actor [2], true)
							thisRow:SetColor (r, g, 0, .3)
						end
					end
				end
			end
		
		else
			--print ("nao tem target")
		end
		
	end
	
	function ThreatMeter:TargetChanged()
		if (not ThreatMeter.Actived) then
			return
		end
		local NewTarget = _UnitName ("target")
		if (NewTarget and not _UnitIsFriend ("player", "target")) then
			target = NewTarget
			ThreatMeter.UpdateWindowTitle (NewTarget)
			Threater()

		elseif (NewTarget and _UnitIsFriend ("player", "target") and not _UnitIsFriend ("player", "targettarget")) then
			target = _UnitName("playertargettarget")
			ThreatMeter.UpdateWindowTitle (target)
			Threater()
		else
			ThreatMeter.UpdateWindowTitle (false)
			ThreatMeter:HideBars()
		end
	end
	
	function ThreatMeter:Tick()
		Threater()
	end

	function ThreatMeter:Start()
		ThreatMeter:HideBars()
		if (ThreatMeter.Actived) then
			if (ThreatMeter.job_thread) then
				ThreatMeter:CancelTimer (ThreatMeter.job_thread)
				ThreatMeter.job_thread = nil
			end
			
			ThreatMeter.player_list_indexes = {}
			ThreatMeter.player_list_hash = {}
			
			--> pre build player list
			if (_IsInRaid()) then
				for i = 1, _GetNumGroupMembers(), 1 do
					local thisplayer_name = GetUnitName ("raid"..i, true)
					local role = _UnitGroupRolesAssigned ("raid"..i)
					local _, class = UnitClass (thisplayer_name)
					local t = {thisplayer_name, 0, false, role, class, 0}
					ThreatMeter.player_list_indexes [#ThreatMeter.player_list_indexes+1] = t
					ThreatMeter.player_list_hash [thisplayer_name] = #ThreatMeter.player_list_indexes
				end

				

			elseif (_IsInGroup()) then
				for i = 1, _GetNumGroupMembers()-1, 1 do
					local thisplayer_name = GetUnitName ("party"..i, true)
					local role = _UnitGroupRolesAssigned ("party"..i)
					local _, class = UnitClass (thisplayer_name)
					local t = {thisplayer_name, 0, false, role, class, 0}
					ThreatMeter.player_list_indexes [#ThreatMeter.player_list_indexes+1] = t
					ThreatMeter.player_list_hash [thisplayer_name] = #ThreatMeter.player_list_indexes
				end
				local thisplayer_name = GetUnitName ("player", true)
				local role = _UnitGroupRolesAssigned ("player")
				local _, class = UnitClass (thisplayer_name)
				local t = {thisplayer_name, 0, false, role, class, 0}
				ThreatMeter.player_list_indexes [#ThreatMeter.player_list_indexes+1] = t
				ThreatMeter.player_list_hash [thisplayer_name] = #ThreatMeter.player_list_indexes

				if (UnitExists ("pet") and not IsInInstance() and false) then --disabled
					local thispet_name = GetUnitName ("pet", true) .. " *PET*"
					local role = "DAMAGER"
					local t = {thispet_name, 0, false, role, class, 0}
					ThreatMeter.player_list_indexes [#ThreatMeter.player_list_indexes+1] = t
					ThreatMeter.player_list_hash [thispet_name] = #ThreatMeter.player_list_indexes
				end
				
			else
				local thisplayer_name = GetUnitName ("player", true)
				local role = _UnitGroupRolesAssigned ("player")
				local _, class = UnitClass (thisplayer_name)
				local t = {thisplayer_name, 0, false, role, class, 0}
				ThreatMeter.player_list_indexes [#ThreatMeter.player_list_indexes+1] = t
				ThreatMeter.player_list_hash [thisplayer_name] = #ThreatMeter.player_list_indexes
				
				if (UnitExists ("pet")) then
					local thispet_name = GetUnitName ("pet", true) .. " *PET*"
					local role = "DAMAGER"
					local t = {thispet_name, 0, false, role, class, 0}
					ThreatMeter.player_list_indexes [#ThreatMeter.player_list_indexes+1] = t
					ThreatMeter.player_list_hash [thispet_name] = #ThreatMeter.player_list_indexes
				end
			end
			
			local job_thread = ThreatMeter:ScheduleRepeatingTimer ("Tick", ThreatMeter.options.updatespeed)
			ThreatMeter.job_thread = job_thread
		end
	end
	
	function ThreatMeter:End()
		ThreatMeter:HideBars()
		if (ThreatMeter.job_thread) then
			ThreatMeter:CancelTimer (ThreatMeter.job_thread)
			ThreatMeter.job_thread = nil
			ThreatMeter.UpdateWindowTitle (false)
		end
	end
	
	function ThreatMeter:Cancel()
		ThreatMeter:HideBars()
		if (ThreatMeter.job_thread) then
			ThreatMeter:CancelTimer (ThreatMeter.job_thread)
			ThreatMeter.job_thread = nil
		end
		ThreatMeter.Actived = false
	end
	
end

local build_options_panel = function()

	local options_frame = ThreatMeter:CreatePluginOptionsFrame ("ThreatMeterOptionsWindow", "Tiny Threat Options", 1)

	local menu = {
		{
			type = "range",
			get = function() return ThreatMeter.saveddata.updatespeed end,
			set = function (self, fixedparam, value) ThreatMeter.saveddata.updatespeed = value end,
			min = 0.2,
			max = 3,
			step = 0.2,
			desc = "How fast the window get updates.",
			name = "Update Speed",
			usedecimals = true,
		},
		{
			type = "toggle",
			get = function() return ThreatMeter.saveddata.useplayercolor end,
			set = function (self, fixedparam, value) ThreatMeter.saveddata.useplayercolor = value end,
			desc = "When enabled, your bar get the following color.",
			name = "Player Color Enabled"
		},
		{
			type = "color",
			get = function() return ThreatMeter.saveddata.playercolor end,
			set = function (self, r, g, b, a) 
				local current = ThreatMeter.saveddata.playercolor
				current[1], current[2], current[3], current[4] = r, g, b, a
			end,
			desc = "If Player Color is enabled, your bar have this color.",
			name = "Color"
		},
		{
			type = "toggle",
			get = function() return ThreatMeter.saveddata.useclasscolors end,
			set = function (self, fixedparam, value) ThreatMeter.saveddata.useclasscolors = value end,
			desc = "When enabled, threat bars uses the class color of the character.",
			name = "Use Class Colors"
		},
	}
	
	_detalhes.gump:BuildMenu (options_frame, menu, 15, -65, 260)

end

ThreatMeter.OpenOptionsPanel = function()
	if (not ThreatMeterOptionsWindow) then
		build_options_panel()
	end
	ThreatMeterOptionsWindow:Show()
end

local loadPlugin = function()

			--> create widgets
			CreatePluginFrames (data)

			local MINIMAL_DETAILS_VERSION_REQUIRED = 1
			
			--> Install
			local install, saveddata = _G._detalhes:InstallPlugin ("RAID", Loc ["STRING_PLUGIN_NAME"], "Interface\\CHATFRAME\\UI-ChatIcon-D3", ThreatMeter, "DETAILS_PLUGIN_TINY_THREAT", MINIMAL_DETAILS_VERSION_REQUIRED, "Details! Team", "v1.07")
			if (type (install) == "table" and install.error) then
				print (install.error)
			end
			
			--> Register needed events
			_G._detalhes:RegisterEvent (ThreatMeter, "COMBAT_PLAYER_ENTER")
			_G._detalhes:RegisterEvent (ThreatMeter, "COMBAT_PLAYER_LEAVE")
			_G._detalhes:RegisterEvent (ThreatMeter, "DETAILS_INSTANCE_ENDRESIZE")
			_G._detalhes:RegisterEvent (ThreatMeter, "DETAILS_INSTANCE_SIZECHANGED")
			_G._detalhes:RegisterEvent (ThreatMeter, "DETAILS_INSTANCE_STARTSTRETCH")
			_G._detalhes:RegisterEvent (ThreatMeter, "DETAILS_INSTANCE_ENDSTRETCH")
			_G._detalhes:RegisterEvent (ThreatMeter, "DETAILS_OPTIONS_MODIFIED")
			
			ThreatMeterFrame:RegisterEvent ("PLAYER_TARGET_CHANGED")
			ThreatMeterFrame:RegisterEvent ("PLAYER_REGEN_DISABLED")
			ThreatMeterFrame:RegisterEvent ("PLAYER_REGEN_ENABLED")
			ThreatMeterFrame:RegisterUnitEvent("UNIT_TARGET", "target")

			--> Saved data
			ThreatMeter.saveddata = saveddata or {}
			
			ThreatMeter.saveddata.updatespeed = ThreatMeter.saveddata.updatespeed or 0.25
			ThreatMeter.saveddata.animate = ThreatMeter.saveddata.animate or false
			ThreatMeter.saveddata.showamount = ThreatMeter.saveddata.showamount or false
			ThreatMeter.saveddata.useplayercolor = ThreatMeter.saveddata.useplayercolor or false
			ThreatMeter.saveddata.playercolor = ThreatMeter.saveddata.playercolor or {1, 1, 1}
			ThreatMeter.saveddata.useclasscolors = ThreatMeter.saveddata.useclasscolors or false

			ThreatMeter.options = ThreatMeter.saveddata

			ThreatMeter.saveddata.updatespeed = 0.20
			--ThreatMeter.saveddata.animate = true
			
			--> Register slash commands
			SLASH_DETAILS_TINYTHREAT1, SLASH_DETAILS_TINYTHREAT2 = "/tinythreat", "/tt"
			
			function SlashCmdList.DETAILS_TINYTHREAT (msg, editbox)
			
				local command, rest = msg:match("^(%S*)%s*(.-)$")
				
				if (command == Loc ["STRING_SLASH_ANIMATE"]) then
				
				elseif (command == Loc ["STRING_SLASH_SPEED"]) then
				
					if (rest) then
						local speed = tonumber (rest)
						if (speed) then
							if (speed > 3) then
								speed = 3
							elseif (speed < 0.3) then
								speed = 0.3
							end
							
							ThreatMeter.saveddata.updatespeed = speed
							ThreatMeter:Msg (Loc ["STRING_SLASH_SPEED_CHANGED"] .. speed)
						else
							ThreatMeter:Msg (Loc ["STRING_SLASH_SPEED_CURRENT"] .. ThreatMeter.saveddata.updatespeed)
						end
					end

				elseif (command == Loc ["STRING_SLASH_AMOUNT"]) then
				
				else
					ThreatMeter:Msg (Loc ["STRING_COMMAND_LIST"])
					print ("|cffffaeae/tinythreat " .. Loc ["STRING_SLASH_SPEED"] .. "|r: " .. Loc ["STRING_SLASH_SPEED_DESC"])
				
				end
			end
			ThreatMeter.initialized = true
end

function ThreatMeter:OnEvent (_, event, ...)

	if (event == "PLAYER_TARGET_CHANGED") then
		ThreatMeter:TargetChanged()

	elseif ( event == "UNIT_TARGET" ) then
		ThreatMeter:TargetChanged()
	
	elseif (event == "PLAYER_REGEN_DISABLED") then
		ThreatMeter.Actived = true
		ThreatMeter:Start()
		--print ("tiny theat: regen disabled")
		
	elseif (event == "PLAYER_REGEN_ENABLED") then
		ThreatMeter:End()
		ThreatMeter.Actived = false
		--print ("tiny theat: regen enabled")
	
	elseif (event == "ADDON_LOADED") then --player_login
		if (_G._detalhes) then
			C_Timer.After(3, loadPlugin)
		end
	end
end
