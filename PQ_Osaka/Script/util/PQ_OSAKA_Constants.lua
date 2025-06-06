-- PQ_OSAKA_Constants
-- Author: 71891
-- DateCreated: 5/18/2025 10:30:40 PM
--------------------------------------------------------------

-- ===========================================================================
-- UTILITIES
-- ===========================================================================

-- Stores Overall COnstants. For example, CIVIC_WITH_GOVERNMENT is for Osaka to judge whether this civic will cause Anarchy
PQ_OVERALL_CONSTANTS = {
	CIVIC_WITH_GOVERNMENT = {}
};


for row in GameInfo.Governments() do
	local nCivic = row.PrereqCivic;
	if (nCivic ~= nil and nCivic ~= "") then
		local iCivic = GameInfo.Civics[nCivic].Index;
		table.insert(PQ_OVERALL_CONSTANTS.CIVIC_WITH_GOVERNMENT, iCivic);
	end
end
--------------------------------------------------------------


-- ===========================================================================
-- CHIYOCHICHI
-- ===========================================================================

-- Stores modifier that will be attached, and SFX that will be played, when exploration percentage reaches these levels
PQ_CHIYOCHICHI_PERCENTAGE = {
    LEVELS = {30,40,50,60,80,90,100},
    PERCENTAGE_EFFECT = {
		[30] = "MODIFIER_PQ_CHIYOCHICHI_JUMP_1",
		[40] = "MODIFIER_PQ_CHIYOCHICHI_MOVE_1",
		[50] = "MODIFIER_PQ_CHIYOCHICHI_SIGHT_1",
		[60] = "MODIFIER_PQ_CHIYOCHICHI_JUMP_2",
		[80] = "MODIFIER_PQ_CHIYOCHICHI_MOVE_2",
		[90] = "MODIFIER_PQ_CHIYOCHICHI_JUMP_3",
		[100] = "MODIFIER_PQ_CHIYOCHICHI_SIGHT_2"
	},
    PERCENTAGE_SFX = {
		[30] = "PQ_SFX_BIRD",
		[40] = "PQ_SFX_NEKO",
		[50] = "PQ_SFX_HELLO",
		[60] = "PQ_SFX_BIRD",
		[80] = "PQ_SFX_NEKO",
		[90] = "PQ_SFX_BIRD",
		[100] = "PQ_SFX_HELLO"
	},
	BIRTH_CONTINENT_EFFECTS = {"MODIFIER_PQ_CHIYOCHICHI_VIEW_1", "MODIFIER_PQ_CHIYOCHICHI_VIEW_2"},
	BIRTH_CONTINENT_SFX = "PQ_SFX_CHICHI"
}
------------------------------------------------------------------------------

-- ===========================================================================
-- AZUMANGA
-- ===========================================================================

-- Stores constants that MassProduction part needs
PQ_MASSPRODUCTION_AZUMANGA = {
	BINARY_AMENITIES_BASE = {},
	MODIFIER_PQ_AZUMANGA_CULTURE_PER_AMENITY = "MODIFIER_PQ_AZUMANGA_CULTURE_PER_AMENITY"
}
------------------------------------------------------------------------------

-- Initialize the corresponding table from PQ_Binary_Amenities_Base, namely make it lua from sql
local bin = GameInfo.PQ_Binary_Amenities_Base;
local i = 0;
while true do
	local row = bin[i]
	if not row then break end
	table.insert(PQ_MASSPRODUCTION_AZUMANGA.BINARY_AMENITIES_BASE, row.Num);
	i = i + 1;
end
------------------------------------------------------------------------------

-- ===========================================================================
-- OSAKA
-- ===========================================================================

-- Stores constants that Anarchy feature needs
PQ_OSAKA_FEATURE = {
	OSAKATECHBONUS = 0.3
}
------------------------------------------------------------------------------

--============================================================================
--============================================================================