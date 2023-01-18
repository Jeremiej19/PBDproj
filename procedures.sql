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
    IF (SELECT Takeaway FROM [Order] WHERE OrderID = @OrderID) = 1
        BEGIN
            IF NOT EXISTS(SELECT *
                          FROM MenuOn((SELECT CollectionDate FROM [Order] WHERE OrderID = @OrderID))
                          WHERE ProductID = @ProductID)
                BEGIN
                    THROW 51000,'Item not in respective menu',1
                END
            SET @price = (SELECT Price
                          FROM MenuOn((SELECT CollectionDate FROM [Order] WHERE OrderID = @OrderID))
                          WHERE ProductID = @ProductID)
        END
    ELSE
        BEGIN
            IF NOT EXISTS(SELECT * FROM CurrentMenu WHERE ProductID = @ProductID)
                BEGIN
                    THROW 51000,'Item not in current menu',1
                END
            SET @price = (SELECT Price FROM CurrentMenu WHERE ProductID = @ProductID)
        END
    IF NOT EXISTS(SELECT * FROM OrderDetails WHERE OrderID = @OrderID AND ProductID = @ProductID)
        BEGIN
            INSERT INTO OrderDetails VALUES (@OrderID, @ProductID, @Amount, @price)
        END
    ELSE
        BEGIN
            UPDATE OrderDetails SET Quantity = Quantity + @Amount
        END
END
--
--
CREATE PROCEDURE CreateReservation @OrderID AS INTEGER,
                                   @TableNumber AS INTEGER,
                                   @StartDate AS DATETIME,
                                   @EndDate AS DATETIME
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM [Order] WHERE OrderID = @OrderID)
        BEGIN
            THROW 51000,'No such order',1
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
    IF EXISTS(SELECT * FROM TableReservation WHERE OrderID = @OrderID)
        BEGIN
            THROW 51000,'This order already has an reservation',1
        END
    INSERT INTO TableReservation VALUES (@OrderID, @StartDate, @EndDate)
    DECLARE @ReservationID AS INTEGER
    SET @ReservationID = (SELECT ReservationID FROM TableReservation WHERE OrderID = @OrderID)
    INSERT INTO TableReservarionDetails VALUES (@ReservationID, @TableNumber)
END



DROP PROCEDURE AddItemToOrder
DROP PROCEDURE CreateReservation
