local Encounter, super = HookSystem.hookScript(Encounter)

function Encounter:getPartyPosition(index)
    if #Game.battle.party <= 3 then return super.getPartyPosition(self, index) end
    
    local x, y = 0, 0
    local column = 0
    local reset = 0
    local middle = 0
    local classic = 4
    if #Game.battle.party > classic then
        if index <= classic then
            column = 80
        else
            reset = classic
            middle = (classic * 2 - #Game.battle.party) * 35
        end
    end
    x = 80 + column
    y = (50 / classic) + ((SCREEN_HEIGHT * 0.5) / classic) * (index - 1 - reset) + middle
    local battler = Game.battle.party[index]
    local ox, oy = battler.chara:getBattleOffset()
    x = x + (battler.actor:getWidth()/2 + ox) * 2
    y = y + (battler.actor:getHeight()  + oy) * 2
    return x, y
end


return Encounter