--VIEW TO SHORTEN AND BE FASTER 
--ORDER BY CAN NOT BE IN THE FUNCTION WITH "VIEW"
--VIEW IS A DATABASE OBJECT (WILL NOT BE DELETED)


CREATE VIEW ProductStock AS
SELECT	A.product_id, A.product_name, B.store_id, B.quantity
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310
;

-- TO USE IT


SELECT * 
FROM dbo.ProductStock
;


SELECT *
FROM dbo.ProductStock
WHERE store_id = 1
;

-- AFTER CREATING IT YOU CAN USE "ORDER BY"

SELECT *
FROM dbo.ProductStock
WHERE store_id = 1
ORDER BY 1
;

-- Mağaza çalışanlarını çalıştıkları mağaza bilgileriyle birlikte listeleyin
-- Çalışan adı, soyadı, mağaza adlarını seçin

CREATE VIEW SaleStaff as 
SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
	ON	A.store_id = B.store_id
;

SELECT *
FROM dbo.SaleStaff
;

SELECT *
FROM dbo.SaleStaff
WHERE store_name = 'Burkes Outlet'
;

SELECT *
FROM dbo.SaleStaff
WHERE first_name LIKE 'D%' 
;

