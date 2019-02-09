ALTER TABLE db_version CHANGE COLUMN required_z1940_s1528_11940_01_mangos_creature_movement_scripts required_z1940_s1528_11940_02_mangos_event_scripts bit;


ALTER TABLE event_scripts ADD COLUMN temp MEDIUMINT(8) DEFAULT 0 AFTER command;

-- Move datalong4 -> 2, 3 -> 4, 2 -> 3 (right shift)
UPDATE event_scripts SET temp=datalong4 WHERE command IN (0, 1, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29);
UPDATE event_scripts SET datalong4=datalong3, datalong3=datalong2, datalong2=temp WHERE command IN (0, 1, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29);

ALTER TABLE event_scripts CHANGE COLUMN datalong3 buddy_entry MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '0';
ALTER TABLE event_scripts CHANGE COLUMN datalong4 search_radius MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '0';

UPDATE event_scripts SET temp=0;

/* Chat*/
UPDATE event_scripts SET temp=temp | 0x04 WHERE command=0 AND (data_flags & 0x02) > 0; -- target self
UPDATE event_scripts SET temp=temp | 0x01 WHERE command=0 AND (data_flags & 0x04) > 0; -- buddy as target
UPDATE event_scripts SET temp=temp | 0x10 WHERE command=0 AND (data_flags & 0x01) > 0; -- will produce error
-- Note that old flag 0x01 // flag_target_player_as_source     0x01 could not be converted automatically, need to check every script

/* Emote*/
UPDATE event_scripts SET temp=temp | 0x02 WHERE command=1 AND (data_flags & 0x01 > 0) AND buddy_entry = 0; -- reverse order if no buddy defined
/*Summon */
UPDATE event_scripts SET temp=temp | 0x08 WHERE command=10 AND (data_flags & 0x01 > 0); -- Summon as active
/* Remove Aura */
UPDATE event_scripts SET temp=0x02 WHERE command=14 AND datalong2=1;
UPDATE event_scripts SET datalong2=0 WHERE command=14;
/* Cast */
UPDATE event_scripts SET temp=temp | 0x08 WHERE command=15 AND (datalong2 & 0x04 > 0); -- cast triggered
UPDATE event_scripts SET temp=temp | 0x04 WHERE command=15 AND datalong2=0x01; -- s->t
UPDATE event_scripts SET temp=temp | 0x06 WHERE command=15 AND datalong2=0x02; -- t->t
UPDATE event_scripts SET temp=temp | 0x02 WHERE command=15 AND datalong2=0x03; -- t->s
UPDATE event_scripts SET datalong2=0 WHERE command=15;
/* change faction */
UPDATE event_scripts SET datalong2=data_flags WHERE command=22;
/* morph/ mount */
UPDATE event_scripts SET temp=temp | 0x08 WHERE command IN (23, 24) AND (data_flags & 0x01 > 0); -- Summon as active
/* attack start */
UPDATE event_scripts SET temp=temp | 0x03 WHERE command=26 AND data_flags=0x02; -- b->s
UPDATE event_scripts SET temp=temp | 0x01 WHERE command=26 AND data_flags=0x04 AND buddy_entry!=0; -- s->b/t
UPDATE event_scripts SET temp=temp | 0x14 WHERE command=26 AND data_flags=0x06 AND buddy_entry!=0; -- s->s -- Throw error, this would be unreasonable if buddy defined
UPDATE event_scripts SET temp=temp | 0x04 WHERE command=26 AND data_flags=0x06 AND buddy_entry=0; -- s->s
/* stand state */
UPDATE event_scripts SET temp=temp | 0x02 WHERE command=28 AND (data_flags & 0x01 > 0) AND buddy_entry=0;
/* change npc flag */
UPDATE event_scripts SET datalong2=data_flags WHERE command=29;

UPDATE event_scripts SET data_flags=temp;

ALTER TABLE event_scripts DROP COLUMN temp;
