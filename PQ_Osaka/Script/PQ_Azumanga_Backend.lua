-- PQ_Azumanga_backend
-- Author: 71891
-- DateCreated: 5/17/2025 10:52:18 PM
--------------------------------------------------------------

-- ===========================================================================
-- INCLUDE
-- ===========================================================================

include("PQ_OSAKA_Utilities.lua");
include("PQ_OSAKA_Constants.lua");

-- ===========================================================================
-- UTILS
-- ===========================================================================

-- Record the birth continent Id into pPlayer's iBirthContinent property at the beginning of the game.
-- If Osaka establish her capital at the birth point, then the continent ID will be changed. This function is to keep the original ID.
function PQRecordBirthContinent()
	local azuCivilizations = GetAzumangaCivilizationIDs();
	for _, iPlayer in ipairs(azuCivilizations) do
		local pPlayer = Players[iPlayer];
		if (pPlayer:GetProperty("PQ_iBirthContinent") == nil) then
			local iBirthContinent = Players[iPlayer]:GetStartingPlot():GetContinentType();
			pPlayer:SetProperty("PQ_iBirthContinent", iBirthContinent);
		end
	end

	Events.TurnBegin.Remove(PQRecordBirthContinent);
end
------------------------------------------------------------------------------

-- Check whether the birth continent of a player is all revealed. 
-- Note that the continent ID is obtained by pPlayer:GetProperty("PQ_iBirthContinent"). More SEE PQRecordBirthContinent() 
function PQIsBirthContinentRevealed(iPlayer)
	local pPlayer = Players[iPlayer];
	local iBirthContinent = pPlayer:GetProperty("PQ_iBirthContinent");
	if (iBirthContinent == nil) then
		return;
	end

	local pPlayerVisibility = PlayersVisibility[iPlayer];
	local iPlots = Map.GetContinentPlots(iBirthContinent);
	local pPlot = {};
	local x = 0;
	local y = 0;
	local allRevealed = true;
	for _, iPlot in ipairs(iPlots) do
		pPlot = Map.GetPlotByIndex(iPlot);
		x = pPlot:GetX()
		y = pPlot:GetY()
		if (not pPlayerVisibility:IsRevealed(x, y)) then
			allRevealed = false;
			break;
		end
	end
	return allRevealed;
end
------------------------------------------------------------------------------

-- ===========================================================================
-- FUNCTIONS
-- ===========================================================================

-- Check all Azumanga players revealed plots count at TurnEnd, if certain exploration condition is reached, add modifiers to Chiyochichi. If all finished, remove from event
-- This function is to huge and ugly, needs to be simplified
function PQCheckRevealed()
	local azuCivilizations = GetAzumangaCivilizationIDs();

	local allFinished = true;

	for _, iPlayer in ipairs(azuCivilizations) do

		local pPlayerVisibility = PlayersVisibility[iPlayer];
		local nRevealedPlot = pPlayerVisibility:GetNumRevealedHexes();
		local nTotalPlot = Map.GetPlotCount();

		local pPlayer = Players[iPlayer];

		if (nRevealedPlot ~= nTotalPlot) then
			allFinished = false;
		end

		local percentage = math.floor(100 * nRevealedPlot / nTotalPlot);
		local formerPercentage = pPlayer:GetProperty("PQ_formerPercentage") or 0;
		local finalLevel = 0;


		for _, level in ipairs(PQ_CHIYOCHICHI_PERCENTAGE.LEVELS) do
			if (level > formerPercentage and level <= percentage) then
				pPlayer:AttachModifierByID(PQ_CHIYOCHICHI_PERCENTAGE.PERCENTAGE_EFFECT[level]);
				finalLevel = level;
			end
		end


		pPlayer:SetProperty("PQ_formerPercentage", percentage);
		pPlayer:SetProperty("PQ_finalLevel", finalLevel);


		local IsBirthContinentRevealed = pPlayer:GetProperty("PQ_IsBirthContinentRevealed");
		if (IsBirthContinentRevealed == nil or IsBirthContinentRevealed == "Not") then
			IsBirthContinentRevealed = PQIsBirthContinentRevealed(iPlayer);
			if (IsBirthContinentRevealed) then
				pPlayer:SetProperty("PQ_IsBirthContinentRevealed", "JustNow");
				for _, effect in ipairs(PQ_CHIYOCHICHI_PERCENTAGE.BIRTH_CONTINENT_EFFECTS) do
					pPlayer:AttachModifierByID(effect);
				end
			else
				pPlayer:SetProperty("PQ_IsBirthContinentRevealed", "Not");
			end
			allFinished = false;
		elseif (IsBirthContinentRevealed == "JustNow") then
			pPlayer:SetProperty("PQ_IsBirthContinentRevealed", "Yes");
		end
	end

	if (allFinished) then
		Events.TurnEnd.Remove(PQCheckRevealed);
	end
end
------------------------------------------------------------------------------

-- ===========================================================================
-- INITIALIZE
-- ===========================================================================

-- If there are any Azumanga players, add the checking above to event
function PQCRInitialize()
	local azuCivilizations = GetAzumangaCivilizationIDs();
	if (#azuCivilizations == 0) then
		return;
	end
	
	Events.TurnEnd.Add(PQCheckRevealed);
	Events.TurnBegin.Add(PQRecordBirthContinent);
end
------------------------------------------------------------------------------

Events.LoadGameViewStateDone.Add(PQCRInitialize);

--============================================================================
--============================================================================
