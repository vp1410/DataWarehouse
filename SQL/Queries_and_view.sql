# Query 1
# The number of orders that are not shipped within 10 days of order from PEC.

SELECT pd.division, COUNT(*) 'No. of Orders from PEC not shipped within 10 days' 
FROM tpc_sales_fact tsf
JOIN product_dimension pd USING(product_sk)
JOIN sales_date_dimension sd USING(salesdate_sk)
JOIN order_date_dimension od USING(orderDate_sk)
WHERE 
pd.division = 1
AND
DATEDIFF(sd.saleDate,orderDate) >= 10;

# Query 2
# The most frequent method of ordering a product from PEC.

SELECT jk.orderMethod, count(*) 'Frequency'
FROM tpc_sales_fact tsf JOIN junk_dimension jk USING (junk_sk)
JOIN product_dimension p USING (product_sk)
WHERE p.division = 1
GROUP BY jk.orderMethod
ORDER BY Frequency DESC
LIMIT 1;


# Query 3
# The average time in days needed to fulfill an order from PEC.

SELECT Division, AVG(a.diff) 'Average Time'
FROM
(SELECT pd.division 'Division', DATEDIFF(sd.saleDate,od.orderDate) 'diff'
FROM tpc_sales_fact tsf
JOIN product_dimension pd USING(product_sk)
JOIN sales_date_dimension sd USING(salesdate_sk)
JOIN order_date_dimension od USING(orderDate_sk)
WHERE pd.division = 1
GROUP BY pd.division) a;


# Query 4
# The average cost of shipping for a particular product by different methods.

SELECT a.Product, a.sm 'Shipping Method', a.asc1 'Average Shipping Cost'
FROM
(SELECT p.prodDesc 'Product', j.shipMethod 'sm', AVG(tsf.shipCost) 'asc1'
FROM tpc_sales_fact tsf 
JOIN product_dimension p USING(product_sk)
JOIN junk_dimension j USING(junk_sk)
GROUP BY p.prodDesc, j.shipMethod) a
ORDER BY a.asc1 DESC
LIMIT 10;


# Query 5
# The percentage of invoices that are COD.

SELECT a.pm 'Payment Method', a.totalcod 'Total COD Invoices', b.total 'Total Invoices', format(100*a.totalcod/b.total,2) "PCT"
FROM
(SELECT j.paymentMethod 'pm', COUNT(*) 'totalcod'
FROM tpc_sales_fact tsf 
JOIN junk_dimension j USING(junk_sk)
WHERE j.paymentMethod = "cod"
GROUP BY j.paymentMethod) a,
(SELECT COUNT(*) 'total'
FROM tpc_sales_fact) b;



# VIEW of gross_profits_saleYear by saleYear
# All reports should be able to report sales, costs 
# and gross profit (sales minus costs).

CREATE OR REPLACE VIEW gross_profits_saleYear AS
SELECT a.Year, a.Sales, a.Costs, (a.Sales-a.Costs) 'Gross Profit' 
FROM
(SELECT s.Sales_Year 'Year', SUM(tsf.amt) 'Sales', SUM(p.unitCost * tsf.qty) 'Costs'
FROM tpc_sales_fact tsf JOIN product_dimension p USING (product_sk)
JOIN sales_date_dimension s USING(salesDate_sk)
GROUP BY s.Sales_Year) a;

SELECT* FROM gross_profits_saleYear;























