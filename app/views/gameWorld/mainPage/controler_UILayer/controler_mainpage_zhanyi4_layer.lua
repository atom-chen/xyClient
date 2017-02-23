--
-- Author: lipeng
-- Date: 2015-07-02 15:39:31
-- 控制器: 活动

local controler_mainpage_zhanyi4_layer = class("controler_mainpage_zhanyi4_layer")

function controler_mainpage_zhanyi4_layer:ctor(mainpage_zhanyi4_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._mainpage_zhanyi4_layer = mainpage_zhanyi4_layer
    -- self._mainpage_zhanyi4_layer:setContentSize(visibleSize)
    -- ccui.Helper:doLayout(self._mainpage_zhanyi4_layer)
end


--初始化数据
function controler_mainpage_zhanyi4_layer:_initModels()

end


return controler_mainpage_zhanyi4_layer
