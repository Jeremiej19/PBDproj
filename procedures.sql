CREATE PROCEDURE CreateOrder @CustomerID as INTEGER

AS
BEGIN
    IF NOT EXISTS(SELECT * FROM Customer WHERE CustomerID = @CustomerID)
        BEGIN
            THROW 51000,'No such customer',1
        END
    INSERT INTO [Order] OUTPUT Inserted.OrderID VALUES (@CustomerID,NULL,GETDATE(),GETDATE(),0,0,0)
END
--
--
CREATE PROCEDURE CreateOrderTakeaway @CustomerID AS INTEGER,
                                     @CollectionDate AS DATETIME
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM Customer WHERE CustomerID = @CustomerID)
        BEGIN
            THROW 51000,'No such customer',1
        END
    IF DATEDIFF(MINUTE, GETDATE(), @CollectionDate) <= 0
        BEGIN
            THROW 51000,'Cant create reservation for past date', 1
        END
    INSERT INTO [Order] OUTPUT Inserted.OrderID VALUES (@CustomerID, NULL, GETDATE(), @CollectionDate, 0, 1, 0)
END
--
--
CREATE PROCEDURE CreateOrderWithReservation @CustomerID AS INTEGER,
                                            @StartDate AS DATETIME,
                                            @EndDate AS DATETIME,
                                            @TableNumber AS INTEGER
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM Customer WHERE CustomerID = @CustomerID)
        BEGIN
            THROW 51000,'No such customer',1
        END
    DECLARE @TMP AS TABLE (
        OrderID INTEGER
                          )
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO [Order] OUTPUT Inserted.OrderID INTO @TMP
                            VALUES (@CustomerID, NULL, GETDATE(), GETDATE(), 0, 0, 0);
        DECLARE @OrderID AS INTEGER
        SELECT @OrderID = (
            SELECT * FROM @TMP
            )
        EXEC CreateReservation @OrderID,@StartDate,@EndDate,@TableNumber
        COMMIT TRANSACTION ;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW
    END CATCH
END
--
--
CREATE PROCEDURE AddItemToOrder @OrderID AS INTEGER,
                                @ProductID AS INTEGER,
                                @Amount AS INTEGER
AS
BEGIN
    DECLARE @price AS MONEY
    IF @Amount <= 0
        BEGIN
            THROW 51000,'Amount must be greater than 0',1
        END
    IF NOT EXISTS(SELECT * FROM [Order] WHERE OrderID = @OrderID)
        BEGIN
            THROW 51000,'No such order',1
        END
    IF NOT EXISTS(SELECT * FROM Product WHERE ProductID = @ProductID)
        BEGIN
            THROW 51000,'No such product',1
        END
    IF NOT EXISTS(SELECT * FROM MenuOn((SELECT CollectionDate FROM [Order] WHERE OrderID = @OrderID))
                  WHERE ProductID = @ProductID)
        BEGIN
            THROW 51000,'Item not in respective menu',1
        END
    SELECT @price = (SELECT Price
                  FROM MenuOn((SELECT CollectionDate FROM [Order]
                                                     WHERE OrderID = @OrderID))
                  WHERE ProductID = @ProductID)

    IF NOT EXISTS(SELECT * FROM OrderDetails
                           WHERE OrderID = @OrderID AND ProductID = @ProductID)
        BEGIN
            INSERT INTO OrderDetails VALUES (@OrderID, @ProductID, @Amount, @price)
        END
    ELSE
        BEGIN
            UPDATE OrderDetails SET Quantity = Quantity + @Amount WHERE OrderID = @OrderID AND ProductID = @ProductID
        END
    DECLARE @CustomerID AS INTEGER
    SELECT @CustomerID = (
        (SELECT CustomerID FROM [Order] WHERE OrderID = @OrderID)
        )
    IF EXISTS(SELECT * FROM IndividualCustomer WHERE CustomerID = @CustomerID)
    BEGIN
        UPDATE IndividualCustomer
        SET MoneyAccumulatedForNextDiscount = MoneyAccumulatedForNextDiscount + (@Amount*@price)
        WHERE CustomerID = @CustomerID;
    END
END
--
--
CREATE PROCEDURE CreateReservation @OrderID AS INTEGER,
                                   @StartDate AS DATETIME,
                                   @EndDate AS DATETIME,
                                   @TableNumber AS INTEGER
AS
BEGIN
    DECLARE @WK AS INTEGER
    SET @WK = 5
    DECLARE @WZ AS MONEY
    SET @WZ = 50
    IF NOT EXISTS(SELECT * FROM [Order] WHERE OrderID = @OrderID)
        BEGIN
            THROW 51000,'No such order',1
        END
    IF (SELECT Takeaway FROM [Order] WHERE OrderID = @OrderID) = 1
        BEGIN
            THROW 51000,'Cant create reservation for takeaway order',1
        END
    IF EXISTS(SELECT * FROM TableReservation WHERE OrderID = @OrderID)
        BEGIN
            THROW 51000,'This order already has an reservation',1
        END
    DECLARE @CustomerID AS INTEGER
    SELECT @CustomerID = (
        SELECT CustomerID FROM [Order] WHERE OrderID = @OrderID
        )
    IF dbo.NumberOfOrdersByCustomer(@CustomerID) < @WK
        BEGIN
            THROW 51000, ' orders required to make a reservation' , 1
        END
    IF (SELECT SUM(UnitPrice*Quantity) FROM OrderProducts(@OrderID)) < @WZ
        BEGIN
            THROW 51000, 'Order value must be at least ' , 1
        END
    IF NOT EXISTS(SELECT * FROM [Table] WHERE TableNumber = @TableNumber)
        BEGIN
            THROW 51000,'No such table',1
        END
    IF DATEDIFF(DAY, GETDATE(), @StartDate) < 0 OR DATEDIFF(DAY, GETDATE(), @EndDate) < 0
        BEGIN
            THROW 51000,'Cant create reservation for past date',1
        END
    IF DATEDIFF(DAY, @StartDate, @EndDate) < 0
        BEGIN
            THROW 51000,'End date must be greater than start date',1
        END
    IF @TableNumber NOT IN (SELECT * FROM FreeTables(@StartDate, @EndDate))
        BEGIN
            THROW 51000,'Table is not free during specified time',1
        END
    INSERT INTO TableReservation VALUES (@OrderID, @StartDate, @EndDate)
    DECLARE @ReservationID AS INTEGER
    SET @ReservationID = (SELECT ReservationID FROM TableReservation WHERE OrderID = @OrderID)
    INSERT INTO TableReservarionDetails VALUES (@ReservationID, @TableNumber)
    UPDATE [Order] SET CollectionDate = @StartDate WHERE OrderID = @OrderID
END



CREATE PROCEDURE AddPayment @OrderID AS INTEGER,
                            @Value AS MONEY
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM [Order] WHERE OrderID = @OrderID)
    BEGIN
        THROW 51000,'No such order',1
    END
    IF @Value <= 0
    BEGIN
        THROW 51000,'Amount must be positive', 1
    END
    IF NOT EXISTS(SELECT * FROM OrderProducts (@OrderID))
    BEGIN
        THROW 51000,'Order something before paying', 1
    END
    DECLARE @AmountPaid AS MONEY
    SELECT @AmountPaid = (
        SELECT SUM(AmountPaid) FROM Payment WHERE OrderID = @OrderID
        )
    DECLARE @RequitedAmount AS MONEY
    SELECT @RequitedAmount = (
                dbo.OrderValue(@OrderID)
        )
    IF @AmountPaid IS NULL
    BEGIN
        IF @RequitedAmount < @Value
        BEGIN
            THROW 51000,'Paid amount exceeds required amount', 1
        END
    END
    ELSE
    BEGIN
        IF @RequitedAmount - @AmountPaid < @Value
        BEGIN
            THROW 51000,'Paid amount exceeds required amount', 1
        END
    END
    INSERT INTO Payment VALUES (@OrderID,@Value,GETDATE())
END


CREATE PROCEDURE UseDiscount @OrderID AS INTEGER,
                             @DiscountID AS INTEGER
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM [Order] WHERE OrderID = @OrderID)
        BEGIN
            THROW 51000,'No such order',1
        END
    IF NOT EXISTS(SELECT * FROM Discount WHERE DiscountID = @DiscountID)
        BEGIN
            THROW 51000,'No such discount',1
        END
    IF  (SELECT Discount FROM [Order] WHERE OrderID = @OrderID) <> 0
        BEGIN
            THROW 51000,'Order has already applied discount',1
        END
    IF  (SELECT Used FROM Discount WHERE DiscountID = @DiscountID) = 1
        BEGIN
            THROW 51000,'Discount already used',1
        END
    DECLARE @Rate AS DECIMAL(5,2)
    SELECT @Rate = (
        SELECT DiscountRate FROM Discount WHERE DiscountID = @DiscountID
        )
    IF (SELECT ExpirationDate FROM Discount WHERE DiscountID = @DiscountID) IS NULL
        BEGIN
            UPDATE [Order] SET Discount = @Rate WHERE OrderID = @OrderID
        END
    ELSE
        BEGIN
            IF  (SELECT DATEDIFF(DAY, GETDATE(), ExpirationDate ) FROM Discount WHERE DiscountID = @DiscountID) < 0
            BEGIN
                THROW 51000,'Discount has expired', 1
            END
            BEGIN TRY
                BEGIN TRANSACTION;
                    UPDATE [Order] SET Discount = @Rate WHERE OrderID = @OrderID
                    UPDATE Discount SET Used = 1 WHERE DiscountID = @DiscountID
                COMMIT TRANSACTION;
            END TRY
            BEGIN CATCH
                ROLLBACK;
                THROW
            END CATCH
        END
END


CREATE PROCEDURE AddR2Discount @CustomerID AS INTEGER
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM Customer WHERE CustomerID = @CustomerID)
        BEGIN
            THROW 51000,'No such customer',1
        END
        DECLARE @K2 AS MONEY
        SET @K2 = 50
        DECLARE @R2 AS DECIMAL(5,2)
        SET @R2 = 0.05
        DECLARE @D1 AS INTEGER
        SET @D1 = 10
        INSERT INTO Discount VALUES (@CustomerID,@R2,DATEADD(DAY ,@D1,GETDATE()),0)
        UPDATE IndividualCustomer SET MoneyAccumulatedForNextDiscount = MoneyAccumulatedForNextDiscount - @K2
            WHERE CustomerID = @CustomerID
        IF (SELECT MoneyAccumulatedForNextDiscount FROM IndividualCustomer) >= @K2
        BEGIN
            EXEC AddR2Discount @CustomerID
        END
END

CREATE PROCEDURE AddPersonToReservation @ReservationID AS INTEGER,
                                        @FirstName AS nvarchar(30),
                                        @Surname AS nvarchar(30)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM TableReservation WHERE ReservationID = @ReservationID)
        BEGIN
            THROW 51000,'No such reservation',1
        END
        INSERT INTO Person VALUES (@ReservationID,@FirstName,@Surname)
END


CREATE PROCEDURE AddTableToReservation @ReservationID AS INTEGER,
                                       @TableNumber AS INTEGER
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM TableReservation WHERE ReservationID = @ReservationID)
        BEGIN
            THROW 51000,'No such reservation',1
        END
    IF NOT EXISTS(SELECT * FROM [Table] WHERE TableNumber = @TableNumber)
        BEGIN
            THROW 51000,'No such table',1
        END
    DECLARE @StartDate AS DATETIME
    DECLARE @EndDate AS DATETIME
    SELECT @StartDate = (
        SELECT ReservationStart FROM TableReservation WHERE ReservationID = @ReservationID
        )
    SELECT @EndDate = (
        SELECT ReservationEnd FROM TableReservation WHERE ReservationID = @ReservationID
        )
    IF @TableNumber NOT IN (SELECT * FROM FreeTables(@StartDate, @EndDate))
        BEGIN
            THROW 51000,'Table is not free during specified time',1
        END
    INSERT INTO TableReservarionDetails VALUES (@ReservationID,@TableNumber)
END


CREATE PROCEDURE CreateInvoice @OrderID AS INTEGER
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM [Order] WHERE OrderID = @OrderID)
        BEGIN
            THROW 51000,'No such order',1
        END
    IF ( SELECT InvoiceID FROM [Order] WHERE OrderID = @OrderID ) IS NOT NULL
        BEGIN
            THROW 51000,'Order already has an invoice',1
        END
    DECLARE @InvoiceID AS INTEGER
    DECLARE @TMP AS TABLE (
        InvoiceID INTEGER
                          )
    INSERT INTO Invoice OUTPUT inserted.InvoiceID INTO @TMP VALUES (GETDATE(),0)
    SELECT @InvoiceID = (
        SELECT * FROM @TMP
        )
    UPDATE [Order] SET InvoiceID = @InvoiceID WHERE OrderID = @OrderID
END

CREATE PROCEDURE CreateInvoiceMonthly @CustomerID AS INTEGER,
                                      @Month AS INTEGER,
                                      @Year AS INTEGER
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM [Company] WHERE CustomerID = @CustomerID)
        BEGIN
            THROW 51000,'No such order',1
        END
    IF NOT EXISTS(SELECT OrderID FROM [Order]
                       WHERE CustomerID = @CustomerID
                         AND MONTH(OrderDate) = @Month
                         AND YEAR(OrderDate) = @Year
                         AND InvoiceID IS NULL)
        BEGIN
            THROW 51000,'No orders without invoice',1
        END

    DECLARE @InvoiceID AS INTEGER
    DECLARE @TMP AS TABLE (
        InvoiceID INTEGER
                          )
    INSERT INTO Invoice OUTPUT inserted.InvoiceID INTO @TMP VALUES (GETDATE(),1)
    SELECT @InvoiceID = (
        SELECT * FROM @TMP
        )

    DECLARE @OrderID AS INTEGER
    DECLARE CursorOrder CURSOR FOR
            SELECT OrderID FROM [Order]
                       WHERE CustomerID = @CustomerID
                         AND MONTH(OrderDate) = @Month
                         AND YEAR(OrderDate) = @Year
                         AND InvoiceID IS NULL
    OPEN CursorOrder
    FETCH NEXT FROM CursorOrder INTO
        @OrderID
    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE [Order] SET InvoiceID = @InvoiceID WHERE OrderID = @OrderID
        FETCH NEXT FROM CursorOrder INTO
        @OrderID
    END
END