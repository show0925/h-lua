require "cliSlk"
require "main"
local _main_start_trg = cj.CreateTrigger()
cj.TriggerRegisterTimerEvent(_main_start_trg, 0.1, false)
cj.TriggerAddAction(_main_start_trg, function()
    cj.DisableTrigger(_main_start_trg)
    cj.DestroyTrigger(_main_start_trg)
    _main_start_trg = nil
    main()
end)
