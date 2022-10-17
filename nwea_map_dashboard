--/**** NOTES ON VIEW ****/
----This view is pulled directly to the MAP dashboard with/ the MAP goals view.
----It unions all NWEA tables (imported from Illuminate) together in to a single "tall" view.
----Is is queried in the view:  [dashboards].[vw_nwea_map] and joined with the dashboard.map_goals to populate the map dashboard" 
----ANNUAL UPDATE REQUIRED: Add new SY table to the end of the union.
--/******End of Notes******/
--ALTER VIEW [dashboards].[vw_nwea_map_2023]
--AS
SELECT  mu.[Student ID]
      ,mu.[Illuminate Student ID]
      ,mu.[Student Name]
      ,mu.[Last Name]
      ,mu.[First Name]
      ,mu.[School ID]
      ,mu.[School Name]
	  ,fr.grade AS "Current Grade Level"
      ,mu.[Homeroom]
      ,mu.[Entry Date] AS "Entry Date"
      ,mu.[Exit Date] AS "Exit Date"
	  ,mu.[School Year]
      ,mu.[Enrollment Status]
      ,mu.[Grade Level ID]
      ,mu.[Grade Level] AS "Enrolled Grade"
      ,mu.[ID]
      ,mu.[Discipline]
      ,mu.[TermName]
      ,mu.[TestRITScore] AS "TestRITScore"
      ,mu.[TestType]
      ,mu.[TestName]
      ,mu.[TestPercentile]
      --,[StudentLastName]
      --,[StudentFirstName]
      ,mu.[TestStartDate]
      ,mu.[TestStandardError]
      ,mu.[TestAligned]
      ,mu.[BestTest]
      ,mu.[Fall TestRITScore]
      ,mu.[Fall Percentile]
      ,mu.[FW TypicalGrowth]
      ,mu.[FS TypicalGrowth]
     
  FROM [students].[custom].[vw_map_union] mu
  LEFT JOIN [focus].[foundation_report_2023] fr ON fr.student_id = mu.[Student ID]
	AND fr.enrollment_start_date = [Entry Date]
WHERE fr.grade IS NOT NULL
	--AND fr.enrollment_drop_date = [Exit Date]
 -- WHERE fr.enrollment_drop_date = [Exit Date]
	--OR fr.enrollment_drop_date = ''
  --[Student ID] = '10976314' --[Last Name] = 'Newkirk' --AND Discipline = 'Mathematics' --AND TermName LIKE 'Fall%'--AND [School Year ] = '2021'
  ORDER BY fr.grade  DESC
  --Discipline
  --GROUP BY 
  --[Student ID]
  --    ,[Illuminate Student ID]
  --    ,[Student Name]
  --    ,[Last Name]
  --    ,[First Name]
  --    ,[School ID]
  --    ,[School Name]
	 -- ,fr.grade
  --    ,[Homeroom]
	 ----,[Entry Date]
	 ----,[Exit Date]
  --    ,[School Year]
  --    ,[Enrollment Status]
  --    ,[Grade Level ID]
  --    ,[Grade Level]
  --    ,[ID]
  --    ,[Discipline]
  --    ,[TermName]
  --    ,[TestRITScore] 
  --    ,[TestType]
  --    ,[TestName]
  --    ,[TestPercentile]
  --    --,[StudentLastName]
  --    --,[StudentFirstName]
  --    ,[TestStartDate]
  --    ,[TestStandardError]
  --    ,[TestAligned]
  --    ,[BestTest]
  --    ,[Fall TestRITScore]
  --    ,[Fall Percentile]
  --    ,[FW TypicalGrowth]
  --    ,[FS TypicalGrowth]
GO


