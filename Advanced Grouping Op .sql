
SELECT * 
FROM product.brand
;

-- AGGREGATE FUNCITON "COUNT()"
-- HOW MANY BRANDS

SELECT count(*)
FROM product.brand
;

-- SATIR SAYISI

SELECT count(*)
FROM product.product
;

-- HOW MANY PRODUCTS OF EACH BRAND

SELECT count(*) -- WITHOUT BRAND_ID 
FROM product.product
GROUP BY brand_id
;

SELECT brand_id, count(*) AS CountOfProduct -- WITH BRAND_ID
FROM product.product
GROUP BY brand_id
;

SELECT brand_id, count(product_id) -- WITH BRAND_ID / "*" BÜTÜN SATIRLAR
FROM product.product
GROUP BY brand_id
;

-- count(column_namr) column_name is null

-- HER BIR KATEGORIDEKI TOPLAM ÜRÜN SAYISI

SELECT category_id, count(*) AS CountOfProduct 
FROM product.product
GROUP BY category_id
;

-- Herbir kategorideki toplam ürünü sayısını yazdırınız.
-- Sonuç olarak Category_id, Category_name ve Ürün miktarı bulunsun

SELECT A.category_id, B.category_name, COUNT(*) AS count_products
FROM product.product as A
JOIN product.category as B
ON A.category_id = B.category_id
GROUP BY A.category_id, B.category_name;


-- Model yili 2016`dan büyük olan ürünlerin liste fiyatlarinin ortalamasi 1000'den fazla oldugu markalari listeleyin

SELECT b.brand_name, AVG(a.list_price) AS AveragePrice
FROM product.product a, product.brand b 
WHERE a.brand_id = b.brand_id AND a.model_year > 2016
GROUP BY b.brand_name
HAVING AVG(a.list_price) > 1000
ORDER BY AveragePrice DESC -- ORDER BY 2 DESC (AveragePrice 2.sütun oldugu icin)
;

--Write a query that checks if any product id is repeated in more than one row in the product table.

SELECT	product_id, COUNT (product_id) num_of_rows
FROM	product.product
GROUP BY product_id
HAVING COUNT (product_id) > 1
;

SELECT category_id, MAX(list_price) AS max_price, MIN(list_price) AS min_price
FROM product.product
GROUP BY category_id
HAVING MAX(list_price) > 4000 OR MIN(list_price) < 500
;

--bir siparişin toplam net tutarını getiriniz. (müşterinin sipariş için ödediği tutar)
--discount' ı ve quantity' yi ihmal etmeyiniz.

SELECT order_id, SUM(quantity*list_price*(1-discount)) AS Payment
FROM sale.order_item
Group BY order_id

-- Herbir kategorideki toplam ürün sayısı
-- Herbir model yılındaki toplam ürün sayısı
-- Herbir kategorinin model yılındaki toplam ürün sayısıs

SELECT	category_id, model_year, COUNT(*) AS CountOfProducts
FROM	product.product
GROUP BY
	GROUPING SETS (
				(category_id), -- 1. group
				(model_year), -- 2. group
				(category_id, model_year) -- 3. group
	)
ORDER BY 1, 2
;

-- ROLLUP

SELECT	category_id, model_year, COUNT(*) AS CountOfProducts
FROM	product.product
GROUP BY
	ROLLUP (category_id, model_year)
;

-- Herbir marka id, herbir category id ve herbir model yılı için toplam ürün sayılarını getiriniz.
-- Sonuç tablosunda tüm ihtimaller bulunsun.

SELECT brand_id, category_id, model_year, COUNT(*) AS CountOfProducts
FROM product.product
GROUP BY 
    ROLLUP (brand_id, category_id, model_year)
;

-- CUBE

SELECT brand_id, category_id, model_year, COUNT(*) AS CountOfProducts
FROM product.product
GROUP BY 
    CUBE (brand_id ,category_id, model_year)
;


SELECT model_year, COUNT(*)
FROM product.product
GROUP BY model_year
;

--PIVOT


-- model yıllarına göre toplam ürün sayısı

SELECT *
FROM
			(
			SELECT product_id, Model_Year
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
;

SELECT *
FROM
			(
			SELECT category_id, Model_Year, product_id
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
;



SELECT *
FROM
			(
			SELECT category_id, Model_Year, product_id
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
UNION ALL
SELECT NULL, *
FROM
			(
			SELECT Model_Year, product_id
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE