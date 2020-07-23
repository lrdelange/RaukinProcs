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

        	RaukinProcsDB.posX = RaukinProcsDB.target.posX or 0
       		RaukinProcsDB.posY = RaukinProcsDB.target.posY or 20
        	RaukinProcsDB.width = RaukinProcsDB.target.width or 34
        	RaukinProcsDB.height = RaukinProcsDB.target.height or 34	
		RaukinProcsDB.alpha = RaukinProcsDB.target.alpha or 1
		RaukinProcsDB.point = RaukinProcsDB.target.point or "CENTER"

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
        name = "Sizing options",
        order = 2,
        args = {
            MoveTog = {
                type = "group",
                name = "Move Frames",
                guiInline = true,
                order = 1,
                args = {
                    Toggle = {
                        name = "Move Icons for 25sec",
                        type = "toggle",
                        get = function(info) return RaukinProcsDB.Moveable end,
                        set = function(info, s) RaukinProcsDB.Moveable = s; RaukinProcs.UpdateFrames(); end,
                    },
                },
            },            
	    SizeT = {
                type = "group",
                name = "Target Sizing",
                guiInline = true,
                order = 1,
                args = {
                    size = {
                        name = "Target Icon Size",
                        type = "range",
                        get = function(info) return RaukinProcsDB.target.width end,
                        set = function(info, s) RaukinProcsDB.target.width = s; RaukinProcsDB.target.height = s; RaukinProcs.UpdateFrames(); end,
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
                order = 5,
                args = {
                    alpha = {
                        name = "Alpha of Icons",
                        type = "range",
                        get = function(info) return RaukinProcsDB.focus.alpha end,
                        set = function(info, s) RaukinProcsDB.focus.alpha = s; RaukinProcsDB.target.alpha = s; RaukinProcsDB.focuskick.alpha = s; RaukinProcsDB.targetkick.alpha = s; RaukinProcs.UpdateFrames(); end,
                        min = 0,
                        max = 1,
                        step = 0.1,
                    },
                },
            },
        type = "group",
        name = "Proc Management",
        order = 1,
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