
DROP VIEW IF EXISTS f_linesales;

CREATE OR REPLACE VIEW f_linesales AS  
SELECT 
	so.orderid,
	so.orderdate::date, 
	so.requireddate::date,
	so.shippeddate::date,
	so.shipperid,
	so.shipname,
	freight,
	od.productid,
	od.unitprice,
	od.unitprice * 0.7 as standard_cost,
	od.qty,
	od.discount
FROM public.salesorder as so
left join public.orderdetail as od on so.orderid = od.orderid;

select 
	distinct(shipcity)
FROM public.salesorder;

CREATE OR REPLACE VIEW shipping AS 
SELECT DISTINCT
	shipperid,
	shipname,
	shipcity,
	shipregion,
	shipcountry
FROM public.salesorder;

DROP VIEW IF EXISTS orders;

CREATE OR REPLACE VIEW orders AS 
select 
	orderid,
	freight
FROM public.salesorder;