local BattleUI, super = HookSystem.hookScript(BattleUI)
function BattleUI:init()
    super.init(self)
    self.adraw = 0
    self.adraw2 = 0
end

function BattleUI:beginAttack()
    if #Game.battle.party <= 3 then super.beginAttack(self) return end
    local attack_order = Utils.pickMultiple(Game.battle.normal_attackers, #Game.battle.normal_attackers)
    for _,box in ipairs(self.attack_boxes) do
        box:remove()
        end
        self.attack_boxes = {}
        local last_offset = 0
        local offset = 0
        local height = math.floor(112 / 3)
        for i = 1, #attack_order do
        offset = offset + last_offset
        local battler = attack_order[i]
        local index = Game.battle:getPartyIndex(battler.chara.id)
        local attack_box = AttackBox(battler, 30 + offset, index, 0, 40 + (height * (MathUtils.wrap(index-1, 0, 3))))
        attack_box.layer = -10 - (index * 0.01)
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
        box.x = MathUtils.lerp(box.x, (k-MathUtils.clamp(Game.battle.current_selecting-1, 1, #Game.battle.party-2))*213, 0.3)
    end
end

function BattleUI:draw()
    super.draw(self)
    love.graphics.translate(0,30)
    if Game.battle.state == "DEFENDING" then
        self.adraw2 = self.adraw2 + 4*DT
        self.adraw2 = MathUtils.clamp(self.adraw2, 0, 1)
        for e, party in ipairs(Game.battle.party) do
            if e > 3 then
                -- local tex = Assets.getTexture(party.chara:getHeadIcons().."/head")
				local tex = self.action_boxes[e].head_sprite.texture
                Draw.setColor(1,1,1,self.adraw2)
                if e <= 8 then
                    Draw.draw(tex, 130 * (e-4), 10)
                elseif e <= 13 then
                    Draw.draw(tex, 130 * (e-9), 50)
                elseif e > 13 then
                    Draw.draw(tex, 130 * (e-13), 90)
                end
                local health = (party.chara:getHealth() / party.chara:getStat("health")) * 100
                local color = {1,1,1,self.adraw2}
                
                if health <= 0 then
                    color = {1,0,0,self.adraw2}
                elseif (party.chara:getHealth() <= (party.chara:getStat("health") / 4)) then
                    color = {1,1,0,self.adraw2}
                else
                    color = {1,1,1,self.adraw2}
                end
                Draw.setColor(color)
                love.graphics.setFont(Assets.getFont("smallnumbers"))
                if e <= 8 then
                    love.graphics.print(party.chara.health.."/"..party.chara.stats.health, (130 * (e-4))+tex:getWidth()+5, 20)
                elseif e <= 13 then
                    love.graphics.print(party.chara.health.."/"..party.chara.stats.health, (130 * (e-9))+tex:getWidth()+5, 60)
                elseif e > 13 then
                    love.graphics.print(party.chara.health.."/"..party.chara.stats.health, (130 * (e-13))+tex:getWidth()+5, 100)
                end
            end
        end
    else
        self.adraw2 = 0
    end
    love.graphics.translate(0,-360)
    if Input.down("showhealth") then
        self.adraw = self.adraw + 4*DT
        self.adraw = MathUtils.clamp(self.adraw, 0, 1)
        Draw.setColor(0,0,0,self.adraw-0.6)
        Draw.rectangle("fill",0,0,SCREEN_WIDTH, (#Game.battle.party * 30)+ 13)
        for k, party in ipairs(Game.battle.party) do
            local head = Assets.getTexture(party.chara:getHeadIcons().."/head")
            local name = Assets.getTexture(party.chara:getNameSprite())
            Draw.setColor(1,1,1,self.adraw)
            Draw.draw(head, 15, 10 + 30*(k-1))
            Draw.draw(name, 65, 15 + 30*(k-1))
            
            Draw.setColor(PALETTE["action_health_bg"])
            Draw.rectangle("fill", 140, (30*(k-1))+name:getHeight()+3, 100, 10)
            local health = (party.chara:getHealth() / party.chara:getStat("health")) * 100
            Draw.setColor(party.chara.color[1], party.chara.color[2], party.chara.color[3], self.adraw)
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
        
            Draw.setColor(color[1], color[2], color[3], self.adraw)
            love.graphics.print(party.chara:getHealth(), 250, h)
            Draw.setColor(PALETTE["action_health_text"])
            love.graphics.print("/", (260+health_offset), h)
            local string_width = g:getWidth(tostring(party.chara:getStat("health")))
            Draw.setColor(color[1], color[2], color[3], self.adraw)
            love.graphics.print(party.chara:getStat("health"), (280 + health_offset), h)
            --Draw.rectangle("fill", 75 + name:getWidth(), (30*(k-1))+name:getHeight()+5, math.ceil(health), 10)
        end
    else
        self.adraw = 0
    end
end

return BattleUI