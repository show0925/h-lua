--- 默认配置项
SLK_CONF = {
    autoShadowItem = false, -- 是否自动启用影子物品
    courierSkill = {
        -- 信使技能-名称、热键、图标位置、冷却
        blink = {
            Ubertip = "闪烁到任何地方", Art = "ReplaceableTextures\\CommandButtons\\BTNBlink.blp",
            Hotkey = 'Q', Buttonpos1 = 0, Buttonpos2 = 2, Cool1 = 10
        },
        rangePickUp = {
            Ubertip = "将附近地上的物品拾取到身上", Art = "ReplaceableTextures\\CommandButtons\\BTNPickUpItem.blp",
            Hotkey = 'W', Buttonpos1 = 1, Buttonpos2 = 2, Cool1 = 5
        },
        separate = {
            Ubertip = "将合成或重叠的物品拆分成零件", Art = "ReplaceableTextures\\CommandButtons\\BTNRepair.blp",
            Hotkey = 'E', Buttonpos1 = 2, Buttonpos2 = 2, Cool1 = 5
        },
        deliver = {
            Ubertip = "将所有物品依照顺序传送给英雄，当你的英雄没有空余物品位置，物品会返回给信使", Art = "ReplaceableTextures\\CommandButtons\\BTNLoadPeon.blp",
            Hotkey = 'R', Buttonpos1 = 3, Buttonpos2 = 2, Cool1 = 5
        },
    },
    unitSight = 1400, -- 一般单位白天视野默认值
    unitNSight = 800, -- 一般单位黑夜视野默认值
    heroSight = 1800, -- 英雄单位白天视野默认值
    heroNSight = 800, -- 英雄单位黑夜视野默认值
    shopSight = 1200, -- 商店单位白天视野默认值
    shopNSight = 1200, -- 商店单位黑夜视野默认值
    -- 描述文本颜色,可配置 hcolor 里拥有的颜色函数，也可以配置 hex 6位颜色码
    color = {
        hotKey = "ffcc00", -- 热键
        itemActive = "fae470", -- 物品主动
        itemPassive = "6ab2f6", -- 物品被动
        itemCoolDown = "ccffff", -- 物品冷却时间
        itemAttr = "b0f26e", -- 物品属性
        itemOverlie = "ff59ff", -- 物品叠加
        itemWeight = "ee82ee", -- 物品重量
        itemRemarks = "969696", -- 物品备注
        itemProfit = "ffd88c", -- 物品合成品
        itemFragment = hcolor.orange, -- 物品零部件
        abilityDesc = "fae470", -- 技能描述
        abilityCoolDown = "ccffff", -- 技能冷却时间
        abilityAttr = "b0f26e", -- 技能属性
        ringArea = "99ccff", -- 光环范围
        ringTarget = "99ccff", -- 光环作用目标
        ringDesc = hcolor.white, -- 光环描述
        heroWeapon = "ff3939", -- 英雄攻击武器类型
        heroAttack = "ff8080", -- 英雄基础攻击
        heroRange = "99ccff", -- 英雄攻击范围
        heroPrimary = "ffff00", -- 英雄主属性
        heroSecondary = "ffffcc", -- 英雄主属性
        heroMove = "ccffcc", -- 英雄移动
    },
}

---@param _v{checkDep,Requires,Requiresamount,Effectsound,Effectsoundlooped,EditorSuffix,Name,Untip,Unubertip,Tip,Ubertip,Researchtip,Researchubertip,Unorder,Orderon,Order,Orderoff,Unhotkey,Hotkey,Researchhotkey,UnButtonpos1,UnButtonpos2,Buttonpos1,Buttonpos2,Researchbuttonpos1,Researchbuttonpos2,Unart,Researchart,Art,SpecialArt,Specialattach,Missileart,Missilespeed,Missilearc,MissileHoming,LightningEffect,EffectArt,TargetArt,Targetattachcount,Targetattach,Targetattach1,Targetattach2,Targetattach3,Targetattach4,Targetattach5,Areaeffectart,Animnames,CasterArt,Casterattachcount,Casterattach,Casterattach1,hero,item,race,levels,reqLevel,priority,BuffID1,EfctID1,Tip1,Ubertip1,targs1,DataA1,DataB1,DataC1,DataD1,DataE1,DataF1,Cast1,Cool1,Dur1,HeroDur1,Cost1,Rng1,Area1,_id,_class,_type,_parent,_desc,_attr,_attr_txt,_ring}
hslk_ability = function(_v)
    _v = F6V_A(_v)
    _v._id = SLK_ID(_v._class, _v._id)
    SLK_GO_SET(_v)
    return _v
end

---@param _v{checkDep,Requires,Requiresamount,Effectsound,Effectsoundlooped,EditorSuffix,Name,Untip,Unubertip,Tip,Ubertip,Researchtip,Researchubertip,Unorder,Orderon,Order,Orderoff,Unhotkey,Hotkey,Researchhotkey,UnButtonpos1,UnButtonpos2,Buttonpos1,Buttonpos2,Researchbuttonpos1,Researchbuttonpos2,Unart,Researchart,Art,SpecialArt,Specialattach,Missileart,Missilespeed,Missilearc,MissileHoming,LightningEffect,EffectArt,TargetArt,Targetattachcount,Targetattach,Targetattach1,Targetattach2,Targetattach3,Targetattach4,Targetattach5,Areaeffectart,Animnames,CasterArt,Casterattachcount,Casterattach,Casterattach1,hero,item,race,levels,reqLevel,priority,BuffID1,EfctID1,Tip1,Ubertip1,targs1,DataA1,DataB1,DataC1,DataD1,DataE1,DataF1,Cast1,Cool1,Dur1,HeroDur1,Cost1,Rng1,Area1,_id,_class,_desc,_attr,_attr_txt,_ring}
hslk_ability_empty = function(_v)
    _v = F6V_A_E(_v)
    _v._id = SLK_ID(_v._class, _v._id)
    SLK_GO_SET(_v)
    return _v
end

---@param _v{checkDep,Requires,Requiresamount,Effectsound,Effectsoundlooped,EditorSuffix,Name,Untip,Unubertip,Tip,Ubertip,Researchtip,Researchubertip,Unorder,Orderon,Order,Orderoff,Unhotkey,Hotkey,Researchhotkey,UnButtonpos1,UnButtonpos2,Buttonpos1,Buttonpos2,Researchbuttonpos1,Researchbuttonpos2,Unart,Researchart,Art,SpecialArt,Specialattach,Missileart,Missilespeed,Missilearc,MissileHoming,LightningEffect,EffectArt,TargetArt,Targetattachcount,Targetattach,Targetattach1,Targetattach2,Targetattach3,Targetattach4,Targetattach5,Areaeffectart,Animnames,CasterArt,Casterattachcount,Casterattach,Casterattach1,hero,item,race,levels,reqLevel,priority,BuffID1,EfctID1,Tip1,Ubertip1,targs1,DataA1,DataB1,DataC1,DataD1,DataE1,DataF1,Cast1,Cool1,Dur1,HeroDur1,Cost1,Rng1,Area1,_id,_class,_desc,_attr,_attr_txt,_ring}
hslk_ability_ring = function(_v)
    _v = F6V_A_R(_v)
    _v._id = SLK_ID(_v._class, _v._id)
    SLK_GO_SET(_v)
    return _v
end

---@param _v{Name,Description,Tip,Ubertip,Hotkey,level,race,type,goldcost,lumbercost,manaN,regenMana,mana0,HP,regenHP,regenType,fmade,fused,stockStart,stockRegen,stockMax,sight,nsight,collision,modelScale,file,fileVerFlags,scaleBull,scale,selZ,selCircOnWater,red,green,blue,occH, -- 闭塞高度maxPitch,maxRoll,impactZ,impactSwimZ,launchX,launchY,launchZ,launchSwimZ,unitSound,RandomSoundLabel,MovementSoundLabel,LoopingSoundFadeOut,LoopingSoundFadeIn,auto,abilList,Sellitems,Sellunits,Markitems,Builds,Buttonpos1,Buttonpos2,Art,Specialart,unitShadow,buildingShadow,shadowH,shadowW,shadowX,shadowY,shadowOnWater,death,deathType,movetp,moveHeight,moveFloor,spd,maxSpd,minSpd,turnRate,acquire,minRange,weapsOn,Missileart,Missilespeed,Missilearc,MissileHoming,targs1,atkType1,weapTp1,weapType1,spillRadius1,spillDist1,damageLoss1,showUI1,backSw1,dmgpt1,rangeN1,RngBuff1,dmgplus1,dmgUp1,sides1,dice1,splashTargs1,cool1,Farea1,targCount1,Qfact1,Qarea1,Hfact1,Harea1,Missileart2,Missilespeed2,Missilearc2,MissileHoming2,targs2,atkType2,weapTp2,weapType2,spillRadius2,spillDist2,damageLoss2,showUI2,backSw2,dmgpt2,rangeN2,RngBuff2,dmgplus2,dmgUp2,sides2,dice2,splashTargs2,cool2,Farea2,targCount2,Qfact2,Qarea2,Hfact2,Harea2,defType,defUp,def,armor,targType,Propernames,nameCount,Awakentip,Revivetip,Primary,STR,STRplus,AGI,AGIplus,INT,INTplus,heroAbilList,hideHeroMinimap,hideHeroBar,hideHeroDeathMsg,Requiresacount,Requires1,Requires2,Requires3,Requires4,Requires5,Requires6,Requires7,Requires8,Reviveat,buffRadius,buffType,Revive,Trains,Upgrade,requirePlace,preventPlace,requireWaterRadius,pathTex,uberSplat,nbrandom,nbmmlcon,canBuildOn,isBuildOn,tilesets,special,campaign,inEditor,dropItems,hostilePal,useClickHelper,tilesetSpecific,Requires,Requiresamount,DependencyOr,Researches,upgrades,EditorSuffix,Casterupgradename,Casterupgradetip,Castrerupgradeart,ScoreScreenIcon,animProps,Attachmentanimprops,Attachmentlinkprops,Boneprops,castpt,castbsw,blend,run,walk,propWin,orientInterp,teamColor,customTeamColor,elevPts,elevRad,fogRad,fatLOS,repulse,repulsePrio,repulseParam,repulseGroup,isbldg,bldtm,bountyplus,bountysides,bountydice,goldRep,lumberRep,reptm,lumberbountyplus,lumberbountysides,lumberbountydice,cargoSize,hideOnMinimap,points,prio,formation,canFlee,canSleep,_id,_class,_type,_parent,_attr}
hslk_unit = function(_v)
    _v = F6V_U(_v)
    _v._id = SLK_ID(_v._class, _v._id)
    SLK_GO_SET(_v)
end

--- 物品合成公式数组，只支持slkHelper创建的注册物品
---例子1 "小刀割大树=小刀+大树" 2个不一样的合1个
---例子2 "三头地狱犬的神识=地狱狗头x3" 3个一样的合1个
---例子3 "精灵神水x2=精灵的眼泪x50" 50个一样的合一种,但得到2个
---例子4 {{"小刀割大树",1},{"小刀",1},{"大树",1}} 对象型配置，第一项为结果物品(适合物品名称包含特殊字符的物品，如+/=影响公式的符号)
hslk_item_synthesis = function(formula)
    F6V_I_SYNTHESIS(formula)
end

---@param _v{abiList,Requires,Requiresamount,Name,Description,Tip,Ubertip,Hotkey,Art,scale,file,Buttonpos1,Buttonpos2,selSize,colorR,colorG,colorB,armor,Level,oldLevel,class,goldcost,lumbercost,HP,stockStart,stockRegen,stockMax,prio,morph,drop,powerup,sellable,pawnable,droppable,pickRandom,uses,perishable,usable,_id,_class,_type,_parent,_overlie,_weight,_active,_passive,_attr,_attr_txt,_ring,_cooldown,_cooldownTarget,_shadow}
hslk_item = function(_v)
    _v = F6V_I(_v)
    _v._id = SLK_ID(_v._class, _v._id)
    if (type(_v._shadow) == "boolean" and true == _v._shadow) then
        local _vs = F6V_I_SHADOW(_v)
        _vs._id = SLK_ID(_vs._class, _vs._id)
        _v._shadow_id = _vs._id
        _vs._shadow_id = _v._id
        SLK_GO_SET(_v)
        SLK_GO_SET(_vs)
    else
        SLK_GO_SET(_v)
    end
end
