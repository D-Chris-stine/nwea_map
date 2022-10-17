USE [students]
GO

/****** Object:  View [custom].[vw_map_goals]    Script Date: 10/16/2022 5:37:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/******Notes on this view ******/
--This view hardcodes typical and tiered goals so they can be used in dashboards without filter issues."
-- It is used in conjunction with the view [dashboards].[vw_nwea_map] to populate the MAP dashboard.
/******End of Notes******/

ALTER VIEW [custom].[vw_map_goals]
AS
SELECT DISTINCT
	 stu.local_student_id AS "Student ID"
	,sta.grade_level_id
	,sch.site_name
	,map_2023.[nwea_2023_Discipline] AS "subject"
	,map_2023.[nwea_2023_TestPercentile] AS "fall_percentile"
	,map_2023.[nwea_2023_TestRITScore] AS "fall_rit"
	,map_2023.[nwea_2023_TypicalFallToWinterGrowth] AS "FWTypicalGrowth"
	,CASE 
		WHEN sta.grade_level_id IN (1,2,3,4)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 1 AND 50
			THEN ROUND((map_2023.[nwea_2023_TypicalFallToWinterGrowth]*1.5),0)
		
		WHEN sta.grade_level_id IN (1,2,3,4)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 51 AND 75
			THEN ROUND((map_2023.[nwea_2023_TypicalFallToWinterGrowth]*1.25),0)
		
		WHEN sta.grade_level_id IN (1,2,3,4)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 76 AND 100
			THEN ROUND((map_2023.[nwea_2023_TypicalFallToWinterGrowth]*1),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 1 AND 25
			THEN ROUND((map_2023.[nwea_2023_TypicalFallToWinterGrowth]*2),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 26 AND 50
			THEN ROUND((map_2023.[nwea_2023_TypicalFallToWinterGrowth]*1.75),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 51 AND 75 
			THEN ROUND((map_2023.[nwea_2023_TypicalFallToWinterGrowth]*1.5),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 76 AND 100  
			THEN ROUND((map_2023.[nwea_2023_TypicalFallToWinterGrowth]*1),0)
		
		ELSE NULL
		END AS "FW Tiered Growth"
	
	,map_2023.[nwea_2023_TestRITScore] + map_2023.[nwea_2023_TypicalFallToWinterGrowth] AS "FW Typical Growth Goal"

	,CASE 
		WHEN sta.grade_level_id IN (1,2,3,4)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 1 AND 50
			THEN ROUND(((map_2023.[nwea_2023_TypicalFallToWinterGrowth]*1.5)+map_2023.[nwea_2023_TestRITScore]),0)
		
		WHEN sta.grade_level_id IN (1,2,3,4)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 51 AND 75
			THEN ROUND(((map_2023.[nwea_2023_TypicalFallToWinterGrowth]*1.25)+map_2023.nwea_2023_TestRITScore),0)
		
		WHEN sta.grade_level_id IN (1,2,3,4)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 76 AND 100
			THEN ROUND(((map_2023.[nwea_2023_TypicalFallToWinterGrowth]*1)+map_2023.[nwea_2023_TestRITScore]),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 1 AND 25
			THEN ROUND(((map_2023.[nwea_2023_TypicalFallToWinterGrowth]*2)+map_2023.[nwea_2023_TestRITScore]),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 26 AND 50
			THEN ROUND(((map_2023.[nwea_2023_TypicalFallToWinterGrowth]*1.75)+map_2023.[nwea_2023_TestRITScore]),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 51 AND 75 
			THEN ROUND(((map_2023.[nwea_2023_TypicalFallToWinterGrowth]*1.5)+map_2023.[nwea_2023_TestRITScore]),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 76 AND 100  
			THEN ROUND(((map_2023.[nwea_2023_TypicalFallToWinterGrowth]*1)+map_2023.[nwea_2023_TestRITScore]),0)
		
		ELSE NULL
		END AS "FW Tiered Growth Goal"
	
	,map_2023.[nwea_2023_TypicalFallToSpringGrowth] AS "FSTypicalGrowth"

	,CASE 
		WHEN sta.grade_level_id IN (1,2,3,4)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 1 AND 50
			THEN ROUND((map_2023.[nwea_2023_TypicalFallToSpringGrowth]*1.5),0)
		
		WHEN sta.grade_level_id IN (1,2,3,4)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 51 AND 75
			THEN ROUND((map_2023.[nwea_2023_TypicalFallToSpringGrowth]*1.25),0)
		
		WHEN sta.grade_level_id IN (1,2,3,4)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 76 AND 100
			THEN ROUND((map_2023.[nwea_2023_TypicalFallToSpringGrowth]*1),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 1 AND 25
			THEN ROUND((map_2023.[nwea_2023_TypicalFallToSpringGrowth]*2),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 26 AND 50
			THEN ROUND((map_2023.[nwea_2023_TypicalFallToSpringGrowth]*1.75),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 51 AND 75 
			THEN ROUND((map_2023.[nwea_2023_TypicalFallToSpringGrowth]*1.5),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 76 AND 100  
			THEN ROUND((map_2023.[nwea_2023_TypicalFallToSpringGrowth]*1),0)
		
		ELSE NULL
		END AS "FS Tiered Growth"
	
	,map_2023.[nwea_2023_TestRITScore] + map_2023.[nwea_2023_TypicalFallToSpringGrowth] AS  "FS Typical Growth Goal"
	,CASE 
		WHEN sta.grade_level_id IN (1,2,3,4)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 1 AND 50
			THEN ROUND(((map_2023.[nwea_2023_TypicalFallToSpringGrowth]*1.5)+map_2023.[nwea_2023_TestRITScore]),0)
		
		WHEN sta.grade_level_id IN (1,2,3,4)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 51 AND 75
			THEN ROUND(((map_2023.[nwea_2023_TypicalFallToSpringGrowth]*1.25)+map_2023.nwea_2023_TestRITScore),0)
		
		WHEN sta.grade_level_id IN (1,2,3,4)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 76 AND 100
			THEN ROUND(((map_2023.[nwea_2023_TypicalFallToSpringGrowth]*1)+map_2023.[nwea_2023_TestRITScore]),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 1 AND 25
			THEN ROUND(((map_2023.[nwea_2023_TypicalFallToSpringGrowth]*2)+map_2023.[nwea_2023_TestRITScore]),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 26 AND 50
			THEN ROUND(((map_2023.[nwea_2023_TypicalFallToSpringGrowth]*1.75)+map_2023.[nwea_2023_TestRITScore]),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 51 AND 75 
			THEN ROUND(((map_2023.[nwea_2023_TypicalFallToSpringGrowth]*1.5)+map_2023.[nwea_2023_TestRITScore]),0)
		
		WHEN sta.grade_level_id IN (5,6,7,8,9)	AND map_2023.[nwea_2023_TestPercentile] BETWEEN 76 AND 100  
			THEN ROUND(((map_2023.[nwea_2023_TypicalFallToSpringGrowth]*1)+map_2023.[nwea_2023_TestRITScore]),0)
		
		ELSE NULL
		END AS "FS Tiered Growth Goal"
	
	,RANK() OVER(		
		PARTITION BY map_2023.nwea_2023_localstudentid, map_2023.[nwea_2023_TermName], map_2023.[nwea_2023_Discipline]
		ORDER BY map_2023.[nwea_2023_TestStandardError] DESC) BestTest
	
	FROM [illuminate].[public_students] stu
	INNER JOIN [custom].[vw_illuminate_student_site_aff] sch ON sch.student_id = stu.student_id
	INNER JOIN [illuminate].[matviews_student_term_aff] sta ON sch.student_id=sta.student_id
	  AND sta.entry_date=sch.start_date
	  AND sta.leave_date IS NULL
	LEFT JOIN [illuminate].[national_assessments_nwea_2023] map_2023 on map_2023.[student_id] = stu.student_id

	WHERE 1=1
	AND sch.start_date > '2022-07-01' -- SY22-23
	AND sch.end_date < '2023-07-01'
	AND map_2023.[nwea_2023_TermName] = 'Fall 2022-2023'
	AND map_2023.[nwea_2023_Discipline] NOT IN ('Math K-12','Science K-12')
	AND CASE
		WHEN sta.grade_level_id IN (1,2) 
		AND map_2023.[nwea_2023_TestName] IN ('Growth: Math K-2 FL 2020', 'Growth: Reading K-2 FL 2020')
			THEN 1
        WHEN  sta.grade_level_id IN (3,4,5,6) 
        AND map_2023.[nwea_2023_TestName] IN ('Growth: Math 2-5 FL 2020', 'Growth: Reading 2-5 FL 2020')
			THEN 1
		WHEN  sta.grade_level_id IN (7,8,9) 
        AND map_2023.[nwea_2023_TestName] IN ('Growth: Math 6+ FL 2020', 'Growth: Reading 6+ FL 2020 V2')
			THEN 1
		WHEN  sta.grade_level_id IN (4,5,6) 
        AND map_2023.[nwea_2023_TestName] = 'Growth: Science 3-5 FL 2008'
			THEN 1
		WHEN  sta.grade_level_id IN (7,8,9) 
        AND map_2023.[nwea_2023_TestName] = 'Growth: Science 6-8 FL 2008'
			THEN 1
		ELSE 0
        END = 1

	--ORDER BY [Student ID]
GO


