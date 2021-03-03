# H-Lua

[![image](https://img.shields.io/badge/english-EN_US-blue.svg)](https://github.com/hunzsig-warcraft3/h-lua/blob/main/README_EN-US.md)
![image](https://img.shields.io/badge/license-MIT-blue.svg)
[![image](https://img.shields.io/badge/doc-document-blue.svg)](http://wenku.hunzsig.org/?_=_1_5)
![image](https://img.shields.io/badge/version-1-blue.svg)
[![image](https://img.shields.io/badge/author-hunzsig-red.svg)](https://www.hunzsig.com)
![image](https://img.shields.io/badge/email-mzyhaohaoren@qq.com-green.svg)

[![image](https://img.shields.io/badge/demo-HelloWorld-orange.svg)](https://github.com/hunzsig-warcraft3/w3x-h-lua-helloworld)
[![image](https://img.shields.io/badge/demo-MysteriousLand-orange.svg)](https://github.com/hunzsig-warcraft3/w3x-mysterious-land)
[![image](https://img.shields.io/badge/test-DZAPI-lightgrey.svg)](https://github.com/hunzsig-warcraft3/w3x-test-dzapi)
[![image](https://img.shields.io/badge/test-Crash-lightgrey.svg)](https://github.com/hunzsig-warcraft3/w3x-test-breakdown)

> This set of codes is free for trial by authors who understand Lua. If you do n’t know Lua language, please use T to make maps or learn by yourself. Teaching is not provided here. This tutorial uses YDWE as an example

## Introduction
h-lua has an excellent demo, which guides you to learn more while being open source.
Contains a variety of rich attribute systems, built-in up to dozens of custom events, you can easily make skills that are usually difficult or even impossible.
Powerful item synthesis and splitting, enriching custom skill templates! Avoid writing it yourself! 
Timers, environments, shots, units, enemies, music, weather, masks, missions, and more.

## Project structure：
```
    ├── h-lua.lua - Enter，Your main.lua file should require this first time.
    ├── const
    │   ├── abilityTarget
    │   ├── attritube
    │   ├── attributeXtras
    │   ├── breakArmorType
    │   ├── cache
    │   ├── damageSource
    │   ├── damageType
    │   ├── enchant
    │   ├── event
    │   ├── hero
    │   ├── hotKey
    │   ├── hSlkKeys
    │   ├── item
    │   ├── playerColor
    │   ├── target
    │   └── unit
    ├── foundation
    │   ├── blizzard_b.lua - Blizzard B global variables
    │   ├── blizzard_c.lua - Blizzard C global variables
    │   ├── blizzard_bj.lua - [INVALID]
    │   ├── blizzard_def.lua - [INVALID]
    │   ├── cache.lua
    │   ├── cmd.lua - h-lua Default Commands
    │   ├── color.lua - Color for text
    │   ├── debug.lua
    │   ├── echo.lua - Game screen printing
    │   ├── json.lua
    │   ├── Mapping.lua
    │   ├── math.lua
    │   ├── md5.lua
    │   ├── runtime.lua - cache
    │   ├── string.lua
    │   └── table.lua
    ├── lib
    │   ├── skill
    │   ├── attrbute - Universal Property System
    │   ├── award.lua
    │   ├── buff.lua
    │   ├── camera.lua
    │   ├── courier.lua
    │   ├── dialog.lua
    │   ├── dzapi.lua - Dzapi(with ./plugins/dzapi.jass)
    │   ├── effect.lua
    │   ├── enchant.lua
    │   ├── enemy.lua - Used to set enemy players, automatically assign units
    │   ├── env.lua
    │   ├── event.lua
    │   ├── group.lua - Unit Group
    │   ├── hero.lua
    │   ├── is.lua
    │   ├── item.lua
    │   ├── itemPool.lua
    │   ├── japi.lua
    │   ├── itemPool.lua
    │   ├── leaderBoard.lua
    │   ├── lightning.lua
    │   ├── matcher.lua
    │   ├── monitor.lua
    │   ├── multiBoard.lua
    │   ├── player.lua
    │   ├── quest.lua
    │   ├── rect.lua
    │   ├── shop.lua
    │   ├── sound.lua
    │   ├── textTag.lua
    │   ├── texture.lua
    │   ├── time.lua
    │   ├── unit.lua
    │   └── weather.lua 
    ├── plugins（Copy all codes to the TRIGGER when using）
    │   ├── dzapi.v1.jass - WY expand dzapi(ver.1)
    │   └── dzapi.v2.jass - WY expand dzapi(ver.2)
    ├── require - F4 h-lua enter
    │   ├── data.lua - Files that need to be loaded in the trigger editor
    │   ├── helper.ljass - lua&vjass mixed file，help slk building
    │   ├── init.0.ljass - lua&vjass mixed file，init hslk hashtable
    │   ├── init.1.ljass - lua&vjass mixed file，save hslk data
    │   ├── math.lua - extent functions
    │   ├── require.ljass - enter
    │   └── table.lua - extent functions
    └── resource - [INVALID]
```

#### Quick start：
use [h-lua-cli](https://github.com/hunzsig-warcraft3/h-lua-cli)


#### Enable debug：
```
-- Set HLUA_DEBUG is true before require h-lua
HLUA_DEBUG = true
require "h-lua"
...
```


#### Note：
```
The h-lua library is open source, updated from time to time, you can visit http://wenku.hunzsig.org to view the latest documents
The h-lua library only provides some functional functions to help map authors make maps easier
The h-lua library is not guaranteed to be completely correct and bug-free. If necessary, please modify the source code for game production. Here is just to provide ideas and help.
```