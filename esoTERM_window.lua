esoTERM_window = {}

function esoTERM_window.create()
    etw = WINDOW_MANAGER:CreateTopLevelWindow()
    etw:SetMouseEnabled(true)
    etw:SetMovable(false)
    etw:SetDimensions(500, 305)
    etw:SetResizeHandleSize(8)
    etw:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 20, 450)
    etw:SetHidden(true)

    esoTERM_window.tb = WINDOW_MANAGER:CreateControl(nil, etw, CT_TEXTBUFFER)
    esoTERM_window.tb:SetMouseEnabled(true)
    esoTERM_window.tb:SetLinkEnabled(true)
    esoTERM_window.tb:SetFont("ZoFontChat")
    esoTERM_window.tb:SetHandler("OnLinkMouseUp", function(self, _, link, button) return ZO_LinkHandler_OnLinkMouseUp(link, button, self) end)
    esoTERM_window.tb:SetHandler("OnMouseEnter", function() esoTERM_window.tb:ShowFadedLines() end)
    esoTERM_window.tb:SetHidden(false)
    esoTERM_window.tb:SetClearBufferAfterFadeout(false)
    esoTERM_window.tb:SetMaxHistoryLines(10000)
    esoTERM_window.tb:SetAnchorFill(etw)
    esoTERM_window.tb:SetLineFade(30, 1)

    local fragment = ZO_SimpleSceneFragment:New(etw)
    HUD_SCENE:AddFragment(fragment)
    HUD_UI_SCENE:AddFragment(fragment)
end

function esoTERM_window.initialize()
    esoTERM_window.create()
end

return esoTERM_window
