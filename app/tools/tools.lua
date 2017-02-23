--
-- Author: Wu Hengmin
-- Date: 2015-07-09 20:15:02
--

function globalTouchEvent(sender,eventType)
    if eventType == ccui.TouchEventType.began then
        sender.MarkIsMove = false
        sender.Record_pos = sender:convertToWorldSpace(cc.p(0, 0))
    elseif eventType == ccui.TouchEventType.moved then
    	if not sender.MarkIsMove then
	    	local pos = sender:convertToWorldSpace(cc.p(0, 0))
	    	if cc.pGetLength(cc.p(pos.x - sender.Record_pos.x, pos.y - sender.Record_pos.y)) > 20 then
	    		sender.MarkIsMove = true
	    	end
	    end
    elseif eventType == ccui.TouchEventType.ended then
        if not sender.MarkIsMove then
            return true
        end
    elseif eventType == ccui.TouchEventType.canceled then
        
    end
    return false
end
