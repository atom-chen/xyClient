--
-- Author: lipeng
-- Date: 2015-07-06 15:32:59
-- 富文本列表
--[[
使用示例:
	local params = {
		width = 500, 
		height = 400,
		backgroundColorType = ccui.LayoutBackGroundColorType.solid
	}
	local richTextList = require("app.views.RichTextList").new(params)
	richTextList:pushString("[d=1][/]aaaaaa[color=255|255|0]bb\nbb[/]ffff\nffff")
	richTextList:pushString("[d=1][/]\naaaaaa[color=255|255|0]bb\nbb[/]ffff\nffff\n")
]]

--[[
标签说明:
[d=1]: 使用ID为1的默认布局richTextListView.DEFAULT_LAYOUTS[1]
\n: 换行
[color=255|255|0, opacity=255, fontSize=20]: 
	color,设置文字颜色rgb; 
	opacity,不透明度; 
	fontSize, 字体大小; 
	如果某个属性没有设置则使用默认布局的属性设置, 如: opacity没有设置, 则使用[d=1]中的属性
]]



local richTextListView = class("richTextListView", function ( params )
	return ccui.ListView:create()
end)

richTextListView.DEFAULT_LAYOUTS = RichText_DEFAULT_LAYOUTS

--[[
params.direction: listView方向, 默认ccui.ScrollViewDir.vertical(垂直), 可选参数
params.width: listView宽, 默认100, 必要参数
params.height: listView高, 默认100, 必要参数
params.backgroundColorType: 背景颜色类型, 默认ccui.LayoutBackGroundColorType.none, 可选参数
params.backgroundColor: 背景颜色(当backgroundColorType不为ccui.LayoutBackGroundColorType.none时生效), 
						默认cc.c3b(0, 0, 0), 可选参数
]]
function richTextListView:ctor(params)
	self._dataList = {}
	local listDirection = params.direction or ccui.ScrollViewDir.vertical
	local listWidht = params.width or 100
	local listHeight = params.height or 100
	local listBackgroundColorType = params.backgroundColorType or ccui.LayoutBackGroundColorType.none
	local listBackgroundColor = params.backgroundColor or cc.c3b(0, 0, 0)
	self:setContentSize(cc.size(listWidht, listHeight))
	self:setDirection(listDirection)

	if listBackgroundColorType ~= ccui.LayoutBackGroundColorType.none then
		self:setBackGroundColorType(listBackgroundColorType)
		self:setBackGroundColor(listBackgroundColor)
	end

	--上次使用的richText
	self._lastUseRichText = nil

	local function onNodeEvent(tag)
        if tag == "exit" then
            self:clear()
        end
    end

    self:registerScriptHandler(onNodeEvent)
end


--末尾添加字符串
function richTextListView:pushString( str, isRefreshView )
	local isRefreshView = isRefreshView or false

	local dataList = self:_stringToDataList(str)
	self:_addItemToListViewWithDataList(dataList)

	if isRefreshView then
		self:refreshView()
	end

	table.insertto(self._dataList, dataList, 0)
	--self:_printDataList()
end

--清除数据及item
--如果只想清除item,  应该调用self:removeAllChildren()
function richTextListView:clear()
	self._dataList = {}
	self:removeAllChildren()
end


--使用数据列表添加Item到listView
function richTextListView:_addItemToListViewWithDataList(dataList)

	local function createRichText()
		local richText = ccui.RichText:create()
		richText:ignoreContentAdaptWithSize(false)
	    richText:setContentSize(cc.size(self:getContentSize().width, 10))

	    return richText
	end

	local curDefaultLayout = nil
	if self._lastUseRichText == nil then
		self._lastUseRichText = createRichText()
    	self:addChild(self._lastUseRichText)
	end
	local richText = self._lastUseRichText

	for dataIdx, data in ipairs(dataList) do
		local richEle = nil

		if data.type == "tag" then

			--内容类型: 默认布局
			if data.contentAttr.d ~= nil then
				local layout = data.contentAttr.d.default_layout
				curDefaultLayout = layout

			--内容类型: 文本
			else
				local color = data.contentAttr.color or curDefaultLayout.color
				local opacity = data.contentAttr.opacity or curDefaultLayout.opacity
				local fontSize = data.contentAttr.fontSize or curDefaultLayout.fontSize

				local textList = {}

				textList = string.split(data.content, "\n")

				for textIdx, text in ipairs(textList) do

					if textIdx > 1 then
						--先放入之前的richText
						richText:formatText()

	    				--再放入当前的richText
	    				richText = createRichText()
	    				self:addChild(richText)
					end

					richEle = ccui.RichElementText:create(
						dataIdx, 
						cc.c3b(color.r, color.g, color.b),
						opacity,
						text,
						DEFAULT_FONT,
						fontSize
					)

					richText:pushBackElement(richEle)
				end
			end

		elseif data.type == "text" then
			local textList = {}

			textList = string.split(data.text, "\n")

			for textIdx, text in ipairs(textList) do

				if textIdx > 1 then
					--先放入之前的richText
					richText:formatText()

    				--再放入当前的richText
    				richText = createRichText()
    				self:addChild(richText)
				end

				richEle = ccui.RichElementText:create(
					dataIdx, 
					cc.c3b(curDefaultLayout.color.r, curDefaultLayout.color.g, curDefaultLayout.color.b), 
					curDefaultLayout.opacity, 
					text, 
					DEFAULT_FONT,
					curDefaultLayout.fontSize
				)

				richText:pushBackElement(richEle)
			end

			
		end

	end

	richText:formatText()

    self._lastUseRichText = richText
end


--字符串转换为数据列表
function richTextListView:_stringToDataList( str )

	local function getTagContent( str, tagHeadStrBeginPos, tagHeadStrEndPos )
		return string.sub(str, tagHeadStrBeginPos+1, tagHeadStrEndPos-1)
	end

	local function getContentTable( tagContent )
		return string.split(tagContent, " ")
	end

	local function getAttrTable( contentTable )
		local attrMap = {}

		local attrTable = nil
		for k,v in pairs(contentTable) do
			attrTable = string.split(v, "=")
			local attrKey = attrTable[1]
			attrMap[attrKey] = {}
			local attrValue = attrMap[attrKey]
			local attrValueList = string.split(attrTable[2], "|")

			--颜色属性
			if "color" == attrKey then
				attrValue.r = attrValueList[1]
				attrValue.g = attrValueList[2]
				attrValue.b = attrValueList[3]

			--透明度属性
			elseif "opacity" == attrKey then
				attrValue.opacity = attrValueList[1]

			--默认布局ID属性
			elseif "d" == attrKey then
				local default_layout_id = tonumber(attrValueList[1])
				attrValue.default_layout = richTextListView.DEFAULT_LAYOUTS[default_layout_id]
			--字体大小属性
			elseif "fontSize" == attrKey then
				attrValue.fontSize = attrValueList[1]
			end
		end

		return attrMap
	end

	local function getAttrTableWithString( str, tagHeadStrBeginPos, tagHeadStrEndPos )
		local tagContent = getTagContent(str, tagHeadStrBeginPos, tagHeadStrEndPos)
		local contentTable = getContentTable(tagContent)
		return getAttrTable(contentTable)
	end

	local function getTextData( str, pos )
		local textData = {}
		--找到标签头的起始和结束为止
		local tagHeadStrBeginPos, tagHeadStrEndPos = 
			string.find(str, "%b[]", pos)

		textData.curPos = pos

		if tagHeadStrBeginPos == nil then
			textData.text = string.sub(str, pos)
			textData.endPos = string.len(str)
		else
			textData.text = string.sub(str, pos, tagHeadStrBeginPos-1)
			textData.endPos = tagHeadStrBeginPos - 1
		end

		return textData
	end

	--获取匹配标签的数据
	local function getTagData(str, pos)
		--[[
		标签格式检测 []....[/]
		]]

		--找到标签头的起始和结束为止
		local tagHeadStrBeginPos, tagHeadStrEndPos = 
			string.find(str, "%b[]", pos)

		if tagHeadStrBeginPos == nil then
			return
		end

		--找到标签尾的起始和结束为止
		local tagTailStrBeginPos, tagTailStrEndPos = 
			string.find(str, "%b[]", tagHeadStrEndPos+1)

		if tagTailStrBeginPos == nil then
			return
		end

		local tagData = {}
		tagData.content = string.sub(str, tagHeadStrEndPos+1, tagTailStrBeginPos-1)
		tagData.contentAttr = getAttrTableWithString(str, tagHeadStrBeginPos, tagHeadStrEndPos)
		tagData.curPos = pos
		tagData.endPos = tagTailStrEndPos

		return tagData
	end

	local function getNextData( str, curPos )
		local data = nil

		--找到标签头的起始和结束为止
		local tagHeadStrBeginPos, tagHeadStrEndPos = 
			string.find(str, "%b[]", curPos)

		local dataType = ""
		if tagHeadStrBeginPos == nil then
			dataType = "text"
		else
			--说明标签之间有文本, 如: [a][/]bbbb[c][/], 处理的是bbbb这种情况
			if tagHeadStrBeginPos ~= curPos then
				dataType = "text"
			else
				dataType = "tag"
			end
		end

		if dataType == "tag" then
			--获取标签类型的数据
			data = getTagData(str, curPos)

		elseif dataType == "text" then
			--获取文本类型数据的数据
			data = getTextData(str, curPos)

		end
		data.type = dataType

		return data
	end

	local curStrPos = 1

	--获取第一个数据
	local data = getNextData(str, curStrPos)
	if data == nil then
		--没有任何有效数据
		printInfo(debug.traceback())
		return
	end

	--如果没有任何标签
	if data.type ~= "tag" then
		--报错, 至少应该有一个默认布局的标签
		printInfo(debug.traceback())
		return
	end

	--保存数据
	local dataList = {}
	dataList[#dataList+1] = data
	curStrPos = data.endPos + 1

	while curStrPos <= string.len(str) do
		data = getNextData(str, curStrPos)
		dataList[#dataList+1] = data
		curStrPos = data.endPos + 1
	end


	return dataList
end


function richTextListView:_printDataList()
	printInfo("function richTextListView:_printDataList()")

	for i,v in ipairs(self._dataList) do
		printInfo("i = %d", i)
		if v.type == "tag" then
			printInfo("type = tag")
			--内容类型: 默认布局
			if v.contentAttr.d ~= nil then
				local layout = v.contentAttr.d.default_layout
				printInfo("contentType = defalutLayout")

				printInfo("color r=%d, g=%d, b=%d; opacity=%d; fontSize=%d",
					layout.color.r,
					layout.color.g,
					layout.color.b,
					layout.opacity,
					layout.fontSize
				)

			--内容类型: 文本
			else
				printInfo("contentType = tagText")

				printInfo("color r=%d, g=%d, b=%d; content=%s",
					v.contentAttr.color.r,
					v.contentAttr.color.g,
					v.contentAttr.color.b,
					v.content
				)
			end

		elseif v.type == "text" then
			printInfo("type = text,  text = %s", v.text)
		end
		
	end
end



return richTextListView
