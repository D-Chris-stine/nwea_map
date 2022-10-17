USE [students]
GO

/****** Object:  View [custom].[vw_map_union]    Script Date: 10/17/2022 12:25:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/**** NOTES ON VIEW ****/
--This view is the basis for the MAP dashboard.
--It unions all NWEA tables (imported from Illuminate) together in to a single "tall" view.
--Is is queried in the view:  [dashboards].[vw_nwea_map] and joined with the dashboard.map_goals to populate the map dashboard" 
--ANNUAL UPDATE REQUIRED: Add new SY table to the end of the union.
/******End of Notes******/

CREATE VIEW [custom].[vw_map_union]
AS
--NWEA Data SY18-19
SELECT * FROM (
SELECT DISTINCT
stu.local_student_id AS "Student ID"
,stu.student_id AS "Illuminate Student ID"
,CONCAT(stu.last_name,', ',stu.first_name) AS "Student Name"
,stu.last_name AS "Last Name"
,stu.first_name AS "First Name"
,sch.site_id AS "School ID"
,sch.site_name "School Name"
,'' AS "Homeroom"
--,mr.learning_program AS "Learning Program"
,sch.[start_date] AS "Entry Date"
,sch.end_date AS "Exit Date"
,CASE
    WHEN sch.end_date='2019-06-30' THEN 'Active'
    ELSE 'Inactive'
    END "Enrollment Status"
,sta.grade_level_id AS "Grade Level ID"
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
,map_2019."nwea_2019_id" AS "ID"
,map_2019."nwea_2019_Discipline" AS "Discipline"
,map_2019."nwea_2019_TermName" AS "TermName"
,map_2019."nwea_2019_TestRITScore" AS "TestRITScore"
,map_2019."nwea_2019_TestType" AS "TestType"
,map_2019."nwea_2019_TestName" AS "TestName"
,map_2019."nwea_2019_TestPercentile" AS "TestPercentile"
--,map_2019."nwea_2019_studentLastName" AS "StudentLastName"
--,map_2019."nwea_2019_studentFirstName" AS "StudentFirstName"
,map_2019."nwea_2019_TestStartDate" AS "TestStartDate"
,map_2019.[nwea_2019_TestStandardError] AS "TestStandardError"
,CASE
		WHEN sta.[grade_level_id] IN (1,2) 
		AND map_2019.[nwea_2019_TestName] IN ('Growth: Math K-2 FL 2014', 'Growth: Reading K-2 FL 2014')
			THEN 1
        WHEN  sta.[grade_level_id] IN (3,4,5,6) 
        AND map_2019.[nwea_2019_TestName] IN ('Growth: Math 2-5 FL 2014', 'Growth: Reading 2-5 FL 2014 V2')
			THEN 1
		WHEN  sta.[grade_level_id] IN (7,8,9) 
        AND map_2019.[nwea_2019_TestName] IN ('Growth: Math 6+ FL 2014', 'Growth: Reading 6+ FL 2014 V2')
			THEN 1
		WHEN sta.[grade_level_id] IN (4,5,6) 
        AND map_2019.[nwea_2019_TestName] = 'Growth: Science 3-5 FL 2008'
			THEN 1
		WHEN  sta.[grade_level_id] IN (7,8,9) 
        AND map_2019.[nwea_2019_TestName] = 'Growth: Science 6-8 FL 2008'
			THEN 1
		ELSE 0
        END TestAligned
,RANK() OVER(		
		PARTITION BY map_2019.nwea_2019_localstudentid, map_2019.[nwea_2019_TermName], map_2019.[nwea_2019_Discipline]
		ORDER BY map_2019.[nwea_2019_TestStandardError] DESC) BestTest
,'' AS "Fall TestRITScore"
,'' AS "Fall Percentile"
,'' AS "FW TypicalGrowth"
,'' AS "FS TypicalGrowth"
--,NULL AS "FW TypicalGrowth Goal"
--,NULL AS "FW Typical Growth Goal"
,'2019' AS "School Year"
,map_2019.nwea_2019_testgradelevel AS "test grade level"
FROM [illuminate].[public_students] stu
INNER JOIN [custom].[vw_illuminate_student_site_aff] sch ON sch.student_id = stu.student_id
INNER JOIN [illuminate].[matviews_student_term_aff] sta ON sch.student_id=sta.student_id
  AND sta.entry_date=sch.start_date 
 -- AND sta.leave_date IS NULL
LEFT JOIN [illuminate].[national_assessments_nwea_2019] map_2019 on map_2019.student_id = stu.student_id
--LEFT JOIN [google].[master_roster_2021] mr on mr.student_id=stu.local_student_id

WHERE 1=1
AND sch.start_date > '2018-07-01' -- SY18-19
AND sch.end_date < '2019-07-01'
--AND stu.local_student_id = '12532669'
) map19
UNION ALL

--NWEA Data SY19-20
SELECT * FROM (
SELECT DISTINCT
stu.local_student_id AS "Student ID"
,stu.student_id AS "Illuminate Student ID"
,CONCAT(stu.last_name,', ',stu.first_name) AS "Student Name"
,stu.last_name AS "Last Name"
,stu.first_name AS "First Name"
,sch.site_id AS "School ID"
,sch.site_name "School Name"
,'' AS "Homeroom"
--,mr.learning_program AS "Learning Program"
,sch.[start_date] AS "Entry Date"
,sch.end_date AS "Exit Date"
,CASE
    WHEN sch.end_date='2020-06-30' THEN 'Active'
    ELSE 'Inactive'
    END "Enrollment Status"
,sta.grade_level_id AS "Grade Level ID"
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
,map_2020."nwea_2020_id" AS "ID"
,map_2020."nwea_2020_Discipline" AS "Discipline"
,map_2020."nwea_2020_TermName" AS "TermName"
,map_2020."nwea_2020_TestRITScore" AS "TestRITScore"
,map_2020."nwea_2020_TestType" AS "TestType"
,map_2020."nwea_2020_TestName" AS "TestName"
,map_2020."nwea_2020_TestPercentile" AS "TestPercentile"
--,map_2020."nwea_2020_studentLastName" AS "StudentLastName"
--,map_2020."nwea_2020_studentFirstName" AS "StudentFirstName"
,map_2020."nwea_2020_TestStartDate" AS "TestStartDate"
,map_2020.[nwea_2020_TestStandardError] AS "TestStandardError"
,CASE
		WHEN sta.[grade_level_id] IN (1,2) 
		AND map_2020.[nwea_2020_TestName] IN ('Growth: Math K-2 FL 2014', 'Growth: Reading K-2 FL 2014')
			THEN 1
        WHEN  sta.[grade_level_id] IN (3,4,5,6) 
        AND map_2020.[nwea_2020_TestName] IN ('Growth: Math 2-5 FL 2014', 'Growth: Reading 2-5 FL 2014 V2')
			THEN 1
		WHEN  sta.[grade_level_id] IN (7,8,9) 
        AND map_2020.[nwea_2020_TestName] IN ('Growth: Math 6+ FL 2014', 'Growth: Reading 6+ FL 2014 V2')
			THEN 1
		WHEN sta.[grade_level_id] IN (4,5,6) 
        AND map_2020.[nwea_2020_TestName] = 'Growth: Science 3-5 FL 2008'
			THEN 1
		WHEN  sta.[grade_level_id] IN (7,8,9) 
        AND map_2020.[nwea_2020_TestName] = 'Growth: Science 6-8 FL 2008'
			THEN 1
		ELSE 0
        END TestAligned
,RANK() OVER(		
		PARTITION BY map_2020.nwea_2020_localstudentid, map_2020.[nwea_2020_TermName], map_2020.[nwea_2020_Discipline]
		ORDER BY map_2020.[nwea_2020_TestStandardError] DESC) BestTest
,'' AS "Fall TestRITScore"
,'' AS "Fall Percentile"
,'' AS "FW TypicalGrowth"
,'' AS "FS TypicalGrowth"
--,NULL AS "FW TypicalGrowth Goal"
--,NULL AS "FW Typical Growth Goal"
,'2020' AS "School Year"
,map_2020.nwea_2020_testgradelevel
FROM [illuminate].[public_students] stu
INNER JOIN [custom].[vw_illuminate_student_site_aff] sch ON sch.student_id = stu.student_id
INNER JOIN [illuminate].[matviews_student_term_aff] sta ON sch.student_id=sta.student_id
  AND sta.entry_date=sch.start_date 
  --AND sta.leave_date IS NULL
LEFT JOIN [illuminate].[national_assessments_nwea_2020] map_2020 on map_2020.student_id = stu.student_id
LEFT JOIN [google].[master_roster_2021] mr on mr.student_id=stu.local_student_id
WHERE 1=1
AND sch.start_date > '2019-07-01' -- SY19-20
AND sch.end_date < '2020-07-01'
--AND stu.local_student_id = '12532669'
)map20
UNION ALL

--NWEA Data SY20-21
SELECT * FROM (

	SELECT DISTINCT
	 stu.local_student_id AS "Student ID"
	,stu.student_id AS "Illuminate Student ID"
	,CONCAT(stu.last_name,', ',stu.first_name) AS "Student Name"
	,stu.last_name AS "Last Name"
	,stu.first_name AS "First Name"
	,sch.site_id AS "School ID"
	,sch.site_name "School Name"
	,mr.homeroom_lp AS "Homeroom"
	--,mr.learning_program AS "Learning Program"
	,sch.[start_date] AS "Entry Date"
	,sch.end_date AS "Exit Date"
	,CASE
		WHEN sch.end_date='2021-06-30' THEN 'Active'
		ELSE 'Inactive'
		END "Enrollment Status"
	,sta.grade_level_id AS "Grade Level ID"
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
    ,map_2021."nwea_2021_id" AS "ID"
	,map_2021.[nwea_2021_Discipline] AS "NWEA Subject"
	,map_2021.[nwea_2021_TermName] AS "TermName"
	,map_2021.[nwea_2021_TestRITScore] AS "TestRITScore"
	,map_2021.[nwea_2021_TestType] AS "TestType"
	,map_2021.[nwea_2021_TestName] AS "TestName"
	,map_2021.[nwea_2021_TestPercentile] AS "TestPercentile"
	--,map_2021.[nwea_2021_studentLastName] AS "StudentLastName"
	--,map_2021.[nwea_2021_studentFirstName] AS "StudentFirstName"
	,map_2021.[nwea_2021_TestStartDate] AS "TestStartDate"
	,map_2021.[nwea_2021_TestStandardError] AS "TestStandardError"
        ,CASE
		WHEN sta.[grade_level_id] IN (1,2) 
		AND map_2021.[nwea_2021_TestName] IN ('Growth: Math K-2 FL 2014', 'Growth: Reading K-2 FL 2014')
			THEN 1
        WHEN  sta.[grade_level_id] IN (3,4,5,6) 
        AND map_2021.[nwea_2021_TestName] IN ('Growth: Math 2-5 FL 2014', 'Growth: Reading 2-5 FL 2014 V2')
			THEN 1
		WHEN  sta.[grade_level_id] IN (7,8,9) 
        AND map_2021.[nwea_2021_TestName] IN ('Growth: Math 6+ FL 2014', 'Growth: Reading 6+ FL 2014 V2')
			THEN 1
		WHEN sta.[grade_level_id] IN (4,5,6) 
        AND map_2021.[nwea_2021_TestName] = 'Growth: Science 3-5 FL 2008'
			THEN 1
		WHEN  sta.[grade_level_id] IN (7,8,9) 
        AND map_2021.[nwea_2021_TestName] = 'Growth: Science 6-8 FL 2008'
			THEN 1
		ELSE 0
        END TestAligned
	,RANK() OVER(		
		PARTITION BY map_2021.nwea_2021_localstudentid, map_2021.[nwea_2021_TermName], map_2021.[nwea_2021_Discipline]
		ORDER BY map_2021.[nwea_2021_TestStandardError] DESC) BestTest
	,a.[Fall TestRITScore]
	,a.[Fall TestPercentile]
	,map_2021.[nwea_2021_TypicalFallToWinterGrowth] AS "FW TypicalGrowth"
	,map_2021.[nwea_2021_TypicalFallToSpringGrowth] AS "FS TypicalGrowth"
	--,NULL AS "FW TypicalGrowth Goal"
	--,NULL AS "FW Typical Growth Goal"
	,'2021' AS "School Year"
	,map_2021.nwea_2021_testgradelevel
	FROM [illuminate].[public_students] stu
	INNER JOIN [custom].[vw_illuminate_student_site_aff] sch ON sch.student_id = stu.student_id
	INNER JOIN [illuminate].[matviews_student_term_aff] sta ON sch.student_id=sta.student_id
	  AND sta.entry_date=sch.start_date
	  --AND sta.leave_date IS NULL
	LEFT JOIN [illuminate].[national_assessments_nwea_2021] map_2021 on map_2021.[student_id] = stu.student_id
	LEFT JOIN [google].[master_roster_2021] mr on mr.student_id=stu.local_student_id
	LEFT JOIN [illuminate].[map_fall_2021] a ON a.[StudentID]=stu.local_student_id AND a.Discipline=map_2021.[nwea_2021_Discipline]
	
	WHERE 1=1
	AND sch.start_date > '2020-07-01' -- SY20-21
	AND sch.end_date < '2021-07-01'
	AND map_2021.[nwea_2021_Discipline] NOT IN ('Math K-12','Science K-12')
	--AND stu.local_student_id = '12532669'
	) map21
	

	UNION ALL

	--SY 21-22
	SELECT * FROM (

	SELECT DISTINCT
	 stu.local_student_id AS "Student ID"
	,stu.student_id AS "Illuminate Student ID"
	,CONCAT(stu.last_name,', ',stu.first_name) AS "Student Name"
	,stu.last_name AS "Last Name"
	,stu.first_name AS "First Name"
	,sch.site_id AS "School ID"
	,sch.site_name "School Name"
	,mr.homeroom AS "Homeroom"
	--,mr.learning_program AS "Learning Program"
	,sch.[start_date] AS "Entry Date"
	,sch.end_date AS "Exit Date"
	,CASE
		WHEN sch.end_date='2022-06-30' THEN 'Active'
		ELSE 'Inactive'
		END "Enrollment Status"
	,sta.grade_level_id AS "Grade Level ID"
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
    ,map_2022."nwea_2022_id" AS "ID"
	,map_2022.[nwea_2022_Discipline] AS "NWEA Subject"
	,map_2022.[nwea_2022_TermName] AS "TermName"
	,map_2022.[nwea_2022_TestRITScore] AS "TestRITScore"
	,map_2022.[nwea_2022_TestType] AS "TestType"
	,map_2022.[nwea_2022_TestName] AS "TestName"
	,map_2022.[nwea_2022_TestPercentile] AS "TestPercentile"
	--,map_2022.[nwea_2022_studentLastName] AS "StudentLastName"
	--,map_2022.[nwea_2022_studentFirstName] AS "StudentFirstName"
	,map_2022.[nwea_2022_TestStartDate] AS "TestStartDate"
	,map_2022.[nwea_2022_TestStandardError] AS "TestStandardError"
    ,CASE
		WHEN sta.grade_level_id IN (1,2) 
		AND map_2022.[nwea_2022_TestName] IN ('Growth: Math K-2 FL 2014', 'Growth: Reading K-2 FL 2014')
			THEN 1
        WHEN  sta.grade_level_id IN (3,4,5,6) 
        AND map_2022.[nwea_2022_TestName] IN ('Growth: Math 2-5 FL 2014', 'Growth: Reading 2-5 FL 2014 V2')
			THEN 1
		WHEN  sta.grade_level_id IN (7,8,9) 
        AND map_2022.[nwea_2022_TestName] IN ('Growth: Math 6+ FL 2014', 'Growth: Reading 6+ FL 2014 V2')
			THEN 1
		WHEN  sta.grade_level_id IN (4,5,6) 
        AND map_2022.[nwea_2022_TestName] = 'Growth: Science 3-5 FL 2008'
			THEN 1
		WHEN  sta.grade_level_id IN (7,8,9) 
        AND map_2022.[nwea_2022_TestName] = 'Growth: Science 6-8 FL 2008'
			THEN 1
		ELSE 0
        END TestAligned
	,RANK() OVER(		
		PARTITION BY map_2022.nwea_2022_localstudentid, map_2022.[nwea_2022_TermName], map_2022.[nwea_2022_Discipline]
		ORDER BY map_2022.[nwea_2022_TestStandardError] DESC) BestTest
	,a.[Fall TestRITScore]
	,a.[Fall TestPercentile]
	,map_2022.[nwea_2022_TypicalFallToWinterGrowth] AS "FW TypicalGrowth"
	,map_2022.[nwea_2022_TypicalFallToSpringGrowth] AS "FS TypicalGrowth"
	--,a.[FW Typical Growth Goal] AS "FW TypicalGrowth Goal"
	--,a.[FS Typical Growth Goal] AS "FW Typical Growth Goal"
	,'2022' AS "School Year"
	,map_2022.nwea_2022_testgradelevel
	FROM [illuminate].[public_students] stu
	INNER JOIN [custom].[vw_illuminate_student_site_aff] sch ON sch.student_id = stu.student_id
	INNER JOIN [illuminate].[matviews_student_term_aff] sta ON sch.student_id=sta.student_id
	  AND sta.entry_date=sch.start_date
	  AND sta.leave_date IS NULL
	LEFT JOIN [illuminate].[national_assessments_nwea_2022] map_2022 on map_2022.[student_id] = stu.student_id
	LEFT JOIN [google].[master_roster_2022] mr on mr.student_id=stu.local_student_id
	LEFT JOIN [custom].[vw_map_anchor_2022] a ON a.[StudentID]=stu.local_student_id AND a.Discipline=map_2022.[nwea_2022_Discipline]

	WHERE 1=1
	AND sch.start_date > '2021-07-01' -- SY21-22
	AND sch.end_date < '2022-07-01'
	AND map_2022.[nwea_2022_Discipline] NOT IN ('Math K-12','Science K-12')
	--AND stu.local_student_id = '12532669'
	) map22


UNION ALL

--SY 22-23
	SELECT * FROM (

	SELECT DISTINCT
	 stu.local_student_id AS "Student ID"
	,stu.student_id AS "Illuminate Student ID"
	,CONCAT(stu.last_name,', ',stu.first_name) AS "Student Name"
	,stu.last_name AS "Last Name"
	,stu.first_name AS "First Name"
	,sch.site_id AS "School ID"
	,sch.site_name "School Name"
	,mr.homeroom AS "Homeroom"
	--,mr.learning_program AS "Learning Program"
	,sch.[start_date] AS "Entry Date"
	,sch.end_date AS "Exit Date"
	,CASE
		WHEN sch.end_date='2023-06-30' THEN 'Active'
		ELSE 'Inactive'
		END "Enrollment Status"
	,sta.grade_level_id AS "Grade Level ID"
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
    ,map_2023."nwea_2023_id" AS "ID"
	,map_2023.[nwea_2023_Discipline] AS "NWEA Subject"
	--,a.Discipline
	,map_2023.[nwea_2023_TermName] AS "TermName"
	,map_2023.[nwea_2023_TestRITScore] AS "TestRITScore"
	,map_2023.[nwea_2023_TestType] AS "TestType"
	,map_2023.[nwea_2023_TestName] AS "TestName"
	,map_2023.[nwea_2023_TestPercentile] AS "TestPercentile"
	--,map_2022.[nwea_2022_studentLastName] AS "StudentLastName"
	--,map_2022.[nwea_2022_studentFirstName] AS "StudentFirstName"
	,map_2023.[nwea_2023_TestStartDate] AS "TestStartDate"
	,map_2023.[nwea_2023_TestStandardError] AS "TestStandardError"
    ,CASE
		WHEN sta.grade_level_id IN (1,2) 
		AND map_2023.[nwea_2023_TestName] IN ('Growth: Math K-2 FL 2020', 'Growth: Reading K-2 FL 2020')
			THEN 1
        WHEN  sta.grade_level_id IN (3,4,5,6) 
        AND map_2023.[nwea_2023_TestName] IN ('Growth: Math 2-5 FL 2020', 'Growth: Reading 2-5 FL 2020')
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
        END TestAligned
	,RANK() OVER(		
		PARTITION BY map_2023.nwea_2023_localstudentid, map_2023.[nwea_2023_TermName], map_2023.[nwea_2023_Discipline]
		ORDER BY map_2023.[nwea_2023_TestStandardError] DESC) BestTest
	,a.[Fall TestRITScore]
	,a.[Fall TestPercentile]
	,map_2023.[nwea_2023_TypicalFallToWinterGrowth] AS "FW TypicalGrowth"
	,map_2023.[nwea_2023_TypicalFallToSpringGrowth] AS "FS TypicalGrowth"
	--,a.[FW Typical Growth Goal] AS "FW TypicalGrowth Goal"
	--,a.[FS Typical Growth Goal] AS "FW Typical Growth Goal"
	,'2023' AS "School Year"
	,map_2023.nwea_2023_testgradelevel
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
	AND map_2023.[nwea_2023_Discipline] NOT IN ('Math K-12','Science K-12')
	AND a.[Fall TestRitScore] IS NULL
	--AND stu.local_student_id = '12532669'
	--ORDER BY map_2023.[nwea_2023_Discipline] DESC
	) map23
GO


