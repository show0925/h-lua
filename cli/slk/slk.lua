--- 设定配置
---@param conf table 参考 F6_CONF
hslk_conf = function(conf)
    F6_CONF_SET(conf)
end

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

---@param _v{Name,Description,Tip,Ubertip,Hotkey,level,race,type,goldcost,lumbercost,manaN,regenMana,mana0,HP,regenHP,regenType,fmade,fused,stockStart,stockRegen,stockMax,sight,nsight,collision,modelScale,file,fileVerFlags,scaleBull,scale,selZ,selCircOnWater,red,green,blue,occH,maxPitch,maxRoll,impactZ,impactSwimZ,launchX,launchY,launchZ,launchSwimZ,unitSound,RandomSoundLabel,MovementSoundLabel,LoopingSoundFadeOut,LoopingSoundFadeIn,auto,abilList,Sellitems,Sellunits,Markitems,Builds,Buttonpos1,Buttonpos2,Art,Specialart,unitShadow,buildingShadow,shadowH,shadowW,shadowX,shadowY,shadowOnWater,death,deathType,movetp,moveHeight,moveFloor,spd,maxSpd,minSpd,turnRate,acquire,minRange,weapsOn,Missileart,Missilespeed,Missilearc,MissileHoming,targs1,atkType1,weapTp1,weapType1,spillRadius1,spillDist1,damageLoss1,showUI1,backSw1,dmgpt1,rangeN1,RngBuff1,dmgplus1,dmgUp1,sides1,dice1,splashTargs1,cool1,Farea1,targCount1,Qfact1,Qarea1,Hfact1,Harea1,Missileart2,Missilespeed2,Missilearc2,MissileHoming2,targs2,atkType2,weapTp2,weapType2,spillRadius2,spillDist2,damageLoss2,showUI2,backSw2,dmgpt2,rangeN2,RngBuff2,dmgplus2,dmgUp2,sides2,dice2,splashTargs2,cool2,Farea2,targCount2,Qfact2,Qarea2,Hfact2,Harea2,defType,defUp,def,armor,targType,Propernames,nameCount,Awakentip,Revivetip,Primary,STR,STRplus,AGI,AGIplus,INT,INTplus,heroAbilList,hideHeroMinimap,hideHeroBar,hideHeroDeathMsg,Requiresacount,Requires1,Requires2,Requires3,Requires4,Requires5,Requires6,Requires7,Requires8,Reviveat,buffRadius,buffType,Revive,Trains,Upgrade,requirePlace,preventPlace,requireWaterRadius,pathTex,uberSplat,nbrandom,nbmmlcon,canBuildOn,isBuildOn,tilesets,special,campaign,inEditor,dropItems,hostilePal,useClickHelper,tilesetSpecific,Requires,Requiresamount,DependencyOr,Researches,upgrades,EditorSuffix,Casterupgradename,Casterupgradetip,Castrerupgradeart,ScoreScreenIcon,animProps,Attachmentanimprops,Attachmentlinkprops,Boneprops,castpt,castbsw,blend,run,walk,propWin,orientInterp,teamColor,customTeamColor,elevPts,elevRad,fogRad,fatLOS,repulse,repulsePrio,repulseParam,repulseGroup,isbldg,bldtm,bountyplus,bountysides,bountydice,goldRep,lumberRep,reptm,lumberbountyplus,lumberbountysides,lumberbountydice,cargoSize,hideOnMinimap,points,prio,formation,canFlee,canSleep,_id,_class,_type,_parent,_attr}
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

---@param _v{abiList,Requires,Requiresamount,Name,Description,Tip,Ubertip,Hotkey,Art,scale,file,Buttonpos1,Buttonpos2,selSize,colorR,colorG,colorB,armor,Level,oldLevel,class,goldcost,lumbercost,HP,stockStart,stockRegen,stockMax,prio,morph,drop,powerup,sellable,pawnable,droppable,pickRandom,uses,perishable,usable,_id,_class,_type,_parent,_overlie,_weight,_active,_passive,_attr,_attr_txt,_ring,_remarks,_cooldown,_cooldownTarget,_shadow}
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

---@param _v{}
hslk_upgrade = function(_v)
    _v = F6V_UP(_v)
    _v._id = SLK_ID(_v._class, _v._id)
    SLK_GO_SET(_v)
end
