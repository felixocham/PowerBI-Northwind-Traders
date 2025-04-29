CREATE VIEW orders AS
SELECT
	orderdate::date AS order_date,
	so.orderid,
	empid,
	custid,
	ROUND(SUM(unitprice * qty * (1 - discount)), 2) AS salesamount,
	freight,
	ROUND(SUM(unitprice * qty * (1 - discount)), 2) - freight AS netsales
FROM
	salesorder so
	LEFT JOIN orderdetail od ON so.orderid = od.orderid
GROUP BY
	so.orderid,
	custid,
	empid,
	orderdate::date,
	freight;

-- drop view orders
CREATE VIEW f_linesales AS
SELECT
	so.orderdate::date,
	o.orderid,
	o.productid,
	c.categoryid,
	o.unitprice,
	o.qty,
	o.discount,
	o.unitprice * 0.7 AS estimated_cogs
FROM
	public.orderdetail o
	LEFT JOIN public.product p ON o.productid = p.productid
	LEFT JOIN public.category c ON p.categoryid = c.categoryid
	LEFT JOIN public.salesorder so ON so.orderid = o.orderid;

--Dropping unnecesary views.
DROP VIEW order_details;

--changes made, include orderdate
DROP VIEW if EXISTS costing,
employee_details,
sales_by_region,
top_5_prod_by_cat,
reports_by_order,
prod_level cascade;

--renaming views for consistent naming.
ALTER VIEW dcustomer
RENAME TO d_customer;

ALTER VIEW demployee
RENAME TO d_employee;

--creating employee dimension table view
CREATE VIEW demployee AS
SELECT
	empid,
	title,
	CONCAT(titleofcourtesy, ' ', firstname, ' ', lastname) AS employee_name,
	birthdate::date AS birthdate,
	hiredate::date AS hiredate,
	city,
	region,
	country
FROM
	employee;

--creating a customer dimension table. Extra columns removed.
CREATE VIEW dcustomer AS
SELECT
	custid,
	companyname,
	contactname,
	contacttitle,
	city,
	region,
	country
FROM
	public.customer;

--creating a product category view.
CREATE VIEW d_category AS
SELECT
	categoryid,
	categoryname,
	description
FROM
	public.category;

--creating products dimension  table.

CREATE VIEW d_product AS
SELECT
	productid,
	productname,
	supplierid,
	categoryid,
	unitprice,
	unitsinstock,
	unitsonorder,
	reorderlevel
FROM
	public.product;

--Creating suppliers dimension table.
CREATE VIEW d_supplier AS
SELECT
	supplierid,
	companyname,
	contactname,
	city,
	country
FROM public.supplier;
