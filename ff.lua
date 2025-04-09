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
        y+= spd
    end,

    draw = function(_ENV)
    circfill(2, 2, 2, 2)
    end

})