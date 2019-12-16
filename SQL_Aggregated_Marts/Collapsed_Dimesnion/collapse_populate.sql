-- use db
USE tpc_collapsed


-- populate the table
INSERT INTO tpc_collapsed.yearlycost_collapsed(salesyear,divisionname,suppliername,amt,qty,shipcost)
SELECT Sales_Year , CASE WHEN division = 1 THEN "PEC"
	WHEN division = 2 THEN "TPC East"
	WHEN division = 3 THEN "TPC West"
	END AS "DivisionName" , SupplierName, sum(amt) 'Yearly cost', sum(qty), sum(shipcost)
FROM salesorders_02_2191.tpc_sales_fact f JOIN salesorders_02_2191.sales_date_dimension sd
USING (salesDate_sk) JOIN salesorders_02_2191.supplier_dimension ss USING (supplier_Sk)
WHERE division IS NOT NULL AND SupplierName IS NOT NULL
GROUP BY sd.sales_year,ss.division,ss.suppliername ORDER BY 1,2,3;