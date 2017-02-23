--
-- Author: li Yang
-- Date: 2014-06-22 14:35:59
-- 助手管理

local model_helperManager = class("model_helperManager");



function model_helperManager:ctor()

	--助阵者记录池
	self.helperPool = {};
	--助阵记录信息
	self.RecordHelperPool = {};

	-- 是否更新
	self.IsHelperUpData = false;

	-- 数量
	self.HelperNum = 0;
	--选择的助阵者
	self.ChooseHelper = nil;
	--助阵者位置
	self.HelperExchangePos = 10;

	self.RecordHelperNum = 0;

	--清理帮助者数值
	self.ClearHelperNumValuse = 7;
end

--[[ 添加助手

]]
function model_helperManager:addHelper( params )
	print("添加助手：",params.GUID)
	self.helperPool[params.GUID] = params;
end

--得到援助者数量
function model_helperManager:getHelperCount(  )
	return table.nums(self.helperPool);
end

--设置默认值
function model_helperManager:SetDefaultHelper( params )
	if not params then
		self.ChooseHelper = nil;
		self.HelperExchangePos = 10;
		return ;
	end
	local MaxGradeRole = 0;
	local count = 0;
	for k,v in pairs(self.helperPool) do
		-- print("援军",v.captainhero.curLv , MaxGradeRole);
		if v then
			count = count + 1;
		end
		if v and v.captainhero.curLv >= MaxGradeRole then
			-- print(v.captainhero.curLv , MaxGradeRole)
			if self.ChooseHelper and v.captainhero.curLv == MaxGradeRole then
				if tostring(v) > tostring(self.ChooseHelper) then
					self.ChooseHelper = v;
					MaxGradeRole = v.captainhero.curLv;
				end
			else
				self.ChooseHelper = v;
				MaxGradeRole = v.captainhero.curLv;
			end
		end
	end
	-- print("model_helperManager:SetDefaultHelper",count);
	self.HelperExchangePos = 10;
end

function model_helperManager:removeAlreadyUse(  )
	if self.ChooseHelper and self.HelperExchangePos ~= 10 then
		self:RemoveHelper( self.ChooseHelper.GUID )
	end
	self.ChooseHelper = nil;
	self.HelperExchangePos = 10;
end

--设置助阵者
function model_helperManager:SetHelperData( heperdata )
	self.ChooseHelper = heperdata;
end


--删除助手
function model_helperManager:RemoveHelper( guid )
	self.helperPool[guid] = nil;
end


function model_helperManager:ClearHelperPool( )
	self.helperPool = {};
	self.ChooseHelper = nil;

	self.HelperExchangePos = 10;
end

--添加援助者记录
function model_helperManager:addHelperRecord( params )
	if not params then
		return;
	end
	if self.RecordHelperPool[params.GUID] then
		self.RecordHelperNum = self.RecordHelperNum + 1;
		params.NumberID = self.RecordHelperNum;
		return;
	end
	logPrint("model_helperManager:", "添加援助记录者"..params.GUID)
	self.RecordHelperPool[params.GUID] = params;
	self.RecordHelperNum = self.RecordHelperNum + 1;
	params.NumberID = self.RecordHelperNum;
	if self.RecordHelperNum >= self.ClearHelperNumValuse then
		--清理
		for k,v in pairs(self.RecordHelperPool) do
			-- print("清理：",v.NumberID)
			if v and v.NumberID < self.ClearHelperNumValuse - 4 then
				self.RecordHelperPool[k] = nil;
			end
		end
	end
end

function sortUp( a , b )
	if a.NumberID < b.NumberID  then
		return false;
	end
	return true;
end

function model_helperManager:HelperRecordSort(  )
	table.sort( self.RecordHelperPool, sortUp );
	-- for k,v in pairs(self.RecordHelperPool) do
	-- 	print(k,v.NumberID);
	-- end
end

--添加当前使用的援助者到记录池
function model_helperManager:addCurrentUseHelperToRecordPool(  )
	self:addHelperRecord( self.ChooseHelper );
end

function model_helperManager:ClearHelperRecordPool( )
	self.RecordHelperPool = {};
end


return model_helperManager;
