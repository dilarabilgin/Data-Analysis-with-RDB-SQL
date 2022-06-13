
-------------------------------------------- EXISTS AND NOT EXISTS --------------------------------------------

-- Apple - Pre-Owned iPad 3 - 32GB - White ürünün hiç sipariş verilmediği eyaletleri bulunuz.
-- Eyalet müşterilerin ikamet adreslerinden alınacaktır.

-- Asagidaki ürünü satin alan müsterilerin eyalet listesi


SELECT  distinct C.state
FROM    product.product P, 
        sale.order_item I, 
        sale.orders O, 
        sale.customer C
WHERE   P.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' AND 
        P.product_id = I.product_id AND
        I.order_id = O.order_id AND
        O.customer_id = C.customer_id


SELECT  distinct [state]
FROM    sale.customer C2
WHERE   NOT EXISTS (
        SELECT  distinct C.state
        FROM    product.product P, 
        sale.order_item I, 
        sale.orders O, 
        sale.customer C
        WHERE   P.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' AND 
        P.product_id = I.product_id AND
        I.order_id = O.order_id AND
        O.customer_id = C.customer_id AND
        C2.state = C.state
    )

-- Burkes Outlet mağaza stoğunda bulunmayıp,
-- Davi techno mağazasında bulunan ürünlerin stok bilgilerini döndüren bir sorgu yazın. 

SELECT      PC.product_id, PC.store_id, PC.quantity
FROM        product.product P,
            product.stock PC, 
            sale.store SS
WHERE       PC.store_id = SS.store_id AND 
            SS.store_name = 'Davi techno Retail' AND
NOT EXISTS  (
            SELECT DISTINCT A.product_id, A.store_id, A.quantity
            FROM product.stock A, sale.store B, product.product P
            WHERE A.store_id = B.store_id AND  
            B.store_name = 'Burkes Outlet' AND 
            PC.product_id = A.product_id AND 
            A.quantity > 0)



-- Brukes Outlet storedan alınıp The BFLO Store mağazasından hiç alınmayan ürün var mı?
-- Varsa bu ürünler nelerdir?
-- Ürünlerin satış bilgileri istenmiyor, sadece ürün listesi isteniyor.

SELECT P.product_name, p.list_price, p.model_year
FROM product.product P
WHERE NOT EXISTS (
		SELECt	I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'The BFLO Store'
				and P.product_id = I.product_id)
	AND
	EXISTS (
		SELECt	I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'Burkes Outlet'
				and P.product_id = I.product_id)
;

-- Alternative

SELECT	distinct I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'Burkes Outlet'
except
		SELECt	distinct I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'The BFLO Store'
;


-------------------------------------------- CTE's --------------------------------------------

-- Common Table Expression 

-- Jerald Berray isimli müşterinin son siparişinden önce sipariş vermiş ve Austin şehrinde ikamet eden müşterileri listeleyin.

WITH tbl AS (
SELECT  max(B.order_Date) JeraldsLastOrderDate
FROM    sale.customer A, sale.orders B
WHERE   A.first_name = 'Jerald' and a.last_name = 'Berray'
        AND A.customer_id = B.customer_id
)
SELECT  distinct A.first_name, A.last_name
FROM    sale.customer A, 
        sale.orders B,
        tbl C
WHERE   A.city = 'Austin' and A.customer_id = B.customer_id AND
        B.order_date < C.JeraldsLastOrderDate
;

-- Herbir markanın satıldığı en son tarihi bir CTE sorgusunda,
-- Yine herbir markaya ait kaç farklı ürün bulunduğunu da ayrı bir CTE sorgusunda tanımlayınız.
-- Bu sorguları kullanarak  Logitech ve Sony markalarına ait son satış tarihini ve toplam ürün sayısını (product tablosundaki) aynı sql sorgusunda döndürünüz.

with tbl as(
	select	br.brand_id, br.brand_name, max(so.order_date) LastOrderDate
	from	sale.orders so, sale.order_item soi, product.product pr, product.brand br
	where	so.order_id=soi.order_id and
			soi.product_id = pr.product_id and
			pr.brand_id = br.brand_id
	group by br.brand_id, br.brand_name
),
tbl2 as(
	select	pb.brand_id, pb.brand_name, count(*) count_product
	from	product.brand pb, product.product pp
	where	pb.brand_id=pp.brand_id
	group by pb.brand_id, pb.brand_name
)
select	*
from	tbl a, tbl2 b
where	a.brand_id=b.brand_id and
		a.brand_name in ('Logitech', 'Sony')
;

-------------------------------------------- Recursice CTE --------------------------------------------

-- 0'dan 9'a kadar herbir rakam bir satırda olacak şekide bir tablo oluşturun.

with cte AS (
	select 0 rakam
	union all
	select rakam + 1
	from cte
	where rakam < 9
)

select * from cte;

-- 2020 ocak ayının herbir tarihi bir satır olacak şekilde 31 satırlı bir tablo oluşturunuz.

with cte AS (
	select cast('2020-01-01' as date) AS gun
	union all
	select DATEADD(DAY,1,gun)
	from cte
	where gun < EOMONTH('2020-01-01')
)
select * from cte;

-- 2020 ocak ayının herbir tarihi bir satır olacak şekilde 31 satırlı bir tablo oluşturunuz.

with ocak as (
	select	cast('2020-01-01' as date) tarih
	union all
	select	cast(DATEADD(DAY, 1, tarih) as date) tarih
	from ocak
	where tarih < '2020-01-31'
)
select * from ocak;
with cte AS (
	select cast('2020-01-01' as date) AS gun
	union all
	select DATEADD(DAY,1,gun)
	from cte
	where gun < EOMONTH('2020-01-01')
)
select gun tarih, day(gun) gun, month(gun) ay, year(gun) yil,
	EOMONTH(gun) ayinsongunu
from cte;

--Write a query that returns all staff with their manager_ids. (use recursive CTE)

with cte as (
	select	staff_id, first_name, manager_id
	from	sale.staff
	where	staff_id = 1
	union all
	select	a.staff_id, a.first_name, a.manager_id
	from	sale.staff a, cte b
	where	a.manager_id = b.staff_id
)
select *
from	cte
;

--2018 yılında tüm mağazaların ortalama cirosunun altında ciroya sahip mağazaları listeleyin.
--List the stores their earnings are under the average income in 2018.

WITH T1 AS (
SELECT	c.store_name, SUM(list_price*quantity*(1-discount)) Store_earn
FROM	sale.orders A, SALE.order_item B, sale.store C
WHERE	A.order_id = b.order_id
AND		A.store_id = C.store_id
AND		YEAR(A.order_date) = 2018
GROUP BY C.store_name
),
T2 AS (
SELECT	AVG(Store_earn) Avg_earn
FROM	T1
)
SELECT *
FROM T1, T2
WHERE T2.Avg_earn > T1.Store_earn
;