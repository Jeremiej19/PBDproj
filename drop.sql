-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-01-03 12:14:54.902

-- foreign keys
ALTER TABLE Company DROP CONSTRAINT Company_Customer;

ALTER TABLE Discount DROP CONSTRAINT Discount_IndividualCustomer;

ALTER TABLE IndividualCustomer DROP CONSTRAINT IndividualCustomer_Customer;

ALTER TABLE MenuDetails DROP CONSTRAINT MenuDetails_Menu;

ALTER TABLE MenuDetails DROP CONSTRAINT MenuDetails_Product;

ALTER TABLE OrderDetails DROP CONSTRAINT OrderDetails_Order;

ALTER TABLE OrderDetails DROP CONSTRAINT OrderDetails_Product;

ALTER TABLE Payment DROP CONSTRAINT OrderPayments_Order;

ALTER TABLE "Order" DROP CONSTRAINT Order_Customer;

ALTER TABLE "Order" DROP CONSTRAINT Order_Invoice;

ALTER TABLE Person DROP CONSTRAINT Person_TableReservation;

ALTER TABLE Product DROP CONSTRAINT Product_Category;

ALTER TABLE TableReservarionDetails DROP CONSTRAINT TableReservarionDetails_Table;

ALTER TABLE TableReservarionDetails DROP CONSTRAINT TableReservarionDetails_TableReservation;

ALTER TABLE TableReservation DROP CONSTRAINT TableReservation_Order;

-- tables
DROP TABLE Category;

DROP TABLE Company;

DROP TABLE Customer;

DROP TABLE Discount;

DROP TABLE IndividualCustomer;

DROP TABLE Invoice;

DROP TABLE Menu;

DROP TABLE MenuDetails;

DROP TABLE "Order";

DROP TABLE OrderDetails;

DROP TABLE Payment;

DROP TABLE Person;

DROP TABLE Product;

DROP TABLE "Table";

DROP TABLE TableReservarionDetails;

DROP TABLE TableReservation;

-- sequences
-- DROP SEQUENCE Category_seq;
--
-- DROP SEQUENCE Company_seq;
--
-- DROP SEQUENCE Customer_seq;
--
-- DROP SEQUENCE IndividualClient_seq;
--
-- DROP SEQUENCE Invoice_seq;
--
-- DROP SEQUENCE Menu_seq;
--
-- DROP SEQUENCE MonthlyInvoice_seq;
--
-- DROP SEQUENCE Order_seq;
--
-- DROP SEQUENCE Product_seq;
--
-- DROP SEQUENCE TableReservation_seq;
--
-- DROP SEQUENCE Table_seq;

-- End of file.

