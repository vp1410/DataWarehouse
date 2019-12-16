-- Query 1 

SELECT a.DivisionName, a.SupplierName, a.TotalCost, COUNT(b.TotalCost) 'Rank'
FROM (SELECT DivisionName,SupplierName, sum(amt) 'TotalCost'
		FROM yearlycost_collapsed y
		GROUP BY y.DivisionName) a
	JOIN 
	(SELECT DivisionName,SupplierName, sum(amt) 'TotalCost'
		FROM yearlycost_collapsed z
		GROUP BY z.DivisionName) b
ON a.TotalCost <= b.TotalCost
GROUP BY a.DivisionName
ORDER BY 4;

-- Query 2
SELECT a.Divisionname, a.SalesYear, a.YearlyCost, b.SalesYear, b.YearlyCost
FROM (SELECT divisionName,SalesYear, sum(amt) AS 'YearlyCost'
		FROM yearlycost_collapsed y
		WHERE divisionName = 'PEC'
		GROUP BY y.SalesYear)a
	JOIN 
	(SELECT divisionName,SalesYear, sum(amt) AS 'YearlyCost'
		FROM yearlycost_collapsed y
		WHERE divisionName = 'PEC'
		GROUP BY y.SalesYear)b
		ON a.SalesYear < b.SalesYear
		ORDER BY a.SalesYear,b.SalesYear;
	