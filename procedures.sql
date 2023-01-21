CREATE PROCEDURE CreateMenu @StartDate AS DATE,
                            @EndDate AS DATE
AS
BEGIN;
    IF (@StartDate < GETDATE())
        BEGIN;
            THROW 51000, 'Cannot create menu for the past', 1;
        END;
    IF (@EndDate < @StartDate)
        BEGIN;
            THROW 51000, 'Start date cannot be later than end date.', 1;
        END;
    INSERT INTO Menu VALUES (@StartDate,@EndDate,0);
END;
GO;

CREATE PROCEDURE AddItemToMenu @ProductID AS INTEGER,
                               @MenuID AS INTEGER
AS
BEGIN;
    IF NOT EXISTS (SELECT * FROM Product WHERE ProductID = @ProductID)
        BEGIN;
            THROW 51000, 'No such product', 1;
        END;
    IF NOT EXISTS (SELECT * FROM Menu WHERE MenuID = @MenuID)
        BEGIN;
            THROW 51000, 'No such menu', 1;
        END;
    IF EXISTS (SELECT * FROM MenuDetails WHERE MenuID = @MenuID AND ProductID = @ProductID)
        BEGIN;
            THROW 51000, 'Item already in menu', 1;
        END;
    DECLARE @price AS MONEY;
    SET @price = (Select Price FROM Product WHERE ProductID = @ProductID);
    INSERT INTO MenuDetails VALUES (@MenuID,@ProductID,@price);
END;
GO;

CREATE PROCEDURE DeleteItemFromMenu @MenuID AS INT,
                                    @ProductID AS INT
AS
BEGIN;
    IF NOT EXISTS (SELECT * FROM Menu WHERE MenuID = @MenuID)
        BEGIN;
            THROW 51000, 'No such menu.', 1;
        END;
    IF NOT EXISTS (SELECT * FROM MenuDetails WHERE MenuID = @MenuID AND ProductID = @ProductID)
        BEGIN;
            THROW 51000, 'Item not in respective menu', 1;
        END;
    DELETE FROM MenuDetails WHERE MenuID = @MenuID AND ProductID = @ProductID;
END;
GO;

CREATE PROCEDURE ValidateMenu @MenuID AS INT
AS
BEGIN;
    IF NOT EXISTS (SELECT * FROM Menu WHERE MenuID = @MenuID)
        BEGIN;
            THROW 51000, 'No such menu', 1;
        END;
    DECLARE @startdate2 AS DATE;
    DECLARE @enddate2 AS DATE;
    SET @startdate2 = (
        SELECT StartDate FROM Menu
        WHERE MenuID = @MenuID
    );
    SET @enddate2 = (
        SELECT EndDate FROM Menu
        WHERE MenuID = @MenuID
    );
    IF EXISTS (SELECT * FROM MenuDetails 
        INNER JOIN Product
        ON MenuDetails.ProductID = Product.ProductID
        INNER JOIN Category
        ON Product.CategoryID = Category.CategoryID
        WHERE MenuID = @MenuID AND Category.Name = 'Seafood'
    )
    AND NOT DATEPART(WEEKDAY, @startdate2) BETWEEN 5 AND 7
    OR NOT DATEPART(WEEKDAY, @enddate2) BETWEEN 5 AND 7
    OR DATEDIFF(day, @startdate2, @enddate2) > 2
        BEGIN;
            THROW 51000, 'Seafood is not available between Sunday and Wednesday', 1;
        END;
    IF EXISTS(SELECT * FROM Menu WHERE
    (
        (StartDate BETWEEN @startdate2 AND @enddate2
        OR EndDate BETWEEN @startdate2 AND @enddate2
        OR @startdate2 BETWEEN StartDate AND EndDate)
        AND MenuID != @MenuID
        AND IsValid = 1
    )
    )
        BEGIN;
            THROW 51000, 'Menu overlaps other menu that is valid', 1;
        END;
    IF EXISTS (
        SELECT * FROM MenuDetails 
        INNER JOIN Product
        ON MenuDetails.ProductID = Product.ProductID
        WHERE MenuID = @MenuID AND Product.Available = 0
    )
        BEGIN;
            THROW 51000, 'One of the products is not available', 1;
        END;
    DECLARE @previousmenu AS INT;
    SET @previousmenu = (
        SELECT MenuID from Menu
        WHERE EndDate = DATEADD(day, -1, @startdate2)
        AND IsValid = 1
    )
    IF DATEDIFF(day, (SELECT LastSignificantMenuChange from AuxiliaryValues), @startdate2) > 14
    AND (2 * (SELECT COUNT(*) FROM MenuDetails AS P
    INNER JOIN MenuDetails AS N
    ON P.ProductID = N.ProductID
    WHERE P.MenuID = @previousmenu
    AND N.MenuID = @MenuID)) > (
        SELECT COUNT(*) FROM MenuDetails
        WHERE MenuID = @previousmenu
    )
    BEGIN;
        THROW 51000, 'New menu cannot have more than 50% of the products from the previous menu', 1;
    END;
    BEGIN;
        UPDATE AuxiliaryValues SET LastSignificantMenuChange = @startdate2
        UPDATE Menu SET IsValid = 1 WHERE MenuID = @MenuID
    END;
END;
GO;