--
-- Author: lipeng
-- Date: 2015-07-14 20:49:51
-- 公用动作1

--弹出动作弹出
--params.node
--params.shadowNode 可选参数
function GLOBAL_COMMON_ACTION:popupOut( params )
	local node = params.node
	local shadowNode = params.shadowNode
	node:setCascadeOpacityEnabled(true)
	node:setOpacity(0)

	node:setScale(0.4)
	local actions = cc.Spawn:create(
			cc.FadeIn:create(0.25),
			cc.EaseQuinticActionOut:create(cc.ScaleTo:create(0.25, 1))
		)

	if params.callback ~= nil then
		node:runAction(cc.Sequence:create(actions, cc.CallFunc:create(params.callback)))
	else
		node:runAction(actions)
	end
	
	
	if shadowNode ~= nil then
		shadowNode:setOpacity(0)
		shadowNode:runAction(cc.FadeIn:create(0.25))
	end
	
end


--弹出动作收回
--params.node
--params.shadowNode 可选参数
--params.callback 可选参数
function GLOBAL_COMMON_ACTION:popupBack(params)
	local node = params.node
	local shadowNode = params.shadowNode
	-- body
	local actions = cc.Spawn:create(
			cc.FadeOut:create(0.23),
			cc.EaseQuinticActionIn:create(cc.ScaleTo:create(0.25, 0.4))
		)

	if params.callback ~= nil then
		node:runAction(cc.Sequence:create(actions, cc.CallFunc:create(params.callback)))
	end
	
	if shadowNode ~= nil then
		shadowNode:runAction(cc.FadeOut:create(0.25))
	end
end

