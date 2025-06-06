-- PQ_Osaka_GamePlay
-- Author: 71891
-- DateCreated: 5/4/2025 10:42:37 PM
--------------------------------------------------------------

-- ===========================================================================
-- INCLUDE
-- ===========================================================================

include("PQ_OSAKA_Utilities.lua");
include("PQ_OSAKA_Constants.lua");

-- ===========================================================================
-- UTILS
-- ===========================================================================

-- Send Osaka to Anarchy. If there are no government changed before, then skip
-- Offset indicates extra turns should the counter count, this is necessary when this function is executed before the turn starts, which will count a turn in vain
-- I have to keep this stupid mechanism, because to trigger Anarchy, I have to set current government to a used one manually, 
-- and I havn't found a better way to trigger it directly.
function PQOsakaGoAnarchy(iPlayer, offset)
	offset = offset or 0;
	local pPlayer = Players[iPlayer];
	local currentGovernment = pPlayer:GetProperty("PQ_currentGovernment") or -1;
	local firstNewGovernment = pPlayer:GetProperty("PQ_firstNewGovernment") or -1;
	local remainingAnarchyTurns = pPlayer:GetProperty("PQ_remainingAnarchyTurns") or 0;
	local targetGovernment = -1;

	if (firstNewGovernment == -1 or remainingAnarchyTurns > 0) then
		return;
	elseif (currentGovernment == 0) then
		targetGovernment = firstNewGovernment;
	else 
		targetGovernment = 0;
	end

	local anarchyDuration = pPlayer:GetCulture():GetAnarchyTurns();
	remainingAnarchyTurns = anarchyDuration + offset;
	pPlayer:SetProperty("PQ_policyAvailableAfter", 1 + remainingAnarchyTurns);
	pPlayer:SetProperty("PQ_remainingAnarchyTurns", remainingAnarchyTurns);
	
	pPlayer:GetCulture():SetCurrentGovernment(targetGovernment);
end
------------------------------------------------------------------------------

-- ===========================================================================
-- FUNCTIONS
-- ===========================================================================

-- Executed for each Civic completed
-- 1. Set the flag as 1 so that 1 turn later, a free policy/government change will be available
-- 2. If this Civic unlocks new governments, start Anarchy
-- SIDE EFFECT: This function will cause non-major-civilizations' CivicCompleted event triggered
function PQDelayOsakaPolicyAndCheckAnarchy(iPlayer, iCivic, bCancelled)
	if (PlayerConfigurations[iPlayer]:GetLeaderTypeName() ~= "LEADER_PQ_OSAKA") then
		return;
	end
	local pPlayer = Players[iPlayer];

	local policyAvailableAfter = pPlayer:GetProperty("PQ_policyAvailableAfter") or 0;
	if (policyAvailableAfter > 1) then
		return;
	end
	pPlayer:SetProperty("PQ_policyAvailableAfter", 1);
	pPlayer:GetCulture():SetCivicCompletedThisTurn(false);

	print(iCivic)
	PrintList(PQ_OVERALL_CONSTANTS.CIVIC_WITH_GOVERNMENT)
	print(IsInArray(PQ_OVERALL_CONSTANTS.CIVIC_WITH_GOVERNMENT, iCivic))
	if (IsInArray(PQ_OVERALL_CONSTANTS.CIVIC_WITH_GOVERNMENT, iCivic)) then
		PQOsakaGoAnarchy(iPlayer);
	end
end
------------------------------------------------------------------------------

-- Executed for each Era started
-- Start Anarchy for Osaka
function PQCheckAnarchyForEra(previousEra, newEra)
	local osakaCivilizations = GetOsakaCivilizationIDs();
	for _, iPlayer in ipairs(osakaCivilizations) do
		PQOsakaGoAnarchy(iPlayer, 1);
	end
end
------------------------------------------------------------------------------

-- Executed for each Turn started
-- Count for two counters. That is:
-- 1. For PQ_policyAvailableAfter, if it's 1, which means that a Civic has completed 1 turn before, then we can change policy/government now
-- 2. For PQ_remainingAnarchyTurns, if it's 1, which means that Anarchy ends now, Eureka and Inspiration needs to be granted
function PQStepOneTurnForProperty()
	local osakaCivilizations = GetOsakaCivilizationIDs();
	for _, iPlayer in ipairs(osakaCivilizations) do
		local pPlayer = Players[iPlayer];
		local remainingAnarchyTurns = pPlayer:GetProperty("PQ_remainingAnarchyTurns") or 0;
		local policyAvailableAfter = pPlayer:GetProperty("PQ_policyAvailableAfter") or 0;

		if (remainingAnarchyTurns > 0) then
			remainingAnarchyTurns = remainingAnarchyTurns - 1;
			if (remainingAnarchyTurns == 0) then
				local iOsakaEra = pPlayer:GetEra() + 1;
				PQGiveRandomBoostsForEra(iPlayer, true, 1, iOsakaEra);
				PQGiveRandomBoostsForEra(iPlayer, false, 1, iOsakaEra);
			end
		end
		if (policyAvailableAfter > 0) then
			policyAvailableAfter = policyAvailableAfter - 1;
			if (policyAvailableAfter == 0) then
				pPlayer:GetCulture():SetCivicCompletedThisTurn(true);
			end
		end
		pPlayer:SetProperty("PQ_policyAvailableAfter", policyAvailableAfter);
		pPlayer:SetProperty("PQ_remainingAnarchyTurns", remainingAnarchyTurns);
	end
end
------------------------------------------------------------------------------

-- Executed for each Government changed
-- Record enough information that will be used to trigger Anarchy, that is:
-- If now it's not Chiefdom, enter it;
-- If now it's Chiefdom, enter the first government we have ever chosen that is not Chiefdom
-- Logic for firstNewGovernment is that the first GovenrmentChanged after currentGovernment is no longer -1 must brings a new government
function PQUpdateGovernmentProperty(iPlayer, iGov)
	if (PlayerConfigurations[iPlayer]:GetLeaderTypeName() ~= "LEADER_PQ_OSAKA") then
		return;
	end
	local pPlayer = Players[iPlayer];
	if (iGov == -1) then
		return;
	end

	local pPlayer = Players[iPlayer];
	local currentGovernment = pPlayer:GetProperty("PQ_currentGovernment") or -1;
	local firstNewGovernment = pPlayer:GetProperty("PQ_firstNewGovernment") or -1;
	if (firstNewGovernment == -1 and currentGovernment ~= -1) then
		pPlayer:SetProperty("PQ_firstNewGovernment", iGov);
	end

	pPlayer:SetProperty("PQ_currentGovernment", iGov);
end
------------------------------------------------------------------------------

-- Executed for each INspiration triggred
-- Grant a random Eureka-ed technology progress
function PQPlusPercentageTech(iPlayer, iCivic, _, __)
	if (PlayerConfigurations[iPlayer]:GetLeaderTypeName() ~= "LEADER_PQ_OSAKA") then
		return;
	end

	local candidateTechs = PQGetFirstNTechsOrCivicsInID(iPlayer, true, -1, -1, 1, 0, -1, -1);
	if (#candidateTechs == 0) then
		return;
	end
	local iTech = RandomChoose(candidateTechs);

	PQTechPlusPercentageProgress(iPlayer, iTech, PQ_OSAKA_FEATURE.OSAKATECHBONUS);
end
------------------------------------------------------------------------------





-- Change the continent of Osaka's original capital on city established
function PQChangeOsakaCapitalContinent(iPlayer, iCity)
	if (PlayerConfigurations[iPlayer]:GetLeaderTypeName() ~= "LEADER_PQ_OSAKA") then
		return;
	end
	local pPlayer = Players[iPlayer];

	if (pPlayer:GetProperty("PQ_isCapitalContinentChanged")) then
		return;
	end

	local pCity = CityManager.GetCity(iPlayer, iCity);
	local pPlot = Map.GetPlot(pCity:GetX(), pCity:GetY());
	local newContinent = GetLowestNotUsedContinent();
	TerrainBuilder.SetContinentType(pPlot, newContinent);
	pPlayer:SetProperty("PQ_isCapitalContinentChanged", true);
end
------------------------------------------------------------------------------


-- If there's an Osaka, initialize
function PQInitializeOsaka()
	local osakaCivilizations = GetOsakaCivilizationIDs();
	if (#osakaCivilizations == 0) then
		return;
	end

	for _, iPlayer in ipairs(osakaCivilizations) do
		local pPlayer = Players[iPlayer];
		if (pPlayer:GetProperty("PQ_policyAvailableAfter") == nil) then
			pPlayer:SetProperty("PQ_policyAvailableAfter", 2);
			pPlayer:SetProperty("PQ_remainingAnarchyTurns", 0);
			pPlayer:SetProperty("PQ_currentGovernment", -1);
			pPlayer:SetProperty("PQ_firstNewGovernment", -1);
			pPlayer:GetCulture():SetCurrentGovernment(0);
		end
	end

	Events.CapitalCityChanged.Add(PQChangeOsakaCapitalContinent);
	Events.CivicCompleted.Add(PQDelayOsakaPolicyAndCheckAnarchy);
	Events.GameEraChanged.Add(PQCheckAnarchyForEra);
	Events.TurnBegin.Add(PQStepOneTurnForProperty);
	Events.GovernmentChanged.Add(PQUpdateGovernmentProperty);
	Events.CivicBoostTriggered.Add(PQPlusPercentageTech);
end
------------------------------------------------------------------------------

Events.LoadGameViewStateDone.Add(PQInitializeOsaka);

--============================================================================
--============================================================================


