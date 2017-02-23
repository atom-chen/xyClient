--
-- Author: lipeng
-- Date: 2015-08-07 10:32:17
-- 控制器: pageView
-- 参考文献: http://www.cocoachina.com/bbs/read.php?tid-216078-page-1.html


local controler_pageView = class("controler_pageView")


function controler_pageView:ctor(pageView)
	self:_initModels()

	self._pageView = pageView

	self:_registUIEvent()
end

--[[
跳转至目标页
构造时并不会对页的数据更新, 
要更新对应页的数据只能通过调用该函数
]]
function controler_pageView:turnToPage( destDataPageIdx )
	if destDataPageIdx > self._maxDataPageNum then
		destDataPageIdx = self._maxDataPageNum

	elseif destDataPageIdx < 1 then
		destDataPageIdx = 1
	end

	self._curInDataPageIdx = destDataPageIdx

	if self._maxDataPageNum == 1 then
		self:_updatePage(1, 0)

	elseif self._maxDataPageNum > 1 then
		local prePage = self._curInDataPageIdx - 1
		if prePage < 1 then
			prePage = self._maxDataPageNum
		end

		local nextPage = self._curInDataPageIdx + 1
		if nextPage > self._maxDataPageNum then
			nextPage = 1
		end

		self:_updatePage(prePage, 0)
	    self:_updatePage(self._curInDataPageIdx, 1)
	    self:_updatePage(nextPage, 2)
	    self:_scrollToPage(1)
	end
	
end

--设置数据页最大数量
function controler_pageView:setMaxDataPageNum( num )
	self._maxDataPageNum = num
	--当最大页数发生变化时, 必定要更新页缓存
	--因为如果最大页为1页时, 为了避免产生滑动, 会清掉缓存页,
	--仅保留1页
	self:_updateCachePageView()
end

--获取数据页最大数量
function controler_pageView:getMaxDataPageNum()
	return self._maxDataPageNum
end

--设置通过滑动翻页时的回调
function controler_pageView:setScrollPageCallBack( callBackFun )
	self._scrollPageCallBack = callBackFun
end


--设置页更新回调
--[[
dataPageIdx: 数据页索引
pageView: 页视图
function pageUpdateCallBack(dataPageIdx, pageView)
	...
end
]]
function controler_pageView:setPageUpdateCallBack( callBackFun )
	self._pageUpdateCallback = callBackFun
end

--[[
pageCloneFunc: 设置页的克隆函数(默认调用UIWeiget的clone)
function pageCloneFunc(page)
	local newPage = page:clone()
	--特殊数据的拷贝处理
	...
	return newPage
end
]]
function controler_pageView:setPageCloneFunc( pageCloneFunc )
	self._pageCloneFunc = pageCloneFunc
end


function controler_pageView:getView()
    return self._pageView
end



--获取当前所在数据页
function controler_pageView:getCurInDataPageIdx()
	return self._curInDataPageIdx
end

--左翻页
function controler_pageView:leftTurnPage()
	local destDataPageIdx = self._curInDataPageIdx - 1

	if destDataPageIdx < 1 then
		destDataPageIdx = self._maxDataPageNum
	end

	self:turnToPage(destDataPageIdx)
end

--右翻页
function controler_pageView:rightTurnPage()
	local destDataPageIdx = self._curInDataPageIdx + 1
	if destDataPageIdx > self._maxDataPageNum then
		destDataPageIdx = 1
	end

	self:turnToPage(destDataPageIdx)
end



function controler_pageView:_initModels()
    self._controlerMap = {}
    self._curInDataPageIdx = 1 -- 当前所在数据页的索引
    self._maxDataPageNum = 1  --数据页最大数量
    self._pageCloneFunc = nil --页的拷贝函数(默认调用UIWeiget的clone)
    self._pageUpdateCallback = nil --页更新回调
    self._scrollPageCallBack = nil --滑动翻页时的回调
end


function controler_pageView:_registUIEvent()
	self._pageView:addEventListener(handler(self, self._onPageViewEvent))
end


--[[
更新Page视图缓存,
以已经存在的page0为模板进行拷贝, 生成其他两个page
共3个page视图, 
page0: 负责缓存上一页
page1: 负责显示当前页
page2: 负责缓存下一页

如果最大页数只有一页则不会缓存, 因为会导致滑动生效
]]
function controler_pageView:_updateCachePageView()
	--删除原来的页面, 仅保留第一页
	local pageNum = table.nums(self._pageView:getPages())
    for i = pageNum - 1, 1, -1 do
        self._pageView:removePageAtIndex(i) 
    end

	--是否创建视图缓存
	local isCreateCacheView = false

	if self._maxDataPageNum > 1 then
		isCreateCacheView = true
	end

	if isCreateCacheView then
		for i=1, 2 do
			local newPageView = nil

			if self._pageCloneFunc ~= nil then
				newPageView = self._pageCloneFunc(self._pageView:getPage(0))
			else
				newPageView = self._pageView:getPage(0):clone()
			end

			self._pageView:insertPage(newPageView, 0)
		end

		self:_scrollToPage(1)

	else
		self:_scrollToPage(0)
	end

end


function controler_pageView:_updatePage( dataPageIdx, viewPageIdx )
 	if self._pageUpdateCallback ~= nil then
 		local panle = self._pageView:getPage(viewPageIdx)
 		if panle ~= nil then
 			self._pageUpdateCallback(dataPageIdx, panle)
 		end
	end
end


function controler_pageView:_onPageViewEvent(sender, eventType)

    if eventType == ccui.PageViewEventType.turning then
    	if self._maxDataPageNum > 1 then
    		--左翻页成功, 因为如果翻页失败, 当前页索引为1
    		if 0 == self._pageView:getCurPageIndex() then
    			self:leftTurnPage()
    			if self._scrollPageCallBack ~= nil then
    				self._scrollPageCallBack()
    			end

			--右翻页成功, 因为如果翻页失败, 当前页索引为1
	        elseif 2 == self._pageView:getCurPageIndex() then
	        	self:rightTurnPage()
	        	if self._scrollPageCallBack ~= nil then
    				self._scrollPageCallBack()
    			end
	        end
    	end
    end
 
end


function controler_pageView:_scrollToPage( viewPageIdx )
	--如果scrollTo的页为当前所在页, 在self._pageView:update(10)时会发生崩溃,
	--具体原因没有细看
	if self._pageView:getCurPageIndex() == viewPageIdx then
		return
	end
    self._pageView:scrollToPage(viewPageIdx)
    --解决强制滑动到1后回弹效果
    self._pageView:update(10)
end

return controler_pageView


