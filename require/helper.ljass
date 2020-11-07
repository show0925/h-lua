--- slk hash data
slkHelperHashData = {}

slkHelper = {
    count = 0,
    -- 设定完毕后请求生效，不执行helper设置的内容不会生效(slkHelper)
    enable = function()
        local total = 0
        for _,v in ipairs(slkHelperHashData)do
            total = total + 1
        end
        ?>
        call SaveInteger(hash_hslk_helper, 1, 0, <?=total?>)
        <?
        for i,v in ipairs(slkHelperHashData)do
            ?>
            call SaveStr(hash_hslk_helper, 1, <?=i?>, "<?=string.addslashes(json.stringify(v))?>")
            <?
        end
    end
}

#include "./helper/conf.lua"
#include "./helper/attr.lua"
#include "./helper/ability.lua"
#include "./helper/item.lua"
#include "./helper/unit.lua"
