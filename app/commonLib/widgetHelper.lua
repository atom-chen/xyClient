--
-- Author: lipeng
-- Date: 2015-08-15 14:45:52
--
widgetHelper = {}

function widgetHelper:loadTextureWithPlist(widget, imageName)
	widget:loadTexture(
		imageName, 
		ccui.TextureResType.plistType
	)
end


function widgetHelper:loadTexturesWithPlistForBtn(btn, nImgName, pImgName, disImgName)
	btn:loadTextures(
		nImgName, 
		pImgName,
		disImgName,
		ccui.TextureResType.plistType
	)
end

