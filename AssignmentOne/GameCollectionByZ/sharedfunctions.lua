-----------------------------
--
-- Shared functions
-- 
-- Created by Zoltan Debre
-- 
-- I collect here reusable functions to keep my code a little bit DRY.
--
------------------------

local widget = require ('widget')
local storyboard = require ("storyboard")

local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight

local tapChannel

-- This file behave as a module.
local M = {}

-- Button creator function.
local createAButton = function (left, top, width, height, default, over, label, onevent, fontsize)

  fontsize = fontsize or 12

  local createdButton = widget.newButton
  {
    left = left,
    top = top,
    width = width,
    height = height,
    label = label,
    onEvent = onevent,
    fontSize = fontsize
  }

  return(createdButton)
end
M.createAButton = createAButton

-- Sound ON/OFF button will be available in each screen.
local function drawSoundONOFFButton()

  -- Sound ON/OFF text in the bottom-right corner
  --  soundText = display.newText(screenGroup, "Sound: ON", 0, _H-30, "Arial", 20)
  --  soundText:setTextColor(50)

  function soundOnOff(event)
    local phase = event.phase

    if phase == "began" then
      tapChannel = audio.play( tapSound )
    end

    if phase == "ended" then
      if audioPaused then
        print("Sound ON")
        audio.setMaxVolume(1)
        soundButton:setLabel("Sound: ON")
        audioPaused = false
      else
        print("Sound OFF")
        audio.setMaxVolume(0) -- Handy option to turn off the music and every sound effects.
        audioPaused = true
        soundButton:setLabel("Sound: OFF")
      end
    end
  end

  -- If audio already paused the new button will get proper label.
  local buttonLabel
  if audioPaused then
    buttonLabel = "Sound: OFF"
  else
    buttonLabel = "Sound: ON"
  end

  soundButton = createAButton(5, _H-50, 100, 40, '', '', buttonLabel, soundOnOff)
  --  screenGroup:insert(soundButton)


  -- This listener connect action to our button.
  --  soundText:addEventListener("tap", soundOnOff)
end
M.drawSoundONOFFButton = drawSoundONOFFButton


-- I prefer to draw a clean background instead of messy graphics... this function will manage that.
local drawBackground = function (group)

	local background = display.newRect(group, 0, 0, _W, _H )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
  background:setFillColor(30,30,30)

end
M.drawBackground = drawBackground


-- Back to menu button is exist in each screen. This function will create it.
local drawBackToMenu = function (group)

  local backToMenuEvent = function (event)
    local phase = event.phase

    if phase == "began" then
      tapChannel = audio.play( tapSound )
    end

    if phase == "ended" then
      storyboard.gotoScene( "menu" )
    end
  end

  backButton = createAButton(_W-110, _H-50, 100, 40, '', '', "Menu", backToMenuEvent)
  group:insert(backButton)

end
M.drawBackToMenu = drawBackToMenu

return M