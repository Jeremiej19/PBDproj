CREATE VIEW CurrentMenu AS
select P.Name, MD.Price
from menu M
    INNER JOIN MenuDetails MD on M.MenuID = MD.MenuID
    INNER JOIN Product P on P.ProductID = MD.ProductID
where DATEDIFF(day, StartDate, GETDATE()) >= 0
AND DATEDIFF(day, EndDate, GETDATE()) < 0
AND P.Available = 1;
GO;

CREATE VIEW WeeklyTableStats AS
SELECT T.TableNumber AS [Table Number],
COUNT(*) AS [Number of reservations]
FROM [Table] AS T
INNER JOIN TableReservarionDetails AS TRD
ON T.TableNumber = TRD.TableNumber
INNER JOIN TableReservation AS TR
ON TRD.ReservationID = TR.ReservationID
WHERE DATEDIFF(WEEK, TR.ReservationStart, GETDATE()) = 0
GROUP BY T.TableNumber 
GO;

CREATE VIEW MonthlyTableStats AS
SELECT T.TableNumber AS [Table Number],
COUNT(*) AS [Number of reservations]
FROM [Table] AS T
INNER JOIN TableReservarionDetails AS TRD
ON T.TableNumber = TRD.TableNumber
INNER JOIN TableReservation AS TR
ON TRD.ReservationID = TR.ReservationID
WHERE DATEDIFF(MONTH, TR.ReservationStart, GETDATE()) = 0
GROUP BY T.TableNumber
GO;

CREATE VIEW DiscountsExpiringThisWeek AS
SELECT CustomerID, DiscountID, DiscountRate, ExpirationDate FROM Discount
WHERE DATEDIFF(WEEK, ExpirationDate, GETDATE()) = 0
AND Used = 0
GO;

CREATE VIEW DiscountsExpiringThisMonth AS
SELECT CustomerID, DiscountID, DiscountRate, ExpirationDate FROM Discount
WHERE DATEDIFF(MONTH, ExpirationDate, GETDATE()) = 0
AND Used = 0
GO;

CREATE VIEW ProductsOrderedWeekly AS
SELECT P.Name AS [Product Name],
SUM(OD.Quantity) AS [Number of orders]
FROM Product AS P
INNER JOIN OrderDetails AS OD
ON P.ProductID = OD.ProductID
INNER JOIN [Order] AS O
ON OD.OrderID = O.OrderID
WHERE DATEDIFF(WEEK, O.OrderDate, GETDATE()) = 0
GROUP BY P.Name
GO;

CREATE VIEW ProductsOrderedMonthly AS
SELECT P.Name AS [Product Name],
SUM(OD.Quantity) AS [Number of orders]
FROM Product AS P
INNER JOIN OrderDetails AS OD
ON P.ProductID = OD.ProductID
INNER JOIN [Order] AS O
ON OD.OrderID = O.OrderID
WHERE DATEDIFF(MONTH, O.OrderDate, GETDATE()) = 0
GROUP BY P.Name
GO;

CREATE VIEW IndividualCustomerWeeklyOrderStats AS
SELECT (IC.Firstname + ' ' + IC.Surname) AS [Customer name],
O.OrderID,
dbo.OrderValue(O.OrderID) as [Order value],
O.OrderDate AS [Order Date]
FROM IndividualCustomer AS IC
INNER JOIN [Order] as O
ON IC.CustomerID = O.CustomerID
WHERE DATEDIFF(WEEK, O.OrderDate, GETDATE()) = 0
GO;

CREATE VIEW IndividualCustomerMonthlyOrderStats AS
SELECT (IC.Firstname + ' ' + IC.Surname) AS [Customer name],
O.OrderID,
dbo.OrderValue(O.OrderID) as [Order value],
O.OrderDate AS [Order Date]
FROM IndividualCustomer AS IC
INNER JOIN [Order] as O
ON IC.CustomerID = O.CustomerID
WHERE DATEDIFF(MONTH, O.OrderDate, GETDATE()) = 0
GO;

CREATE VIEW CompanyWeeklyOrderStats AS
SELECT CompanyName AS [Company name],
O.OrderID,
dbo.OrderValue(O.OrderID) as [Order value],
O.OrderDate AS [Order Date]
FROM Company AS C
INNER JOIN [Order] as O
ON C.CustomerID = O.CustomerID
WHERE DATEDIFF(WEEK, O.OrderDate, GETDATE()) = 0
GO;

CREATE VIEW CompanyMonthlyOrderStats AS
SELECT CompanyName AS [Company name],
O.OrderID,
dbo.OrderValue(O.OrderID) as [Order value],
O.OrderDate AS [Order Date]
FROM Company AS C
INNER JOIN [Order] as O
ON C.CustomerID = O.CustomerID
WHERE DATEDIFF(MONTH, O.OrderDate, GETDATE()) = 0
GO;