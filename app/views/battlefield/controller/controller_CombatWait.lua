--
-- Author: liyang
-- Date: 2015-06-11 14:56:30
-- 战场等待计数效果


local controller_CombatWait = class("controller_CombatWait")

function controller_CombatWait:ctor()
    self.registerConfig = {
        --初始化数据
        {"battlefield_combatWait","create",1},--战场提示等待
        -- {"battlefield","over",1},--boss 挑战结束
    }
    self:register_event();

    self.CurrentDelayTime = 10;

    self.DelayTimeEffect = nil;
end

--注册事件
function controller_CombatWait:register_event(  )
    local defaultCallbacks = {
        battlefield_combatWait_create = handler(self, self.register_event_create),
    }
    self.eventlisen = {};
    for i,v in ipairs(self.registerConfig) do
        local eventname = createGlobaleEventName( v[1], v[2] )
        print("注册事件",eventname);
        if defaultCallbacks[eventname] then
            createGlobalEventListener( v[1], v[2], defaultCallbacks[eventname], v[3] )
        end
    end

end

function controller_CombatWait:register_event_create( event )
    
end

--[[
    data = {
        boutCount = 18, --回合数
        nextprompt = "", --下一场战斗提示
        countdown = 10,--倒计时
    }
]]
function controller_CombatWait:refreshView( data )
    self.boutValuse:setString(data.boutCount.."/"..data.sumBout);
    self.nextprompt:setString(data.nextprompt);
    --创建倒计时

    if data.countdown then
        self.timeNode = EffectManager.CreatePiece_Timer( data.countdown );
        self.node_timer:addChild(self.timeNode,10);
        self.timeNode:setFinishCallback( function (  )
            print("倒计时完成");
            control_Combat:doEvent("event_exit_battle");
        end );
    end

end


return controller_CombatWait


