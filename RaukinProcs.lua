RaukinProcs = CreateFrame("Frame","RaukinProcs")

RaukinProcs:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

media = LibStub("LibSharedMedia-3.0")

RaukinProcs:RegisterEvent("ADDON_LOADED")
RaukinProcs:RegisterEvent("PLAYER_AURAS_CHANGED")

function RaukinProcs.ADDON_LOADED(self,event,arg1)
	if arg1=="RaukinProcs" then
------------------------------------------- Database -------------------------------------------
		RaukinProcsDB = RaukinProcsDB or {}
		RaukinProcsDB.Moveable = RaukinProcsDB.Moveable or false

        	RaukinProcsDB.posX = RaukinProcsDB.posX or 0
       		RaukinProcsDB.posY = RaukinProcsDB.posY or 20
        	RaukinProcsDB.width = RaukinProcsDB.width or 34
        	RaukinProcsDB.height = RaukinProcsDB.height or 34	
		RaukinProcsDB.alpha = RaukinProcsDB.alpha or 1
		RaukinProcsDB.point = RaukinProcsDB.point or "CENTER"

		RaukinProcsDB.barvis = RaukinProcsDB.barvis or true
		RaukinProcsDB.baramount = RaukinProcsDB.baramount or 5
		RaukinProcsDB.bartexture = RaukinProcsDB.bartexture or "Aluminium"
		RaukinProcsDB.barfont = RaukinProcsDB.barfont or "Arial Narrow"
		RaukinProcsDB.barfontsize = RaukinProcsDB.barfontsize or 14
		

------------------------------------------- Iconframe1 -------------------------------------------
		IconFrame1 = CreateFrame("Frame",nil,UIParent)
		IconFrame1:SetFrameStrata("HIGH")
		IconFrame1:SetWidth(RaukinProcsDB.width)
		IconFrame1:SetHeight(RaukinProcsDB.height)
		IconFrame1:SetAlpha(RaukinProcsDB.alpha)

		tR = IconFrame1:CreateTexture(nil,"BACKGROUND")
		_,_,dsIcon = GetSpellInfo(408) 
		tR:SetTexture(dsIcon)
		tR:SetTexCoord(.07, .93, .07, .93)
		tR:SetAllPoints(IconFrame1)
		IconFrame1.texture = tR

		IconFrame1:SetPoint(RaukinProcsDB.point,RaukinProcsDB.posX,RaukinProcsDB.posY)
		IconFrame1:RegisterForDrag("LeftButton")
		IconFrame1:SetScript("OnDragStart", IconFrame1.StartMoving)
		IconFrame1:SetScript("OnDragStop", 
			function() 
				IconFrame1:StopMovingOrSizing() 
				point, relativeTo, relativePoint, xOfs, yOfs = IconFrame1:GetPoint()
				RaukinProcsDB.point = point
				RaukinProcsDB.posX = xOfs 
				RaukinProcsDB.posY = yOfs 
			end)
		
------------------------------------------- BarFrame1 -------------------------------------------		
		BarFrame1 = CreateFrame("Frame",nil,UIParent)


		RaukinProcs.MakeOptions()

	end
end

function RaukinProcs.PLAYER_AURAS_CHANGED(self,event,arg1)

end

function RaukinProcs.ChangeBackground(f,Frame, Icon)
	_,_,dsIcon = GetSpellInfo(Icon) 
	f:SetTexture(dsIcon)
	f:SetTexCoord(.07, .93, .07, .93)
	f:SetAllPoints(Frame)
	Frame.texture = f
end

function RaukinProcs.UpdateFrame()
	IconFrame1:SetWidth(RaukinProcsDB.width)
	IconFrame1:SetHeight(RaukinProcsDB.height)
	IconFrame1:SetAlpha(RaukinProcsDB.alpha)
	
end

function RaukinProcs.MakeOptions(self)
    for i,v in pairs(media:List('statusbar')) do
        bars[v] = v
    end
    media.RegisterCallback(RaukinProcs, "LibSharedMedia_Registered",
        function(event, mediatype, key)
            if mediatype == 'font' then
                fonts[key] = key
                if key == RaukinProcsDB.barfont then
                    BarFrame1.text:SetFont(media:Fetch('font',RaukinProcsDB.barfont),RaukinProcsDB.barfontsize)
                end
            elseif mediatype == 'statusbar' then
                bars[key] = key
                if key == RaukinProcsDB.bartexture then
                    if RaukinProcsDB.barvis then BarFrame1:SetTexture(media:Fetch('statusbar',RaukinProcsDB.bartexture)) end
                end
            end
        end)

    local opt = {
		type = 'group',
        name = "RaukinProcs",
        args = {},
	}
    opt.args.general = {
        type = "group",
        name = "Addon options",
        order = 1,
        args = {
            SelectSpellId = {
                type = "group",
                name = "Select SpellId",
                guiInline = true,
                order = 1,
                args = {
                    Drop = {
			order = 1,
                        name = "Spell Id Select",
                        type = "select",
			values = {112, 113, 114},
			style = "dropdown",
                        get = function(info) end,
                        set = function(info, s) end,
                    },
                    DeleteButton = {
			order = 2,
                        name = "Delete",
                        type = "execute",
			func = function(info) end,
		    },
                },
            }, 
            InputBox1 = {
                type = "group",
                name = "SpellId",
                guiInline = true,
                order = 2,
                args = {
                    SpellIdInput = {
			order = 1,
                        name = "SpellId",
                        type = "input",
                        get = function(info) end,
                        set = function(info, s) end,
                    },
                    InputButton = {
			order = 2,
                        name = "Input",
                        type = "execute",
			func = function(info) end,
                    },
                },
            }, 
            Inputbox2 = {
                type = "group",
                name = "Manual Cooldown",
                guiInline = true,
                order = 3,
                args = {
                    MCDInput = {
			order = 1,
                        name = "Cooldown",
                        type = "input",
                        get = function(info) end,
                        set = function(info, s) end,
                    },
                    UpdateButton = {
			order = 2,
                        name = "Update",
                        type = "execute",
			func = function(info) end,
                    },
                },
            },  
            MoveButton = {
                type = "group",
                name = "Move Bars",
                guiInline = true,
                order = 6,
                args = {
                    Button = {
                        name = "Move Bars",
                        type = "execute",
			func = function(info) 
				if RaukinProcsDB.Moveable then
					IconFrame1:EnableMouse(false)
					IconFrame1:SetMovable(false)
					RaukinProcsDB.Moveable=false
					RaukinProcs.ChangeBackground(tR,IconFrame1, 14176)	
				else
					IconFrame1:EnableMouse(true)
					IconFrame1:SetMovable(true)
					RaukinProcsDB.Moveable=true
					RaukinProcs.ChangeBackground(tR,IconFrame1, 25820)	
				end;
			end,
                    },
                },
            },            
	    SizeT = {
                type = "group",
                name = "Target Sizing",
                guiInline = true,
                order = 7,
                args = {
                    size = {
                        name = "Target Icon Size",
                        type = "range",
                        get = function(info) return RaukinProcsDB.width end,
                        set = function(info, s) RaukinProcsDB.width = s; RaukinProcsDB.height = s; RaukinProcs.UpdateFrame(); end,
                        min = 1,
                        max = 400,
                        step = 1,
                    },
                },
            },
            AlphaFT = {
                type = "group",
                name = "Aplha of Frames",
                guiInline = true,
                order = 8,
                args = {
                    alpha = {
                        name = "Alpha of Icons",
                        type = "range",
                        get = function(info) end,
                        set = function(info, s) end,
                        min = 0,
                        max = 1,
                        step = 0.1,
                    },
                },
            },
            Options = {
                type = "group",
                name = "Options",
                guiInline = true,
                order = 9,
                args = {
                    Bartog = {
                        name = "Only show the icons",
                        type = "toggle",
                        get = function(info) end,
                        set = function(info, s) end,
                    },
                    AmountBars = {
                        name = "Max amount of procs",
                        type = "range",
                        get = function(info) end,
                        set = function(info, s) end,
			min = 1,
			max = 10,
			step = 1,
                    },
                },
            }, 
        },
    }
    
    local Config = LibStub("AceConfigRegistry-3.0")
    local Dialog = LibStub("AceConfigDialog-3.0")
    
    Config:RegisterOptionsTable("RaukinProcs-Bliz", {name = "RaukinProcs",type = 'group',args = {} })
    Dialog:SetDefaultSize("RaukinProcs-Bliz", 600, 400)
    
    Config:RegisterOptionsTable("RaukinProcs-General", opt.args.general)
    Dialog:AddToBlizOptions("RaukinProcs-General", "RaukinProcs")
    

    SLASH_MBSLASH1 = "/rp";
    SLASH_MBSLASH2 = "/RaukinProcs";
    SlashCmdList["MBSLASH"] = function() InterfaceOptionsFrame_OpenToFrame("RaukinProcs") end;
end