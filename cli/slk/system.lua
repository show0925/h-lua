-- h-lua内置slk

--- 单位
--- #token
hslk_unit({
    _parent = "ogru",
    EditorSuffix = "#h-lua",
    Name = "H_LUA_UNIT_TOKEN",
    special = 1,
    abilList = "Avul,Aloc",
    upgrade = "",
    file = ".mdl",
    unitShadow = "",
    collision = 0,
    Art = "",
    movetp = "fly",
    moveHeight = 25.00,
    spd = 522,
    turnRate = 3.00,
    moveFloor = 25.00,
    weapsOn = 0,
    race = "other",
    fused = 0,
    sight = 0,
    nsight = 0,
    Builds = "",
    upgrades = "",
})

--- 冲击单位
--- #token
hslk_unit({
    _parent = "ogru",
    EditorSuffix = "#h-lua",
    Name = "H_LUA_UNIT_TOKEN_LEAP",
    special = 1,
    abilList = "Avul,Aloc",
    upgrade = "",
    file = "h-lua\\interface_token.mdx",
    unitShadow = "",
    collision = 0,
    Art = "",
    modelScale = 1.00,
    movetp = "fly",
    moveHeight = 0.00,
    moveFloor = 0.00,
    spd = 0,
    turnRate = 3.00,
    weapsOn = 0,
    race = "other",
    fused = 0,
    sight = 250,
    nsight = 250,
    Builds = "",
    upgrades = "",
})
