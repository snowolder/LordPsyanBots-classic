ALTER TABLE db_version CHANGE COLUMN required_z0649_133_01_mangos_mangos_string required_z0652_134_01_mangos_creature_model_info bit;

DELETE FROM creature_model_info WHERE modelid IN (49,50,51,52,53,54,55,56,57,58,59,60,1478,1479,1563,1564,10045);
INSERT INTO creature_model_info (modelid, bounding_radius, combat_reach, gender, modelid_other_gender) VALUES
(49, 0.3060, 1.5, 0, 50),
(50, 0.2080, 1.5, 1, 49),
(51, 0.3720, 1.5, 0, 52),
(52, 0.2360, 1.5, 1, 51),
(53, 0.3470, 1.5, 0, 54),
(54, 0.3470, 1.5, 1, 53),
(55, 0.3890, 1.5, 0, 56),
(56, 0.3060, 1.5, 1, 55),
(57, 0.3830, 1.5, 0, 58),
(58, 0.3830, 1.5, 1, 57),
(59, 0.9747, 1.5, 0, 60),
(60, 0.8725, 1.5, 1, 59),
(1478, 0.3060, 1.5, 0, 1479),
(1479, 0.3060, 1.5, 1, 1478),
(1563, 0.3519, 1.5, 0, 1564),
(1564, 0.3519, 1.5, 1, 1563),
(10045, 1.0000, 1.5, 2, 0);
