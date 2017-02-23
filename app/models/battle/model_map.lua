--
-- Author: liYang
-- Date: 2015-06-15 11:40:29
-- 45地图数据

local model_map = class("model_map")


function model_map:ctor()
	self.width = 42;
	self.height = 42;
	--地图单位像素值
	self.tilewidth = 64;
	self.tileheight = 32;

	self.pixelwidth = 0;
	self.pixelheight = 0;

	--地图起始点坐标
	self.mapStartPos_x = 0;
	self.mapStartPos_y = 0;

	--当前显示的mapid
	self.ShowMapID = 1;
end

--游戏坐标 转换为地图坐标
function model_map:getWorldToMapTransform( x , y )
	
	local map_x = 0.5 * ((x - self.mapStartPos_x) / 32  + (self.mapStartPos_y - y) / 16  );
	local map_y = 0.5 * ((self.mapStartPos_y - y) / 16  - (x - self.mapStartPos_x) / 32 );
	-- print(self.mapStartPos_x,self.mapStartPos_y,x ,y,map_x,map_y)
	return math.floor(map_x) ,math.floor(map_y);
end

--地图坐标换算成游戏坐标
function model_map:getMapToWorldTransform( x ,y )
	local word_x = (self.tilewidth / 2) * (x - y) + self.mapStartPos_x;
	local word_y = self.mapStartPos_y - (self.tileheight / 2) * (x + y);
	-- print("model_map:getMapToWorldTransform",x,y,(self.tilewidth / 2) * (x - y),(self.tileheight / 2) * (x + y),word_x ,word_y)
	return word_x ,word_y;
end

--将世界坐标转换成游戏画板坐标
function model_map:getWorldToNodeLayerSpace( x ,y )
	return x + self.pixelwidth / 2 - display.cx, y + self.pixelheight / 2 - display.cy
end

--得到mapID
function model_map:getMapID(  )
	return self.ShowMapID;
end

return model_map


