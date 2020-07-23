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

------------------------------------------- Frame -------------------------------------------
		Rframe = CreateFrame("Frame",nil,UIParent)
		Rframe:SetFrameStrata("HIGH")
		Rframe:SetWidth(RaukinProcsDB.width)
		Rframe:SetHeight(RaukinProcsDB.height)
		Rframe:SetAlpha(RaukinProcsDB.alpha)

		tR = Rframe:CreateTexture(nil,"BACKGROUND")
		_,_,dsIcon = GetSpellInfo(408) 
		tR:SetTexture(dsIcon)
		tR:SetTexCoord(.07, .93, .07, .93)
		tR:SetAllPoints(Rframe)
		Rframe.texture = tR

		tRcolor = Rframe:CreateTexture(nil,"LOW")
		tRcolor:SetAllPoints(Rframe)
		tRcolor:SetTexture(0,1,0,1)
		Rframe.texture = tRcolor
		Rframe.texture:SetAlpha(0)

		Rframe:SetPoint(RaukinProcsDB.point,RaukinProcsDB.posX,RaukinProcsDB.posY)
		Rframe:RegisterForDrag("LeftButton")
		Rframe:SetScript("OnDragStart", Rframe.StartMoving)
		Rframe:SetScript("OnDragStop", 
			function() 
				Rframe:StopMovingOrSizing() 
				point, relativeTo, relativePoint, xOfs, yOfs = Rframe:GetPoint()
				RaukinProcsDB.point = point
				RaukinProcsDB.posX = xOfs 
				RaukinProcsDB.posY = yOfs 
			end)
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

function RaukinProcs.MakeOptions(self)

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
                        name = "Spell Id Select",
                        type = "select",
			values = {112, 113, 114},
			style = "dropdown",
                        get = function(info) end,
                        set = function(info, s) end,
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
                        name = "SpellId",
                        type = "input",
                        get = function(info) end,
                        set = function(info, s) end,
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
                        name = "Cooldown",
                        type = "input",
                        get = function(info) end,
                        set = function(info, s) end,
                    },
                },
            }, 
            InputButton = {
                type = "group",
                name = "Input",
                guiInline = true,
                order = 4,
                args = {
                    InputButton = {
                        name = "Input",
                        type = "execute",
			func = function(info) end,
                    },
                },
            },
            DeleteButton = {
                type = "group",
                name = "Delete",
                guiInline = true,
                order = 5,
                args = {
                    DeleteButton = {
                        name = "Delete",
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
			func = function(info) end,
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
                        set = function(info, s) RaukinProcsDB.width = s; RaukinProcsDB.height = s; end,
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
            BarTog = {
                type = "group",
                name = "Only Icons",
                guiInline = true,
                order = 9,
                args = {
                    Bartog = {
                        name = "Only show the icons",
                        type = "toggle",
                        get = function(info) end,
                        set = function(info, s) end,
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