ALTER TABLE Discount
    ADD CONSTRAINT CHK_NULLDatePermDsc
        CHECK ( (ExpirationDate IS NOT NULL) OR ( ExpirationDate IS NULL AND Used = 0) )

ALTER TABLE Discount
    ADD CONSTRAINT CHK_DiscountRate
        CHECK ( DiscountRate <= 1 AND DiscountRate > 0 )

ALTER TABLE [Order]
    ADD CONSTRAINT CHK_Discount
        CHECK ( Discount <= 1 AND Discount >= 0 )

ALTER TABLE Product
    ADD CONSTRAINT CHK_P_Price
        CHECK ( Price > 0 )

ALTER TABLE MenuDetails
    ADD CONSTRAINT CHK_MD_Price
        CHECK ( Price > 0 )

ALTER TABLE Menu
    ADD CONSTRAINT CHK_M_Price
        CHECK ( EndDate > Menu.StartDate )

ALTER TABLE [Order]
    ADD CONSTRAINT CHK_O_DiscountRate
        CHECK ( Discount <= 1 AND Discount >= 0 )

ALTER TABLE [Order]
    ADD CONSTRAINT CHK_O_Dates
        CHECK ( CollectionDate >= [Order].OrderDate )


ALTER TABLE OrderDetails
    ADD CONSTRAINT CHK_OD_Price
        CHECK ( UnitPrice > 0 )

ALTER TABLE OrderDetails
    ADD CONSTRAINT CHK_OD_Quantity
        CHECK ( Quantity > 0 )

ALTER TABLE Payment
    ADD CONSTRAINT CHK_PAY_Aount
        CHECK ( AmountPaid > 0 )


ALTER TABLE TableReservation
    ADD CONSTRAINT CHK_TR_Dates
        CHECK ( ReservationEnd > TableReservation.ReservationStart )

ALTER TABLE [Table]
    ADD CONSTRAINT CHK_T_Seats
        CHECK ( NumberOfSeats > 0 )


ALTER TABLE IndividualCustomer
    ADD CONSTRAINT CHK_IC_Money
        CHECK ( MoneyAccumulatedForNextDiscount >= 0 )

