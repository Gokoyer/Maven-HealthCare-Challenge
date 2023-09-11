--- ON RESPONSES
SELECT 
	*
FROM 
	[dbo].[responses]

--To remove all the null values in Response Rate(%)
DELETE FROM [dbo].[responses]
WHERE [Response Rate (%)] is NULL

--For complete Surveys column, let assume that all the 'FEWER THAN 50' surveys are 49
SELECT REPLACE ([Completed Surveys], 'FEWER THAN 50', 49)
FROM [dbo].[responses]

--To replace 'FEWER THAN 50' by 48 in [Completed Surveys]
UPDATE [dbo].[responses]
SET [Completed Surveys] = REPLACE([Completed Surveys], 49, 'FEWER THAN 50')


--Response rate from Top with all the attributes
SELECT
	[Release Period],
    [State],
	[Facility ID],
	[Completed Surveys],
    [Response Rate (%)],
	ROW_NUMBER() OVER (PARTITION BY [Response Rate (%)] ORDER BY [Release Period] DESC) AS Response
FROM [dbo].[responses]
ORDER BY [Response Rate (%)] DESC

SELECT [Release Period],
    [State],
    [Response Rate (%)],
	RANK() OVER (PARTITION BY AVG( [Response Rate (%)]) ORDER BY [Release Period]) AS Response
FROM [dbo].[responses]
GROUP BY [Release Period], [State],  [Response Rate (%)]
ORDER BY Response DESC

--Response rate by State
SELECT 
    [State],
	ROUND(AVG([Response Rate (%)]), 2) AS Response_Rate
FROM [dbo].[responses]
GROUP BY [State]
ORDER BY Response_Rate DESC

--Reponse Rate By Release Period
SELECT 
    [Release Period],
	ROUND(AVG([Response Rate (%)]), 2) AS Response_Rate
FROM [dbo].[responses]
GROUP BY [Release Period]
ORDER BY Response_Rate DESC


SELECT 
	[Release Period],
	ROW_NUMBER () OVER(PARTITION BY AVG([Response Rate (%)]) ORDER BY [Release Period]) AS Response
FROM [dbo].[responses]
GROUP BY [State], [Release Period] 
ORDER BY [State]



