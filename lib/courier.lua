---@class hcourier 信使
hcourier = {}

--- 注册hlua框架默认的信使技能，极速做图
--- slkHelper配置了 COURIER_AUTO_SKILL 的信使会自动注册,无需手动调用
hcourier.embed = function(whichCourier)
    hevent.pool(whichCourier, hevent_default_actions.courier.defaultSkills, function(tgr)
        cj.TriggerRegisterUnitEvent(tgr, whichCourier, EVENT_UNIT_SPELL_EFFECT)
    end)
end