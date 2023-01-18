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