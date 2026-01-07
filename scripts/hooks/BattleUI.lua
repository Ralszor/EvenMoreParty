local BattleUI, super = HookSystem.hookScript(BattleUI)
      
function BattleUI:beginAttack()
    if #Game.battle.party <= 3 then super.beginAttack(self) return end
    local attack_order = Utils.pickMultiple(Game.battle.normal_attackers, #Game.battle.normal_attackers)
    for _,box in ipairs(self.attack_boxes) do
        box:remove()
        end
        self.attack_boxes = {}
        local last_offset = 0
        local offset = 0
        local height = math.floor(112 / #Game.battle.party)
        for i = 1, #attack_order do
        offset = offset + last_offset
        local battler = attack_order[i]
        local index = Game.battle:getPartyIndex(battler.chara.id)
        local attack_box = AttackBox(battler, 30 + offset, index, 0, 40 + (height * (index - 1)))
        attack_box.layer = -10 + (index * 0.01)
        self:addChild(attack_box)
        table.insert(self.attack_boxes, attack_box)
        if i < #attack_order and last_offset ~= 0 then
            last_offset = TableUtils.pick{0, 10, 15}
        else
            last_offset = TableUtils.pick{10, 15}
        end
    end
    self.attacking = true
end

function BattleUI:update()
    super.update(self)
    for k, box in ipairs(Game.battle.battle_ui.action_boxes) do
        box.x = MathUtils.lerp(box.x, (k-MathUtils.clamp(Game.battle.current_selecting-2, 1, #Game.battle.party))*213, 0.3)
    end
end

function BattleUI:draw()
    super.draw(self)
    love.graphics.translate(0,-330)
    if Input.down("showhealth") then
        Draw.setColor(0,0,0,0.6)
        Draw.rectangle("fill",0,0,SCREEN_WIDTH, (#Game.battle.party * 30)+ 13)
        for k, party in ipairs(Game.battle.party) do
            local head = Assets.getTexture(party.chara:getHeadIcons().."/head")
            local name = Assets.getTexture(party.chara:getNameSprite())
            Draw.setColor(1,1,1,1)
            Draw.draw(head, 15, 10 + 30*(k-1))
            Draw.draw(name, 65, 15 + 30*(k-1))
            
            Draw.setColor(PALETTE["action_health_bg"])
            Draw.rectangle("fill", 140, (30*(k-1))+name:getHeight()+3, 100, 10)
            local health = (party.chara:getHealth() / party.chara:getStat("health")) * 100
            Draw.setColor(party.chara:getColor())
            if health > 0 then
                Draw.rectangle("fill", 140, (30*(k-1))+name:getHeight()+3, math.ceil(health), 10)
            end

            local g = Assets.getFont("smallnumbers")
            local h = (30*(k-1))+name:getHeight()+3 --Shameful realization i should have done this sooner
            
            love.graphics.setFont(g)
            local color = PALETTE["action_health_text"]
            
            if health <= 0 then
                color = PALETTE["action_health_text_down"]
            elseif (party.chara:getHealth() <= (party.chara:getStat("health") / 4)) then
                color = PALETTE["action_health_text_low"]
            else
                color = PALETTE["action_health_text"]
            end
        
        
            local health_offset = 0
            health_offset = (#tostring(party.chara:getHealth()) - 1) * 8
        
            Draw.setColor(color)
            love.graphics.print(party.chara:getHealth(), 250, h)
            Draw.setColor(PALETTE["action_health_text"])
            love.graphics.print("/", (260+health_offset), h)
            local string_width = g:getWidth(tostring(party.chara:getStat("health")))
            Draw.setColor(color)
            love.graphics.print(party.chara:getStat("health"), (280 + health_offset), h)
            --Draw.rectangle("fill", 75 + name:getWidth(), (30*(k-1))+name:getHeight()+5, math.ceil(health), 10)
        end
    end
end

return BattleUI