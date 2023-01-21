-- Category
Insert Into Category values ('Drink');

INSERT INTO Category values ('Desert');

INSERT INTO Category VALUES ('Seafood')

-- Product
INSERT INTO Product VALUES (1,'Tea',5,1);

INSERT INTO Product VALUES (2,'Water',3,1);

INSERT INTO Product VALUES (3,'Lobster',40,3);

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

INSERT INTO [TableReservation] VALUES (1,'2023-01-10 00:00:00','2023-01-20 00:00:00')

INSERT INTO [TableReservarionDetails] VALUES (1,1,3)