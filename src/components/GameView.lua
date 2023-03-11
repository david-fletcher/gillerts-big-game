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

local Flux = require "libs.flux.flux"
local Plan = require "libs.plan.plan"
local Rules = Plan.Rules

local Container = Plan.Container
local GameView = Container:extend()

local COLORS = require "utils.Colors"
local MainMenu = require "scenes.00_MainMenu"
local AudioManager = require "components.AudioManager"

local flux = require "libs.flux.flux"

function GameView:new(rules)
    -- initialises all the container fields
    local gameView = GameView.super.new(self, rules)

    gameView.rules = Rules.new()
        :addX(Plan.relative(0))
        :addY(Plan.relative(0))
        :addWidth(Plan.relative(1))
        :addHeight(Plan.relative(1))

    gameView.scene = MainMenu:init(rules, gameView)
    gameView:addChild(gameView.scene)

    gameView.nextScene = nil
    gameView.tween = nil

    gameView.audioManager = AudioManager:new()
    gameView.audioManager:play()

    gameView.sceneOffset = 0

    return gameView
end

function GameView:switchScene(nextScene)
    if (self.tween ~= nil) then return end

    self.nextScene = nextScene

    self.tween = flux.to(self, 1, {sceneOffset=-love.graphics.getWidth()})
        :ease("quadinout")
        :onupdate(function()
            self.scene:setOffset(self.sceneOffset)
            self.nextScene:setOffset(self.sceneOffset + love.graphics.getWidth())
        end)
        :oncomplete(function()
            self:removeChild(self.scene)
            self.scene = nextScene
            self:addChild(self.scene)
            self.sceneOffset = 0
            self.nextScene = nil
            self.tween = nil
        end)
end

function GameView:refresh()
    -- refresh for all of the children components
    GameView.super.refresh(self)
end

function GameView:update( dt )
    flux.update(dt)
    -- update for all of the children components
    GameView.super.update( self, dt )

    if (self.nextScene ~= nil) then
        self.nextScene:update(dt)
    end
end

function GameView:draw()
    love.graphics.push("all")
        local color = COLORS.colorFromHex("#000000")
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.pop()

    -- then we want to draw our children containers:
    GameView.super.draw(self)

    if (self.nextScene ~= nil) then
        self.nextScene:draw()
    end
end

return GameView