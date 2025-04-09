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

game_state = class:new({

})

start_state = game_state:new({
    
    update = function(_ENV)
        blizzard:update()
    end,


    draw = function(_ENV)
        blizzard:draw()
    print("start state", 20, 20, 7)
    end
})

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

function initial_variables()
    current_state = start_state:new()
    blizzard_instance = blizzard:new()
    blizzard_instance:create(50)
end

function _init()
    cls()
    initial_variables()
end

function _update()
    if current_state and current_state.update then
        current_state:update()
    end
end

function _draw()
    if current_state and current_state.draw then
        current_state:draw()
    end
end