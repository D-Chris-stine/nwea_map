USE [students]
GO

/****** Object:  View [custom].[vw_map_WITH_sub_queries]    Script Date: 10/17/2022 12:27:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [custom].[vw_map_WITH_sub_queries]
AS
/* MAP SUB Queries */
WITH
d AS (
/* MAP Demographics */
SELECT DISTINCT
	 stu.local_student_id AS "Student ID"
	,stu.student_id AS "Illuminate Student ID"
	,CONCAT(stu.last_name,', ',stu.first_name) AS "Student Name"
	--,sch.site_id AS "School ID"
	,sch.site_name "School Name"
	,mr.homeroom AS "Homeroom"
	,sch.[start_date] AS "Entry Date"
	,sch.end_date AS "Exit Date"
	,CASE
    WHEN sta.grade_level_id = 1 THEN 'K'
    WHEN sta.grade_level_id = 2 THEN '1st'
    WHEN sta.grade_level_id = 3 THEN '2nd'
    WHEN sta.grade_level_id = 4 THEN '3rd'
    WHEN sta.grade_level_id = 5 THEN '4th'
    WHEN sta.grade_level_id = 6 THEN '5th'
    WHEN sta.grade_level_id = 7 THEN '6th'
    WHEN sta.grade_level_id = 8 THEN '7th'
    WHEN sta.grade_level_id = 9 THEN '8th'
    ELSE NULL
    END "Grade Level"     
	,'2023' AS "School Year"
	
	FROM [illuminate].[public_students] stu
	INNER JOIN [custom].[vw_illuminate_student_site_aff] sch ON sch.student_id = stu.student_id
	INNER JOIN [illuminate].[matviews_student_term_aff] sta ON sch.student_id=sta.student_id
	  AND sta.entry_date=sch.start_date
	  AND sta.leave_date IS NULL
	LEFT JOIN [google].[master_roster_2023] mr on mr.student_id=stu.local_student_id
	
	WHERE 1=1
	AND sch.start_date > '2022-07-01' -- SY21-22
	AND sch.end_date ='2023-06-30'
	AND sch.site_id != 5901
	),

f AS (
SELECT DISTINCT
	 stu.local_student_id AS "Student ID"
	,map_2023.[nwea_2023_Discipline] AS "subject"
	--,map_2023.[nwea_2023_TermName] AS "term_name"
	--,map_2023.[nwea_2023_TestName] AS "test_name"
	,map_2023.[nwea_2023_TestPercentile] AS "fall_percentile"
	,map_2023.[nwea_2023_TestRITScore] AS "fall_rit"
	,map_2023.[nwea_2023_TypicalFallToWinterGrowth] AS "FWTypicalGrowth"
	,map_2023.[nwea_2023_TypicalFallToSpringGrowth] AS "FSTypicalGrowth"
	,map_2023.[nwea_2023_TestRITScore] + map_2023.[nwea_2023_TypicalFallToWinterGrowth] AS "FW Typical Growth Goal"
	,map_2023.[nwea_2023_TestRITScore] + map_2023.[nwea_2023_TypicalFallToSpringGrowth] AS  "FS Typical Growth Goal"
	,RANK() OVER(		
		PARTITION BY map_2023.nwea_2023_localstudentid, map_2023.[nwea_2023_TermName], map_2023.[nwea_2023_Discipline]
		ORDER BY map_2023.[nwea_2023_TestStandardError] DESC) BestTest
	FROM [illuminate].[public_students] stu
	INNER JOIN [custom].[vw_illuminate_student_site_aff] sch ON sch.student_id = stu.student_id
	INNER JOIN [illuminate].[matviews_student_term_aff] sta ON sch.student_id=sta.student_id
	  AND sta.entry_date=sch.start_date
	  AND sta.leave_date IS NULL
	LEFT JOIN [illuminate].[national_assessments_nwea_2023] map_2023 on map_2023.[student_id] = stu.student_id
	LEFT JOIN [google].[master_roster_2023] mr on mr.student_id=stu.local_student_id
	LEFT JOIN [custom].[vw_map_anchor_2023] a ON a.[StudentID]=stu.local_student_id AND a.Discipline=map_2023.[nwea_2023_Discipline]

	WHERE 1=1
	AND sch.start_date > '2022-07-01' -- SY21-22
	AND sch.end_date < '2023-07-01'
	AND map_2023.[nwea_2023_TermName] = 'Fall 2022-2023'
	AND map_2023.[nwea_2023_Discipline] NOT IN ('Math K-12','Science K-12')
	AND CASE
		WHEN sta.grade_level_id IN (1,2) 
		AND map_2023.[nwea_2023_TestName] IN ('Growth: Math K-2 FL 2014', 'Growth: Reading K-2 FL 2014')
			THEN 1
        WHEN  sta.grade_level_id IN (3,4,5,6) 
        AND map_2023.[nwea_2023_TestName] IN ('Growth: Math 2-5 FL 2014', 'Growth: Reading 2-5 FL 2014 V2')
			THEN 1
		WHEN  sta.grade_level_id IN (7,8,9) 
        AND map_2023.[nwea_2023_TestName] IN ('Growth: Math 6+ FL 2014', 'Growth: Reading 6+ FL 2014 V2')
			THEN 1
		WHEN  sta.grade_level_id IN (4,5,6) 
        AND map_2023.[nwea_2023_TestName] = 'Growth: Science 3-5 FL 2008'
			THEN 1
		WHEN  sta.grade_level_id IN (7,8,9) 
        AND map_2023.[nwea_2023_TestName] = 'Growth: Science 6-8 FL 2008'
			THEN 1
		ELSE 0
        END = 1
	),

w AS (
/*MAP Winter sub query*/
SELECT DISTINCT
	 stu.local_student_id AS "Student ID"
	,map_2023.[nwea_2023_Discipline] AS "subject"
	--,map_2023.[nwea_2023_TermName] AS "TermName"
	--,map_2023.[nwea_2023_TestName] AS "TestName"
	,map_2023.[nwea_2023_TestPercentile] AS "winterTestPercentile"
	,map_2023.[nwea_2023_TestRITScore] AS "winterTestRITScore"
	,RANK() OVER(		
		PARTITION BY map_2023.nwea_2023_localstudentid, map_2023.[nwea_2023_TermName], map_2023.[nwea_2023_Discipline]
		ORDER BY map_2023.[nwea_2023_TestStandardError] DESC) BestTest
	FROM [illuminate].[public_students] stu
	INNER JOIN [custom].[vw_illuminate_student_site_aff] sch ON sch.student_id = stu.student_id
	INNER JOIN [illuminate].[matviews_student_term_aff] sta ON sch.student_id=sta.student_id
	  AND sta.entry_date=sch.start_date
	  AND sta.leave_date IS NULL
	LEFT JOIN [illuminate].[national_assessments_nwea_2023] map_2023 on map_2023.[student_id] = stu.student_id
	LEFT JOIN [google].[master_roster_2023] mr on mr.student_id=stu.local_student_id
	LEFT JOIN [custom].[vw_map_anchor_2023] a ON a.[StudentID]=stu.local_student_id AND a.Discipline=map_2023.[nwea_2023_Discipline]

	WHERE 1=1
	AND sch.start_date > '2022-07-01' -- SY21-22
	AND sch.end_date < '2023-07-01'
	AND map_2023.[nwea_2023_TermName] = 'Winter 2022-2023'
	AND map_2023.[nwea_2023_Discipline] NOT IN ('Math K-12','Science K-12')
	AND CASE
		WHEN sta.grade_level_id IN (1,2) 
		AND map_2023.[nwea_2023_TestName] IN ('Growth: Math K-2 FL 2014', 'Growth: Reading K-2 FL 2014')
			THEN 1
        WHEN  sta.grade_level_id IN (3,4,5,6) 
        AND map_2023.[nwea_2023_TestName] IN ('Growth: Math 2-5 FL 2014', 'Growth: Reading 2-5 FL 2014 V2')
			THEN 1
		WHEN  sta.grade_level_id IN (7,8,9) 
        AND map_2023.[nwea_2023_TestName] IN ('Growth: Math 6+ FL 2014', 'Growth: Reading 6+ FL 2014 V2')
			THEN 1
		WHEN  sta.grade_level_id IN (4,5,6) 
        AND map_2023.[nwea_2023_TestName] = 'Growth: Science 3-5 FL 2008'
			THEN 1
		WHEN  sta.grade_level_id IN (7,8,9) 
        AND map_2023.[nwea_2023_TestName] = 'Growth: Science 6-8 FL 2008'
			THEN 1
		ELSE 0
        END = 1
		)

SELECT 
 d.[Student ID]
,d.[Student Name]
,d.[School Name]
,d.Homeroom
,d.[Grade Level]
,f.subject
,f.fall_percentile "Fall Percentile"
,w.winterTestPercentile "Winter Percentile"
,f.fall_rit "Fall RIT"
,w.winterTestRITScore "Winter RIT"
,f.[FW Typical Growth Goal]
,f.[FS Typical Growth Goal]

FROM d
LEFT JOIN f on d.[Student ID] = f.[Student ID]
LEFT JOIN w on d.[Student ID] = w.[Student ID] AND f.subject= w.subject
--WHERE d.[Student ID] = 11995958
GO


