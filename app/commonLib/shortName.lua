--
-- Author: lipeng
-- Date: 2015-06-15 10:37:32
-- 接口缩写

--全局事件分发器
--使用示例参考: cocos2dx\3.6\cocos2d-x-3.6\tests\lua-tests\src\NewEventDispatcherTest
--主要参考CustomEvent(自定义事件)
GLOBAL_EVENT_DISPTACHER = cc.Director:getInstance():getEventDispatcher()
--全局调度器
GLOBAL_SCHEDULER = cc.Director:getInstance():getScheduler()
--纹理缓存
GLOBAL_TEXTURE_CACHE = cc.Director:getInstance():getTextureCache()
--精灵帧缓存
GLOBAL_SPRITE_FRAMES_CACHE = cc.SpriteFrameCache:getInstance()
--动画管理
GLOBAL_ARMATURE_MANAGER = ccs.ArmatureDataManager:getInstance()

--
NULL_GUID = "{00000000-0000-0000-0000-000000000000}"
