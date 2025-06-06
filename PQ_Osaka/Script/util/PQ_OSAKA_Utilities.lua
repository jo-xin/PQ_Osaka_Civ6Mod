-- PQ_OSAKA_Utilities
-- Author: 71891
-- DateCreated: 5/17/2025 11:14:14 PM
--------------------------------------------------------------

-- Constants that may be used by utilities
PQ_UTILITIES_CONSTANTS = {
	MIN_ERA = 0,
	MAX_ERA = 8,
	TECH_WITH_BOOST = {},
	CIVIC_WITH_BOOST = {}
};


for row in GameInfo.Boosts() do
	local nTech = row.TechnologyType;
	local nCivic = row.CivicType;
	if (nTech ~= nil and nTech ~= "") then
		local iTech = GameInfo.Technologies[nTech].Index;
		table.insert(PQ_UTILITIES_CONSTANTS.TECH_WITH_BOOST, iTech);
	elseif (nCivic ~= nil and nCivic ~= "") then
		local iCivic = GameInfo.Civics[nCivic].Index;
		table.insert(PQ_UTILITIES_CONSTANTS.CIVIC_WITH_BOOST, iCivic);
	end
end
------------------------------------------------------------------------------




-- ===========================================================================
-- LUA FUNCTIONS
-- ===========================================================================

-- The same to python ` ret = [value for _ in range(length)] `
function NewInitializedList(value, length)
	local ret = {};
	for i = 1, length do
		ret[i] = value;
	end
	return ret;
end
------------------------------------------------------------------------------

-- Get the binary expression of input number based on base.
-- e.g. {0, 1, 1} = ToBinaryBase(6, {1, 2, 4}), {1, 1, 1} = ToBinaryBase(10, {1, 2, 4}). Base only accept lists like {1, 2, 4, 8, ...}
function ToBinaryBase(value, Base)
	if (value <= 0) then
		return NewInitializedList(0, #Base);
	elseif (value >= Base[#Base] * 2) then
		return NewInitializedList(1, #Base);
	end

	local ret = NewInitializedList(0, #Base);
	for i = #Base, 1, -1 do
		if (value >= Base[i]) then
			ret[i] = 1;
			value = value - Base[i];
		end
	end
	return ret;
end
------------------------------------------------------------------------------

-- Is an element in the array
function IsInArray(t, val)
	for _, v in ipairs(t) do
		if v == val then
			return true
		end
	end
	return false
end
------------------------------------------------------------------------------

-- Print a list
function PrintList(list)
	print("{")
	for _, item in ipairs(list) do
		print(item .. ", ")
	end
	print("}")
end
------------------------------------------------------------------------------

-- Choose a random element
-- "Game.GetRandNum(n)" used! For original lua, use "local index = math.random(1, #list);"
function RandomChoose(list, n)
	if (n == nil or n == 1) then
		local index = Game.GetRandNum(#list) + 1;
		return {list[index]};
	end

	if (n >= #list) then
		return list;
	end

	local selected = {};
	local notSelected = {};
	for i, v in ipairs(list) do
		notSelected[i] = v;
	end

	for i = 1, n do
		local index = Game.GetRandNum(#notSelected) + 1;
		table.insert(selected, notSelected[index]);
		table.remove(notSelected, index);
	end

	return selected;
end
------------------------------------------------------------------------------

-- ===========================================================================
-- CIV6 FUNCTIONS
-- ===========================================================================

-- Get the list of id of all Azumanga players 
function GetAzumangaCivilizationIDs()
	local results = {};
	for iPlayer, pPlayer in ipairs(PlayerManager.GetAliveMajors()) do
		iPlayer = iPlayer - 1;
		if (PlayerConfigurations[iPlayer]:GetCivilizationTypeName() == "CIVILIZATION_PQ_AZUMANGA") then
			results[#results + 1] = iPlayer;
		end
	end
	return results;
end
------------------------------------------------------------------------------

-- Get the list of id of all Osaka players 
function GetOsakaCivilizationIDs()
	local results = {};
	for iPlayer, pPlayer in ipairs(PlayerManager.GetAliveMajors()) do
		iPlayer = iPlayer - 1;
		if (PlayerConfigurations[iPlayer]:GetLeaderTypeName() == "LEADER_PQ_OSAKA") then
			results[#results + 1] = iPlayer;
		end
	end
	return results;
end
------------------------------------------------------------------------------

-- Get the list of id of all Chiyochichi units of a player
function GetChiyochichiIDs(iPlayer)
	local results = {};
	local pPlayer = Players[iPlayer];
    for _, pUnit in pPlayer:GetUnits():Members() do
        if (pUnit:GetType() == GameInfo.Units["UNIT_PQ_CHIYOCHICHI"].Index) then
            results[#results + 1] = pUnit:GetID();
        end
    end
	return results;
end
------------------------------------------------------------------------------

-- Kill all units with a certain type(in string) of a player
function KillAllUnitsWithUnitType(iPlayer, nUnitType)
	local pPlayer = Players[iPlayer];
	for _, pUnit in pPlayer:GetUnits():Members() do
		if (GameInfo.Units[pUnit:GetType()].UnitType == nUnitType) then
			UnitManager.Kill(pUnit);
		end
	end
end
------------------------------------------------------------------------------

-- Get the ID of continent that is not used, the one with lowest ID
function GetLowestNotUsedContinent()
	local newCon = 1;
	local usedCon = {};
	for _, i in ipairs(Map.GetContinentsInUse()) do
		usedCon[#usedCon + 1] = i;
	end
	while (IsInArray(usedCon, newCon)) do
		newCon = newCon + 1;
	end
	return newCon;
end
------------------------------------------------------------------------------

-- Give a technology percentage progress. paarmeter percentage is in float, say 0.3
function PQTechPlusPercentageProgress(iPlayer, iTech, percentage)
	local playerTechs = Players[iPlayer]:GetTechs();
	local cost = playerTechs:GetResearchCost(iTech);
	local currentProgress = playerTechs:GetResearchProgress(iTech);
	playerTechs:SetResearchProgress(iTech, currentProgress + (cost * percentage));
end
------------------------------------------------------------------------------

-- Get the ID of first n required Techs or Civics
-- @isTech							1 for choosing Technologies, 0 for choosing Civics
-- @n					DEFAULT -1	indicates the maximum length of return list. -1 for no limits
-- @requireCompleted	DEFAULT 0	1 for requiring it completed, -1 for not, 0 for no requirement
-- @requireBoosted		DEFAULT 0	1 for requiring it boosted, -1 for not, 0 for no requirement
-- @requireCanBoost		DEFAULT 0	1 for requiring it can be boosted, -1 for not, 0 for no requirement
-- @startingEraIndex	DEFAULT -1	the index of starting era, itself included, -1 for no requirement
-- @endingEraIndex		DEFAULT -1	the index of ending era, itself included, -1 for no requirement
-- @return							list of indexes
function PQGetFirstNTechsOrCivicsInID(iPlayer, isTech, n, requireCompleted, requireBoosted, requireCanBoost, startingEraIndex, endingEraIndex)
	local pPlayer = Players[iPlayer];
	local ret = {};
	local iterator = 0;
	n					= n					or -1;
	requireCompleted	= requireCompleted	or 0;
	requireBoosted		= requireBoosted	or 0;
	requireCanBoost		= requireCanBoost	or 0;
	startingEraIndex	= startingEraIndex	or -1;
	endingEraIndex		= endingEraIndex	or -1;

	if (isTech) then
		iterator = GameInfo.Technologies();
	else
		iterator = GameInfo.Civics();
	end

	for row in iterator do
		if (n >= 0 and (#ret == n)) then
			break;
		end
		local ID = row.Index;
		if (PQTechOrCivicFitRequirements(iPlayer, isTech, ID, requireCompleted, requireBoosted, requireCanBoost, startingEraIndex, endingEraIndex)) then
			table.insert(ret, ID);
		end
	end

	return ret;
end
------------------------------------------------------------------------------

-- Check whether this Tech or Civic meet the requirements
function PQTechOrCivicFitRequirements(iPlayer, isTech, ID, requireCompleted, requireBoosted, requireCanBoost, startingEraIndex, endingEraIndex)
	local playerTechs = {};
	local completed = 0;
	local triggered = 0;
	local era = 0;
	local boosts;

	if (isTech) then
		local playerTechs = Players[iPlayer]:GetTechs();
		completed = playerTechs:HasTech(ID);
		triggered = playerTechs:HasBoostBeenTriggered(ID);
		era = GameInfo.Eras[GameInfo.Technologies[ID].EraType].Index;
		boosts = PQ_UTILITIES_CONSTANTS.TECH_WITH_BOOST;
	else
		local playerCulture = Players[iPlayer]:GetCulture();
		completed = playerCulture:HasCivic(ID);
		triggered = playerCulture:HasBoostBeenTriggered(ID);
		era = GameInfo.Eras[GameInfo.Civics[ID].EraType].Index;
		boosts = PQ_UTILITIES_CONSTANTS.CIVIC_WITH_BOOST;
	end

	local canBoost = IsInArray(boosts, ID);

	if (requireCompleted == 1 and completed == false) then
		return false;
	end
	if (requireCompleted == -1 and completed == true) then
		return false;
	end
	if (requireBoosted == 1 and triggered == false) then
		return false;
	end
	if (requireBoosted == -1 and triggered == true) then
		return false;
	end
	if (requireCanBoost == 1 and canBoost == false) then
		return false;
	end
	if (requireCanBoost == -1 and canBoost == true) then
		return false;
	end
	if (startingEraIndex ~= -1 and era < startingEraIndex) then
		return false;
	end
	if (endingEraIndex ~= -1 and era > endingEraIndex) then
		return false;
	end
	return true;
end
------------------------------------------------------------------------------

-- Give n random Tech or Civic Boosts for an indicated Era
function PQGiveRandomBoostsForEra(iPlayer, isTech, n, iEra)
	local pPlayer = Players[iPlayer];
	iEra = math.min(iEra, PQ_UTILITIES_CONSTANTS.MAX_ERA);
	iEra = math.max(iEra, PQ_UTILITIES_CONSTANTS.MIN_ERA);
	local pool = PQGetFirstNTechsOrCivicsInID(iPlayer, isTech, -1, -1, -1, 1, iEra, iEra);
	if (#pool == 0) then
		return;
	end
	local selected = RandomChoose(pool, n);
	local pItemPool = 0;
	if (isTech) then
		pItemPool = pPlayer:GetTechs();
	else
		pItemPool = pPlayer:GetCulture();
	end

	for _, ID in ipairs(selected) do
		pItemPool:TriggerBoost(ID, 1);
	end
end
------------------------------------------------------------------------------

-- ===========================================================================
-- PQ FUNCTIONS
-- ===========================================================================

-- Set the property of a Chiyochichi, whicn will be used as his combat strength, to achive "gain 10 strength per era" 
function SetChiyoChichiStrength(iPlayer, iUnit)
	local pPlayer = Players[iPlayer];
	local pUnit = pPlayer:GetUnits():FindID(iUnit);
	local old_property = pUnit:GetProperty("PQ_COMBAT_STRENGTH_FOR_CHIYOCHICHI") or 0;
	local new_property = 0;

	new_property = (Game.GetEras():GetCurrentEra() + 1) * 10;

	pUnit:SetProperty("PQ_COMBAT_STRENGTH_FOR_CHIYOCHICHI", new_property);
end
------------------------------------------------------------------------------

-- Set the property of a plot, which will be used in MassProduction part, which gives each district corresponding modifier
function SetPlotBinaryProperty(pPlot, IDBase, BinaryBase, binaryBasedValue)
	for i, value in ipairs(binaryBasedValue) do
		pPlot:SetProperty(IDBase .. '_' .. BinaryBase[i], value);
	end
end
------------------------------------------------------------------------------

--============================================================================
--============================================================================