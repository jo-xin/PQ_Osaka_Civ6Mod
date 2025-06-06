-- PQ_Civilization_AzuManga_MD
-- Author: 71891
-- DateCreated: 5/14/2025 4:30:53 PM
--------------------------------------------------------------


-- ===========================================================================
-- NOTICE | NOT PUT IN USE
-- 
-- If you enable the following TraitModifiers, then civilization Azumanga will get -2 amenities each city in dark age, get -1 appeal in normal age
-- ===========================================================================




--INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
--('TRAIT_CIVILIZATION_PQ_AZUMANGA', 'MODIFIER_PQ_AZUMANGA_AMENITIES_DARK'),
--('TRAIT_CIVILIZATION_PQ_AZUMANGA', 'MODIFIER_PQ_AZUMANGA_APPEAL_OPPOSITE'),
--('TRAIT_CIVILIZATION_PQ_AZUMANGA', 'MODIFIER_PQ_AZUMANGA_NOTNORMAL_APPEAL');

INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODIFIER_PQ_AZUMANGA_AMENITIES_DARK', 'MODIFIER_PLAYER_CITIES_ADJUST_TRAIT_AMENITY', 0, 0, 0, NULL, 'RS_PQ_CIV_DARK');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODIFIER_PQ_AZUMANGA_AMENITIES_DARK', 'Amount', '-2');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('RS_PQ_CIV_DARK', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('RS_PQ_CIV_DARK', 'RQ_PQ_CIV_DARK');




INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODIFIER_PQ_AZUMANGA_APPEAL_OPPOSITE', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_APPEAL', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODIFIER_PQ_AZUMANGA_APPEAL_OPPOSITE', 'Amount', '-1');




INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODIFIER_PQ_AZUMANGA_NOTNORMAL_APPEAL', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_APPEAL', 0, 0, 0, NULL, 'RS_PQ_CIV_NOT_NORMAL');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODIFIER_PQ_AZUMANGA_NOTNORMAL_APPEAL', 'Amount', '1');

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('RS_PQ_CIV_NOT_NORMAL', 'REQUIREMENTSET_TEST_ANY');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('RS_PQ_CIV_NOT_NORMAL', 'RQ_PQ_CIV_DARK'), 
('RS_PQ_CIV_NOT_NORMAL', 'RQ_PQ_CIV_GOLDEN');

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
('RQ_PQ_CIV_DARK', 'REQUIREMENT_PLAYER_HAS_DARK_AGE'), 
('RQ_PQ_CIV_GOLDEN', 'REQUIREMENT_PLAYER_HAS_GOLDEN_AGE');




