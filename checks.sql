ALTER TABLE Discount
    ADD CONSTRAINT CHK_NULLDatePermDsc
        CHECK ( (ExpirationDate IS NOT NULL) OR ( ExpirationDate IS NULL AND Used = 0) )

