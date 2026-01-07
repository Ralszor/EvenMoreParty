local AttackBox, super = HookSystem.hookScript(AttackBox)

function AttackBox:init(battler, offset, index, x, y)
    super.init(self, battler, offset, index, x, y)
    if #Game.battle.party <= 3 then return end
    
    self.bolt.height = math.floor(112 / #Game.battle.party)
    self.head_sprite:setOrigin(0.5, 0.75 + (2 * (#Game.battle.party - 4) * 0.075))
    self.press_sprite:setOrigin(0, (#Game.battle.party - 4) * 0.025)
    self.head_sprite:setScale(1 - ((#Game.battle.party - 4) * 0.125))
end

function AttackBox:update()
    if self.removing or Game.battle.cancel_attack then
        self.fade_rect.alpha = MathUtils.approach(self.fade_rect.alpha, 1, 0.08 * DTMULT)
    end

    if not self.attacked then
        self.bolt:move(-self.BOLTSPEED * DTMULT, 0)

        self.afterimage_timer = self.afterimage_timer + DTMULT/2
        while math.floor(self.afterimage_timer) > self.afterimage_count do
            self.afterimage_count = self.afterimage_count + 1
            local afterimg = AttackBar(self.bolt.x, 0, 6, #Game.battle.party > 3 and math.floor(112/#Game.battle.party) or 38)
            afterimg.layer = 3
            afterimg.alpha = 0.4
            afterimg:fadeOutSpeedAndRemove()
            self:addChild(afterimg)
        end
    end

    local pressed_confirm = false
    if Mod.libs["multiplayer"] then -- Compatibility with 'multiplayer' Library.
        for i = 2, math.min(Mod.libs["multiplayer"].max_players, #Game.battle.party) do
            if Input.pressed("p".. i .."_confirm") then
                pressed_confirm = true
            end
        end
    end

    if not Game.battle.cancel_attack and (Input.pressed("confirm") or pressed_confirm) then
        self.flash = 1
    else
        self.flash = MathUtils.approach(self.flash, 0, DTMULT/5)
    end

    Object.update(self)
end

function AttackBox:draw()
            local target_color = {self.battler.chara:getAttackBarColor()}
            local box_color = {self.battler.chara:getAttackBoxColor()}

            if self.flash > 0 then
                box_color = TableUtils.lerp(box_color, {1, 1, 1, 1}, self.flash)
            end

            love.graphics.setLineWidth(2)
            love.graphics.setLineStyle("rough")

            local ch1_offset = Game:getConfig("oldUIPositions") and #Game.battle.party <= 4

            Draw.setColor(box_color)
            local height = #Game.battle.party > 3 and math.floor(104 / #Game.battle.party) or 36
            
            love.graphics.rectangle("line", 80, ch1_offset and 0 or 1, (15 * self.BOLTSPEED) + 3, height + (ch1_offset and 1 or 0))

            Draw.setColor(target_color)
            love.graphics.rectangle("line", 83, 1, 8, height)
            Draw.setColor(0, 0, 0)
            love.graphics.rectangle("fill", 84, 2, 6, height - 2)

            love.graphics.setLineWidth(1)

            Object.draw(self)
end

return AttackBox