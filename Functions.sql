/*Session 3 Functions */

CREATE TABLE t_date_time
    (
        A_time time,
        A_Date date,
        A_smalldatetime smalldatetime,
        A_datetime datetime,
        A_datetime2 datetime2,
        A_datetimeoffset datetimeoffset
    )

SELECT * from t_date_time



SELECT GETDATE() as get_date



INSERT t_date_time 
VALUES ( GETDATE(),GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE() )




INSERT t_date_time (A_time, A_Ddate, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES
('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' )




--- CONVERT DATE TO VARCHAR

SELECT GETDATE()

SELECT CONVERT(varchar(10), GETDATE(), 6)


--- CONVERT VARCHAR TO DATE

SELECT CONVERT(DATE, '04 Jun 22', 6)
SELECT CONVERT(DATETIME, '04 Jun 22', 6)


---- DATE FUNCTIONS

-- Functions for return date or time parts

SELECT A_Ddate
        , DAY(A_Ddate) DAY_
        , MONTH(A_Ddate) MONTH_
        , DATENAME(DAYOFYEAR, A_Ddate) DOY
        , DATEPART(WEEKDAY, A_Ddate) WKD
        , DATENAME(MONTH, A_Ddate) MON
FROM t_date_time




-- GETDATE VE GIRILEN DATE ARASINDAKI FARK(gün,saniye...)

SELECT DATEDIFF(DAY, '2022-05-10', GETDATE()) 

SELECT DATEDIFF(SECOND, '2022-05-10', GETDATE())


-----

SELECT *
FROM sale.orders

-- Teslimat tarihi ile kargolama/teslimat tarihi arasindaki gün farkini bulunuz.

SELECT *, DATEDIFF(DAY, order_date, shipped_date) Diff_Of_Day
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2 AND store_id = 2



---


---- GETDATE'E EKLENECEK DEGER(gün,saniye...)


SELECT DATEADD(DAY, 5 ,GETDATE())
SELECT DATEADD(MINUTE, 5 ,GETDATE())


---- EMONTH(END OF MONTH)

SELECT EOMONTH(GETDATE())
SELECT EOMONTH(GETDATE(), 2) -- icinde bulundugum ayin 2 ay sonrasinin son günü


---- LEN, CHARINDEX, PATINDEX

SELECT LEN ('CHARACTER') -- "9" == SELECT LEN ('CHARACTER  ') "9" != SELECT LEN ('  CHARACTER') "11"

----

SELECT CHARINDEX('R' , 'CHARACTER') -- 'R' harfinin yeri

SELECT CHARINDEX('R', 'CHARACTER', 5) -- Saymaya 5 den fazla bu sayede ikinci 'R'

SELECT CHARINDEX('RA', 'CHARACTER') -- Basdaki harfin indexini verir (1'Den basliyo)

SELECT CHARINDEX('RA', 'CHARACTER') - 1


----

-- R ile biten stringler 

SELECT PATINDEX('%R', 'CHARACTER') -- == SELECT PATINDEX('%r', 'CHARACTER')

SELECT PATINDEX('%H%', 'CHARACTER')

SELECT PATINDEX('%A%', 'CHARACTER')

SELECT PATINDEX('__A_____' , 'CHARACTER') -- A'dan önce bilmedigim kadar karakter

SELECT PATINDEX('__A%' , 'CHARACTER') -- A'dan önce iki karakter A'dan sonra bilmedigim kadar karakter

SELECT PATINDEX('%A____' , 'CHARACTER')


---- LEFT, RIGHT, SUBSTRING

SELECT LEFT('CHARACTER', 3) -- Soldan 3 karakter

SELECT RIGHT('CHARACTER', 3) -- Sagdan 3 karakter

SELECT SUBSTRING('CHARACTER', 3, 5) -- 3'ten basla 5 karakter al
SELECT SUBSTRING('CHARACTER', 4, 9) -- 4`ten basla 9 karakter al ama kelimenin sonunda kadar gitti cünkü 9 karakter alamiyor 4'ten sonra

SELECT SUBSTRING('CHARACTER', 4, 20)


---- LOWER, UPPER, STRING_SPLIT

SELECT LOWER('CHARACTER')

SELECT UPPER('character')

SELECT *
FROM STRING_SPLIT('JACK,MARTIN,ALAIN,OWEN', ',') -- ayirici karakter ',' ve bir tablo döndürüyor


---- 'chracter' kelimesinin ilk harfini büyüten bir script yaziniz.

SELECT UPPER ('character')
SELECT LEFT ('character',1)
SELECT UPPER (LEFT('character', 1))

SELECT SUBSTRING('character', 2, 9)

SELECT SUBSTRING('character', 2, LEN('character')) -- 2'den kelimenin sonuna kadar 

SELECT LOWER (SUBSTRING('character', 2, LEN('character'))) -- eger büyük karakter versa hepsini kücültmek icin

-- SONUC 

SELECT UPPER (LEFT('character', 1)) + LOWER (SUBSTRING('character', 2, LEN('character')))

SELECT CONCAT (UPPER (LEFT('character', 1)) , LOWER (SUBSTRING('character', 2, LEN('character'))))


