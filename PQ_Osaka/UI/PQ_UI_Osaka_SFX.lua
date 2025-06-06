-- PQ_UI_Osaka_SFX
-- Author: 71891
-- DateCreated: 5/5/2025 10:16:55 PM
--------------------------------------------------------------

-- ===========================================================================
-- FUNCTIONS
-- ===========================================================================

-- Play OMG SFX
function PQSFXOMG()
	UI.PlaySound("PQ_SFX_OMG");
end
------------------------------------------------------------------------------

-- ===========================================================================
-- INITIALIZE
-- ===========================================================================

-- If local player is Osaka, play OMG when entering Anarchy
function PQInitializeOMG()
	local iPlayer = Game.GetLocalPlayer();
	if (PlayerConfigurations[iPlayer]:GetLeaderTypeName() ~= "LEADER_PQ_OSAKA") then
		return;
	end

	Events.AnarchyBegins.Add(PQSFXOMG);
end
------------------------------------------------------------------------------

Events.LoadGameViewStateDone.Add(PQInitializeOMG)

--============================================================================
--============================================================================


