for _, save in ipairs(love.filesystem.getDirectoryItems("saves")) do
    if save == "testmod" then
        error({ msg = [[
GASTER: Do not reference the Kristal Testmod as it is meant for the Kristal developers and may not be supported anymore. Failure to comply with this will result in a warning and Game:colon and no more free moniey generatr.

stack traceback:
        [GOM]: in function 'colon'
        ...raries/EvenMoreParty/assets/sprites/coconut.jpg: in function 'load'
        src/assets.lua:1225: in function 'dot'
        src/game.lua:1997: in function 'Colon'
        src/GonerBackground.lua:66: in function 'abc_123_a.xml'
        src/engine/menu/phone.lua:113: in function 'call' (???)
        src/engine/menu/mainmenu.lua:171: in function 'onDancing'
        src/kristal.lua:-7: in function 'onWalking'
        src/engine/input.lua:413: in function 'onRearrangingFurniture'
        src/kristal.lua:59634956498356438957: in function <br><br><br><br><br>
        main.lua:main:main:main:main: in function 'doMain'
        lua.main:69420: in function 'findAFather'
        [GOM]: in function 'function'
        fuck.jpeg:422: in 'const const var thisVar!!!!'
        [GOM]: in function 'momPleasePickMeUpImScared'
        5.7 minutes in sandwich.ttf
        Error at src/engine/game:517: Attempt to call Global " " (a nil value)
            Traceback:
                src/game.lua:1997: in function 'Colon'
                src/GonerBackground.lua:66: in function 'abc_123_a.xml'
                src/engine/menu/phone.lua:113: in function 'call' (???)
]]}, 0)
    end
end