CREATE VIEW CurrentMenu AS
SELECT P.ProductID, P.Name, MD.Price
from menu M
    INNER JOIN MenuDetails MD on M.MenuID = MD.MenuID
    INNER JOIN Product P on P.ProductID = MD.ProductID
WHERE DATEDIFF(day, StartDate, GETDATE()) >= 0
AND DATEDIFF(day, EndDate, GETDATE()) < 0
AND P.Available = 1;


DROP VIEW CurrentMenu
