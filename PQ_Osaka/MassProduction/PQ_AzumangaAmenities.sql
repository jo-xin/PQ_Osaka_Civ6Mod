-- PQ_AzumangaAmenities
-- Author: 71891
-- DateCreated: 5/25/2025 11:27:31 AM
--------------------------------------------------------------


-- ===========================================================================
-- NOTES
-- ===========================================================================

-- Whether CASE statement can be used

-- ===========================================================================
-- BITS TABLE
-- ===========================================================================
-- I'm sorry for mis-naming this as binary in the project

CREATE TABLE PQ_Binary_Amenities_Base (
    Num INTEGER PRIMARY KEY
);
INSERT INTO PQ_Binary_Amenities_Base (Num)
VALUES (1), (2), (4), (8), (16), (32); -- up to 63

-- ===========================================================================
-- MODIFIERS
-- ===========================================================================

CREATE TABLE PQ_Amen_Modifiers (
	ID TEXT PRIMARY KEY NOT NULL,
	YieldType TEXT NOT NULL,
	District TEXT NOt NULL DEFAULT 'DISTRICT_CITY_CENTER',
	BaseValue INTEGER NOT NULL DEFAULT 0,
	Multiplier INTEGER NOT NULL DEFAULT 1
);
INSERT INTO PQ_Amen_Modifiers (ID,						 YieldType,			 District,					BaseValue,	Multiplier) VALUES
('MODIFIER_PQ_AZUMANGA_CULTURE_PER_AMENITY',			'YIELD_CULTURE',	'DISTRICT_CITY_CENTER',		0,			1);


-- ===========================================================================
-- INSERT INTO TABLES
-- ===========================================================================

INSERT INTO modifiers (ModifierId,					 ModifierType,											 OwnerRequirementSetId,						SubjectRequirementSetId)
SELECT			PQMDs.ID || '_' || PQBinary.Num,	'MODIFIER_PLAYER_DISTRICT_ADJUST_BASE_YIELD_CHANGE',	'RS_' || PQMDs.ID || '_' || PQBinary.Num,	NULL						FROM PQ_Amen_Modifiers AS PQMDs JOIN PQ_Binary_Amenities_Base AS PQBinary ON 1=1
;


INSERT INTO ModifierArguments (ModifierId,			 Name,					Value)
SELECT			PQMDs.ID || '_' || PQBinary.Num,	'YieldType',			PQMDs.YieldType												FROM PQ_Amen_Modifiers AS PQMDs JOIN PQ_Binary_Amenities_Base AS PQBinary ON 1=1
UNION SELECT	PQMDs.ID || '_' || PQBinary.Num,	'Amount',				((PQBinary.Num + PQMDs.BaseValue) * PQMDs.Multiplier)		FROM PQ_Amen_Modifiers AS PQMDs JOIN PQ_Binary_Amenities_Base AS PQBinary ON 1=1
;



INSERT INTO RequirementSets (RequirementSetId,					 RequirementSetType)
SELECT			'RS_' || PQMDs.ID || '_' || PQBinary.Num,		'REQUIREMENTSET_TEST_ALL'												FROM PQ_Amen_Modifiers AS PQMDs JOIN PQ_Binary_Amenities_Base AS PQBinary ON 1=1
;

INSERT INTO RequirementSetRequirements (RequirementSetId,		 RequirementId)
SELECT			'RS_' || PQMDs.ID || '_' || PQBinary.Num,		'RQ_' || PQMDs.ID || '_' || PQBinary.Num								FROM PQ_Amen_Modifiers AS PQMDs JOIN PQ_Binary_Amenities_Base AS PQBinary ON 1=1
UNION SELECT	'RS_' || PQMDs.ID || '_' || PQBinary.Num,		'RQ_IS_AZUMANGA'														FROM PQ_Amen_Modifiers AS PQMDs JOIN PQ_Binary_Amenities_Base AS PQBinary ON 1=1
;

INSERT INTO Requirements (RequirementId,						 RequirementType)
SELECT			'RQ_' || PQMDs.ID || '_' || PQBinary.Num,		'REQUIREMENT_PLOT_PROPERTY_MATCHES'										FROM PQ_Amen_Modifiers AS PQMDs JOIN PQ_Binary_Amenities_Base AS PQBinary ON 1=1
;

INSERT INTO RequirementArguments (RequirementId,				 Name,				Value)
SELECT			'RQ_' || PQMDs.ID || '_' || PQBinary.Num,		'PropertyName',		'PQ_' || PQMDs.ID || '_' || PQBinary.Num			FROM PQ_Amen_Modifiers AS PQMDs JOIN PQ_Binary_Amenities_Base AS PQBinary ON 1=1
UNION SELECT	'RQ_' || PQMDs.ID || '_' || PQBinary.Num,		'PropertyMinimum',	1													FROM PQ_Amen_Modifiers AS PQMDs JOIN PQ_Binary_Amenities_Base AS PQBinary ON 1=1
;





INSERT INTO DistrictModifiers (	DistrictType,			ModifierId)
SELECT							PQMDs.District,			PQMDs.ID || '_' || PQBinary.Num		FROM PQ_Amen_Modifiers AS PQMDs JOIN PQ_Binary_Amenities_Base AS PQBinary ON 1=1
;





INSERT INTO Requirements (RequirementId, RequirementType) VALUES 
('RQ_IS_AZUMANGA', 'REQUIREMENT_PLAYER_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES 
('RQ_IS_AZUMANGA', 'CivilizationType', 'CIVILIZATION_PQ_AZUMANGA');
