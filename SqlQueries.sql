USE UserDefinedTypes;

CREATE ASSEMBLY ListType  
FROM 'C:\Users\Cherry\Desktop\UDT\ListType\ListType\bin\Debug\ListType.dll'   
WITH PERMISSION_SET = SAFE; 

CREATE TYPE ListType   
EXTERNAL NAME ListType.[ListType];

CREATE TABLE FoodItems(
	ID int IDENTITY(1,1) PRIMARY KEY, 
	Items ListType
);

INSERT INTO FoodItems (Items) VALUES ('Biryani,lol,lofeaij,oiagejg,oisdj,');
INSERT INTO FoodItems (Items) VALUES ('dosa,idli,vada,puri');
INSERT INTO FoodItems (Items) VALUES ('pizza,');

UPDATE FoodItems set Items =  'rosie' WHERE Id=4;

DECLARE @listTypeVariable ListType;
SELECT @listTypeVariable = Items FROM FoodItems WHERE Id = 4;
SELECT @listTypeVariable.ToString();
SELECT @listTypeVariable.ToString();
SELECT @listTypeVariable.SecondName AS Items;

DECLARE @var ListType;
SET @var = (SELECT Items FROM FoodItems WHERE Id=2);
SELECT @var.ToString() AS Items;
SET @var.AddItem('lo');

UPDATE FoodItems
SET Items = CAST('LOL,OOIJG,OIGIJA' AS ListType)
WHERE Id=1;


SELECT
	Id, Items.GetItem(3) AS Items
FROM FoodItems
WHERE Id=2;

SELECT Items.ToString()
FROM FoodItems;

DECLARE @itemsVariable ListType;
SELECT @itemsVariable = Items FROM FoodItems WHERE Id = 1;
SET @itemsVariable.FirstName = 'Ramesh';
SET @itemsVariable.SecondName = 'Suresh';
SELECT @itemsVariable.ToString() AS Items;
SET @itemsVariable.FirstName = 'Cherry';
SELECT @itemsVariable.SecondName AS Items;

DROP TABLE FoodItems;  
DROP TYPE ListType;  
DROP ASSEMBLY ListType;  