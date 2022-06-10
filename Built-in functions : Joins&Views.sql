
----- TRIM(), LTRIM(), RTRIM()

SELECT TRIM(' CHARACTER');

SELECT ' CHARACTER' ; -- printing 'character with space at the beginning

SELECT GETDATE() ;

SELECT TRIM(' CHAR ACTER '); -- trim tirnaktan önceki bosluklari degil sonraki bosluklari kaale alir

SELECT TRIM('X' FROM 'ABCXXDE') -- basindaki ve sonundaki 'X'leri cikarir

SELECT TRIM('X' FROM 'XXXXXXXABCXXDEXXXXX')

SELECT TRIM('ABC' FROM 'CCCCBBBAAAAJFJDFDFJDHFJACBBACBABCABCABB') -- 'ABC' farkli siralarla geliyorsada siliniyor

SELECT LTRIM('       CHARACTER ') -- soldaki karakterler temizlenecek

SELECT RTRIM('       CHARACTER ') -- sagdaki karakterler temizlenir


---- REPLACE(), STR()

SELECT REPLACE('CHARACTER STRING', ' ', '/') -- bosluk yerine slash isareti

SELECT REPLACE('CHARACTER STRING', 'CHARACTER STRING', 'CHARACTER')

SELECT STR (5454) -- string funktionu 10 karakterli ifade döndürür

SELECT STR (2135454654)

SELECT STR (133215.654645, 11, 3) -- toplam 11 karakter 3'ü virgülden sonra ve yuvarlar sayiyi

SELECT STR(123456789101112) -- 10 karakterden hangisini yollanacak bilinmiyor bu sebeple 10 yildiz 
SELECT LEN(STR(123456789101112))


---- CAST(), CONVERT()

SELECT CAST (12345 AS CHAR)
SELECT CAST (123.65 AS INT)



SELECT CONVERT(int, 30.60)
SELECT CONVERT (VARCHAR(10), '2020-10-10') -- tarihi metine döndürdü
SELECT CONVERT (DATETIME, '2020-10-10' )
SELECT CONVERT (NVARCHAR, GETDATE(),112 ) -- getdate() sonucunu texte cevir ve 112 formatina (YYYYMMDD) cevir

SELECT CAST ('20201010' AS DATE)
SELECT CONVERT (NVARCHAR, CAST ('20201010' AS DATE),103 )


----- COALESCE 

SELECT COALESCE(NULL, 'Hi', 'Hello', NULL) -- Birinciden baslayip ilk NULL olmayan parametreyi alir


----- NULLIF

SELECT NULLIF (10,10) -- iki parametre birbirine esitse NULL getirir
SELECT NULLIF (10,11) -- sadece 10 getirir



----- ROUND

SELECT ROUND (432.368, 2, 0) -- virgülden sonraki 2. karakterine göre yuvarla / '0' yukariya yuvarliyor
SELECT ROUND (432.368, 2)
SELECT ROUND (432.368, 2, 1) -- '1' asagiya yuvarliyor



----- ISNULL()

SELECT ISNULL (NULL, 'ABC') -- birincisi bos ise ikincisi aliyor
SELECT ISNULL (' ', 'ABC') -- NULL olmayan ilk veriyi aliyor



----- ISNUMERIC

SELECT ISNUMERIC(123) -- numeric mi degil mi diye test ediyoruz '1' TRUE, '0' FALSE
SELECT ISNUMERIC('ABC') 





------------------------------------------------------- JOIN ---------------------------------------------------------

----- INNER JOIN: returns common records in both tables

-- List products with category names

SELECT A.product_id, A.product_name, B.category_id, B.category_name
FROM product.product AS A 
INNER JOIN product.category AS B
ON A.category_id = B.category_id

-- List employees of stores with their store indormation / Select employee name, surname, store names

SELECT A.first_name, A.last_name, B.store_name
FROM sale.staff AS A
INNER JOIN sale.store AS B
ON A.store_id = B.store_id



----- LEFT JOIN: returns all records from the left table and matching records from the right table

-- write a query that returns products that have never been ordered

SELECT A.product_id, A.product_name, B.order_id
FROM product.product AS A 
LEFT JOIN sale.order_item AS B
ON A.product_id = B.product_id
WHERE B.order_id is NULL

-- report the stock status of the products that product id greater then 310 in the store 

SELECT A.product_id, A.product_name, B.store_id, B.product_id, B.quantity
FROM product.product A 
LEFT JOIN product.stock B 
ON A.product_id = B.product_id
WHERE A.product_id > 310




----- RIGHT JOIN: returns all records from the right table and matching records from the left table 

SELECT B.product_id, B.product_name , A.*
FROM product.stock  A 
RIGHT JOIN  product.product B 
ON A.product_id = B.product_id
WHERE B.product_id > 310




----- FULL JOIN: rreturns all records if both left and right tables


-- write a query that returns stock and order infotmation together for all products (TOP 10)

SELECT TOP 100 A.product_id, B.store_id, B.quantity, C.order_id, C.list_price
FROM    product.product A 
FULL OUTER JOIN product.stock B 
ON A.product_id = B.product_id
FULL OUTER JOIN sale.order_item C 
ON A.product_id = C.product_id
ORDER BY b.store_id



----- CROSS JOIN: returns the cartesian prroduct of records in joined tables


--stock tablosunda olmayıp product tablosunda mevcut olan ürünlerin stock tablosuna tüm storelar için kayıt edilmesi gerekiyor. 
--stoğu olmadığı için quantity leri 0 olmak zorunda
--Ve bir product id tüm store' ların stockuna eklenmesi gerektiği için cross join yapmamız gerekiyor.

SELECT	B.store_id, A.product_id, 0 quantity
FROM	product.product A
CROSS JOIN sale.store B
WHERE	A.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY A.product_id, B.store_id


----- SELF JOIN a join of a table to itself
