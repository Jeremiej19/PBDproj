CREATE TRIGGER addDiscountR2
    ON IndividualCustomer
    AFTER UPDATE
    AS
        DECLARE @K2 AS MONEY
        SELECT @K2 = (
            SELECT MinTotalValueOfOrdersForOneTimeDiscount FROM AuxiliaryValues
            )
        IF (SELECT MoneyAccumulatedForNextDiscount FROM inserted) >= @K2
            BEGIN
                DECLARE @CustomerID AS INTEGER
                SELECT @CustomerID = (
                        (SELECT CustomerID FROM inserted))
                EXEC AddR2Discount @CustomerID
            END



CREATE TRIGGER addDiscountR1
    ON IndividualCustomer
    AFTER UPDATE
    AS
        DECLARE @CustomerID AS INTEGER
        SELECT @CustomerID = (
            (SELECT CustomerID FROM inserted))
        IF EXISTS(SELECT * FROM Discount WHERE CustomerID = @CustomerID
                                           AND ExpirationDate IS NULL)
            BEGIN
                RETURN
            END
        DECLARE @K1 AS MONEY
        SELECT @K1 = (
            SELECT MinValueOfOrderForPermanentDiscount FROM AuxiliaryValues
            )
        DECLARE @Z1 AS INTEGER
        SELECT @Z1 = (
            SELECT MinNumberOfOrdersForPermanentDiscount FROM AuxiliaryValues
            )
        DECLARE @R1 AS DECIMAL(5,2)
                SELECT @R1 = (
            SELECT RateOfPermanentDiscount FROM AuxiliaryValues
            )
        IF (SELECT Count(*) FROM [Order] WHERE [Order].CustomerID = @CustomerID
                                           AND dbo.OrderValue (OrderID) >= @K1 ) >= @Z1
            BEGIN
                INSERT INTO Discount VALUES (@CustomerID,@R1,NULL,0)
            END