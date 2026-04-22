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
            local col = math.floor((k - 4) / 11)
            local row = (k - 4) % 11

            local x_head  = MathUtils.rangeMap(self.y, -80, 0, -100, 20  + col * 150)
            local x_bar   = MathUtils.rangeMap(self.y, -80, 0, -100, 60  + col * 150)
            local x_text  = MathUtils.rangeMap(self.y, -80, 0, -100, 60  + col * 150)
            local y_pos   = 90 + 30 * row

            Draw.setColor(1, 1, 1, 1)
            local a = Assets.getTexture(party:getHeadIcons().."/head")
            Draw.draw(a, x_head, y_pos)

            local health = (party:getHealth() / party:getStat("health")) * 100
            Draw.setColor(PALETTE["action_health_bg"])
            Draw.rectangle("fill", x_bar, y_pos + 10, 100, 10)
            Draw.setColor(party:getColor())
            Draw.rectangle("fill", x_bar, y_pos + 10, math.ceil(health), 10)

            love.graphics.setFont(Assets.getFont("smallnumbers"))
            local color
            if (party:getHealth() <= (party:getStat("health") / 4)) then
                color = PALETTE["action_health_text_low"]
            else
                color = PALETTE["action_health_text"]
            end

            Draw.setColor(COLORS.black)
            for x = -1, 1 do
                for y = -1, 1 do
                    love.graphics.print(party:getHealth().."/"..party:getStat("health"), x_text + x, y_pos + y)
                end
            end
            Draw.setColor(color)
            love.graphics.print(party:getHealth().."/"..party:getStat("health"), x_text, y_pos)
        end
    end
    Draw.setColor(1,1,1,1)
    love.graphics.pop()
end

return DarkMenu