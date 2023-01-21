CREATE TRIGGER addDiscountR2
    ON IndividualCustomer
    AFTER UPDATE
    AS
        DECLARE @K2 AS MONEY
        SET @K2 = 50
        IF (SELECT MoneyAccumulatedForNextDiscount FROM inserted) >= @K2
            BEGIN
                DECLARE @CustomerID AS INTEGER
                SELECT @CustomerID = (
                        (SELECT CustomerID FROM inserted))
                EXEC AddR2Discount @CustomerID
            END