---@class DarkMenuPartySelect : Object
---@overload fun(...) : DarkMenuPartySelect
local DarkMenuPartySelect, super = HookSystem.hookScript(DarkMenuPartySelect)

function DarkMenuPartySelect:init(x, y)
    super.init(self, x, y)
	
	self.fade_thing = Assets.getTexture("ui/fucking_fade_thing")
end

function DarkMenuPartySelect:draw()
    if #Game.party <=3 then return super.draw(self) end
    for i,party in ipairs(Game.party) do
        if self.selected_party ~= i then
            Draw.setColor(1, 1, 1, 0.4)
        else
            Draw.setColor(1, 1, 1, 1)
        end
        local ox, oy = party:getMenuIconOffset()
        Draw.pushScissor()
        Draw.scissor( -26, -5, 206, 50)
        Draw.draw(Assets.getTexture(party:getMenuIcon()), (i-MathUtils.clamp(self.selected_party-1, 1, #Game.party-2))*50 + (ox*2), oy*2, 0, 2, 2)
        Draw.popScissor()
    end
    Draw.setColor(1,1,1,1)
    Draw.draw(self.fade_thing, -26, -25)
    Draw.draw(self.fade_thing, 180, 55, math.rad(180))
end
return DarkMenuPartySelect