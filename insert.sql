-- Category
Insert Into Category values ('Drink'); --id 1

INSERT INTO Category values ('Desert'); -- id 2

INSERT INTO Category VALUES ('Seafood'); -- id 11

INSERT INTO Category VALUES ('Pizza'); -- id 12

INSERT INTO Category VALUES ('Pasta'); -- id 13

INSERT INTO Category VALUES ('Salad'); -- id 14

INSERT INTO Category VALUES ('Soup'); -- id 15

INSERT INTO Category VALUES ('Beef'); -- id 16

select * from Category

-- Product
INSERT INTO Product VALUES (1,'Tea',5,1);

INSERT INTO Product VALUES (1,'Water',3,1);

INSERT INTO Product VALUES (11,'Lobster',40,1);

INSERT INTO Product VALUES (2,'Cheesecake',15,1);

INSERT INTO Product VALUES (12,'Margherita', 25, 1)

INSERT INTO Product VALUES (13,'Spaghetti Bolognese', 25, 1)

INSERT INTO Product VALUES (14,'Caesar Salad', 15, 1)

INSERT INTO Product VALUES (15,'Tomato Soup', 10, 0)

INSERT INTO Product VALUES (16,'Cheeseburger', 32, 1)

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

-- INSERT INTO [TableReservarionDetails] VALUES (1,1,3)