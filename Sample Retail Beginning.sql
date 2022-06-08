SELECT *
FROM product.brand
ORDER BY brand_name -- ASC

SELECT *
FROM product.brand
ORDER BY brand_name DESC

SELECT TOP 10 *
FROM product.brand
ORDER BY brand_id 

SELECT TOP 10 *
FROM product.brand
ORDER BY brand_id DESC


SELECT *
FROM product.brand

-- WHERE -------------------------------------------------------

SELECT * 
FROM product.brand
WHERE brand_name LIKE 's%' -- BRAND NAME 'S' ILE BASLAYANLAR

SELECT * 
FROM product.product -- product_id PRIMARY KEY

-- ayni ürünler farkli product_id cünkü onlari birbirinden ayiran özellikleri var !!
-- brand_id ve category_id farkli tablolardan geliyor (FK)

SELECT *
FROM product.product
ORDER BY brand_id 


SELECT *
FROM product.product
WHERE model_year BETWEEN 2019 AND 2021

--- sinirlari kontrol etmek icin yapilabilir

-- en kücük tarih
SELECT TOP 1 *
FROM product.product
WHERE model_year BETWEEN 2019 AND 2021
ORDER BY model_year  

-- en büyük tarih
SELECT TOP 1 *
FROM product.product
WHERE model_year BETWEEN 2019 AND 2021
ORDER BY model_year  DESC


------------------------------------------------------------------
 
-- 3,4,5 ürünlerini getir

SELECT * 
FROM product.product
WHERE category_id IN (3,4,5)

-- alternative

SELECT * 
FROM product.product
WHERE category_id = 3 or category_id = 4 or category_id = 5 

-- 3,4,5 haric

SELECT * 
FROM product.product
WHERE category_id NOT IN (3,4,5)

----------------------------------------------------------------------

-- hangi üründen hangi filialede kac tane ürün var 
-- store_id ve product_id COMPOSITE KEY

SELECT * 
FROM product.stock
ORDER BY quantity