# run below queries before running SCDs 1 and 2

TRUNCATE table salesorders_02_scds.product_dimension;

INSERT salesorders_02_scds.product_dimension(product_sk, prodId_nk, division, 
	prodDesc, price1, price2, unitCost, prodTypeId, typeDesc, buid,
	buName, buAbbrev)
SELECT * FROM salesorders_02_2191.product_dimension;


# run below queries before running SCD 6


TRUNCATE table salesorders_02_scds.customer_dimension;

INSERT salesorders_02_scds.customer_dimension(customer_sk, custId_nk, division,
	name, suite, department, address, city, stateName, state, zip,
	custtypeId, typeName)
SELECT customer_sk, custId_nk, division,
	name, suite, department, address, city, stateName, state, zip,
	custtypeId, typeName
FROM salesorders_02_2191.customer_dimension;

UPDATE salesorders_02_scds.customer_dimension
SET name_current = name,
address_current= address;