---@class DarkMenu : Object
---@overload fun(...) : DarkMenu
local DarkMenu, super = HookSystem.hookScript(DarkMenu)

function DarkMenu:updateSelectedBoxes()
    if #Game.party <= 3 then return super.updateSelectedBoxes(self) end
    for _, actionbox in ipairs(Game.world.healthbar.action_boxes) do
        if self.state == "PARTYSELECT" and self.party_select_mode == "ALL" then
            actionbox.selected = true
            actionbox:setHeadIcon("heart")
        else
            actionbox.selected = false
            actionbox:setHeadIcon("head")
        end
    end
    if self.state == "PARTYSELECT" then
        Game.world.healthbar.action_boxes[self.selected_party].selected = true
        Game.world.healthbar.action_boxes[self.selected_party]:setHeadIcon("heart")
    end
end

function DarkMenu:update()
    super.update(self)
    if #Game.party <= 3 then return end
        if self.box and  self.box.party and self.box.party.selected_party then
        for k, box in ipairs(Game.world.healthbar.action_boxes) do
            box.x = MathUtils.lerp(box.x, (k-MathUtils.clamp(self.box.party.selected_party-1, 1, #Game.party-2))*213, 0.3)
        end
    elseif Game.world.healthbar then
        for k, box in ipairs(Game.world.healthbar.action_boxes) do
            box.x = MathUtils.lerp(box.x, (k-MathUtils.clamp(self.selected_party-1, 1, #Game.party-2))*213, 0.3)
        end
    end
end
function DarkMenu:draw()
    super.draw(self)
    if self.box then return end --scary
    love.graphics.push("all")
    love.graphics.origin()
    for k, party in ipairs(Game.party) do
        if k > 3 then
            Draw.setColor(1,1,1,1)
            local a = Assets.getTexture(party:getHeadIcons().."/head")
            if k >=15 then
                Draw.draw(a, MathUtils.rangeMap(self.y, -80, 0, -100, 170), 60+30*(k-14))
            else
                Draw.draw(a, MathUtils.rangeMap(self.y, -80, 0, -100, 20), 60+30*(k-3))
            end
            local color
            Draw.setColor(PALETTE["action_health_bg"])
            local health = (party:getHealth() / party:getStat("health")) * 100
            if k >= 15 then
                Draw.rectangle("fill",MathUtils.rangeMap(self.y, -80, 0, -100, 210),70+30*(k-14), 100, 10)
                Draw.setColor(party:getColor())
                Draw.rectangle("fill",MathUtils.rangeMap(self.y, -80, 0, -100, 210),70+30*(k-14), math.ceil(health), 10)
            else
                Draw.rectangle("fill",MathUtils.rangeMap(self.y, -80, 0, -100, 60),70+30*(k-3), 100, 10)
                Draw.setColor(party:getColor())
                Draw.rectangle("fill",MathUtils.rangeMap(self.y, -80, 0, -100, 60),70+30*(k-3), math.ceil(health), 10)
            end
            love.graphics.setFont(Assets.getFont("smallnumbers"))
            if (party:getHealth() <= (party:getStat("health") / 4)) then
                color = PALETTE["action_health_text_low"]
            else
                color = PALETTE["action_health_text"]
            end
            Draw.setColor(COLORS.black)
            for x=-1, 1 do
                for y=-1, 1 do
                    if k >= 15 then
                        love.graphics.print(party:getHealth().."/"..party:getStat("health"),MathUtils.rangeMap(self.y, -80, 0, -100, 210)+x, 60+30*(k-14)+y)
                    else
                        love.graphics.print(party:getHealth().."/"..party:getStat("health"),MathUtils.rangeMap(self.y, -80, 0, -100, 60)+x, 60+30*(k-3)+y)
                    end
                end
            end
            Draw.setColor(color)
            if k >= 15 then
                love.graphics.print(party:getHealth().."/"..party:getStat("health"),MathUtils.rangeMap(self.y, -80, 0, -100, 210), 60+30*(k-14))
            else
                love.graphics.print(party:getHealth().."/"..party:getStat("health"),MathUtils.rangeMap(self.y, -80, 0, -100, 60), 60+30*(k-3))
            end
        end
    end
    Draw.setColor(1,1,1,1)
    love.graphics.pop()
end

return DarkMenu