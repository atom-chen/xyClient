--
-- Author: LiYang
-- Date: 2015-07-21 14:16:18
-- 资源加载逻辑

--[[发送全局事件名预览
eventModleName: loadres -- 战役界面内部控制
eventName: 
	finish 加载完成
]]

--[[监听全局事件名预览
eventModleName: 
eventName:
]]

--[[
	reslist 必须是解析好的 一维数组
]]

-- cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888
-- cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444
-- cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565

local resLoadLogic = class("resLoadLogic");

function resLoadLogic:ctor()
	-- body
	--异步加载顺序
	self.AsyncLoadOrder = {
		cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888,
		cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444,
		cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565,
	};
	self.CurrentLoad = 1;
end

function resLoadLogic.getInstance()
	if resLoadLogic.instance == nil then
		resLoadLogic.instance = resLoadLogic.new()
	end
	return resLoadLogic.instance
end

--设置加载列表
function resLoadLogic:setLoadList( reslist , mark )
	self.mark = mark;
	self.resList = reslist;
	--加载的数量
	self.loadCount = table.nums(self.resList);
	self.CurrentLoad = 1;
	-- for k,v in pairs(self.resList) do
	-- 	if v then
	-- 		local resInfo = ResConfig[v];
	-- 		for i,j in ipairs(resInfo.res) do
	-- 			self.ResCount = self.ResCount + 1;
	-- 		end
	-- 	end
	-- end
	self.CurrentIndex = 1;
end

function resLoadLogic:setCallback( callfun )
	self.Callfun = callfun;
end

--加载资源
function resLoadLogic:LoadRes(  )
	for k,v in pairs(self.resList) do
		cc.Texture2D:setDefaultAlphaPixelFormat(getTexturePixelFormat( v ));
		GLOBAL_TEXTURE_CACHE:addImage(v)
		cc.Texture2D:setDefaultAlphaPixelFormat(GOLBAL_DEFAULT_PIXELFORMAT);
	end
	-- dispatchGlobaleEvent("loadres", "finish", self.mark)
	if self.Callfun then
		cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888);
		self.Callfun(self.mark)
	end
end

--异步加载
function resLoadLogic:AsyncLoadRes(  )
	-- print(self.AsyncLoadOrder[self.CurrentLoad])
	self:AsyncLoadResByFormat( self.AsyncLoadOrder[self.CurrentLoad] )
end

--队列加载资源
function resLoadLogic:AsyncLoadResByQueue(  )
	local resdata = self.resList[self.CurrentIndex];
	local format = getTexturePixelFormat( resdata );
	cc.Texture2D:setDefaultAlphaPixelFormat(format);
	print("      ",resdata)
	GLOBAL_TEXTURE_CACHE:addImageAsync(resdata, handler(self, self.listenerLoadQueue))
end

--[[分格式加载
]]
function resLoadLogic:AsyncLoadResByFormat( PixelFormat )
	-- if not name then
	-- 	printError("Error:resLoadLogic 加载资源为nil")
	-- 	return;
	-- end
	--[[ 分像素格式加载
		先加载
	]]
	self.CurrentCount = 0;
	for k,v in pairs(self.resList) do
		local format = getTexturePixelFormat( v );
		if format == PixelFormat then
			self.CurrentCount = self.CurrentCount + 1;
		end
	end
	print("加载格式资源:",PixelFormat,self.CurrentCount)
	for k,v in pairs(self.resList) do
		local format = getTexturePixelFormat( v );
		if format == PixelFormat then
			cc.Texture2D:setDefaultAlphaPixelFormat(PixelFormat);
			print("      ",v)
			GLOBAL_TEXTURE_CACHE:addImageAsync(v, handler(self, self.ListenLoad))
		end
	end

	if self.CurrentCount < 1 then
		self.CurrentLoad = self.CurrentLoad + 1;
		if self.AsyncLoadOrder[self.CurrentLoad] then
			self:AsyncLoadResByFormat( self.AsyncLoadOrder[self.CurrentLoad] );
		end
	end
	
end

function resLoadLogic:listenerLoadQueue(  )
	-- print("listenerLoadQueue Finish",self.CurrentIndex);
	self.CurrentIndex = self.CurrentIndex + 1;
	if self.CurrentIndex > self.loadCount then
		--异步加载完成
		cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888);
		if self.Callfun then
			self.Callfun(self.mark)
		end
	else
		self:AsyncLoadResByQueue(  );
	end
end


--监听加载函数
function resLoadLogic:ListenLoad( parame )
	self.loadCount = self.loadCount - 1;
	self.CurrentCount = self.CurrentCount - 1;
	print(self.CurrentCount,parame)
	if self.loadCount < 1 then
		--异步加载完成
		cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888);
		if self.Callfun then
			self.Callfun(self.mark)
		end
	elseif self.CurrentCount < 1 then
		self.CurrentLoad = self.CurrentLoad + 1;
		print("========================>",self.CurrentLoad)
		if self.AsyncLoadOrder[self.CurrentLoad] then
			self:AsyncLoadResByFormat( self.AsyncLoadOrder[self.CurrentLoad] );
		end
	end
end

ResLoad = resLoadLogic.getInstance();

return resLoadLogic
