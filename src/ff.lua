class = setmetatable({
    new = function(_ENV, tbl)
        tbl = tbl or {}

        setmetatable(tbl, {
            __index = _ENV
        })
        return tbl
    end,
    init = function() end
}, {__index = _ENV})


-- game state stuff
-- maybe one for dungeons, might be superfluous 
game_state = class:new({
   --just in case I want to add some things
})

state_manager = class:new({
    current_state = nil,

    set_state = function(_ENVV, new_state)
        current_state = new_state
    end,

    update = function(_ENV_)
        if current_state and current_state.update then
            current_state:update()
        end
    end,

    draw = function(_ENV)
        if current_state and current_state.update then
            current_state:draw()
        end
    end,
})

--title screen
start_state = game_state:new({
    
    update = function()
        blizzard:update()
        if btnp(4) then
            sm:set_state(worldmap_state:new())
        end
        sprite:update()
        
    end,


    draw = function()
        blizzard:draw()
        print("title screen", 64, 64, 13)
        sprite:draw()
    end
   

})


--worldmap
worldmap_state = game_state:new({

   update = function()
        if btnp(4) then
            sm:set_state(battle_state:new())
        end
    end,

    draw = function()
        cls()
        print("world map", 25, 25, 7)
        map()
    end


})

-- for fights
battle_state = game_state:new({

    update = function()
        if btnp(4) then
            sm:set_state(worldmap_state:new())
        end
    end,

    draw = function()
        cls()
        print("battle state", 25, 25, 7)
    end

    
})

--sprites

sprite  = class:new({ 
    
    x = 10, 
    y = 10,
    move_speed = 1,
    sprite = 56,
    w = 1,
    h = 1,

    animate = function(_ENV)
        local animationframes = {56, 57, 58, 59}
        local currentframe = 1
        local function playanimation()
            currentframe += 1
            if currentframe > #animationframes then
                currentframe = 1
            end
        end

    end,

    update = function(_ENV)  
        if btnp(0) then
            x -= move_speed
        elseif btnp(1) then
            x += move_speed
        elseif btnp(2) then
            y -= move_speed
        elseif btnp(3) then
            y += move_speed
        end
    end,


   

    draw = function(_ENV)
            spr(sprite, x, y, h , w, xflip, yflip)
        if btnp(0) then 
            spr(sprite, x, y, h , w, xflip, yflip)
            xflip = true
        elseif btnp(1) then
            spr(sprite, x, y, h , w, xflip ,yflip)
            xflip = false
        elseif btnp(2) then
            spr(sprite, x, y, h , w, xflip ,yflip)
            yflip = true
        else if btnp(3) then 
            spr(sprite, x, y, h , w, xflip ,yflip)
            yflip = false
        end
    
    end
end
})

--snowflake/title screen blizzard
snowflake = class:new({
    x = rnd(127),
    y = rnd(127),
    speed = rnd(2+0.25),
    radius = flr(rnd(3)),
    clr = 7,

    update = function(_ENV)
        if speed < 0.5 then
            clr = 1
        elseif speed < 1.0 then
            clr = 13
        end
        x += speed
        y += speed
        if x - radius > 127 then
            x -= 127
        elseif y - radius > 127 then
            y -= 127
        end
    end,

    draw = function(_ENV)
        circfill(x, y, radius, clr)
    end

})


blizzard = class:new({
   snowflakes = {},
   active_snowflakes = 1,
   blizzard_growing = true,
   timer = 0,

   create = function(_ENV, count)
        for i = 1, count do
            local flake = snowflake:new({
            x = rnd(127),
            y = rnd(127),
            speed = rnd(2 + 0.25),
            radius = flr(rnd(2)),
            })
            add(snowflakes, flake)
        end
    end,

    update = function(_ENV)
        timer += 1
        if timer % 30 == 0 then
            if blizzard_growing then
                if active_snowflakes < #snowflakes then
                    active_snowflakes += 1
                else
                    blizzard_growing = false
                end
            else
                if active_snowflakes > 0 then
                    active_snowflakes -= 1
                else
                    blizzard_growing = true
                end
            end
        end

        for i = 1, active_snowflakes do
            snowflakes[i]:update()
        end
    end,

    draw = function(_ENV)
        cls()
        for i = 1, active_snowflakes do
            snowflakes[i]:draw()
        end
    end
})


--init stuff, trying to keep this fairly clean 
function initial_variables()
    sm = state_manager:new() --new state manager for gloabl env
    sm:set_state(start_state:new())
    blizzard_instance = blizzard:new() --title screen blizzard
    blizzard_instance:create(100)
end

function _init()
    cls()
    initial_variables() 
end

function _update()
    sm:update()
end

function _draw()
    sm:draw()
end