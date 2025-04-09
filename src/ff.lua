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

entity = class:new({
 --   
})

snowflake = entity:new({
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


blizzard = entity:new({
   snowflakes = {},
   active_snowflakes = 1,
   blizzard_growing = true,
   timer = 0,

   init = function(_ENV, count)
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
        for i = 1, active_snowflakes do
            snowflakes[i]:draw()
        end
    end
})


--initial variables to be moved
function initial_variables()
    game_mode = "start"
    blizzard_instance = blizzard:new()
    blizzard_instance:init(50)
     
     
end
--
function _init()
    cls()
    initial_variables()
end

function update_start()
    blizzard:update()

    
    
end

function update_worldmap()

end

function update_battle()

end

function _update()
    if game_mode=="start" then
        update_start()
    elseif game_mode=="worldmap" then
        update_worldmap()
    elseif game_mode=="battle" then
        update_battle()
    end
end

function draw_start()
    cls()
    print(game_mode, 10, 10, 7)
    blizzard:draw()
    
    print(snowflakes, 30, 30, 7)
    print("timer " ..blizzard.timer, 20, 20, 7)
    
    
end

function draw_worldmap()

end

function draw_battle()

end

function _draw()
    if game_mode=="start" then
        draw_start()
    elseif game_mode=="worldmap" then
        draw_worldmap()
    elseif game_mode=="battle" then
        draw_battle()
    end
end