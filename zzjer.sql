select name                     as username,
       create_date,
       modify_date,
       type_desc                as type,
       authentication_type_desc as authentication_type
from sys.database_principals

SELECT *
FROM CurrentMenu

SELECT I.InvoiceID
FROM Customer
         INNER JOIN [Order] O on Customer.CustomerID = O.CustomerID
         INNER JOIN Invoice I on O.InvoiceID = I.InvoiceID
WHERE O.CustomerID = 1

SELECT *
FROM CustomerInvoices(1)

SELECT P.Name, Quantity, OD.UnitPrice
FROM [Order] O
         INNER JOIN OrderDetails OD on O.OrderID = OD.OrderID
         Inner Join Product P on P.ProductID = OD.ProductID
WHERE O.InvoiceID = 1

SELECT P.Name, Quantity, OD.UnitPrice * (100 - O.Discount) / 100 AS PriceWithDiscount
FROM [Order] O
         INNER JOIN OrderDetails OD on O.OrderID = OD.OrderID
         Inner Join Product P on P.ProductID = OD.ProductID
WHERE O.InvoiceID = 1

SELECT SUM(UnitPrice * Quantity * ((100 - O.Discount) / 100.0))
FROM [Order] O
         INNER JOIN OrderDetails OD on O.OrderID = OD.OrderID
WHERE InvoiceID = 1
GROUP BY OD.OrderID



SELECT dbo.InvoiceValue(1)


SELECT [Table].TableNumber
FROM [Table]
    LEFT JOIN TableReservarionDetails TRD on [Table].TableNumber = TRD.TableNumber
    LEFT JOIN TableReservation TR on TR.ReservationID = TRD.ReservationID
WHERE TRD.ReservationID IS NULL OR
      (DATEDIFF(minute , TR.ReservationStart, GETDATE()) < 0 AND DATEDIFF(minute , TR.ReservationEnd, GETDATE()) >= 0)



SELECT [Table].TableNumber, DATEDIFF(minute , TR.ReservationStart, GETDATE()), DATEDIFF(minute , TR.ReservationEnd, GETDATE())
FROM [Table]
    LEFT JOIN TableReservarionDetails TRD on [Table].TableNumber = TRD.TableNumber
    LEFT JOIN TableReservation TR on TR.ReservationID = TRD.ReservationID
WHERE TRD.ReservationID IS NULL OR
      (DATEDIFF(minute , TR.ReservationStart, GETDATE()) < 0 AND DATEDIFF(minute , TR.ReservationEnd, GETDATE()) >= 0)
OR 1=1

SELECT [Table].TableNumber
FROM [Table]
    INNER JOIN TableReservarionDetails TRD ON [Table].TableNumber = TRD.TableNumber
    INNER JOIN TableReservation TR ON TR.ReservationID = TRD.ReservationID
WHERE (DATEDIFF(minute , TR.ReservationStart, GETDATE()) >= 0 AND DATEDIFF(minute , TR.ReservationEnd, GETDATE()) < 0)


SELECT * FROM FreeTables ('2023-01-23 00:34:58.290','2023-01-25 00:34:58.290')
SELECT * FROM TableReservation

SELECT GETDATE()

SELECT * FROM MenuOn('2023-01-10')

EXEC AddItemToOrder 1,1,1

SELECT * FROM OrderDetails

SELECT * FROM ProductsInAnOrder (2)

SELECT DATEDIFF(DAY, '2023-01-21', '2023-01-20')

SELECT * FROM OccupiedTables ('2023-01-25 00:34:58.290','2023-01-30 00:34:58.290')

SELECT dbo.NumberOfOrdersByCustomer(1)

EXEC CreateOrder 1

EXEC AddItemToOrder 2, 2, 10

SELECT SUM(UnitPrice*Quantity) FROM OrderProducts (1)

SELECT dbo.InvoiceValue(1)
SELECT SUM(UnitPrice*Quantity) FROM dbo.InvoiceDetails(1)


EXEC CreateOrderTakeaway 1, '2023-01-19 00:34:58.290'

SELECT CURRENT_TIMESTAMP;

EXEC CreateReservation 5,'2023-01-18 15:34:58.290', '2023-01-18 16:34:58.290', 3

SELECT * FROM FreeTables ('2023-01-18 15:34:58.290', '2023-01-18 16:34:58.290')

SELECT dbo.NumberOfOrdersByCustomer(1)

EXEC CreateOrderWithReservation 1,'2023-01-19 15:34:58.290', '2023-01-19 16:34:58.290', 2

SELECT CONCAT('asd',1)

EXEC UseDiscount 1,2

UPDATE [Order] SET Discount = 0 WHERE OrderID = 1

SELECT dbo.OrderValue(1)

SELECT * FROM OrderProducts(1)

SELECT * FROM CurrentMenu

EXEC AddTableToReservation 3,3

EXEC AddPersonToReservation 3, 'Jeremiasz', 'Pawel'

EXEC AddPersonToReservation 3, 'Jan', 'Kowalski'

EXEC CreateInvoice 4


ALTER TABLE Company ALTER COLUMN CustomerID int  NOT NULL


SELECT * FROM CurrentMenu

EXEC AddItemToMenu 12,3

EXEC CreateOrder 3

BEGIN TRANSACTION;
EXEC AddItemToOrder 16,12,1
COMMIT TRANSACTION ;

EXEC CreateInvoice 14

BEGIN TRANSACTION
EXEC CreateInvoiceMonthly 3,1,2023
COMMIT TRANSACTION

SELECT * FROM CustomerInvoices (3)

SELECT dbo.InvoiceValue(6)
SELECT dbo.OrderValue(15)
SELECT * FROM dbo.OrderProducts (16)

SELECT * FROM OrderDetails

          SELECT SUM(UnitPrice * Quantity * (1 - O.Discount)) value
    FROM [Order] O
             INNER JOIN OrderDetails OD on O.OrderID = OD.OrderID
    WHERE InvoiceID = 6

SELECT DATEDIFF(DAY, '2023-01-21', '2023-01-25')

SELECT DATEPART(WEEKDAY ,GETDATE())

SELECT * FROM CustomerInvoices (1)

EXEC AddItemToOrder 4,2,1
EXEC UseDiscount 4,19

SELECT * FROM [Order]
SELECT * FROM [OrderDetails]
SELECT * FROM Discount
SELECT * FROM TableReservation
SELECT * FROM TableReservarionDetails
SELECT DATEADD(day,GETDATE(),2)
EXEC CreateOrderWithCollectionDate 3, '2023-02-10',1

SELECT * FROM MenuOn('2023-02-10')

EXEC CreateOrder 2
BEGIN TRANSACTION;
EXEC AddItemToOrder 31,12,10
COMMIT TRANSACTION ;

EXEC AddPayment 31, 310.4

SELECT * FROM OrderProducts (30)
SELECT dbo.OrderValue(31)
EXEC UseDiscount 31,54

SELECT DATEPART(WEEKDAY ,'2023-02-10')
SELECT DATEDIFF(day,GETDATE(),'2023-02-10')
SELECT GETDATE()

SELECT SUM(UnitPrice*Quantity) FROM OrderProducts(19)

EXEC CreateOrderWithReservation 2,'2023-01-29 15:34:58.290', '2023-01-29 16:34:58.290', 2


DECLARE @A1 AS DATETIME
SET @A1 = CAST('2023-01-25 00:34:58.290' AS DATETIME)
SELECT 1 WHERE '2023-01-25 00:34:58.291' > '2023-01-25 00:34:58.290'


SELECT CAST('2023-01-25 00:34:58.290' AS DATETIME) > CAST('2023-01-25 00:34:58.290' AS DATETIME)