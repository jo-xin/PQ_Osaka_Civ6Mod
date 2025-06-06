-- PQ_Unit_ChiyoChichi_MD
-- Author: 71891
-- DateCreated: 5/5/2025 8:46:20 PM
--------------------------------------------------------------

-- ===========================================================================
-- BASIC ABILITIES
-- ===========================================================================

-- Gains +10 Strength each Era | This is only Modifier-end, lua end is also needed
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODIFIER_PQ_UNIT_STRENGTH_WITH_PROPERTY', 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODIFIER_PQ_UNIT_STRENGTH_WITH_PROPERTY', 'Key', 'PQ_COMBAT_STRENGTH_FOR_CHIYOCHICHI');
------------------------------------------------------------------------------


-- Can jump with range 2
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MD_PQ_UNIT_CHIYOCHICHI_JUMP', 'MODIFIER_SINGLE_UNIT_ADJUST_JUMP_DISTANCE', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MD_PQ_UNIT_CHIYOCHICHI_JUMP', 'Range', '2');
------------------------------------------------------------------------------


-- Ignore ZOC
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MD_PQ_UNIT_CHIYOCHICHI_IGNORE_ZOC', 'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_ZOC', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MD_PQ_UNIT_CHIYOCHICHI_IGNORE_ZOC', 'Ignore', 'true');
------------------------------------------------------------------------------


-- ===========================================================================
-- EXPLORATION BASED ABILITIES
-- ===========================================================================

-- Player End | Chiyochichi gains mobility with world exploration
-- As this modifier is attached to the player, corresponding unit end modifier will be attached to chiyochichi
-- This is probably not the optimal way, and even there is no need to distinguish player end or unit end. I'm glad to know new ways, and also eager to have a master to follow
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODIFIER_PQ_CHIYOCHICHI_JUMP_1', 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'RS_PQ_IS_CHIYOCHICHI'),
('MODIFIER_PQ_CHIYOCHICHI_JUMP_2', 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'RS_PQ_IS_CHIYOCHICHI'),
('MODIFIER_PQ_CHIYOCHICHI_JUMP_3', 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'RS_PQ_IS_CHIYOCHICHI'),
('MODIFIER_PQ_CHIYOCHICHI_MOVE_1', 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'RS_PQ_IS_CHIYOCHICHI'),
('MODIFIER_PQ_CHIYOCHICHI_MOVE_2', 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'RS_PQ_IS_CHIYOCHICHI'),
('MODIFIER_PQ_CHIYOCHICHI_SIGHT_1', 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'RS_PQ_IS_CHIYOCHICHI'),
('MODIFIER_PQ_CHIYOCHICHI_SIGHT_2', 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'RS_PQ_IS_CHIYOCHICHI');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODIFIER_PQ_CHIYOCHICHI_JUMP_1', 'ModifierId', 'MODIFIER_PQ_UNIT_CHIYOCHICHI_JUMP_1'),
('MODIFIER_PQ_CHIYOCHICHI_JUMP_2', 'ModifierId', 'MODIFIER_PQ_UNIT_CHIYOCHICHI_JUMP_2'),
('MODIFIER_PQ_CHIYOCHICHI_JUMP_3', 'ModifierId', 'MODIFIER_PQ_UNIT_CHIYOCHICHI_JUMP_3'),
('MODIFIER_PQ_CHIYOCHICHI_MOVE_1', 'ModifierId', 'MODIFIER_PQ_UNIT_CHIYOCHICHI_MOVE_1'),
('MODIFIER_PQ_CHIYOCHICHI_MOVE_2', 'ModifierId', 'MODIFIER_PQ_UNIT_CHIYOCHICHI_MOVE_2'),
('MODIFIER_PQ_CHIYOCHICHI_SIGHT_1', 'ModifierId', 'MODIFIER_PQ_UNIT_CHIYOCHICHI_SIGHT_1'),
('MODIFIER_PQ_CHIYOCHICHI_SIGHT_2', 'ModifierId', 'MODIFIER_PQ_UNIT_CHIYOCHICHI_SIGHT_2');
------------------------------------------------------------------------------


-- Unit End | Chiyochichi gains mobility with world exploration
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODIFIER_PQ_UNIT_CHIYOCHICHI_JUMP_1', 'MODIFIER_SINGLE_UNIT_ADJUST_JUMP_DISTANCE', 0, 0, 0, NULL, NULL),
('MODIFIER_PQ_UNIT_CHIYOCHICHI_JUMP_2', 'MODIFIER_SINGLE_UNIT_ADJUST_JUMP_DISTANCE', 0, 0, 0, NULL, NULL),
('MODIFIER_PQ_UNIT_CHIYOCHICHI_JUMP_3', 'MODIFIER_SINGLE_UNIT_ADJUST_JUMP_DISTANCE', 0, 0, 0, NULL, NULL),
('MODIFIER_PQ_UNIT_CHIYOCHICHI_MOVE_1', 'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT', 0, 0, 0, NULL, NULL),
('MODIFIER_PQ_UNIT_CHIYOCHICHI_MOVE_2', 'MODIFIER_PLAYER_UNIT_ADJUST_MOVEMENT', 0, 0, 0, NULL, NULL),
('MODIFIER_PQ_UNIT_CHIYOCHICHI_SIGHT_1', 'MODIFIER_PLAYER_UNIT_ADJUST_SIGHT', 0, 0, 0, NULL, NULL),
('MODIFIER_PQ_UNIT_CHIYOCHICHI_SIGHT_2', 'MODIFIER_PLAYER_UNIT_ADJUST_SIGHT', 0, 0, 0, NULL, NULL);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODIFIER_PQ_UNIT_CHIYOCHICHI_JUMP_1', 'Range', '4'),
('MODIFIER_PQ_UNIT_CHIYOCHICHI_JUMP_2', 'Range', '6'),
('MODIFIER_PQ_UNIT_CHIYOCHICHI_JUMP_3', 'Range', '8'),
('MODIFIER_PQ_UNIT_CHIYOCHICHI_MOVE_1', 'Amount', '2'),
('MODIFIER_PQ_UNIT_CHIYOCHICHI_MOVE_2', 'Amount', '2'),
('MODIFIER_PQ_UNIT_CHIYOCHICHI_SIGHT_1', 'Amount', '2'),
('MODIFIER_PQ_UNIT_CHIYOCHICHI_SIGHT_2', 'Amount', '2');
------------------------------------------------------------------------------


-- Player End | Chiyochichi gains mobility with exploring the birth continent | Vanilla Unit End Modifier Used
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent, NewOnly, OwnerRequirementSetId, SubjectRequirementSetId) VALUES 
('MODIFIER_PQ_CHIYOCHICHI_VIEW_1', 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'RS_PQ_IS_CHIYOCHICHI'),
('MODIFIER_PQ_CHIYOCHICHI_VIEW_2', 'MODIFIER_PLAYER_UNITS_ATTACH_MODIFIER', 0, 0, 0, NULL, 'RS_PQ_IS_CHIYOCHICHI');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
('MODIFIER_PQ_CHIYOCHICHI_VIEW_1', 'ModifierId', 'UNOBSTRUCTED_VIEW'),
('MODIFIER_PQ_CHIYOCHICHI_VIEW_2', 'ModifierId', 'UNOBSTRUCTED_VIEW_TERRAIN');
------------------------------------------------------------------------------

-- ===========================================================================
-- REQUIREMENTSETS AND REQUIREMENTS
-- ===========================================================================

-- RequirementSets

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES 
('RS_PQ_IS_CHIYOCHICHI', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES 
('RS_PQ_IS_CHIYOCHICHI', 'RQ_PQ_IS_CHIYOCHICHI');

-- Requirements

INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
('RQ_PQ_IS_CHIYOCHICHI', 'REQUIREMENT_UNIT_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
('RQ_PQ_IS_CHIYOCHICHI', 'UnitType', 'UNIT_PQ_CHIYOCHICHI');











