-- Category
Insert Into Category values ('Drink');

INSERT INTO Category values ('Desert');

-- Product
INSERT INTO Product VALUES (1,'Tea',5,1);

INSERT INTO Product VALUES (1,'Water',3,1);

INSERT INTO Product VALUES (1,'Coffe',7,1);

INSERT INTO Menu VALUES ('2023-01-01','2023-01-14',1)


INSERT INTO MenuDetails VALUES (1,1,5);

INSERT INTO MenuDetails VALUES (1,2,3);


INSERT INTO Menu VALUES('2023-01-14','2023-01-16',1);


INSERT INTO Customer VALUES('123456789',null);

INSERT INTO Invoice VALUES (GETDATE(),0);

INSERT INTO [Order] VALUES( 1,1, GETDATE(), null, 0, 0,0  );

INSERT INTO OrderDetails VALUES( 1, 1, 2, 5 )

INSERT INTO [Table] VALUES (5)

INSERT INTO [Table] VALUES (10)
INSERT INTO [Table] VALUES (15)

INSERT INTO [TableReservation] VALUES (1,'2023-01-10 00:00:00','2023-01-20 00:00:00')

INSERT INTO [TableReservarionDetails] VALUES (1,1,3)

INSERT INTO Menu VALUES('2023-01-17','2023-01-20',1);

INSERT INTO MenuDetails VALUES (3,1,5);

INSERT INTO MenuDetails VALUES (3,2,3);

INSERT INTO IndividualCustomer VALUES (1,'Jan','Kowalski',0)
INSERT INTO IndividualCustomer VALUES (2,'Piotr','Nowak',0)

INSERT INTO Company VALUES (3,'1234567890','Cisco')
INSERT INTO Company VALUES (4,'0123456789','Comarch')

INSERT INTO Discount VALUES (1,3,NULL,0)

INSERT INTO AuxiliaryValues VALUES (50,10,30,100,0.03,0.05,10,'2023-01-21')

INSERT INTO Company VALUES (1,'0123456789','Azoty')

