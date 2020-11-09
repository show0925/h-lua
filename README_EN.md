 * [Github](https://github.com/hunzsig-warcraft3/h-lua)
 * [Demo1:HelloWorld](https://github.com/hunzsig-warcraft3/w3x-h-lua-helloworld)
 * [Demo2:My TD Game](https://github.com/hunzsig-warcraft3/w3x-my-tower)
 * [Test1: DZAPI](https://github.com/hunzsig-warcraft3/w3x-test-dzapi)
 * [Test2: Crash](https://github.com/hunzsig-warcraft3/w3x-test-breakdown)
 * [Quick start(zh-cn)](http://wenku.hunzsig.org/?_=_1_5)
 * Author: hunzsig
 * QQ Group Number: 325338043(China)


## Introduction
h-lua has an excellent demo, which guides you to learn more while being open source. It does not rely on any game platform (such as JAPI, DzAPI) but does not prohibit you from using it (with integrated DzAPI). 
Contains a variety of rich attribute systems, built-in up to dozens of custom events, you can easily make skills that are usually difficult or even impossible. Powerful item synthesis and splitting, enriching custom skill templates! Avoid writing it yourself! Timers, environments, shots, units, enemies, music, weather, masks, missions, and more.

## Project structure：
```
    ├── h-lua.lua - Enter，Your main.lua file should require this first time.
    ├── const
    │   ├── attritube
    │   ├── breakArmorType
    │   ├── damageKind
    │   ├── damageType
    │   ├── event
    │   ├── hero
    │   ├── hotKey
    │   ├── hSlkKeys
    │   ├── item
    │   ├── playerColor
    │   └── unit
    ├── foundation
    │   ├── blizzard_b.lua - Blizzard B global variables
    │   ├── blizzard_c.lua - Blizzard C global variables
    │   ├── blizzard_bj.lua - [INVALID]
    │   ├── blizzard_def.lua - [INVALID]
    │   ├── color.lua - Color for text
    │   ├── debug.lua
    │   ├── echo.lua - Game screen printing
    │   ├── f9.lua - h-lua Quest
    │   ├── json.lua
    │   ├── math.lua
    │   ├── md5.lua
    │   ├── runtime.lua - cache
    │   ├── string.lua
    │   └── table.lua
    ├── lib
    │   ├── skill
    │   ├── attrbute.lua - Universal Property System
    │   ├── award.lua
    │   ├── camera.lua
    │   ├── dialog.lua
    │   ├── dzapi.lua - Dzapi(with ./plugins/dzapi.jass)
    │   ├── effect.lua
    │   ├── enemy.lua - Used to set enemy players, automatically assign units
    │   ├── env.lua
    │   ├── event.lua
    │   ├── group.lua - Unit Group
    │   ├── hero.lua
    │   ├── is.lua
    │   ├── item.lua
    │   ├── leaderBoard.lua
    │   ├── lightning.lua
    │   ├── multiBoard.lua
    │   ├── player.lua
    │   ├── quest.lua
    │   ├── rect.lua
    │   ├── sound.lua
    │   ├── textTag.lua
    │   ├── texture.lua
    │   ├── time.lua
    │   ├── unit.lua
    │   └── weather.lua 
    ├── package - Package on the WY platform
    ├── plugins
    │   └── dzapi.jass - WY expand dzapi, Copy to trigger when using
    ├── resource - [INVALID]
    └── slk - SLK Object editing data
        ├── data.lua - Files that need to be loaded in the trigger editor
        ├── helper.lua - Files that need to be loaded in the trigger editor
        └── init.jass - Files that need to be loaded in the trigger editor
```

> This set of codes is free for trial by authors who understand Lua. If you do n’t know Lua language, please use T to make maps or learn by yourself. Teaching is not provided here. This tutorial uses YDWE as an example

## Preparation：

> Checked the Lua engine of YDWE

> You can sed editor settings in the [Quick start]

### Let's start to use h-lua：

> Open YDWE, open the map, press F4 to open the trigger editor

> Add a [new trigger] at the top of the top position

> Select the new trigger and click the menu [Edit] to convert it to custom text and replace it with your code, as follows:

```
<?
#include "[YOUR PATH]/h-lua/slk/helper.lua"
#include "[YOUR PATH]/h-lua/slk/init.jass"
import("main.lua") ("hot.lua", true)
?>
```
> When you upload to the WY platform, use package and: import("main.lua") ("dist.lua", true)

```
Note：
The h-lua library is open source, updated from time to time, you can visit http://hlua.book.hunzsig.org to view the latest documents
The h-lua library only provides some functional functions to help map authors make maps easier
The h-lua library is not guaranteed to be completely correct and bug-free. If necessary, please modify the source code for game production. Here is just to provide ideas and help.
Because h-lua uses slk, it will automatically help you generate all the object compilations needed by the framework when saving, so there is no need to build the object compilations by yourself.
```