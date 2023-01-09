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

DROP FUNCTION CustomerInvoices
DROP FUNCTION InvoiceDetails
DROP FUNCTION InvoiceValue

SELECT * FROM InvoiceValue (1)

SELECT InvoiceValue(1)