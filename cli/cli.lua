require 'cliSetter'
require 'cliSlk'
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
end
