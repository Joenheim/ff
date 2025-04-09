class = setmetatable({
    new = function(_ENV, tbl)
        tbl = {} or tbl

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

p1 = entity:new({
    x = 64,
    y = 64,
    speed = 1,

    update = function(_ENV)
        x += speed
        y += speed
    end,

    draw = function(_ENV)
    circfill(2, 2, 2, 2)
    end

})

snowflake = entity:new({
    x = rnd(127),
    y = rnd(127),
    speed = 0.75,
    radius = flr(rnd(2)),
    color = 13,

    update = function(_ENV)
        x += speed
        y += speed
        if x - radius > 127 then
            x -= 127
        elseif y - radius > 127 then
            y -= 127
        end
    end,

    draw = function(_ENV)
        circfill(x, y, radius, color)
    end

})


--initial variables to be moved

pal(0, 129, 1)

--
function _init()
    cls()
    game_mode = "start"
end

function update_start()

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
    cls(13)
    print(game_mode, 64, 64, 7)
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