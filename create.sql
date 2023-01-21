-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-01-03 12:14:54.902

-- tables
-- Table: Category
USE u_sliwinsk;

CREATE TABLE Category (
    CategoryID int  NOT NULL IDENTITY,
    Name nvarchar(20)  NOT NULL,
    CONSTRAINT Category_pk PRIMARY KEY  (CategoryID)
);

-- Table: Company
CREATE TABLE Company (
    CustomerID int  NOT NULL IDENTITY,
    NIP char(10)  NOT NULL,
    CompanyName nvarchar(50)  NOT NULL,
    CONSTRAINT Company_pk PRIMARY KEY  (CustomerID)
);

-- Table: Customer
CREATE TABLE Customer (
    CustomerID int  NOT NULL IDENTITY,
    Phone char(9)  NOT NULL,
    Fax char(10)  NULL,
    CONSTRAINT Customer_pk PRIMARY KEY  (CustomerID)
);

-- Table: Discount
CREATE TABLE Discount (
    DiscountID int  NOT NULL IDENTITY,
    CustomerID int  NOT NULL,
    DiscountRate DECIMAL(5,2)  NOT NULL,
    ExpirationDate date  NULL,
    Used bit  NOT NULL,
    CONSTRAINT CustomerID PRIMARY KEY  (DiscountID)
);

-- Table: IndividualCustomer
CREATE TABLE IndividualCustomer (
    CustomerID int  NOT NULL IDENTITY,
    Firstname nvarchar(30)  NOT NULL,
    Surname nvarchar(30)  NOT NULL,
    MoneyAccumulatedForNextDiscount money  NOT NULL,
    CONSTRAINT IndividualClient_pk PRIMARY KEY  (CustomerID)
);

-- Table: Invoice
CREATE TABLE Invoice (
    InvoiceID int  NOT NULL IDENTITY,
    CreateDate datetime  NOT NULL,
    IsMonthly bit  NOT NULL,
    CONSTRAINT Invoice_pk PRIMARY KEY  (InvoiceID)
);

-- Table: Menu
CREATE TABLE Menu (
    MenuID int  NOT NULL IDENTITY,
    StartDate date  NOT NULL,
    EndDate date  NOT NULL,
    IsValid bit  NOT NULL,
    CONSTRAINT Menu_pk PRIMARY KEY  (MenuID)
);

-- Table: MenuDetails
CREATE TABLE MenuDetails (
    MenuID int  NOT NULL,
    ProductID int  NOT NULL,
    Price money  NOT NULL,
    CONSTRAINT MenuDetails_pk PRIMARY KEY  (MenuID,ProductID)
);

-- Table: Order
CREATE TABLE "Order" (
    OrderID int  NOT NULL IDENTITY,
    CustomerID int  NOT NULL,
    InvoiceID int  NULL,
    OrderDate datetime  NOT NULL,
    CollectionDate datetime NOT NULL,
    Discount DECIMAL(5,2)  NOT NULL,
    Takeaway bit  NOT NULL,
    Cancelled bit  NOT NULL,
    CONSTRAINT Order_pk PRIMARY KEY  (OrderID)
);

-- Table: OrderDetails
CREATE TABLE OrderDetails (
    OrderID int  NOT NULL,
    ProductID int  NOT NULL,
    Quantity int  NOT NULL,
    UnitPrice money  NOT NULL,
    CONSTRAINT OrderDetails_pk PRIMARY KEY  (OrderID,ProductID)
);

-- Table: Payment
CREATE TABLE Payment (
    PaymentID int  NOT NULL IDENTITY,
    OrderID int  NOT NULL,
    AmountPaid money  NOT NULL,
    PaymentDate datetime  NOT NULL,
    CONSTRAINT OrderID PRIMARY KEY  (PaymentID)
);

-- Table: Person
CREATE TABLE Person (
    PersonID int  NOT NULL IDENTITY,
    ReservationID int  NOT NULL,
    Firstname nvarchar(30)  NOT NULL,
    Surname nvarchar(30)  NOT NULL,
    CONSTRAINT Person_pk PRIMARY KEY  (PersonID)
);

-- Table: Product
CREATE TABLE Product (
    ProductID int  NOT NULL IDENTITY,
    CategoryID int  NOT NULL,
    Name varchar(50)  NOT NULL,
    Price money  NOT NULL,
    Available bit  NOT NULL,
    CONSTRAINT Product_pk PRIMARY KEY  (ProductID)
);

-- Table: Table
CREATE TABLE "Table" (
    TableNumber int  NOT NULL IDENTITY,
    NumberOfSeats int  NOT NULL,
    CONSTRAINT Table_pk PRIMARY KEY  (TableNumber)
);

-- Table: TableReservarionDetails
CREATE TABLE TableReservarionDetails (
    ReservationID int  NOT NULL,
    TableNumber int  NOT NULL,
    CONSTRAINT TableReservarionDetails_pk PRIMARY KEY  (TableNumber,ReservationID)
);

-- Table: TableReservation
CREATE TABLE TableReservation (
    ReservationID int  NOT NULL IDENTITY,
    OrderID int  NOT NULL,
    ReservationStart datetime  NOT NULL,
    ReservationEnd datetime  NOT NULL,
    CONSTRAINT TableReservation_pk PRIMARY KEY  (ReservationID)
);

-- foreign keys
-- Reference: Company_Customer (table: Company)
ALTER TABLE Company ADD CONSTRAINT Company_Customer
    FOREIGN KEY (CustomerID)
    REFERENCES Customer (CustomerID);

-- Reference: Discount_IndividualCustomer (table: Discount)
ALTER TABLE Discount ADD CONSTRAINT Discount_IndividualCustomer
    FOREIGN KEY (CustomerID)
    REFERENCES IndividualCustomer (CustomerID);

-- Reference: IndividualCustomer_Customer (table: IndividualCustomer)
ALTER TABLE IndividualCustomer ADD CONSTRAINT IndividualCustomer_Customer
    FOREIGN KEY (CustomerID)
    REFERENCES Customer (CustomerID);

-- Reference: MenuDetails_Menu (table: MenuDetails)
ALTER TABLE MenuDetails ADD CONSTRAINT MenuDetails_Menu
    FOREIGN KEY (MenuID)
    REFERENCES Menu (MenuID);

-- Reference: MenuDetails_Product (table: MenuDetails)
ALTER TABLE MenuDetails ADD CONSTRAINT MenuDetails_Product
    FOREIGN KEY (ProductID)
    REFERENCES Product (ProductID);

-- Reference: OrderDetails_Order (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Order
    FOREIGN KEY (OrderID)
    REFERENCES "Order" (OrderID);

-- Reference: OrderDetails_Product (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Product
    FOREIGN KEY (ProductID)
    REFERENCES Product (ProductID);

-- Reference: OrderPayments_Order (table: Payment)
ALTER TABLE Payment ADD CONSTRAINT OrderPayments_Order
    FOREIGN KEY (OrderID)
    REFERENCES "Order" (OrderID);

-- Reference: Order_Customer (table: Order)
ALTER TABLE "Order" ADD CONSTRAINT Order_Customer
    FOREIGN KEY (CustomerID)
    REFERENCES Customer (CustomerID);

-- Reference: Order_Invoice (table: Order)
ALTER TABLE "Order" ADD CONSTRAINT Order_Invoice
    FOREIGN KEY (InvoiceID)
    REFERENCES Invoice (InvoiceID);

-- Reference: Person_TableReservation (table: Person)
ALTER TABLE Person ADD CONSTRAINT Person_TableReservation
    FOREIGN KEY (ReservationID)
    REFERENCES TableReservation (ReservationID);

-- Reference: Product_Category (table: Product)
ALTER TABLE Product ADD CONSTRAINT Product_Category
    FOREIGN KEY (CategoryID)
    REFERENCES Category (CategoryID);

-- Reference: TableReservarionDetails_Table (table: TableReservarionDetails)
ALTER TABLE TableReservarionDetails ADD CONSTRAINT TableReservarionDetails_Table
    FOREIGN KEY (TableNumber)
    REFERENCES "Table" (TableNumber);

-- Reference: TableReservarionDetails_TableReservation (table: TableReservarionDetails)
ALTER TABLE TableReservarionDetails ADD CONSTRAINT TableReservarionDetails_TableReservation
    FOREIGN KEY (ReservationID)
    REFERENCES TableReservation (ReservationID);

-- Reference: TableReservation_Order (table: TableReservation)
ALTER TABLE TableReservation ADD CONSTRAINT TableReservation_Order
    FOREIGN KEY (OrderID)
    REFERENCES "Order" (OrderID);


CREATE TABLE AuxiliaryValues (
   MinValueOfOrderToBookTable int  NOT NULL,
   MinNumberOfOrdersForPermanentDiscount int  NOT NULL,
   MinValueOfOrderForPermanentDiscount MONEY  NOT NULL,
   MinTotalValueOfOrdersForOneTimeDiscount MONEY  NOT NULL,
   RateOfPermanentDiscount DECIMAL(5,2)  NOT NULL,
   RateOfOneTimeDiscount DECIMAL(5,2)  NOT NULL,
   OneTimeDiscountValidityLength int  NOT NULL,
   LastSignificantMenuChange date  NOT NULL
);


-- -- sequences
-- -- Sequence: Category_seq
-- CREATE SEQUENCE Category_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MINVALUE
--     NO MAXVALUE
--     NO CYCLE
--     NO CACHE;
--
-- -- Sequence: Company_seq
-- CREATE SEQUENCE Company_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MINVALUE
--     NO MAXVALUE
--     NO CYCLE
--     NO CACHE;
--
-- -- Sequence: Customer_seq
-- CREATE SEQUENCE Customer_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MINVALUE
--     NO MAXVALUE
--     NO CYCLE
--     NO CACHE;
--
-- -- Sequence: IndividualClient_seq
-- CREATE SEQUENCE IndividualClient_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MINVALUE
--     NO MAXVALUE
--     NO CYCLE
--     NO CACHE;
--
-- -- Sequence: Invoice_seq
-- CREATE SEQUENCE Invoice_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MINVALUE
--     NO MAXVALUE
--     NO CYCLE
--     NO CACHE;
--
-- -- Sequence: Menu_seq
-- CREATE SEQUENCE Menu_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MINVALUE
--     NO MAXVALUE
--     NO CYCLE
--     NO CACHE;
--
-- -- Sequence: MonthlyInvoice_seq
-- CREATE SEQUENCE MonthlyInvoice_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MINVALUE
--     NO MAXVALUE
--     NO CYCLE
--     NO CACHE;
--
-- -- Sequence: Order_seq
-- CREATE SEQUENCE Order_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MINVALUE
--     NO MAXVALUE
--     NO CYCLE
--     NO CACHE;
--
-- -- Sequence: Product_seq
-- CREATE SEQUENCE Product_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MINVALUE
--     NO MAXVALUE
--     NO CYCLE
--     NO CACHE;
--
-- -- Sequence: TableReservation_seq
-- CREATE SEQUENCE TableReservation_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MINVALUE
--     NO MAXVALUE
--     NO CYCLE
--     NO CACHE;
--
-- -- Sequence: Table_seq
-- CREATE SEQUENCE Table_seq
--     START WITH 1
--     INCREMENT BY 1
--     NO MINVALUE
--     NO MAXVALUE
--     NO CYCLE
--     NO CACHE;
--
-- -- End of file.

