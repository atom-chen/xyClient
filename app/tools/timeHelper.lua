--
-- Author: lipeng
-- Date: 2015-08-20 15:09:51
-- 时间计算相关的辅助类

TIME_HELPER = {}


--客户端时间转换为服务器时间
function TIME_HELPER:clientTimeToServerTime( time )
    return time + g_time
end


--[[计数秒数表示的时间
    second 对应的秒数
    return 天 ，小时 ，分
]]
function TIME_HELPER:timeBySecond( second )
    local minute = 0;
    local day = 0;
    local hour = 0;
    --天数
    day = second / 86400 ;
    if day % 1 > 0 then
        day = math.ceil(day) - 1;
    else
        day = math.ceil(day)
    end
    -- 小时数
    hour = (second - day * 86400) / 3600;
    if hour % 1 > 0 then
        hour = math.ceil(hour) - 1;
    else
        hour = math.ceil(hour)
    end
    -- 分钟
    minute = second % 3600 / 60;
    if minute % 1 > 0 then
        minute = math.ceil(minute) - 1;
    else
        minute = math.ceil(minute)
    end
    return day , hour ,minute;
end

--秒转为小时, 分, 秒
function TIME_HELPER:secondToTime( second )
    local hour_ = (math.floor(second / (60*60))) % 24
    local min_ = (math.floor(second / 60)) % 60
    local sec_ = second % 60

    return {hour=hour_, min=min_, sec=sec_, totalSec = second}
end

--将小时范围内时间的转为秒
function TIME_HELPER:timeToSecondInHourRange( time )
    local hour = time.hour or 0
    local min = time.min or 0
    min = min + hour * 60
    local sec = time.sec or 0
    return sec + min * 60
end

--[[得到时间描述
    时间大于小时 返回 小时 分
    时间大于天 返回 天 小时
    时间大于 秒 返回 分 秒
]]
function TIME_HELPER:getTimeDesByMax( second )
    local day , hour ,minute = TIME_HELPER:timeBySecond( second )
    local des = "";
    if day > 0 then
        des = day.."天"..hour.."小时";
    elseif hour > 0 then
        des = hour.."小时"..minute.."分";
    elseif minute > 0 then
        des = minute.."分";
    else
        des = "1分";
    end
    return des;
end


