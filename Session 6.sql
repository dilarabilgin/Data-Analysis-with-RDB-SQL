
----------------------------------- UNION ----------------------------------- 
-- Iki kümeyi birlestirir

-- Charlotte şehrindeki müşteriler ile Aurora şehrindeki müşterilerin soyisimlerini listeleyin

SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'


SELECT last_name
FROM sale.customer
WHERE city = 'Aurora'

-- RESULT IS DISTINCT "!UNIQUE!" (people with same last_names wont be duplicated)

SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'
UNION 
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora'

-- SIRALAMA YAPMADAN VE DUPLICATELERLE BIRLIKTE

SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'
UNION ALL
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora'

-- Calisanlarin ve müsterilerin eposta adresleri unique olacak sekile listelendirmek

SELECT last_name, email
FROM sale.customer
UNION 
SELECT last_name, email
FROM sale.staff

-- Adı Thomas olan ya da soyadı Thomas olan müşterilerin isim soyisimlerini listeleyiniz.

SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas'
UNION ALL
SELECT last_name, first_name
FROM sale.customer
WHERE last_name = 'Thomas'

----------------------------------- INTERSECT ----------------------------------- 
-- iki kümenin kesisen elemanlarini alir

-- Write a query that returns brands that have products for both 2018 and 2019.

SELECT  A.brand_id, B.brand_name
FROM    product.product A, product.brand B
WHERE   a.brand_id = b.brand_id and 
        a.model_year = 2018
INTERSECT
SELECT  A.brand_id, B.brand_name
FROM    product.product A, product.brand B
WHERE   a.brand_id = b.brand_id and 
        a.model_year = 2019

-- Write a query that returns customers who have orders for all 2018, 2019, and 2020

SELECT	A.first_name, A.last_name
FROM	sale.customer A, sale.orders B
WHERE	B.customer_id = A.customer_id AND 
		YEAR(B.order_date) = 2018
INTERSECT
SELECT	A.first_name, A.last_name
FROM	sale.customer A, sale.orders B
WHERE	B.customer_id = A.customer_id AND 
		YEAR(B.order_date) = 2018
INTERSECT
SELECT	A.first_name, A.last_name
FROM	sale.customer A, sale.orders B
WHERE	B.customer_id = A.customer_id AND 
		YEAR(B.order_date) = 2018

select	*
from
	(
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A , sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2018
	INTERSECT
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A, sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2019
	INTERSECT
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A , sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2020
	) A, sale.orders B
where	a.customer_id = b.customer_id and Year(b.order_date) in (2018, 2019, 2020)
order by a.customer_id, b.order_date
;

SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'
INTERSECT
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora'

-- ayni emaile sahip müşteri ile çalışan var mı?

select	email
from	sale.staff
intersect
select	email
from	sale.customer
;


----------------------------------- EXCEPT ----------------------------------- 
-- iki kümenin birbirinden farki


-- Write a query that returns brands that have a 2018 model product but not a 2019 model product.

SELECT A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
    AND A.model_year = 2018
EXCEPT
SELECT A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
    AND A.model_year = 2019;


--Sadece 2019 yılında sipariş verilen diğer yıllarda sipariş verilmeyen ürünleri getiriniz.

select	C.product_id, D.product_name
from	
	(
	select	B.product_id
	from	sale.orders A, sale.order_item B
	where	Year(A.order_date) = 2019 AND
			A.order_id = B.order_id
	except
	select	B.product_id
	from	sale.orders A, sale.order_item B
	where	Year(A.order_date) <> 2019 AND
			A.order_id = B.order_id
	) C, product.product D
where	C.product_id = D.product_id
;

-- 5 marka

select	brand_id, brand_name
from	product.brand
except
select	*
from	(
		select	A.brand_id, B.brand_name
		from	product.product A, product.brand B
		where	a.brand_id = b.brand_id and
				a.model_year = 2018
		INTERSECT
		select	A.brand_id, B.brand_name
		from	product.product A, product.brand B
		where	a.brand_id = b.brand_id and
				a.model_year = 2019
		) A


select	B.product_id, C.product_name
	from	sale.orders A, sale.order_item B, product.product C
	where	Year(A.order_date) = 2019 AND
			A.order_id = B.order_id AND
			B.product_id = C.product_id
	except
	select	B.product_id, C.product_name
	from	sale.orders A, sale.order_item B, product.product C
	where	Year(A.order_date) <> 2019 AND
			A.order_id = B.order_id AND
			B.product_id = C.product_id



--aggregate function

SELECT *
FROM
			(
			SELECT	b.product_id, year(a.order_date) OrderYear, B.item_id
			FROM	SALE.orders A, sale.order_item B
			where	A.order_id = B.order_id
			) A
PIVOT
(
	count(item_id)
	FOR OrderYear IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
order by 1




----------------------------------- CASE ----------------------------------- 
--simple case


SELECT order_id, order_status,
    CASE order_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Completed'
    END order_status_desc
FROM sale.orders
;

SELECT first_name, last_name, store_id,
    CASE store_id
        WHEN 1 THEN 'Davi techno Retail'
        WHEN 2 THEN 'The BFLO Store'
        WHEN 3 THEN 'Burkes Outlet'
    END Store_name
FROM sale.staff


---- searched case 

 SELECT order_id, order_status,
    CASE 
        WHEN order_status = 1 THEN 'Pending'
        WHEN order_status = 2 THEN 'Processing'
        WHEN order_status = 3 THEN 'Rejected'
        WHEN order_status = 4 THEN 'Completed'
        else 'other'
    END order_status_desc
FROM sale.orders
;



--Müşterilerin e-mail adreslerindeki servis sağlayıcılarını yeni bir sütun oluşturarak belirtiniz.

SELECT first_name, last_name,email,
	CASE
		WHEN email LIKE '%gmail%' THEN 'Gmail'
		WHEN email LIKE '%hotmail%' THEN 'Hotmail'
		WHEN email LIKE '%yahoo%' THEN 'Yahoo'
		ELSE 'Other'
	END AS email_service_provider
FROM sale.customer


-- Aynı siparişte hem mp4 player, hem Computer Accessories hem de Speakers kategorilerinde ürün sipariş veren müşterileri bulunuz.

SELECT *
FROM product.category

select	C.first_name, C.last_name
from	(
		select	c.order_id, count(distinct a.category_id) uniqueCategory
		from	product.category A, product.product B, sale.order_item C
		where	A.category_name in ('Computer Accessories', 'Speakers', 'mp4 player') AND
				A.category_id = B.category_id AND
				B.product_id = C.product_id
		group by C.order_id
		having	count(distinct a.category_id) = 3
		) A, sale.orders B, sale.customer C
where	A.order_id = B.order_id AND
		B.customer_id = C.customer_id
;


-- farkli metot ekleyelim



