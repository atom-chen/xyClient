--
-- Author: lipeng
-- Date: 2015-07-02 15:39:31
-- 控制器: 竞技场

local controler_mainpage_zhanyi5_layer = class("controler_mainpage_zhanyi5_layer")

function controler_mainpage_zhanyi5_layer:ctor(mainpage_zhanyi5_layer)
	self:_initModels()

	local visibleSize = cc.Director:getInstance():getVisibleSize()

	self._mainpage_zhanyi5_layer = mainpage_zhanyi5_layer
    -- self._mainpage_zhanyi5_layer:setContentSize(visibleSize)
    -- ccui.Helper:doLayout(self._mainpage_zhanyi5_layer)
end


--初始化数据
function controler_mainpage_zhanyi5_layer:_initModels()

end


return controler_mainpage_zhanyi5_layer
