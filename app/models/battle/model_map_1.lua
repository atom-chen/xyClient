--
-- Author: liYang
-- Date: 2015-06-15 11:40:29
-- 地图数据正 中心店 做下角

local model_map_1 = class("model_map_1")


function model_map_1:ctor()
	self.width = 32;
	self.height = 24;
	--地图单位像素值
	self.tilewidth = 40;
	self.tileheight = 40;

	self.pixelwidth = 0;
	self.pixelheight = 0;

	--地图起始点坐标
	self.mapStartPos_x = 0;
	self.mapStartPos_y = 0;

	--当前显示的mapid
	self.ShowMapID = 1;
end

--游戏坐标 转换为地图坐标
function model_map_1:getWorldToMapTransform( x , y )
	
	local map_x = (x - self.mapStartPos_x) / self.tilewidth;
	local map_y = -(y - self.mapStartPos_y) / self.tileheight;
	-- print(self.mapStartPos_x,self.mapStartPos_y,x ,y,map_x,map_y)
	return math.floor(map_x) ,math.floor(map_y);
end

--地图坐标换算成游戏坐标
function model_map_1:getMapToWorldTransform( x ,y )
	local word_x = self.tilewidth * x + self.mapStartPos_x;
	local word_y = -self.tileheight * y + self.mapStartPos_y;
	return word_x ,word_y;
end

--将世界坐标转换成游戏画板坐标
function model_map_1:getWorldToNodeLayerSpace( x , y )
	--x - display.cx - self.mapStartPos_x, y - display.cy - self.mapStartPos_y;
	return x - display.cx + self.pixelwidth / 2, y - display.cy + self.pixelheight / 2;
end

--将游戏坐标转换为世界坐标
function model_map_1:getNodeLayerToWordSpace( x , y )
	return x + display.cx - self.pixelwidth / 2, y + display.cy - self.pixelheight / 2;
end

--得到mapID
function model_map_1:getMapID(  )
	return self.ShowMapID;
end

return model_map_1


