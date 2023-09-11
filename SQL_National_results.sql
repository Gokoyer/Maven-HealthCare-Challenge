--Data Cleaning
SELECT
   *
FROM 
   national_results

--Check for null values in the dataset
SELECT *
FROM national_results
WHERE [Release Period] is NULL
   OR [Measure ID] is NULL
   OR [Bottom-box Percentage] is NULL
   OR [Middle-box Percentage] is NULL
   OR [Top-box Percentage] is NULL

--To check for duplicates
WITH CTE([Release Period], 
    [Measure ID], 
    [Bottom-box Percentage],
	[Middle-box Percentage],
    [Top-box Percentage],
    duplicatecount)
AS (SELECT [Release Period], 
           [Measure ID], 
           [Bottom-box Percentage],
	       [Middle-box Percentage],
           [Top-box Percentage],
           ROW_NUMBER() OVER(PARTITION BY [Release Period], 
                                          [Measure ID], 
                                          [Bottom-box Percentage],
	                                      [Middle-box Percentage],
                                          [Top-box Percentage]
           ORDER BY [Release Period]) AS DuplicateCount
    FROM [dbo].[national_results])
SELECT *
FROM CTE;

--To delete duplicates if there is any
WITH CTE([Release Period], 
    [Measure ID], 
    [Bottom-box Percentage],
	[Middle-box Percentage],
    [Top-box Percentage],
    duplicatecount)
AS (SELECT [Release Period], 
           [Measure ID], 
           [Bottom-box Percentage],
	       [Middle-box Percentage],
           [Top-box Percentage],
           ROW_NUMBER() OVER(PARTITION BY [Release Period], 
                                          [Measure ID], 
                                          [Bottom-box Percentage],
	                                      [Middle-box Percentage],
                                          [Top-box Percentage]
           ORDER BY [Release Period]) AS DuplicateCount
    FROM [dbo].[national_results])
DELETE FROM CTE
WHERE DuplicateCount > 1

--ROW_NUMBER FOR BOTTOM-BOX RESPONSES
SELECT
   [Release Period],
   [Measure ID],
   [Bottom-box Percentage],
   RANK() OVER (ORDER BY [Bottom-box Percentage] DESC) AS BottomBoxRank
FROM [dbo].[national_results]

--ROW_NUMBER AND RANK WORK SAME WAY
SELECT
   [Release Period],
   [Measure ID],
   [Bottom-box Percentage],
   ROW_NUMBER() OVER (ORDER BY [Bottom-box Percentage] DESC) AS BottomBoxRank
FROM [dbo].[national_results]

--ROW_NUMBER FOR MIDDLE-BOX RESPONSES
SELECT
   [Release Period],
   [Measure ID],
   [Middle-box Percentage],
   RANK() OVER (ORDER BY [Middle-box Percentage] DESC) AS MiddleBoxRank
FROM [dbo].[national_results]

--ROW_NUMBER FOR TOP-BOX RESPONSES
SELECT
   [Release Period],
   [Measure ID],
   [Top-box Percentage],
   RANK() OVER (ORDER BY [Top-box Percentage] DESC) AS TopBoxRank
FROM [dbo].[national_results]

--ROW_NUMBER FOR BOTTOM-BOX, MIDDLE-BOX AND TOP-BOX RESPONSES
SELECT
   [Release Period],
   [Measure ID],
   [Bottom-box Percentage],
   [Middle-box Percentage],
   [Top-box Percentage],
   RANK() OVER (ORDER BY [Bottom-box Percentage] DESC) AS BottomBoxRank,
   RANK() OVER (ORDER BY [Middle-box Percentage] DESC) AS MiddleBoxRank,
   RANK() OVER (ORDER BY [Top-box Percentage] DESC) AS TopBoxRank
FROM [dbo].[national_results]

--BASED ON MEASURE ID FOR BOTTOM-BOX RESPONSES
SELECT
   [Release Period],
   [Measure ID],
   [Bottom-box Percentage],
   ROW_NUMBER() OVER (PARTITION BY [Measure ID] ORDER BY [Bottom-box Percentage] DESC) AS BottomBoxResponses
FROM [dbo].[national_results]

--FILTERING THE HIGHEST BOTTOM-BOX RESPONSES
SELECT 
     [Release Period],
	 [Measure ID],
	 [Bottom-box Percentage] 
	 FROM
	(
	SELECT
		[Release Period],
		[Measure ID],
		[Bottom-box Percentage],
		ROW_NUMBER() OVER (PARTITION BY [Measure ID] ORDER BY [Bottom-box Percentage] DESC) AS BottomBoxResponses
	FROM [dbo].[national_results]
	) S
WHERE BottomBoxResponses = 1

--BASED ON MEASURE ID FOR MIDDLE-BOX RESPONSES
SELECT
   [Release Period],
   [Measure ID],
   [Middle-box Percentage],
   ROW_NUMBER() OVER (PARTITION BY [Measure ID] ORDER BY [Middle-box Percentage] DESC) AS MiddleBoxResponses
FROM [dbo].[national_results]

--FILTERING THE HIGHEST MIDDLE-BOX RESPONSES
SELECT 
   [Release Period],
   [Measure ID],
   [Middle-box Percentage]
FROM
   (
    SELECT
	   [Release Period],
	   [Measure ID],
	   [Middle-box Percentage],
	   ROW_NUMBER() OVER (PARTITION BY [Measure ID] ORDER BY [Middle-box Percentage] DESC) AS MiddleBoxResponses
	FROM [dbo].[national_results]
	) S
WHERE MiddleBoxResponses = 1

--BASED ON MEASURE ID FOR TOP-BOX RESPONSES
SELECT
   [Release Period],
   [Measure ID],
   [Top-box Percentage],
   ROW_NUMBER() OVER (PARTITION BY [Measure ID] ORDER BY [Top-box Percentage] DESC) AS TopBoxResponses
FROM [dbo].[national_results]

--FILTERING THE HIGHEST TOP-BOX RESPONSES
SELECT 
   [Release Period],
   [Measure ID],
   [Top-box Percentage]
FROM
   (
    SELECT
	   [Release Period],
	   [Measure ID],
	   [Top-box Percentage],
	   ROW_NUMBER() OVER (PARTITION BY [Measure ID] ORDER BY [Top-box Percentage] DESC) AS TopBoxResponses
	FROM [dbo].[national_results]
	) S
WHERE TopBoxResponses = 1