EXPLAIN ANALYZE VERBOSE
SELECT 
	DISTINCT t_02.puid
FROM
	PWORKSPACEOBJECT t_01, -- 108431199
	PMFG0MEPLANTBOP t_02, -- 23563
	PSTRUCTURE_REVISIONS t_03, -- 4491757
	PITEMREVISION t_04, -- 8988111
	PPSBOMVIEWREVISION t_05, -- 4491846
	PPSOCCURRENCE t_06, -- 785831616
	PSTRUCTURE_REVISIONS t_07, -- 4491757
	PITEMREVISION t_08, -- 8988111
	PPSBOMVIEWREVISION t_09, -- 4491846
	PPSOCCURRENCE t_010, -- 785831616
	PITEM t_011, -- 5980046
	PMEOP t_012, -- 1009626
	PMFG0MEPROCSTATN t_013, -- 497101
	PMFG0MEPROCLINE t_014, -- 182593
	PPSOCCURRENCE t_015, -- 785831616
	PPSBOMVIEWREVISION t_016, -- 4491846
	PSTRUCTURE_REVISIONS t_017, -- 4491757
	PITEMREVISION t_018 -- 8988111
WHERE 
(
	(
		(
			(t_02.puid = t_018.ritems_tagu)
			AND (
				(t_017.pvalu_0 = t_016.puid)
				AND (
					(t_016.puid = t_015.rparent_bvru)
					AND (
						(t_015.rchild_itemu = t_014.puid)
						AND (
							(t_014.puid = t_04.ritems_tagu)
							AND (
								(t_03.pvalu_0 = t_05.puid)
								AND (
									(t_05.puid = t_06.rparent_bvru)
									AND (
										(t_06.rchild_itemu = t_013.puid)
										AND (
											(t_013.puid = t_08.ritems_tagu)
											AND (
												(t_07.pvalu_0 = t_09.puid)
												AND (
													(t_09.puid = t_010.rparent_bvru)
													AND ( (t_010.rchild_itemu = t_012.puid)  AND (UPPER(t_011.pitem_id) = UPPER('2580116'))))
												)
											)
										)
									)
								)
							)
						)
					)
				)
			)
		)
		AND UPPER(t_01.pobject_type) like UPPER('%')
	)
	AND (
		t_01.puid = t_02.puid 
		AND t_011.puid = t_012.puid 
		AND t_017.puid = t_018.puid 
		AND t_07.puid = t_08.puid 
		AND t_03.puid = t_04.puid
	)
);



EXPLAIN ANALYZE VERBOSE SELECT * FROM PITEM t_011 
where UPPER(t_011.pitem_id) = UPPER('2580116');

EXPLAIN ANALYZE VERBOSE SELECT * FROM PITEM t_011, PMEOP t_012 
where t_011.puid = t_012.puid AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012 
where (t_010.rchild_itemu = t_012.puid) AND t_011.puid = t_012.puid AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012 
where (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND t_011.puid = t_012.puid AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PSTRUCTURE_REVISIONS t_07,PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012 
where (t_07.pvalu_0 = t_09.puid) AND (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND t_011.puid = t_012.puid AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PSTRUCTURE_REVISIONS t_07, PITEMREVISION t_08, PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012 
where (t_07.pvalu_0 = t_09.puid) AND (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND t_011.puid = t_012.puid AND t_07.puid = t_08.puid  AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PSTRUCTURE_REVISIONS t_07, PITEMREVISION t_08, PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012, PMFG0MEPROCSTATN t_013 
where (t_013.puid = t_08.ritems_tagu) AND (t_07.pvalu_0 = t_09.puid) AND (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND t_011.puid = t_012.puid AND t_07.puid = t_08.puid  AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PPSOCCURRENCE t_06, PSTRUCTURE_REVISIONS t_07, PITEMREVISION t_08, PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012, PMFG0MEPROCSTATN t_013  
where (t_06.rchild_itemu = t_013.puid) AND (t_013.puid = t_08.ritems_tagu) AND (t_07.pvalu_0 = t_09.puid) AND (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND t_011.puid = t_012.puid AND t_07.puid = t_08.puid  AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PPSBOMVIEWREVISION t_05,PPSOCCURRENCE t_06, PSTRUCTURE_REVISIONS t_07, PITEMREVISION t_08, PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012, PMFG0MEPROCSTATN t_013 
where (t_05.puid = t_06.rparent_bvru) AND (t_06.rchild_itemu = t_013.puid) AND (t_013.puid = t_08.ritems_tagu) AND (t_07.pvalu_0 = t_09.puid) AND (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND t_011.puid = t_012.puid AND t_07.puid = t_08.puid  AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PSTRUCTURE_REVISIONS t_03, PPSBOMVIEWREVISION t_05,PPSOCCURRENCE t_06, PSTRUCTURE_REVISIONS t_07, PITEMREVISION t_08, PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012, PMFG0MEPROCSTATN t_013 
where (t_03.pvalu_0 = t_05.puid) AND (t_05.puid = t_06.rparent_bvru) AND (t_06.rchild_itemu = t_013.puid) AND (t_013.puid = t_08.ritems_tagu) AND (t_07.pvalu_0 = t_09.puid) AND (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND t_011.puid = t_012.puid AND t_07.puid = t_08.puid  AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PSTRUCTURE_REVISIONS t_03, PITEMREVISION t_04, PPSBOMVIEWREVISION t_05,PPSOCCURRENCE t_06, PSTRUCTURE_REVISIONS t_07, PITEMREVISION t_08, PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012, PMFG0MEPROCSTATN t_013 
where (t_03.pvalu_0 = t_05.puid) AND (t_05.puid = t_06.rparent_bvru) AND (t_06.rchild_itemu = t_013.puid) AND (t_013.puid = t_08.ritems_tagu) AND (t_07.pvalu_0 = t_09.puid) AND (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND t_011.puid = t_012.puid AND t_07.puid = t_08.puid AND t_03.puid = t_04.puid AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PSTRUCTURE_REVISIONS t_03, PITEMREVISION t_04, PPSBOMVIEWREVISION t_05,PPSOCCURRENCE t_06, PSTRUCTURE_REVISIONS t_07, PITEMREVISION t_08, PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012, PMFG0MEPROCSTATN t_013,PMFG0MEPROCLINE t_014 
where (t_014.puid = t_04.ritems_tagu) AND (t_03.pvalu_0 = t_05.puid) AND (t_05.puid = t_06.rparent_bvru) AND (t_06.rchild_itemu = t_013.puid) AND (t_013.puid = t_08.ritems_tagu) AND (t_07.pvalu_0 = t_09.puid) AND (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND t_011.puid = t_012.puid AND t_07.puid = t_08.puid AND t_03.puid = t_04.puid AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PSTRUCTURE_REVISIONS t_03, PITEMREVISION t_04, PPSBOMVIEWREVISION t_05,PPSOCCURRENCE t_06, PSTRUCTURE_REVISIONS t_07, PITEMREVISION t_08, PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012, PMFG0MEPROCSTATN t_013,PMFG0MEPROCLINE t_014, PPSOCCURRENCE t_015 
where (t_015.rchild_itemu = t_014.puid) AND (t_014.puid = t_04.ritems_tagu) AND (t_03.pvalu_0 = t_05.puid) AND (t_05.puid = t_06.rparent_bvru) AND (t_06.rchild_itemu = t_013.puid) AND (t_013.puid = t_08.ritems_tagu) AND (t_07.pvalu_0 = t_09.puid) AND (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND t_011.puid = t_012.puid AND t_07.puid = t_08.puid AND t_03.puid = t_04.puid AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PSTRUCTURE_REVISIONS t_03, PITEMREVISION t_04, PPSBOMVIEWREVISION t_05,PPSOCCURRENCE t_06, PSTRUCTURE_REVISIONS t_07, PITEMREVISION t_08, PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012, PMFG0MEPROCSTATN t_013,PMFG0MEPROCLINE t_014, PPSOCCURRENCE t_015 ,PPSBOMVIEWREVISION t_016 
where (t_016.puid = t_015.rparent_bvru) AND (t_015.rchild_itemu = t_014.puid) AND (t_014.puid = t_04.ritems_tagu) AND (t_03.pvalu_0 = t_05.puid) AND (t_05.puid = t_06.rparent_bvru) AND (t_06.rchild_itemu = t_013.puid) AND (t_013.puid = t_08.ritems_tagu) AND (t_07.pvalu_0 = t_09.puid) AND (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND t_011.puid = t_012.puid AND t_07.puid = t_08.puid AND t_03.puid = t_04.puid AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PSTRUCTURE_REVISIONS t_03, PITEMREVISION t_04, PPSBOMVIEWREVISION t_05,PPSOCCURRENCE t_06, PSTRUCTURE_REVISIONS t_07, PITEMREVISION t_08, PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012, PMFG0MEPROCSTATN t_013,PMFG0MEPROCLINE t_014, PPSOCCURRENCE t_015 ,PPSBOMVIEWREVISION t_016,PSTRUCTURE_REVISIONS t_017 
where (t_017.pvalu_0 = t_016.puid) AND (t_016.puid = t_015.rparent_bvru) AND (t_015.rchild_itemu = t_014.puid) AND (t_014.puid = t_04.ritems_tagu) AND (t_03.pvalu_0 = t_05.puid) AND (t_05.puid = t_06.rparent_bvru) AND (t_06.rchild_itemu = t_013.puid) AND (t_013.puid = t_08.ritems_tagu) AND (t_07.pvalu_0 = t_09.puid) AND (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND t_011.puid = t_012.puid AND t_07.puid = t_08.puid AND t_03.puid = t_04.puid AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PMFG0MEPLANTBOP t_02, PSTRUCTURE_REVISIONS t_03, PITEMREVISION t_04, PPSBOMVIEWREVISION t_05,PPSOCCURRENCE t_06, PSTRUCTURE_REVISIONS t_07, PITEMREVISION t_08, PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012, PMFG0MEPROCSTATN t_013,PMFG0MEPROCLINE t_014, PPSOCCURRENCE t_015 ,PPSBOMVIEWREVISION t_016,PSTRUCTURE_REVISIONS t_017, PITEMREVISION t_018 
where (t_02.puid = t_018.ritems_tagu) AND (t_017.pvalu_0 = t_016.puid) AND (t_016.puid = t_015.rparent_bvru) AND (t_015.rchild_itemu = t_014.puid) AND (t_014.puid = t_04.ritems_tagu) AND (t_03.pvalu_0 = t_05.puid) AND (t_05.puid = t_06.rparent_bvru) AND (t_06.rchild_itemu = t_013.puid) AND (t_013.puid = t_08.ritems_tagu) AND (t_07.pvalu_0 = t_09.puid) AND (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND t_011.puid = t_012.puid AND t_07.puid = t_08.puid AND t_03.puid = t_04.puid AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PMFG0MEPLANTBOP t_02, PSTRUCTURE_REVISIONS t_03, PITEMREVISION t_04, PPSBOMVIEWREVISION t_05,PPSOCCURRENCE t_06, PSTRUCTURE_REVISIONS t_07, PITEMREVISION t_08, PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012, PMFG0MEPROCSTATN t_013,PMFG0MEPROCLINE t_014, PPSOCCURRENCE t_015 ,PPSBOMVIEWREVISION t_016,PSTRUCTURE_REVISIONS t_017, PITEMREVISION t_018 
where (t_02.puid = t_018.ritems_tagu) AND (t_017.pvalu_0 = t_016.puid) AND (t_016.puid = t_015.rparent_bvru) AND (t_015.rchild_itemu = t_014.puid) AND (t_014.puid = t_04.ritems_tagu) AND (t_03.pvalu_0 = t_05.puid) AND (t_05.puid = t_06.rparent_bvru) AND (t_06.rchild_itemu = t_013.puid) AND (t_013.puid = t_08.ritems_tagu) AND (t_07.pvalu_0 = t_09.puid) AND (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND t_011.puid = t_012.puid AND t_017.puid = t_018.puid AND t_07.puid = t_08.puid AND t_03.puid = t_04.puid AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PWORKSPACEOBJECT t_01, PMFG0MEPLANTBOP t_02, PSTRUCTURE_REVISIONS t_03, PITEMREVISION t_04, PPSBOMVIEWREVISION t_05,PPSOCCURRENCE t_06, PSTRUCTURE_REVISIONS t_07, PITEMREVISION t_08, PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012, PMFG0MEPROCSTATN t_013,PMFG0MEPROCLINE t_014, PPSOCCURRENCE t_015 ,PPSBOMVIEWREVISION t_016,PSTRUCTURE_REVISIONS t_017, PITEMREVISION t_018 
where (t_02.puid = t_018.ritems_tagu) AND (t_017.pvalu_0 = t_016.puid) AND (t_016.puid = t_015.rparent_bvru) AND (t_015.rchild_itemu = t_014.puid) AND (t_014.puid = t_04.ritems_tagu) AND (t_03.pvalu_0 = t_05.puid) AND (t_05.puid = t_06.rparent_bvru) AND (t_06.rchild_itemu = t_013.puid) AND (t_013.puid = t_08.ritems_tagu) AND (t_07.pvalu_0 = t_09.puid) AND (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND t_01.puid = t_02.puid  AND t_011.puid = t_012.puid AND t_017.puid = t_018.puid AND t_07.puid = t_08.puid AND t_03.puid = t_04.puid AND (UPPER(t_011.pitem_id) = UPPER('2580116'));

EXPLAIN ANALYZE VERBOSE SELECT * FROM PWORKSPACEOBJECT t_01, PMFG0MEPLANTBOP t_02, PSTRUCTURE_REVISIONS t_03, PITEMREVISION t_04, PPSBOMVIEWREVISION t_05,PPSOCCURRENCE t_06, PSTRUCTURE_REVISIONS t_07, PITEMREVISION t_08, PPSBOMVIEWREVISION t_09, PPSOCCURRENCE t_010, PITEM t_011, PMEOP t_012, PMFG0MEPROCSTATN t_013,PMFG0MEPROCLINE t_014, PPSOCCURRENCE t_015 ,PPSBOMVIEWREVISION t_016,PSTRUCTURE_REVISIONS t_017, PITEMREVISION t_018 
where (t_02.puid = t_018.ritems_tagu) AND (t_017.pvalu_0 = t_016.puid) AND (t_016.puid = t_015.rparent_bvru) AND (t_015.rchild_itemu = t_014.puid) AND (t_014.puid = t_04.ritems_tagu) AND (t_03.pvalu_0 = t_05.puid) AND (t_05.puid = t_06.rparent_bvru) AND (t_06.rchild_itemu = t_013.puid) AND (t_013.puid = t_08.ritems_tagu) AND (t_07.pvalu_0 = t_09.puid) AND (t_09.puid = t_010.rparent_bvru) AND (t_010.rchild_itemu = t_012.puid) AND UPPER(t_01.pobject_type) like UPPER('%') AND t_01.puid = t_02.puid  AND t_011.puid = t_012.puid AND t_017.puid = t_018.puid AND t_07.puid = t_08.puid AND t_03.puid = t_04.puid AND (UPPER(t_011.pitem_id) = UPPER('2580116'));
