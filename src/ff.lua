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
    
    update = function()
        blizzard:update()
        if btnp(4) then
            current_state = worldmap_state:new()
        end
        
    end,


    draw = function()
        blizzard:draw()
        print("start", 5, 5, 7)
        
    end
   

})

worldmap_state = game_state:new({

   update = function()
        if btnp(4) then
            current_state = battle_state:new()
        end
    end,

    draw = function()
        cls()
        print("world map", 25, 25, 7)
    end


})


battle_state = game_state:new({

    update = function()
        if btnp(4) then
            current_state = worldmap_state:new()
        end
    end,

    draw = function()
        cls()
        print("battle state", 25, 25, 7)
    end

    
})

character = class:new({
    name = "Hero",
    hp = 100,
    mp = 100,
    attack = 10,
    defense = 5,
    x = 64,
    y = 64,
    speed = 1,
   
    update = function(_ENV)
        if btnp(0) then
            x -= speed
        elseif btnp(1) then
            x += speed
        elseif btnp(2) then
            y -= speed
        elseif btnp(3) then
            y += speed
        elseif btnp(4) then
            x += 10
        elseif btnp(5) then
            y+= 10
        end
    end,

    draw = function(_ENV)
        circfill(x, y, 5, 8)
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
    current_state = start_state:new() -- global variable, don't bother with _ENV for state switching
    blizzard_instance = blizzard:new()
    blizzard_instance:create(100)
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