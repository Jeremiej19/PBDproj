ALTER TABLE Discount
    ADD CONSTRAINT CHK_NULLDatePermDsc
        CHECK ( (ExpirationDate IS NOT NULL) OR ( ExpirationDate IS NULL AND Used = 0) )

ALTER TABLE Discount
    ADD CONSTRAINT CHK_DiscountRate
        CHECK ( DiscountRate <= 1 AND DiscountRate > 0 )

ALTER TABLE [Order]
    ADD CONSTRAINT CHK_Discount
        CHECK ( Discount <= 1 AND Discount >= 0 )

