-- PQ_Azumanga_GamePlay
-- Author: 71891
-- DateCreated: 5/4/2025 10:42:42 PM
--------------------------------------------------------------

-- ===========================================================================
-- INCLUDE
-- ===========================================================================

include("PQ_OSAKA_Utilities.lua");
include("PQ_OSAKA_Constants.lua");

-- ===========================================================================
-- FUNCTTIONS
-- ===========================================================================

-- Check whether Chiyochichi should rebirth, and update strength after that 
function PQCheckChiyoChichiRebirthAndStrength()
	local azuCivilizations = GetAzumangaCivilizationIDs();
	for _, iPlayer in ipairs(azuCivilizations) do
		while true do		-- wrapping codes with 'While' making "break;" here acts as "continue;" for outter 'For' loop
			local pPlayer = Players[iPlayer];
			local pCapital = pPlayer:GetCities():GetCapitalCity();
			if (pPlayer:GetProperty("PQ_noChiyochichi") or pCapital == nil) then
				break;
			end

			local chiyochichis = GetChiyochichiIDs(iPlayer);
			local newChiyochichi = false;
			if (#chiyochichis == 0) then
				local newUnit = UnitManager.InitUnit(iPlayer, "UNIT_PQ_CHIYOCHICHI", pCapital:GetX(), pCapital:GetY());
				newChiyochichi = newUnit:GetID();
			end

			for _, iUnit in ipairs(chiyochichis) do
				SetChiyoChichiStrength(iPlayer, iUnit);
			end
			if (newChiyochichi ~= false) then
				SetChiyoChichiStrength(iPlayer, newChiyochichi);
			end

			break;
		end

	end
end
------------------------------------------------------------------------------

-- After exoplanet expedition project completed, remove Chiyochichi and further rebirth is also forbidden
function PQExoplanetStarts(iPlayer, iCity, iProject)
	if (iProject ~= GameInfo.Projects["PROJECT_LAUNCH_EXOPLANET_EXPEDITION"].Index) then
		return;
	end

	local azuCivilizations = GetAzumangaCivilizationIDs();
	if (IsInArray(azuCivilizations, iPlayer)) then
		local pPlayer = Players[iPlayer];
		pPlayer:SetProperty("PQ_noChiyochichi", true);
		KillAllUnitsWithUnitType(iPlayer, "UNIT_PQ_CHIYOCHICHI");
	end
end
------------------------------------------------------------------------------

-- ===========================================================================
-- INITIALIZE
-- ===========================================================================

-- If there are any Azumanga players, add the checking above to event. If it's at the start of the game, remove starting warrior
function PQAzumangaLoadGame()
	local azuCivilizations = GetAzumangaCivilizationIDs();
	if (#azuCivilizations == 0) then
		return;
	end
	
	Events.TurnBegin.Add(PQCheckChiyoChichiRebirthAndStrength);
	Events.CityProjectCompleted.Add(PQExoplanetStarts);

	if (Game.GetProperty("PQ_AzumangaInitialized") ~= nil) then
		return;
	end
	Game.SetProperty("PQ_AzumangaInitialized", true);

end
------------------------------------------------------------------------------

Events.LoadGameViewStateDone.Add(PQAzumangaLoadGame);

--============================================================================
--============================================================================

