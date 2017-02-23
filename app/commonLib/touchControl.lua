--
-- Author: lipeng
-- Date: 2015-06-26 15:59:54
-- 全局触摸控制

GLOBAL_TOUCH_CONTROL = {}

------------------------按键控制---------------------------
--无限按键控制开关
GLOBAL_TOUCH_CONTROL.isForeverControl = false

--按键计时控制开关
GLOBAL_TOUCH_CONTROL.isTimerControl = false

-- 按键控制时间(无限控制计时器)
GLOBAL_TOUCH_CONTROL.foreverSchedulerHandler = nil

-- 有限控制时间计时器
GLOBAL_TOUCH_CONTROL.timerSchedulerHandler = nil

--无限控制计数
GLOBAL_TOUCH_CONTROL.foreverControlCount = 0

--[[控制时间长短]]
--短时间控制
GLOBAL_TOUCH_CONTROL.TIME_LOW = 1
--中等时间控制
GLOBAL_TOUCH_CONTROL.TIME_MIDDLE = 3
--长时间控制
GLOBAL_TOUCH_CONTROL.TIME_LONG = 5

--[[控制类型]]
--无线控制
GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_FOREVER = 1
--计时控制
GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_TIMER = 2

--是否处于控制状态
function GLOBAL_TOUCH_CONTROL:isControl()
	print(self.foreverControlCount)
	return self.isForeverControl or self.isTimerControl
end

--[[按键控制计时器
  time 控制的时间(无线控制控制下是(控制计数) 计时控制（是控制的时间）)
  controlType 控制类型(1 无线控制 2 计时控制 默认为计时控制)
]]
function GLOBAL_TOUCH_CONTROL:TounchContrlScheduler(time ,controlType)
	local controlType = controlType or GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_TIMER
	if controlType == GLOBAL_TOUCH_CONTROL.CONTROL_TYPE_TIMER then

		self.isTimerControl = true

		if self.timerSchedulerHandler then
			GLOBAL_SCHEDULER:unscheduleScriptEntry(self.timerSchedulerHandler)
		end
		self.timerSchedulerHandler = GLOBAL_SCHEDULER:scheduleScriptFunc(
	    	function (  )
	    		self.isTimerControl = false
	    		self.timerSchedulerHandler = nil;
	    	end,
	    	time, false)
	else
		self.foreverControlCount = self.foreverControlCount + time;
		if self.foreverControlCount <= 0 then
			self.isForeverControl = false
			self.foreverControlCount = 0;
		else
			self.isForeverControl = true;
		end
	end
end

