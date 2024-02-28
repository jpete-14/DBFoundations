--*************************************************************************--
-- Title: Assignment06
-- Author: YourNameHere
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2017-01-01,YourNameHere,Created File
-- 2024-02-21,JPeterson,Modified File
-- 2024-02-27,JPeterson,Modified File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_JPeterson')
	 Begin 
	  Alter Database [Assignment06DB_JPeterson] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_JPeterson;
	 End
	Create Database Assignment06DB_JPeterson;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_JPeterson;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10 -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, UnitsInStock + 20 -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers *********************************/
print 
'NOTES------------------------------------------------------------------------------------ 
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'

-- Question 1 (5% pts): How can you create BASIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!
/*
-View all tables.
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

-Create views.
CREATE VIEW
	vCategories
AS SELECT
	CategoryID
	,CategoryName
FROM
	dbo.Categories
	;
GO

CREATE VIEW
	vEmployees
AS SELECT
	EmployeeID
	,EmployeeFirstName
	,EmployeeLastName
	,ManagerID
FROM
	dbo.Employees
;
GO

CREATE VIEW
	vInventories
AS SELECT
	InventoryID
	,InventoryDate
	,EmployeeID
	,ProductID
	,Count
FROM
	dbo.Inventories
;
GO

CREATE VIEW
	vProducts
AS SELECT
	ProductID
	,ProductName
	,CategoryID
	,UnitPrice
FROM
	dbo.Products
;
GO

-Final code includes Schema Binding. 


CREATE VIEW
	vCategories
WITH SCHEMABINDING 
AS SELECT
	CategoryID
	,CategoryName
FROM
	dbo.Categories
	;
GO

CREATE VIEW
	vEmployees
WITH SCHEMABINDING 
AS SELECT
	EmployeeID
	,EmployeeFirstName
	,EmployeeLastName
	,ManagerID
FROM
	dbo.Employees
;
GO

CREATE VIEW
	vInventories
WITH SCHEMABINDING 
AS SELECT
	InventoryID
	,InventoryDate
	,EmployeeID
	,ProductID
	,Count
FROM
	dbo.Inventories
;
GO

CREATE VIEW
	vProducts
WITH SCHEMABINDING 
AS SELECT
	ProductID
	,ProductName
	,CategoryID
	,UnitPrice
FROM
	dbo.Products
;
GO
*/
USE
	Assignment06DB_JPeterson
	;
GO

CREATE VIEW
	vCategories
WITH SCHEMABINDING 
AS SELECT
	CategoryID
	,CategoryName
FROM
	dbo.Categories
	;
GO

CREATE VIEW
	vEmployees
WITH SCHEMABINDING 
AS SELECT
	EmployeeID
	,EmployeeFirstName
	,EmployeeLastName
	,ManagerID
FROM
	dbo.Employees
;
GO

CREATE VIEW
	vInventories
WITH SCHEMABINDING 
AS SELECT
	InventoryID
	,InventoryDate
	,EmployeeID
	,ProductID
	,Count
FROM
	dbo.Inventories
;
GO

CREATE VIEW
	vProducts
WITH SCHEMABINDING 
AS SELECT
	ProductID
	,ProductName
	,CategoryID
	,UnitPrice
FROM
	dbo.Products
;
GO

Select * 
	From 
	vCategories;
go
Select * 
	From 
	vProducts;
go
Select * 
	From 
	vEmployees;
go
Select * 
	From 
	vInventories;
go
-- Question 2 (5% pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?
/*
-View all tables.
Select * From vCategories;
go
Select * From vProducts;
go
Select * From vEmployees;
go
Select * From vInventories;
go

-Create a public view for each table.
CREATE VIEW
	vPublicCategories
WITH SCHEMABINDING 
AS SELECT
	CategoryID
	,CategoryName
FROM
	dbo.Categories
	;
GO

CREATE VIEW
	vPublicEmployees
WITH SCHEMABINDING 
AS SELECT
	EmployeeID
	,EmployeeFirstName
	,EmployeeLastName
	,ManagerID
FROM
	dbo.Employees
;
GO

CREATE VIEW
	vPublicInventories
WITH SCHEMABINDING 
AS SELECT
	InventoryID
	,InventoryDate
	,EmployeeID
	,ProductID
	,Count
FROM
	dbo.Inventories
;
GO

CREATE VIEW
	vPublicProducts
WITH SCHEMABINDING 
AS SELECT
	ProductID
	,ProductName
	,CategoryID
	,UnitPrice
FROM
	dbo.Products
;
GO

SELECT
	*
FROM
	vPublicCategories
	;
GO

SELECT
	*
FROM
	vPublicEmployees
	;
GO

SELECT
	*
FROM
	vPublicInventories
	;
GO

SELECT
	*
FROM
	vPublicProducts
	;
GO

-Final code includes protection permissions, deny database tables and grant public views.

USE
	Assignment06DB_JPeterson
	;
GO

DENY SELECT ON
	Categories
	TO PUBLIC
	;
GRANT SELECT ON
	vPublicCategories
	TO PUBLIC
	;
GO

DENY SELECT ON
	Employees
	TO PUBLIC
	;
GRANT SELECT ON
	vPublicEmployees
	TO PUBLIC
	;
GO

DENY SELECT ON
	Inventories
	TO PUBLIC
	;
GRANT SELECT ON
	vPublicInventories
	TO PUBLIC
	;
GO

DENY SELECT ON
	Products
	TO PUBLIC
	;
GRANT SELECT ON
	vPublicProducts
	TO PUBLIC
	;
GO

SELECT
	*
FROM
	vPublicCategories
	;
GO

SELECT
	*
FROM
	vPublicEmployees
	;
GO

SELECT
	*
FROM
	vPublicInventories
	;
GO

SELECT
	*
FROM
	vPublicProducts
	;
GO
*/

USE
	Assignment06DB_JPeterson
	;
GO

DENY SELECT ON
	Categories
	TO PUBLIC
	;
GRANT SELECT ON
	vPublicCategories
	TO PUBLIC
	;
GO

DENY SELECT ON
	Employees
	TO PUBLIC
	;
GRANT SELECT ON
	vPublicEmployees
	TO PUBLIC
	;
GO

DENY SELECT ON
	Inventories
	TO PUBLIC
	;
GRANT SELECT ON
	vPublicInventories
	TO PUBLIC
	;
GO

DENY SELECT ON
	Products
	TO PUBLIC
	;
GRANT SELECT ON
	vPublicProducts
	TO PUBLIC
	;
GO

SELECT
	*
	FROM
	vPublicCategories
	;
GO

SELECT
	*
	FROM
	vPublicEmployees
	;
GO

SELECT
	*
	FROM
	vPublicInventories
	;
GO

SELECT
	*
	FROM
	vPublicProducts
	;
GO

-- Question 3 (10% pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!

/*
-View Category and Products tables.
Select * From vCategories;
go
Select * From vProducts;
go


-Create a view for with category name, product name, and unit price.
CREATE VIEW
	vCategories_Products 
AS SELECT
	CategoryName
	,ProductName
	,UnitPrice
FROM
	vCategories AS [C]
	,vProducts AS [P]
	;

-Join categories and products table together.
CREATE VIEW
	vCategories_Products 
AS SELECT
	CategoryName
	,ProductName
	,UnitPrice
FROM
	vCategories AS [C]
	JOIN vProducts AS [P]
	ON C.CategoryID = P.CategoryID
	;

-Final code is ordered by the Category name and Product name


CREATE VIEW
	vCate_Prod 
AS SELECT 
	TOP 100
	CategoryName
	,ProductName
	,UnitPrice
FROM
	vCategories AS [C]
	JOIN vProducts AS [P]
	ON C.CategoryID = P.CategoryID
ORDER BY
	CategoryName
	,ProductName
	;
	

SELECT
	*
FROM
	vCate_Prod 
	;
GO
*/

USE
	Assignment06DB_JPeterson
	;
GO

CREATE VIEW
	vProductsByCategories
AS SELECT 
	TOP 100
	CategoryName
	,ProductName
	,UnitPrice
FROM
	vCategories AS [C]
	JOIN vProducts AS [P]
	ON C.CategoryID = P.CategoryID
ORDER BY
	CategoryName
	,ProductName
	;
	

SELECT
	*
	FROM
	vProductsByCategories
	;
GO

-- Question 4 (10% pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!

/*
-View Products and Inventories tables.
Select * From vProducts;
go
Select * From vInventories;
go


-Create a view with product name, inventory count, and inventory date.
CREATE VIEW
	vProd_Inve 
AS SELECT
	ProductName
	,Count
	,InventoryDate
FROM
	vProducts AS [P]
	,vInventories AS [I]
	;

-Join products and inventories table together.
CREATE VIEW
	vProd_Inve
AS SELECT
	ProductName
	,Count
	,InventoryDate
FROM
	vProducts AS [P]
	JOIN vInventories AS [I]
	ON P.ProductID = I.ProductID
	;

-Final code is ordered by the Product name, Inventory date, and Count


CREATE VIEW
	vProduct_Inventory
AS SELECT
	TOP 100
	ProductName
	,InventoryDate
	,Count
FROM
	vProducts AS [P]
	JOIN vInventories AS [I]
	ON P.ProductID = I.ProductID
ORDER BY
	ProductName
	,InventoryDate
	,Count
	;

SELECT
	*
FROM
	vProduct_Inventory
	;
GO
*/

USE
	Assignment06DB_JPeterson
	;
GO

CREATE VIEW
	vInventoriesByProductsByDates
AS SELECT
	TOP 100
	ProductName
	,InventoryDate
	,Count
FROM
	vProducts AS [P]
	JOIN vInventories AS [I]
	ON P.ProductID = I.ProductID
ORDER BY
	ProductName
	,InventoryDate
	,Count
	;

SELECT *
	FROM
	vInventoriesByProductsByDates
	;
GO

-- Question 5 (10% pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!

-- Here is are the rows selected from the view:

-- InventoryDate	EmployeeName
-- 2017-01-01	    Steven Buchanan
-- 2017-02-01	    Robert King
-- 2017-03-01	    Anne Dodsworth

/*
-View Inventories and Employees tables.
Select * From vInventories;
go
Select * From vEmployees;
go


-Create a view with inventory date and employee name.
CREATE VIEW
	vInventory_Employee 
AS SELECT
	InventoryDate
	,[EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
FROM
	vInventories AS [I]
	,vEmployees AS [E]
	;

-Join inventories and employees table together.
CREATE VIEW
	vInventory_Employee 
AS SELECT
	InventoryDate
	,[EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
FROM
	vInventories AS [I]
	JOIN vEmployees AS [E]
	ON I.EmployeeID = E.EmployeeID
	;

-Order view by the Inventory date.
CREATE VIEW
	vInventory_Employee 
AS SELECT
	TOP 100
	InventoryDate
	,[EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
FROM
	vInventories AS [I]
	JOIN vEmployees AS [E]
	ON I.EmployeeID = E.EmployeeID
ORDER BY
	InventoryDate
	;



CREATE VIEW
	vInvento_Employ
AS SELECT
	TOP 100
	InventoryDate
	,[EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
FROM
	vInventories AS [I]
	JOIN vEmployees AS [E]
	ON I.EmployeeID = E.EmployeeID
GROUP BY
	InventoryDate
	,EmployeeFirstName + ' ' + EmployeeLastName
ORDER BY
	InventoryDate
	;

SELECT
	*
FROM
	vInvento_Employ
	;
GO
*/

USE
	Assignment06DB_JPeterson
	;
GO

CREATE VIEW
	vInventoriesByEmployeesByDates
AS SELECT
	TOP 100
	InventoryDate
	,[EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
FROM
	vInventories AS [I]
	JOIN vEmployees AS [E]
	ON I.EmployeeID = E.EmployeeID
GROUP BY
	InventoryDate
	,EmployeeFirstName + ' ' + EmployeeLastName
ORDER BY
	InventoryDate
	;

SELECT
	*
	FROM
	vInventoriesByEmployeesByDates
	;
GO	

-- Question 6 (10% pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!

/*
-View Categories, Products, and Inventories tables.
Select * 
	From 
	vCategories;
go

Select * 
	From 
	vProducts;
go

Select * 
	From 
	vInventories;
go


-Create a view with category name, product name, inventory date and inventory count.
CREATE VIEW
	vCategory_Product_Inventory
AS SELECT
	CategoryName
	,ProductName
	,InventoryDate
	,Count
FROM
	vCategories AS [C]
	,vProducts AS [P]
	,vInventories AS [I]
	;

-Join categories and products table together, then join the inventories table together.
ALTER VIEW
	vCategory_Product_Inventory
AS SELECT
	CategoryName
	,ProductName
	,InventoryDate
	,Count
FROM
	vCategories AS [C]
	JOIN vProducts AS [P]
	ON C.CategoryID = P.CategoryID
	JOIN vInventories AS [I]
	ON P.ProductID = I.ProductID
	;

SELECT *
	FROM
	vCategory_Product_Inventory
	;

-Final code is ordered by the Category, Product, Date, and Count.
*/
USE
	Assignment06DB_JPeterson
	;
GO

CREATE VIEW
	vInventoriesByProductsByCategories
AS SELECT
	TOP 100
	CategoryName
	,ProductName
	,InventoryDate
	,Count
FROM
	vCategories AS [C]
	JOIN vProducts AS [P]
	ON C.CategoryID = P.CategoryID
	JOIN vInventories AS [I]
	ON P.ProductID = I.ProductID
ORDER BY
	CategoryName
	,ProductName
	,InventoryDate
	,Count
	;

SELECT *
	FROM
	vInventoriesByProductsByCategories
	;


-- Question 7 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!

/*
-View Categories, Products, Inventories and Employees tables.
Select * 
	From 
	vCategories;
go

Select * 
	From 
	vProducts;
go

Select * 
	From 
	vInventories;
go

Select * 
	From 
	vEmployees;
go

-Create a view with category name, product name, inventory date, inventory count and employee name.
CREATE VIEW
	vCategory_Product_Inventory_Employee
AS SELECT
	CategoryName
	,ProductName
	,InventoryDate
	,Count
	,[EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
FROM
	vCategories AS [C]
	,vProducts AS [P]
	,vInventories AS [I]
	,vEmployees AS [E]
	;

Select * 
	From 
	vCategory_Product_Inventory_Employee
go

-Join categories and products table together, then join inventories table together, lastly join the employees table together.
ALTER VIEW
	vCategory_Product_Inventory_Employee
AS SELECT
	CategoryName
	,ProductName
	,InventoryDate
	,Count
	,[EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
FROM
	vCategories AS [C]
	JOIN vProducts AS [P]
	ON C.CategoryID = P.CategoryID
	JOIN vInventories AS [I]
	ON P.ProductID = I.ProductID
	JOIN vEmployees AS [E]
	ON I.EmployeeID = E.EmployeeID
	;

Select * 
	From 
	vCategory_Product_Inventory_Employee
go	

-Final code is ordered by Inventory Date, Category, Product and Employee.
*/

USE
	Assignment06DB_JPeterson
	;
GO

CREATE VIEW
	vInventoriesByProductsByEmployees
AS SELECT
	TOP 100
	CategoryName
	,ProductName
	,InventoryDate
	,Count
	,[EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
FROM
	vCategories AS [C]
	JOIN vProducts AS [P]
	ON C.CategoryID = P.CategoryID
	JOIN vInventories AS [I]
	ON P.ProductID = I.ProductID
	JOIN vEmployees AS [E]
	ON I.EmployeeID = E.EmployeeID
ORDER BY
	InventoryDate
	,CategoryName
	,ProductName
	,[EmployeeName]
	;

Select * 
	From 
	vInventoriesByProductsByEmployees
go	

-- Question 8 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 

/*
-View Categories, Products, Inventories and Employees tables.
Select * 
	From 
	vCategories;
go

Select * 
	From 
	vProducts;
go

Select * 
	From 
	vInventories;
go

Select * 
	From 
	vEmployees;
go

-Create a view with category name, product name, inventory date, inventory count and employee name.
CREATE VIEW
	vCategory_Product_Inventory_Employee_Chai_Chang
AS SELECT
	CategoryName
	,ProductName
	,InventoryDate
	,Count
	,[EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
FROM
	vCategories AS [C]
	,vProducts AS [P]
	,vInventories AS [I]
	,vEmployees AS [E]
	;

Select * 
	From 
	vCategory_Product_Inventory_Employee_Chai_Chang
go

-Join categories and products table together, then join inventories table together, lastly join the employees table together.
ALTER VIEW
	vCategory_Product_Inventory_Employee_Chai_Chang
AS SELECT
	CategoryName
	,ProductName
	,InventoryDate
	,Count
	,[EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
FROM
	vCategories AS [C]
	JOIN vProducts AS [P]
	ON C.CategoryID = P.CategoryID
	JOIN vInventories AS [I]
	ON P.ProductID = I.ProductID
	JOIN vEmployees AS [E]
	ON I.EmployeeID = E.EmployeeID
	;

Select * 
	From 
	vCategory_Product_Inventory_Employee_Chai_Chang
go	


-Final code filters results by 'Chai' and 'Chang'
*/

USE
	Assignment06DB_JPeterson
	;
GO

CREATE VIEW
	vInventoriesForChaiAndChangByEmployees
AS SELECT
	CategoryName
	,ProductName
	,InventoryDate
	,Count
	,[EmployeeName] = EmployeeFirstName + ' ' + EmployeeLastName
FROM
	vCategories AS [C]
	JOIN vProducts AS [P]
	ON C.CategoryID = P.CategoryID
	JOIN vInventories AS [I]
	ON P.ProductID = I.ProductID
	JOIN vEmployees AS [E]
	ON I.EmployeeID = E.EmployeeID
WHERE
	ProductName 
	IN ('Chai','Chang')
	;

Select * 
	From 
	vInventoriesForChaiAndChangByEmployees
go	

-- Question 9 (10% pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!

/*
-View the Employees table.
Select * 
	From 
	vEmployees
	;
go

-Create a view with manager name and employee name.
CREATE VIEW
	vEmployeesByManager
AS SELECT
	[Manager] = EmployeeFirstName + ' ' + EmployeeLastName
	,[Employee] = EmployeeFirstName + ' ' + EmployeeLastName
FROM
	vEmployees AS [E]
	;

Select * 
	From 
	vEmployeesByManager
	;
go

-Self join the employee table to itself, connecting the employee ID with the manager ID.
ALTER VIEW
	vEmployeesByManager
AS SELECT
	[Manager] = M.EmployeeFirstName + ' ' + M.EmployeeLastName
	,[Employee] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
FROM
	vEmployees AS [M]
	JOIN vEmployees AS [E]
	ON E.ManagerID = M.EmployeeID
	;

Select * 
	From 
	vEmployeesByManager
	;
go

-Final code is ordered by Manager's name.
*/

USE
	Assignment06DB_JPeterson
	;
GO

CREATE VIEW
	vEmployeesByManager
AS SELECT
 TOP 100
	[Manager] = M.EmployeeFirstName + ' ' + M.EmployeeLastName
	,[Employee] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
FROM
	vEmployees AS [M]
	JOIN vEmployees AS [E]
	ON E.ManagerID = M.EmployeeID
ORDER BY
	[Manager]
	;

Select * 
	From 
	vEmployeesByManager
	;
go

-- Question 10 (20% pts): How can you create one view to show all the data from all four 
-- BASIC Views? Also show the Employee's Manager Name and order the data by 
-- Category, Product, InventoryID, and Employee.

/*
-View Categories, Products, Inventories and Employees tables.
Select * 
	From 
	vCategories;
go

Select * 
	From 
	vProducts;
go

Select * 
	From 
	vInventories;
go

Select * 
	From 
	vEmployees;
go


-Create a view with category name, product name, inventory date, inventory count and employee name.
CREATE VIEW
	vInventoriesByProductsByCategoriesByEmployees
AS SELECT
	C.CategoryID
	,C.CategoryName
	,P.ProductID
	,P.ProductName
	,P.UnitPrice
	,I.InventoryID
	,I.InventoryDate
	,I.Count
	,E.EmployeeID
	,[Employee] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
	,[Manager] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
FROM
	vCategories AS [C]
	,vProducts AS [P]
	,vInventories AS [I]
	,vEmployees AS [E]
	;

Select * 
	From 
	vInventoriesByProductsByCategoriesByEmployees
go

-Join categories and products table together, then join inventories table together, lastly join the employees table together.
ALTER VIEW
	vInventoriesByProductsByCategoriesByEmployees
AS SELECT
	C.CategoryID
	,C.CategoryName
	,P.ProductID
	,P.ProductName
	,P.UnitPrice
	,I.InventoryID
	,I.InventoryDate
	,I.Count
	,E.EmployeeID
	,[Employee] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
	,[Manager] = M.EmployeeFirstName + ' ' + M.EmployeeLastName
FROM
	vCategories AS [C]
	JOIN vProducts AS [P]
	ON C.CategoryID = P.CategoryID
	JOIN vInventories AS [I]
	ON P.ProductID = I.ProductID
	JOIN vEmployees AS [E]
	ON I.EmployeeID = E.EmployeeID
	JOIN vEmployees AS [M]
	ON E.ManagerID = M.EmployeeID
	;

Select * 
	From 
	vInventoriesByProductsByCategoriesByEmployees
go	


-Final code ordered by Category name, Product name, InventoryID, and Employee.


*/

USE
	Assignment06DB_JPeterson
	;
GO

CREATE VIEW
	vInventoriesByProductsByCategoriesByEmployees
AS SELECT
	TOP 100
	C.CategoryID
	,C.CategoryName
	,P.ProductID
	,P.ProductName
	,P.UnitPrice
	,I.InventoryID
	,I.InventoryDate
	,I.Count
	,E.EmployeeID
	,[Employee] = E.EmployeeFirstName + ' ' + E.EmployeeLastName
	,[Manager] = M.EmployeeFirstName + ' ' + M.EmployeeLastName
FROM
	vCategories AS [C]
	JOIN vProducts AS [P]
	ON C.CategoryID = P.CategoryID
	JOIN vInventories AS [I]
	ON P.ProductID = I.ProductID
	JOIN vEmployees AS [E]
	ON I.EmployeeID = E.EmployeeID
	JOIN vEmployees AS [M]
	ON E.ManagerID = M.EmployeeID
ORDER BY
	CategoryName
	,ProductName
	,InventoryID
	,[Employee]
	;

Select * 
	From 
	vInventoriesByProductsByCategoriesByEmployees
go	


-- Test your Views (NOTE: You must change the your view names to match what I have below!)
Print 'Note: You will get an error until the views are created!'
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

Select * From [dbo].[vProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByDates]
Select * From [dbo].[vInventoriesByEmployeesByDates]
Select * From [dbo].[vInventoriesByProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByEmployees]
Select * From [dbo].[vInventoriesForChaiAndChangByEmployees]
Select * From [dbo].[vEmployeesByManager]
Select * From [dbo].[vInventoriesByProductsByCategoriesByEmployees]

/***************************************************************************************/
