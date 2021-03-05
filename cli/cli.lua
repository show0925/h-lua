require 'cliConsole'
require 'cliPre.const.enchant'
require 'cliPre.const.abilityTarget'
require 'cliPre.const.attribute'
require 'cliPre.const.attributeXtras'
require 'cliPre.const.breakArmorType'
require 'cliPre.const.cache'
require 'cliPre.const.damageSource'
require 'cliPre.const.damageType'
require 'cliPre.const.event'
require 'cliPre.const.hero'
require 'cliPre.const.hotKey'
require 'cliPre.const.item'
require 'cliPre.const.monitor'
require 'cliPre.const.target'
require 'cliPre.const.unit'
require 'cliPre.foundation.color'
require 'cliPre.foundation.json'
require 'cliPre.foundation.Mapping'
require 'cliPre.foundation.math'
require 'cliPre.foundation.string'
require 'cliPre.foundation.table'
require 'cliSetter'
require 'cliSlk'
require 'cliSystem'
require 'main'
if (cj ~= nil) then
    local t = cj.CreateTrigger()
    cj.TriggerRegisterTimerEvent(t, 0.1, false)
    cj.TriggerAddAction(t, function()
        cj.DisableTrigger(t)
        cj.DestroyTrigger(t)
        t = nil
        if (type(main) == "function") then
            main()
        end
    end)
else
    if (type(main) == "function") then
        main()
    end
end
