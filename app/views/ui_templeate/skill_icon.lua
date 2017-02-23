--
-- Author: lipeng
-- Date: 2015-08-28 10:45:49
--

SKILL_ICON_HELPER = {}


function SKILL_ICON_HELPER:getIconImageName( skillID )
	local iconResID = SkillConfig_getIcon(skillID)
	return ResIDConfig:getConfig_skill(tonumber(iconResID)).icon
end

