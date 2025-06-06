-- PQ_AzumangaAmenities
-- Author: 71891
-- DateCreated: 5/25/2025 8:51:25 PM
--------------------------------------------------------------

-- ===========================================================================
-- INCLUDE
-- ===========================================================================

include("PQ_OSAKA_Utilities.lua");
include("PQ_OSAKA_Constants.lua");

-- ===========================================================================
-- FUNCTIONS
-- ===========================================================================

-- Get all cities of Azumanga, get amenities, and write into plot property in binary, to trigger modifiers
function PQUpdateCityAmenityCulture()
	local azuCivilizations = GetAzumangaCivilizationIDs();
	for _, iPlayer in ipairs(azuCivilizations) do
		local pPlayer = Players[iPlayer];
		local pCities = pPlayer:GetCities();
		for _, pCity in pCities:Members() do
			local amenity = pCity:GetGrowth():GetAmenities();
			local binaryBasedValue = ToBinaryBase(amenity, PQ_MASSPRODUCTION_AZUMANGA.BINARY_AMENITIES_BASE);
			local pPlot = Map.GetPlot(pCity:GetX(), pCity:GetY());
			local baseID = "PQ_" .. PQ_MASSPRODUCTION_AZUMANGA.MODIFIER_PQ_AZUMANGA_CULTURE_PER_AMENITY;
			SetPlotBinaryProperty(pPlot, baseID, PQ_MASSPRODUCTION_AZUMANGA.BINARY_AMENITIES_BASE, binaryBasedValue);
		end
	end
end
------------------------------------------------------------------------------

-- ===========================================================================
-- INITIALIZE
-- ===========================================================================



-- If there are any Azumanga players, add the updating to event, and initialize binary base
function PQAmenInitialize()
	local azuCivilizations = GetAzumangaCivilizationIDs();
	if (#azuCivilizations == 0) then
		return;
	end

	Events.PlayerTurnDeactivated.Add(PQUpdateCityAmenityCulture);
end
------------------------------------------------------------------------------

Events.LoadGameViewStateDone.Add(PQAmenInitialize);

--============================================================================
--============================================================================