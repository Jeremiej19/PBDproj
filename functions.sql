CREATE FUNCTION CustomerInvoices(
    @CustomerID AS INTEGER
)
RETURNS TABLE
AS
RETURN  (
    SELECT I.InvoiceID
    FROM Customer
        INNER JOIN [Order] O on Customer.CustomerID = O.CustomerID
        INNER JOIN Invoice I on O.InvoiceID = I.InvoiceID
    WHERE O.CustomerID = @CustomerID
)

CREATE FUNCTION InvoiceDetails(
    @InvoiceID AS INTEGER
)
RETURNS TABLE
AS
RETURN  (
    SELECT P.Name, Quantity, OD.UnitPrice FROM [Order] O
    INNER JOIN OrderDetails OD on O.OrderID = OD.OrderID
    Inner Join Product P on P.ProductID = OD.ProductID
    WHERE O.InvoiceID = @InvoiceID
    )



CREATE FUNCTION InvoiceValue(
    @InvoiceID AS INTEGER
)
RETURNS DECIMAL
AS
BEGIN
   DECLARE @Value as DECIMAL
   SELECT @Value = (
         SELECT SUM(UnitPrice * Quantity * (1 - O.Discount)) value
    FROM [Order] O
             INNER JOIN OrderDetails OD on O.OrderID = OD.OrderID
    WHERE InvoiceID = @InvoiceID
    GROUP BY OD.OrderID
       )
    RETURN @Value
END

CREATE FUNCTION OccupiedTables(
    @reservationStart AS DATETIME,
    @reservationEnd AS DATETIME
)
RETURNS TABLE
AS
RETURN  (
    SELECT [Table].TableNumber
    FROM [Table]
        INNER JOIN TableReservarionDetails TRD ON [Table].TableNumber = TRD.TableNumber
        INNER JOIN TableReservation TR ON TR.ReservationID = TRD.ReservationID
    WHERE (DATEDIFF(minute , @reservationStart, TR.ReservationStart ) <= 0 AND DATEDIFF(minute , TR.ReservationEnd, @reservationStart) < 0)
        OR (DATEDIFF(minute , @reservationEnd, TR.ReservationStart ) <= 0 AND DATEDIFF(minute , TR.ReservationEnd, @reservationEnd) < 0)
        OR (DATEDIFF(minute , TR.ReservationStart, @reservationStart) < 0 AND DATEDIFF(minute , @reservationEnd ,TR.ReservationEnd) <= 0)
    )


CREATE FUNCTION FreeTables(
    @reservationStart AS DATETIME,
    @reservationEnd AS DATETIME
)
RETURNS TABLE
AS
RETURN  (
    SELECT [Table].TableNumber
    FROM [Table]
    WHERE TableNumber NOT IN (SELECT * FROM OccupiedTables(@reservationStart,@reservationEnd))
    )




CREATE FUNCTION MenuOn(
    @date AS DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT P.ProductID, P.Name, MD.Price
    from menu M
        INNER JOIN MenuDetails MD on M.MenuID = MD.MenuID
        INNER JOIN Product P on P.ProductID = MD.ProductID
    WHERE DATEDIFF(day, StartDate, @date) >= 0
    AND DATEDIFF(day, EndDate, @date) < 0
    AND P.Available = 1
)

CREATE FUNCTION OrderProducts(
    @OrderID AS INTEGER
)
RETURNS TABLE
AS
RETURN (
    SELECT P.ProductID, P.Name, OrderDetails.UnitPrice, Quantity
    FROM OrderDetails
        INNER JOIN Product P ON P.ProductID = OrderDetails.ProductID
    WHERE OrderID = @OrderID
    )

CREATE FUNCTION NumberOfOrdersByCustomer(
    @CustomerID AS INTEGER
)
RETURNS INTEGER
AS
BEGIN
    DECLARE @Value as INTEGER
    SELECT @Value = (
            SELECT COUNT(OrderID) FROM [Order] WHERE CustomerID = @CustomerID GROUP BY CustomerID
       )
    RETURN @Value
END

CREATE FUNCTION OrderValue(
    @OrderID AS INTEGER
)
RETURNS MONEY
AS
BEGIN
    DECLARE @Discount AS DECIMAL(5,2)
    SELECT @Discount = (
        SELECT Discount FROM [Order] WHERE OrderID = @OrderID
        )
    DECLARE @Value AS MONEY
    SELECT @Value = (
        SELECT SUM(Quantity*UnitPrice* (1 - @Discount) ) FROM OrderProducts(@OrderID)
        )
    RETURN @Value
END