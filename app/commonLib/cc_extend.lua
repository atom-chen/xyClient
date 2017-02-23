--
-- Author: lipeng
-- Date: 2015-06-17 09:56:31
-- 2dx的扩展

import(".cc_extern_globalEventDispatcher")

function findComponent( target, componentName )
	for name, component in pairs(target.components_) do
		if name == componentName then
			return component
		end
	end

	return nil
end

--释放贴图资源和图片资源
function release_textureAndplist( texture ,plistfile)
	if texture then
		GLOBAL_TEXTURE_CACHE:removeTextureForKey(resname)
	end
	if plistfile then
		 GLOBAL_SPRITE_FRAMES_CACHE:removeSpriteFramesFromFile(resname)
	end
end

--释放资源 通过贴图
function release_textureAndplistByTexture( texture )
	local imageTexture = GLOBAL_TEXTURE_CACHE:getTextureForKey(texture);
	if imageTexture then
		GLOBAL_SPRITE_FRAMES_CACHE:removeSpriteFramesFromTexture(imageTexture);
	end
	GLOBAL_TEXTURE_CACHE:removeTextureForKey(texture);
end


--动画效果资源释放
function release_ccs_animation( resconfig )
	local config = ResConfig[resconfig];
	if not config then
		printInfo("release_ccs_animation", resconfig.." ,is nil")
		return;
	end
	GLOBAL_ARMATURE_MANAGER:removeArmatureFileInfo(resconfig)
	local path = config.respath;
	for i,v in ipairs(config.res) do
		
		GLOBAL_TEXTURE_CACHE:removeTextureForKey(path..v..".png")
    	GLOBAL_SPRITE_FRAMES_CACHE:removeSpriteFramesFromFile(path..v..".plist")
	end
end

--[[释放资源
	reslist 释放列表
	{
	"ui_image/logineffect_0/logineffect_0.ExportJson"
"ui_image/ui_effect/effect_login_title.ExportJson"
	}, 
]]
function release_res( reslist )
	if not reslist then
		return;
	end
	local restype = type(reslist);
	local relaselist = {};
	if restype == "table" then
		relaselist = reslist;
	else
		relaselist[1] = reslist;
	end
	for k,v in pairs(relaselist) do
		local resdata = ResConfig[v];
		if resdata then
			if resdata.restype == "ExportJson" then
				GLOBAL_ARMATURE_MANAGER:removeArmatureFileInfo(v);
			end
			local path = resdata.respath;
			for i,j in ipairs(resdata.res) do
				GLOBAL_TEXTURE_CACHE:removeTextureForKey(path..j..".png")
		    	GLOBAL_SPRITE_FRAMES_CACHE:removeSpriteFramesFromFile(path..j..".plist")
		    	print("移除资源:"..j)
			end
		end
	end
end


--
function dumpTextureCacheInfo()
	printInfo(GLOBAL_TEXTURE_CACHE:getCachedTextureInfo())
end


--通过节点csb文件创建listView的Item
function createListViewItemWithNodeCSB( resourceFileName, itemName )
	local node = cc.CSLoader:createNode(resourceFileName)
	local item = node:getChildByName(itemName)
	item:removeFromParent()
	return item
end

--创建view 通过csb
function createViewWithCSB( resourceFileName )
	local view = cc.CSLoader:createNode(resourceFileName);
	return view;
end

--创建动作 通过csb
function createActionWithCSB( resourceFileName )
	local action = cc.CSLoader:createTimeline(resourceFileName);
	return action;
end

