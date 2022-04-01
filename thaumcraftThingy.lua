
local os = require("os")
local computer = require("computer")
local term = require("term")
local filesystem = require("filesystem")
local component = require("component")
local keyboard = require("keyboard")
local event = require("event")
local gpu = component.gpu





--minecraft colors
colors_white = 0xffffff
colors_orange = 0xff6600
colors_magenta = 0xff00ff
colors_lightblue = 0x0099ff
colors_yellow = 0xffff00
colors_lime = 0x00ff00
colors_pink = 0xff3399
colors_gray = 0x737373
colors_silver = 0xc0c0c0
colors_cyan = 0x169c9d
colors_purple = 0x8932b7
colors_blue = 0x3c44a9
colors_brown = 0x825432
colors_green = 0x5d7c15
colors_red = 0xb02e26
colors_black = 0x000000
--minecraft colors

local touchLocation = " "
local touchName = " "
local touchX = 0
local touchY = 0
local aspectValues = {}
local aspects = {}
local jars = {}






function modemListen ()
 modem.open(5)
  _, _, from, port, _, msg = event.pull(0.001,  "modem_message")
 if msg ~= nil then
  message = msg
  
 end
end

function touchCheck()
  touchLocation,touchName, touchX, touchY = event.pull(0.01, "touch")
end

-----------------------------
------ functions for UI -----
------------\/---------------


function drawAspctsPanel()
local panelX = 10
local panelY  = 5
local panelSizeX = 30
local panelSizeY = #jars
  drawLine(panelX-1, panelY, panelSizeX+2, panelSizeY+2, colors_gray)
 
 drawText(panelX+7, panelY-3, "thaumcraft ", colors_purple, colors_black)
  drawText(panelX+9, panelY-2, "aspects ", colors_purple, colors_black)
   
     drawText(panelX+29, panelSizeY+panelY+3, #jars, colors_purple, colors_black)


 
 

  for k, v in ipairs(jars) do
   tg =  component.invoke(v, "getAspectNames")
   tf =  component.invoke(v, "getAspectCount", tg[1])
    aspects[tg[1]] =  tf
    drawText(panelX+2, panelY+k, tg[1], colors_purple, colors_gray)
    
    if aspects[tg[1]] ~= nil then
     drawText(panelX+18, panelY+k, aspects[tg[1]], colors_silver, colors_gray) 
    
   
    
    end
  end


end


function drawLine (posX, posY, length, highth, line_color)
  gpu.setBackground(line_color)
  
  gpu.fill(posX, posY, length, highth, " ")
end


function drawText (X, Y, text, color_txt, color_bg)
 term.setCursor(X, Y)
 gpu.setBackground(color_bg)
 
 gpu.setForeground(color_txt, false)
 term.write(tostring(text))
 gpu.setBackground(colors_black)
end

function drawButton (label, x, y, hight, func, fuc_data, txt_color, bttn_color, enabled)
 length = #label+2 
  if not enabled then 
     drawLine(x, y, length, hight, colors_gray)
     drawText(x, y, label, colors_gray, colors_gray)  
  end
  if enabled then
    drawLine(x, y, length, hight, bttn_color)
    drawText(x+1,y+hight/2, label, txt_color, bttn_color)
   if touchX ~= nil or touchY ~= nil then
    if (touchX >= x) and (touchX <= x + length-1)  and (touchY >= y) and (touchY <= y + hight-1) then
      func(fuc_data)
    end
   end
  end
end

function refreshAspects()
 t = 0

end




term.clear()


t = 0


while true do 
  
  --modemListen ()
  touchCheck()

  drawButton("refresh", 85, 35, 3, refreshAspects, _, colors_lightblue, colors_white, true)
 
 if t == 0 then
    term.clear()
    jars = {}
     for key, value in pairs(component.list()) do
      if value == "jar_normal" then
       table.insert(jars, key)
      end
     end
    drawAspctsPanel()
     t = 1
 end
os.sleep(0.0)
end


