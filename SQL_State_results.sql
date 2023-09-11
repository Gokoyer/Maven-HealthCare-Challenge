---State Results Datasets
SELECT 
	*
FROM
	[dbo].[state_results]

--Data Cleaning-----------------------------------------------
--Check for null values in the dataset
SELECT
   *
FROM
   [dbo].[state_results]
WHERE [Release Period] is NULL
	OR [State] is NULL
	OR [Measure ID] is NULL
	OR [Bottom-box Percentage] is NULL
	OR [Middle-box Percentage] is NULL
	OR [Top-box Percentage] is NULL

--To check for duplicates
WITH CTE ([Release Period],
		[State],
		[Measure ID],
		[Bottom-box Percentage],
		[Middle-box Percentage],
		[Top-box Percentage],
		duplicatecount)
AS(SELECT [Release Period],
          [State],
		  [Measure ID],
		  [Bottom-box Percentage],
		  [Middle-box Percentage],
		  [Top-box Percentage],
          ROW_NUMBER() OVER(PARTITION BY [Release Period],
                                  [State],
								  [Measure ID],
								  [Bottom-box Percentage],
								  [Middle-box Percentage],
								  [Top-box Percentage]
          ORDER BY [Release Period]) AS duplicatecount
  FROM [dbo].[state_results])
SELECT *
FROM CTE;

--To delete duplicates if there is any

WITH CTE ([Release Period],
          [State],
          [Measure ID],
	      [Bottom-box Percentage],
	      [Middle-box Percentage],
	      [Top-box Percentage],
	      duplicatecount)
AS(SELECT [Release Period],
          [State],
		  [Measure ID],
		  [Bottom-box Percentage],
		  [Middle-box Percentage],
		  [Top-box Percentage],
          ROW_NUMBER() OVER(PARTITION BY [Release Period],
                                  [State],
								  [Measure ID],
								  [Bottom-box Percentage],
								  [Middle-box Percentage],
								  [Top-box Percentage]
          ORDER BY [Release Period]) AS duplicatecount
  FROM [dbo].[state_results])
DELETE FROM CTE
WHERE DuplicateCount > 1

--BASED ON MEASURE ID FOR BOTTOM-BOX RESPONSES
SELECT
   [Release Period],
   [State],
   [Measure ID],
   [Bottom-box Percentage],
   ROW_NUMBER() OVER (PARTITION BY [Measure ID] ORDER BY [Bottom-box Percentage] DESC) AS BottomBoxResponses
FROM [dbo].[state_results]

--FILTERING THE HIGHEST BOTTOM-BOX RESPONSES
SELECT 
     [Release Period],
	 [State],
	 [Measure ID],
	 [Bottom-box Percentage] 
	 FROM
	(
	SELECT
		[Release Period],
		[State],
		[Measure ID],
		[Bottom-box Percentage],
		ROW_NUMBER() OVER (PARTITION BY [Measure ID] ORDER BY [Bottom-box Percentage] DESC) AS BottomBoxResponses
	FROM [dbo].[state_results]
	) S
 WHERE 
   BottomBoxResponses = 1 
   OR BottomBoxResponses = 2 
   OR BottomBoxResponses = 3

--BASED ON MEASURE ID FOR MIDDLE-BOX RESPONSES
SELECT
   [Release Period],
   [State],
   [Measure ID],
   [Middle-box Percentage],
   ROW_NUMBER() OVER (PARTITION BY [Measure ID] ORDER BY [Middle-box Percentage] DESC) AS MiddleBoxResponses
FROM [dbo].[state_results]

--FILTERING THE HIGHEST MIDDLE-BOX RESPONSES
SELECT 
     [Release Period],
	 [State],
	 [Measure ID],
	 [Middle-box Percentage] 
	 FROM
	(
	SELECT
		[Release Period],
		[State],
		[Measure ID],
		[Middle-box Percentage],
		ROW_NUMBER() OVER (PARTITION BY [Measure ID] ORDER BY [Middle-box Percentage] DESC) AS MiddleBoxResponses
	FROM [dbo].[state_results]
	) S
 WHERE 
   MiddleBoxResponses = 1 
   OR MiddleBoxResponses = 2 
   OR MiddleBoxResponses = 3



--BASED ON MEASURE ID FOR TOP-BOX RESPONSES
SELECT
   [Release Period],
   [State],
   [Measure ID],
   [Top-box Percentage],
   ROW_NUMBER() OVER (PARTITION BY [Measure ID] ORDER BY [Top-box Percentage] DESC) AS TopBoxResponses
FROM [dbo].[state_results]

--FILTERING THE HIGHEST TOP-BOX RESPONSES
SELECT 
	[Release Period],
	[State],
	[Measure ID],
	[Top-box Percentage] 
	FROM
	(
	SELECT
		[Release Period],
		[State],
		[Measure ID],
		[Top-box Percentage],
		ROW_NUMBER() OVER (PARTITION BY [Measure ID] ORDER BY [Top-box Percentage] DESC) AS TopBoxResponses
	FROM [dbo].[state_results]
	) S
WHERE 
	TopBoxResponses = 1 
	OR TopBoxResponses = 2 
	OR TopBoxResponses = 3


---State Results Datasets
SELECT 
   *
FROM
	[dbo].[state_results]

--Overall performance by State by Bottom Box Responses from TOP
SELECT 
	[State],
	ROUND(AVG([Bottom-box Percentage]), 2) AS AVGBottomBox
FROM [dbo].[state_results]
GROUP BY
	[State]
ORDER BY
	AVGBottomBox DESC

--Overall performance by State by Middle Box Responses from Top
SELECT 
	[State],
	ROUND(AVG([Middle-box Percentage]), 2) AS AVGMiddleBox
FROM [dbo].[state_results]
GROUP BY
	[State]
ORDER BY
	AVGMiddleBox DESC

--Overall performance by State by Top Box Responses from Top
SELECT 
	[State],
	ROUND(AVG([Top-box Percentage]), 2) AS AVGTopBoxState
FROM [dbo].[state_results]
GROUP BY
   [State]
ORDER BY
	AVGTopBoxState DESC

---State Results Datasets
SELECT 
	[Release Period],
	[State],
	[Measure ID],
	[Bottom-box Percentage],
	[Middle-box Percentage],
	[Top-box Percentage]
FROM
   [dbo].[state_results]
ORDER BY [Measure ID]

