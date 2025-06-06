-- PQ_Azumanga_Exploration
-- Author: 71891
-- DateCreated: 5/17/2025 10:51:41 PM
--------------------------------------------------------------

-- ===========================================================================
-- INCLUDE
-- ===========================================================================

include("PQ_OSAKA_Utilities.lua")
include("PQ_OSAKA_Constants.lua");

-- ===========================================================================
-- CONSTANTS
-- ===========================================================================


-- ===========================================================================
-- FUNCTIONS
-- ===========================================================================

-- Play SFX of Chiyochichi if certain exploration condition is reached
function PQChiyochichiSFX()
	local iPlayer = Game.GetLocalPlayer();
	local pPlayer = Players[iPlayer];

	local finalLevel = pPlayer:GetProperty("PQ_finalLevel") or 0;
	local IsBirthContinentRevealed = pPlayer:GetProperty("PQ_IsBirthContinentRevealed") or "Not";
	if (IsBirthContinentRevealed == "JustNow") then
		UI.PlaySound(PQ_CHIYOCHICHI_PERCENTAGE.BIRTH_CONTINENT_SFX);
	else
		if (finalLevel ~= 0) then
			UI.PlaySound(PQ_CHIYOCHICHI_PERCENTAGE.PERCENTAGE_SFX[finalLevel]);
		end
	end

end
------------------------------------------------------------------------------

-- ===========================================================================
-- INITIALIZE
-- ===========================================================================

-- If local player is Azumanga, initialize Exploration and add to event
function PQ_InitializeExploration()
	local azuCivilizations = GetAzumangaCivilizationIDs()
	if (#azuCivilizations == 0) then
		return;
	end

	Events.TurnBegin.Add(PQChiyochichiSFX);
end
------------------------------------------------------------------------------

Events.LoadGameViewStateDone.Add(PQ_InitializeExploration)

--============================================================================
--============================================================================