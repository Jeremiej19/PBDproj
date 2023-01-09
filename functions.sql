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
          SELECT SUM(UnitPrice * Quantity * ((100 - O.Discount) / 100.0)) value
    FROM [Order] O
             INNER JOIN OrderDetails OD on O.OrderID = OD.OrderID
    WHERE InvoiceID = @InvoiceID
    GROUP BY OD.OrderID
       )
    RETURN @Value
END

CREATE FUNCTION FreeTables(
    @reservationDate AS DATETIME
)
RETURNS TABLE
AS
RETURN  (
    SELECT [Table].TableNumber
    FROM [Table]
        LEFT JOIN TableReservarionDetails TRD on [Table].TableNumber = TRD.TableNumber
        LEFT JOIN TableReservation TR on TR.ReservationID = TRD.ReservationID
    WHERE TRD.ReservationID IS NULL OR
          NOT (DATEDIFF(minute , TR.ReservationStart, @reservationDate) >= 0 AND DATEDIFF(minute , TR.ReservationEnd, @reservationDate) < 0)
    )



DROP FUNCTION CustomerInvoices
DROP FUNCTION InvoiceDetails
DROP FUNCTION InvoiceValue
DROP FUNCTION FreeTables
