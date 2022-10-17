USE [students]
GO

/****** Object:  View [custom].[vw_map_anchor_2023]    Script Date: 10/17/2022 12:24:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/******Notes on this view ******/
--
/******End of Notes******/

CREATE VIEW [custom].[vw_map_anchor_2023]
AS
SELECT 
	 --map_2023.[student_id] AS "ID"
	-- ,sta.entry_date
    -- ,sta.leave_date
	[nwea_2023_localStudentID] AS "StudentID"
	,[nwea_2023_testGradeLevel] AS "GradeLevel"
	,sta.[grade_level_id] AS "Grade Level ID"
	,[nwea_2023_TermName] AS "TermName"
	,[nwea_2023_Discipline] AS "Discipline"
	,[nwea_2023_TestName] AS "TestName"
	,[nwea_2023_TestStartDate] AS "TestStartDate"
	,[nwea_2023_TestRITScore] AS "Fall TestRITScore"
	,[nwea_2023_TestPercentile] AS "Fall TestPercentile"
	,[nwea_2023_TypicalFallToWinterGrowth] AS "FWTypicalGrowth"
	,[nwea_2023_TypicalFallToSpringGrowth] AS "FSTypicalGrowth"
	,[nwea_2023_TestRITScore] + [nwea_2023_TypicalFallToWinterGrowth] AS "FW Typical Growth Goal"
	,[nwea_2023_TestRITScore] + [nwea_2023_TypicalFallToSpringGrowth] AS "FS Typical Growth Goal"
	
  FROM [illuminate].[national_assessments_nwea_2023] map_2023
  INNER JOIN [illuminate].[matviews_student_term_aff] sta on sta.student_id = map_2023.student_id
	--AND sta.entry_date > '2022-07-31'
	--AND sta.leave_date IS NULL
  WHERE [nwea_2023_TermName] = 'Fall 2022-2023'
  --AND [nwea_2023_localStudentID] = '20048867'
	AND CASE
		WHEN sta.[grade_level_id] IN (1,2) 
		AND map_2023.[nwea_2023_TestName] IN ('Growth: Math K-2 FL 2020', 'Growth: Reading K-2 FL 2020')
			THEN 1
        WHEN  sta.[grade_level_id] IN (3,4,5,6) 
        AND map_2023.[nwea_2023_TestName] IN ('Growth: Math 2-5 FL 2020', 'Growth: Reading 2-5 FL 2020')
			THEN 1
		WHEN  sta.[grade_level_id] IN (7,8,9) 
        AND map_2023.[nwea_2023_TestName] IN ('Growth: Math 6+ FL 2014', 'Growth: Reading 6+ FL 2014 V2')
			THEN 1
		WHEN sta.[grade_level_id] IN (4,5,6) 
        AND map_2023.[nwea_2023_TestName] = 'Growth: Science 3-5 FL 2008'
			THEN 1
		WHEN  sta.[grade_level_id] IN (7,8,9) 
        AND map_2023.[nwea_2023_TestName] = 'Growth: Science 6-8 FL 2008'
			THEN 1
		ELSE 0
        END = 1
  --AND [nwea_2023_localStudentID] = '12532669'
  --ORDER BY [nwea_2023_localStudentID], grade_level_id, Discipline, TestName
--GO


GO


