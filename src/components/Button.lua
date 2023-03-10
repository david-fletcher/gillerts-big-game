-- MIT License

-- Copyright (c) 2023 David Fletcher

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.


local COLORS = require "utils.Colors"
local Button = {}

function Button:new(text, x, y, action)
    local button = {}
    setmetatable(button, self )
    self.__index = self

    button.text = text
    button.x = x
    button.y = y
    button.width = 200
    button.height = 75
    button.textX = 0
    button.textY = 0
    button.fillMode = "line"
    button.textColor = "#FFFFFF"
    button.isPressed = false

    button.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 50)

    button.action = action

    return button
end

function Button:getWidth()
    return self.width
end

function Button:getHeight()
    return self.height
end

function Button:setPosition(x, y)
    self.x = x
    self.y = y
end

function Button:update( dt )
    self.textX = ((self.width / 2) - (self.font:getWidth(self.text) / 2)) + self.x
    self.textY = ((self.height / 2) - (self.font:getHeight() / 2)) + self.y

    local mouseX, mouseY = love.mouse.getPosition()

    if (mouseX > self.x and mouseX < self.x + self.width and
        mouseY > self.y and mouseY < self.y + self.height) then
            self.fillMode = "fill"
            self.textColor = "#615a7d"

        if (love.mouse.isDown(1) and not self.isPressed) then
            self.action()
            self.isPressed = true
        end
    else
            self.fillMode = "line"
            self.textColor = "#FFFFFF"
    end

    if (not love.mouse.isDown(1)) then
        self.isPressed = false
    end
end

function Button:draw()
    love.graphics.push("all")
        -- text bg
        love.graphics.setColor(COLORS.colorFromHex("#00000060"))
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 10)

        -- rectangle
        love.graphics.setLineWidth(5)
        love.graphics.setColor(COLORS.colorFromHex("#FFFFFF"))
        love.graphics.rectangle(self.fillMode, self.x, self.y, self.width, self.height, 10)

        -- text
        love.graphics.setFont(self.font)
        love.graphics.setColor(COLORS.colorFromHex(self.textColor))
        love.graphics.print(self.text, self.textX, self.textY)
    love.graphics.pop()
end

return Button