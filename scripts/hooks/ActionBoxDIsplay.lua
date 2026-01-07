local ActionBoxDisplay, super = HookSystem.hookScript(ActionBoxDisplay)

function ActionBoxDisplay:init(actbox, x, y)
    super.init(self, actbox, x, y)

end

return ActionBoxDisplay