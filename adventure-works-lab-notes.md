## Lab 1

### 1.1

1. SELECT *
FROM sales.customer
LIMIT 1000;

2.
SELECT p.title, firstname, middlename, lastname, p.suffix
FROM sales.customer, person.person AS p
WHERE businessentityid = personid
LIMIT 1000;
Total query runtime: 36 msec
1000 rows retrieved.

I don't have a copy of the LT database in Postgres - this is the
Adventure Works OLTP 2014. (I can use the LT online - but I haven't
extracted it all to use locally. It seems the OLTP has quite a
different and more complex schema less intended for beginners so I'd
like to get the LT db locally on Unix so I can use it without
Internet)

Absolutely - the OLTP database I downloaded has 68 tables, but in LT 2012 I have just 12:

```
mssql> .tables
database          schema   name                             type
----------------  -------  -------------------------------  ----------
AdventureWorksLT  SalesLT  vProductModelCatalogDescription  VIEW
AdventureWorksLT  SalesLT  vProductAndDescription           VIEW
AdventureWorksLT  SalesLT  vGetAllCategories                VIEW
AdventureWorksLT  sys      database_firewall_rules          VIEW
AdventureWorksLT  SalesLT  SalesOrderHeader                 BASE TABLE
AdventureWorksLT  SalesLT  ProductDescription               BASE TABLE
AdventureWorksLT  SalesLT  Address                          BASE TABLE
AdventureWorksLT  SalesLT  CustomerAddress                  BASE TABLE
AdventureWorksLT  SalesLT  SalesOrderDetail                 BASE TABLE
AdventureWorksLT  SalesLT  Customer                         BASE TABLE
AdventureWorksLT  SalesLT  ProductCategory                  BASE TABLE
AdventureWorksLT  SalesLT  Product                          BASE TABLE
AdventureWorksLT  SalesLT  ProductModel                     BASE TABLE
AdventureWorksLT  SalesLT  ProductModelProductDescription   BASE TABLE
AdventureWorksLT  dbo      BuildVersion                     BASE TABLE
AdventureWorksLT  dbo      ErrorLog                         BASE TABLE

16 row(s) returned
```

sql-cli works really badly in Emacs multi-term. Is fine in iterm3

This is weird:

mssql> .schema AdventureWorksLT.SalesLT.Customer;

0 row(s) returned

Executed in 1 ms

wonder what is wrong here

```
mssql> SELECT * FROM SalesLT.Customer LIMIT 100;
Error: Incorrect syntax near '100'.
```

looks ok in SQLITE

```
sqlite> select * from person limit 5;
0|Zed|Shostakovich|37|||0|5551111|90000.0|1980-03-15
1|Angela|Spacey|61|||0|5559883|90000.0|1955-02-03
2|Harry|Potter|26|||0||90000.0|
3|Yours|Truly|41|||0||90000.0|
4|Junior|Truly|17|||0||90000.0|
```

t-sql doesn't seem to have 'limit'

https://msdn.microsoft.com/en-us/library/ms189499.aspx

This works:
    SELECT TOP 100 * FROM SalesLT.Customer;

### 1.2

mssql> SELECT TOP 1 Title, FirstName, MiddleName, LastName, Suffix FROM SalesLT.Customer;
Title  FirstName  MiddleName  LastName  Suffix
-----  ---------  ----------  --------  ------
Mr.    Orlando    N.          Gee       null


12 tables shouldn't be too hard to export and import semi-manually.

### 1.3


*but* I thought I saw in the lectures that they were paginating the tables.

```
SELECT TOP 10 salesperson, (title + lastname) as CustomerName, phone FROM saleslt.customer;
salesperson               CustomerName   phone
------------------------  -------------  ------------
adventure-works\pamela0   Mr.Gee         245-555-0173
adventure-works\david8    Mr.Harris      170-555-0127
adventure-works\jillian0  Ms.Carreras    279-555-0130
adventure-works\jillian0  Ms.Gates       710-555-0173
adventure-works\shu0      Mr.Harrington  828-555-0186
adventure-works\linda3    Ms.Carroll     244-555-0112
adventure-works\shu0      Mr.Gash        192-555-0173
adventure-works\josé1     Ms.Garza       150-555-0127
adventure-works\josé1     Ms.Harding     926-555-0159
adventure-works\garrett1  Mr.Caprio      112-555-0191

10 row(s) returned

```

```
mssql> SELECT TOP 10 salesperson, (title + lastname) as CustomerName, phone FROM saleslt.customer GROUP BY salesperson;
Error: Column 'saleslt.customer.LastName' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause.
```

noticed that ms-cli (`mssql` above) doesn't seem to allow multiline queries -
it seems to submit the query on newline.

```
mssql> SELECT TOP 10 salesperson, (title + lastname) as CustomerName, phone FROM saleslt.customer ORDER BY salesperson;
salesperson             CustomerName  phone
----------------------  ------------  ------------
adventure-works\david8  Mr.Harris     170-555-0127
adventure-works\david8  Ms.Handley    582-555-0113
adventure-works\david8  Ms.Haines     867-555-0114
adventure-works\david8  Mr.Groth      461-555-0118
adventure-works\david8  Mr.Bright     162-555-0166
adventure-works\david8  Ms.Carmody    646-555-0137
adventure-works\david8  Ms.Thompson   464-555-0188
adventure-works\david8  Ms.Thames     799-555-0118
adventure-works\david8  Mr.Bready     340-555-0131
adventure-works\david8  Ms.Dodd       706-555-0140

10 row(s) returned

Executed in 1 ms
```

### 2.1

```
mssql> SELECT TOP 10 CustomerID, CompanyName FROM saleslt.customer;
CustomerID  CompanyName
----------  --------------------------
1           A Bike Store
2           Progressive Sports
3           Advanced Bike Components
4           Modular Cycle Systems
5           Metropolitan Sports Supply
6           Aerobic Exercise Company
7           Associated Bikes
10          Rural Cycle Emporium
11          Sharp Bikes
12          Bikes and Motorbikes

10 row(s) returned

Executed in 1 ms
```

### 2.2

```
mssql> SELECT TOP 4 'SO' + CAST(salesorderid AS varchar) + '(' +  CAST(revisionnumber AS VARCHAR) + ')' AS 'Sales Order Revision', orderdate FROM saleslt.salesorderheader;
Sales Order Revision  orderdate
--------------------  ------------------------
SO71774(2)            2008-06-01T00:00:00.000Z
SO71776(2)            2008-06-01T00:00:00.000Z
SO71780(2)            2008-06-01T00:00:00.000Z
SO71782(2)            2008-06-01T00:00:00.000Z

4 row(s) returned

Executed in 1 ms
mssql> SELECT TOP 4 'SO' + CAST(salesorderid AS varchar) + '(' +  CAST(revisionnumber AS VARCHAR) + ')' AS 'Sales Order Revision', CAST(orderdate AS DATE) FROM saleslt.salesorderheader;
Sales Order Revision
--------------------  ------------------------
SO71774(2)            2008-06-01T00:00:00.000Z
SO71776(2)            2008-06-01T00:00:00.000Z
SO71780(2)            2008-06-01T00:00:00.000Z
SO71782(2)            2008-06-01T00:00:00.000Z

4 row(s) returned

Executed in 1 ms
mssql> SELECT TOP 4 'SO' + CAST(salesorderid AS varchar) + '(' +  CAST(revisionnumber AS VARCHAR) + ')' AS 'Sales Order Revision', CAST(orderdate AS DATE, 102) AS 'Order Date' FROM saleslt.salesorderheader;
Error: Incorrect syntax near ','.
mssql> SELECT TOP 4 'SO' + CAST(salesorderid AS varchar) + '(' +  CAST(revisionnumber AS VARCHAR) + ')' AS 'Sales Order Revision', CAST(orderdate AS VARCHAR, 102) AS 'Order Date' FROM saleslt.salesorderheader;
Error: Incorrect syntax near ','.
mssql> SELECT TOP 4 'SO' + CAST(salesorderid AS varchar) + '(' +  CAST(revisionnumber AS VARCHAR) + ')' AS 'Sales Order Revision', CONVERT(VARCHAR, orderdate, 102) AS 'Order Date' FROM saleslt.salesorderheader;
Sales Order Revision  Order Date
--------------------  ----------
SO71774(2)            2008.06.01
SO71776(2)            2008.06.01
SO71780(2)            2008.06.01
SO71782(2)            2008.06.01

4 row(s) returned

Executed in 1 ms

```

See that CONVERT allows me to specify a Date 'style' but CAST doesn't

Need to have this page or similar handy

https://msdn.microsoft.com/en-us/library/ms187928.aspx

Ran out of time - need to do challenge 3 in a coffee break.

### 3.1

```
mssql> SELECT TOP 10 firstname + ' ' + middlename + ' ' + lastname FROM saleslt.customer;

-------------------
Orlando N. Gee
null
Donna F. Carreras
Janet M. Gates
null
Rosmarie J. Carroll
Dominic P. Gash
Kathleen M. Garza
null
Johnny A. Caprio

10 row(s) returned

Executed in 1 ms
mssql> SELECT TOP 10 firstname + ' ' + ISNULL(middlename, '') + ' ' + lastname FROM saleslt.customer;

-------------------
Orlando N. Gee
Keith  Harris
Donna F. Carreras
Janet M. Gates
Lucy  Harrington
Rosmarie J. Carroll
Dominic P. Gash
Kathleen M. Garza
Katherine  Harding
Johnny A. Caprio

10 row(s) returned

Executed in 1 ms
```

Notice that a NULL result makes the whole concatenated string NULL -
so ISNULL is useful.

I didn't bother squashing double spaces down to single spaces.

### 3.2

```
mssql> SELECT TOP 25 CustomerID, ISNULL(emailaddress, phone) AS PrimaryContact FROM saleslt.customer;
CustomerID  PrimaryContact
----------  --------------------------------
1           245-555-0173
2           keith0@adventure-works.com
3           donna0@adventure-works.com
4           janet1@adventure-works.com
5           lucy0@adventure-works.com
6           rosmarie0@adventure-works.com
7           dominic0@adventure-works.com
10          kathleen0@adventure-works.com
11          katherine0@adventure-works.com
12          johnny0@adventure-works.com
16          christopher1@adventure-works.com
18          david20@adventure-works.com
19          john8@adventure-works.com
20          jean1@adventure-works.com
21          jinghao1@adventure-works.com
22          121-555-0121
23          kerim0@adventure-works.com
24          kevin5@adventure-works.com
25          donald0@adventure-works.com
28          jackie0@adventure-works.com
29          344-555-0144
30          todd0@adventure-works.com
34          barbara4@adventure-works.com
37          jim1@adventure-works.com
38          betty0@adventure-works.com

25 row(s) returned

Executed in 1 ms
```

### 3.3

> a list of sales order IDs and order dates with a column named
> ShippingStatus that contains the text “Shipped” for orders with a
> known ship date, and “Awaiting Shipment” for orders with no ship
> date.


I wish this Unix CLI allowed me to put new lines in :D.

```
mssql> select SalesOrderID, CASE WHEN ShipDate IS NULL THEN 'Awaiting Shipment' ELSE 'Shipped' END AS ShippingStatus FROM saleslt.salesorderheader;
SalesOrderID  ShippingStatus
------------  -----------------
71774         Shipped
71776         Shipped
71780         Shipped
71782         Shipped
71783         Shipped
71784         Shipped
71796         Shipped
71797         Shipped
71815         Shipped
71816         Shipped
71831         Shipped
71832         Shipped
71845         Shipped
71846         Shipped
71856         Shipped
71858         Shipped
71863         Shipped
71867         Shipped
71885         Shipped
71895         Shipped
71897         Shipped
71898         Shipped
71899         Shipped
71902         Awaiting Shipment
71915         Awaiting Shipment
71917         Awaiting Shipment
71920         Awaiting Shipment
71923         Awaiting Shipment
71935         Awaiting Shipment
71936         Awaiting Shipment
71938         Awaiting Shipment
71946         Awaiting Shipment

32 row(s) returned

Executed in 1 ms
mssql>
```

## Lab 2

### 1.1

```
mssql> select distinct city, stateprovince from saleslt.address;
city               stateprovince
-----------------  ----------------
Abingdon           England
Albany             Oregon
Alhambra           California
Alpine             California
Arlington          Texas
Auburn             California
Aurora             Ontario
Austin             Texas
Baldwin Park       California
Barrie             Ontario
....
Woodinville        Washington
Woolston           England
York               England
Zeeland            Michigan

272 row(s) returned

Executed in 1 ms
```
- Would be better ordered but the question didn't ask for that.

## 1.2

Retrieve the names of the top ten percent of products by weight.

```
mssql> SELECT TOP (COUNT(*) / 10 )  Weight FROM saleslt.product ORDER BY WEIGHT;
Error: Invalid expression in a TOP or OFFSET clause.
mssql> SELECT (COUNT(*) / 10 )  FROM saleslt.product;

--
29

1 row(s) returned

Executed in 1 ms
mssql> SELECT TOP 29 Weight FROM saleslt.product ORDER BY WEIGHT;
Weight
------
null
null
null
...
mssql> SELECT TOP 29 Name FROM saleslt.product WHERE Weight IS NOT NULL ORDER BY WEIGHT;
Name
----------------------------
Front Derailleur
HL Road Pedal
ML Road Pedal
ML Bottom Bracket
HL Bottom Bracket
HL Mountain Pedal
LL Road Pedal
Rear Derailleur
ML Mountain Pedal
LL Mountain Pedal
LL Bottom Bracket
Rear Brakes
Front Brakes
HL Crankset
LL Crankset
ML Crankset
HL Road Front Wheel
ML Road Front Wheel
HL Road Rear Wheel
LL Road Front Wheel
HL Road Frame - Red, 44
HL Road Frame - Black, 44
HL Road Frame - Red, 48
HL Road Frame - Black, 48
ML Road Frame-W - Yellow, 38
HL Road Frame - Red, 52
HL Road Frame - Black, 52
ML Road Rear Wheel
ML Road Frame - Red, 44

29 row(s) returned

Executed in 1 ms
```

Turns out above was way wrong, because the ORDER BY happens *before* the TOP 10 (sensibly) so I actually got the bottom 10% . SHould be:

```
mssql> SELECT TOP 29 Name, Weight FROM saleslt.product WHERE Weight IS NOT NULL ORDER BY WEIGHT DESC;
Name                       Weight
-------------------------  --------
Touring-3000 Blue, 62      13607.7
Touring-3000 Yellow, 62    13607.7
Touring-3000 Blue, 58      13562.34
Touring-3000 Yellow, 58    13512.45
Touring-3000 Blue, 54      13462.55
Touring-3000 Yellow, 54    13344.62
Touring-3000 Yellow, 50    13213.08
Touring-3000 Blue, 50      13213.08
Touring-3000 Yellow, 44    13049.78
Touring-3000 Blue, 44      13049.78
Mountain-500 Silver, 52    13008.96
Mountain-500 Black, 52     13008.96
Mountain-500 Silver, 48    12891.03
Mountain-500 Black, 48     12891.03
Mountain-500 Silver, 44    12759.49
Mountain-500 Black, 44     12759.49
Touring-2000 Blue, 60      12655.16
Mountain-500 Silver, 42    12596.19
Mountain-500 Black, 42     12596.19
Touring-2000 Blue, 54      12555.37
Touring-2000 Blue, 50      12437.44
Mountain-400-W Silver, 46  12437.44
Mountain-500 Silver, 40    12405.69
Mountain-500 Black, 40     12405.69
Touring-2000 Blue, 46      12305.9
Mountain-400-W Silver, 42  12305.9
Mountain-400-W Silver, 40  12142.6
Mountain-300 Black, 48     11983.85
Mountain-400-W Silver, 38  11952.1

29 row(s) returned

Executed in 1 ms
```

TSQL TOP has a PERCENT argument. It has a problem in that I get thepercentage after the nulls have been removed.

```
mssql> SELECT TOP 10 PERCENT Name FROM saleslt.product WHERE Weight IS NOT NULL ORDER BY WEIGHT DESC;
Name
-----------------------
Touring-3000 Blue, 62
Touring-3000 Yellow, 62
Touring-3000 Blue, 58
Touring-3000 Yellow, 58
Touring-3000 Blue, 54
Touring-3000 Yellow, 54
Touring-3000 Yellow, 50
Touring-3000 Blue, 50
Touring-3000 Blue, 44
Touring-3000 Yellow, 44
Mountain-500 Silver, 52
Mountain-500 Black, 52
Mountain-500 Silver, 48
Mountain-500 Black, 48
Mountain-500 Black, 44
Mountain-500 Silver, 44
Touring-2000 Blue, 60
Mountain-500 Silver, 42
Mountain-500 Black, 42
Touring-2000 Blue, 54

20 row(s) returned

Executed in 1 ms
mssql>
```


https://msdn.microsoft.com/en-us/library/ms188385.aspx  ORDER BY Clause (Transact-SQL)

```
mssql> SELECT  Name FROM saleslt.product WHERE Weight IS NOT NULL ORDER BY WEIGHT DESC OFFSET 0 ROWS FETCH FIRST 29 ROWS ONLY;
Name
-------------------------
Touring-3000 Blue, 62
Touring-3000 Yellow, 62
Touring-3000 Blue, 58
Touring-3000 Yellow, 58
Touring-3000 Blue, 54
Touring-3000 Yellow, 54
Touring-3000 Yellow, 50
Touring-3000 Blue, 50
Touring-3000 Yellow, 44
Touring-3000 Blue, 44
Mountain-500 Silver, 52
Mountain-500 Black, 52
Mountain-500 Silver, 48
Mountain-500 Black, 48
Mountain-500 Silver, 44
Mountain-500 Black, 44
Touring-2000 Blue, 60
Mountain-500 Silver, 42
Mountain-500 Black, 42
Touring-2000 Blue, 54
Touring-2000 Blue, 50
Mountain-400-W Silver, 46
Mountain-500 Silver, 40
Mountain-500 Black, 40
Touring-2000 Blue, 46
Mountain-400-W Silver, 42
Mountain-400-W Silver, 40
Mountain-300 Black, 48
Mountain-400-W Silver, 38

29 row(s) returned

Executed in 1 ms
```

### 1.3

> The heaviest ten products are transported by a specialist carrier,
> therefore you need to modify the previous query to list the heaviest
> 100 products not including the heaviest ten.

```
mssql> SELECT  Name FROM saleslt.product WHERE Weight IS NOT NULL ORDER BY WEIGHT DESC OFFSET 29 ROWS FETCH FIRST 100 ROWS ONLY;
Name
--------------------------------
Mountain-300 Black, 44
Touring-1000 Blue, 60
Touring-1000 Yellow, 60
Mountain-300 Black, 40
Touring-1000 Yellow, 54
Touring-1000 Blue, 54
Touring-1000 Blue, 50
Touring-1000 Yellow, 50
Mountain-300 Black, 38
Touring-1000 Yellow, 46
Touring-1000 Blue, 46
Mountain-200 Black, 46
Mountain-200 Silver, 46
Mountain-200 Silver, 42
Mountain-200 Black, 42
Mountain-200 Black, 38
Mountain-200 Silver, 38
Mountain-100 Black, 48
Mountain-100 Silver, 48
Mountain-100 Silver, 44
Mountain-100 Black, 44
Road-750 Black, 58
Mountain-100 Black, 42
Mountain-100 Silver, 42
Road-750 Black, 52
Mountain-100 Black, 38
Mountain-100 Silver, 38
Road-750 Black, 48
Road-650 Black, 62
Road-650 Red, 62
Road-650 Red, 60
Road-650 Black, 60
Road-650 Black, 58
Road-650 Red, 58
Road-750 Black, 44
Road-650 Red, 52
Road-650 Black, 52
Road-650 Black, 48
Road-650 Red, 48
Road-650 Red, 44
Road-650 Black, 44
Road-550-W Yellow, 48
Road-550-W Yellow, 44
Road-550-W Yellow, 42
Road-450 Red, 60
Road-450 Red, 58
Road-550-W Yellow, 40
Road-450 Red, 52
Road-550-W Yellow, 38
Road-450 Red, 48
Road-450 Red, 44
Road-350-W Yellow, 48
Road-350-W Yellow, 44
Road-250 Red, 58
Road-350-W Yellow, 42
Road-250 Black, 58
Road-250 Black, 52
Road-250 Red, 52
Road-350-W Yellow, 40
Road-250 Red, 48
Road-250 Black, 48
Road-150 Red, 62
Road-250 Black, 44
Road-250 Red, 44
Road-150 Red, 56
Road-150 Red, 52
Road-150 Red, 48
Road-150 Red, 44
LL Touring Frame - Yellow, 62
LL Touring Frame - Blue, 62
LL Touring Frame - Blue, 58
LL Touring Frame - Yellow, 58
LL Touring Frame - Blue, 54
LL Touring Frame - Yellow, 54
LL Touring Frame - Blue, 50
LL Touring Frame - Yellow, 50
HL Touring Frame - Yellow, 60
HL Touring Frame - Blue, 60
HL Touring Frame - Blue, 54
HL Touring Frame - Yellow, 54
LL Mountain Frame - Silver, 52
LL Mountain Frame - Black, 52
LL Touring Frame - Blue, 44
LL Touring Frame - Yellow, 44
HL Touring Frame - Yellow, 50
HL Touring Frame - Blue, 50
LL Mountain Frame - Silver, 48
LL Mountain Frame - Black, 48
LL Mountain Frame - Black, 44
HL Touring Frame - Blue, 46
HL Touring Frame - Yellow, 46
LL Mountain Frame - Silver, 44
LL Mountain Frame - Silver, 42
LL Mountain Frame - Black, 42
LL Mountain Frame - Black, 40
LL Mountain Frame - Silver, 40
ML Mountain Frame-W - Silver, 46
ML Mountain Frame - Black, 48
HL Mountain Frame - Silver, 46
HL Mountain Frame - Black, 46

100 row(s) returned

Executed in 1 ms
mssql>
```

This was a stupid 'not reading the spec' error. The top *10* are
carried by the specialist carrier, not the top 10 percent. Ouch!!

### 2.1

names, colors, and sizes of the products with a product model ID 1.

```
mssql> SELECT name, color, size  FROM saleslt.product WHERE productmodelid = 1;
name             color  size
---------------  -----  ----
Classic Vest, S  Blue   S
Classic Vest, M  Blue   M
Classic Vest, L  Blue   L

3 row(s) returned

Executed in 1 ms
```

### 2.2
```
mssql> SELECT productnumber, name FROM saleslt.product WHERE color IN('Black', 'Red', 'White') AND size IN('M', 'S');
productnumber  name
-------------  --------------------------
SO-B909-M      Mountain Bike Socks, M
SH-M897-S      Men's Sports Shorts, S
SH-M897-M      Men's Sports Shorts, M
TG-W091-S      Women's Tights, S
TG-W091-M      Women's Tights, M
GL-H102-S      Half-Finger Gloves, S
GL-H102-M      Half-Finger Gloves, M
GL-F110-S      Full-Finger Gloves, S
GL-F110-M      Full-Finger Gloves, M
SH-W890-S      Women's Mountain Shorts, S
SH-W890-M      Women's Mountain Shorts, M
SO-R809-M      Racing Socks, M

12 row(s) returned

Executed in 1 ms
mssql>
```

### 2.3

product number, name, and list price of products whose product number begins 'BK-'.

```
mssql> SELECT productnumber, name, listprice FROM saleslt.product WHERE productnumber LIKE 'BK-%';
productnumber  name                       listprice
-------------  -------------------------  ---------
BK-R93R-62     Road-150 Red, 62           3578.27
BK-R93R-44     Road-150 Red, 44           3578.27
BK-R93R-48     Road-150 Red, 48           3578.27
BK-R93R-52     Road-150 Red, 52           3578.27
...
BK-R19B-44     Road-750 Black, 44         539.99
BK-R19B-48     Road-750 Black, 48         539.99
BK-R19B-52     Road-750 Black, 52         539.99

97 row(s) returned

Executed in 1 ms
mssql>
```


### 2.4

 Retrieve specific products by product number. Modify your previous
query to retrieve the product number, name, and list price of products
whose product number begins 'BK-' followed by any character other than
'R’, and ends with a '-' followed by any two numerals.

```
mssql> SELECT productnumber, name, listprice FROM saleslt.product WHERE productnumber LIKE 'BK-%' AND productnumber NOT LIKE 'BK-R%' AND productnumber LIKE '%-[0-9][0-9]';
productnumber  name                       listprice
-------------  -------------------------  ---------
BK-M82S-38     Mountain-100 Silver, 38    3399.99
BK-M82S-42     Mountain-100 Silver, 42    3399.99
BK-M82S-44     Mountain-100 Silver, 44    3399.99
BK-M82S-48     Mountain-100 Silver, 48    3399.99
BK-M82B-38     Mountain-100 Black, 38     3374.99
BK-M82B-42     Mountain-100 Black, 42     3374.99
BK-M82B-44     Mountain-100 Black, 44     3374.99
BK-M82B-48     Mountain-100 Black, 48     3374.99
BK-M68S-38     Mountain-200 Silver, 38    2319.99
BK-M68S-42     Mountain-200 Silver, 42    2319.99
BK-M68S-46     Mountain-200 Silver, 46    2319.99
BK-M68B-38     Mountain-200 Black, 38     2294.99
BK-M68B-42     Mountain-200 Black, 42     2294.99
BK-M68B-46     Mountain-200 Black, 46     2294.99
BK-M47B-38     Mountain-300 Black, 38     1079.99
BK-M47B-40     Mountain-300 Black, 40     1079.99
BK-M47B-44     Mountain-300 Black, 44     1079.99
BK-M47B-48     Mountain-300 Black, 48     1079.99
BK-T44U-60     Touring-2000 Blue, 60      1214.85
BK-T79Y-46     Touring-1000 Yellow, 46    2384.07
BK-T79Y-50     Touring-1000 Yellow, 50    2384.07
BK-T79Y-54     Touring-1000 Yellow, 54    2384.07
BK-T79Y-60     Touring-1000 Yellow, 60    2384.07
BK-T18U-54     Touring-3000 Blue, 54      742.35
BK-T18U-58     Touring-3000 Blue, 58      742.35
BK-T18U-62     Touring-3000 Blue, 62      742.35
BK-T18Y-44     Touring-3000 Yellow, 44    742.35
BK-T18Y-50     Touring-3000 Yellow, 50    742.35
BK-T18Y-54     Touring-3000 Yellow, 54    742.35
BK-T18Y-58     Touring-3000 Yellow, 58    742.35
BK-T18Y-62     Touring-3000 Yellow, 62    742.35
BK-T79U-46     Touring-1000 Blue, 46      2384.07
BK-T79U-50     Touring-1000 Blue, 50      2384.07
BK-T79U-54     Touring-1000 Blue, 54      2384.07
BK-T79U-60     Touring-1000 Blue, 60      2384.07
BK-T44U-46     Touring-2000 Blue, 46      1214.85
BK-T44U-50     Touring-2000 Blue, 50      1214.85
BK-T44U-54     Touring-2000 Blue, 54      1214.85
BK-T18U-44     Touring-3000 Blue, 44      742.35
BK-T18U-50     Touring-3000 Blue, 50      742.35
BK-M38S-38     Mountain-400-W Silver, 38  769.49
BK-M38S-40     Mountain-400-W Silver, 40  769.49
BK-M38S-42     Mountain-400-W Silver, 42  769.49
BK-M38S-46     Mountain-400-W Silver, 46  769.49
BK-M18S-40     Mountain-500 Silver, 40    564.99
BK-M18S-42     Mountain-500 Silver, 42    564.99
BK-M18S-44     Mountain-500 Silver, 44    564.99
BK-M18S-48     Mountain-500 Silver, 48    564.99
BK-M18S-52     Mountain-500 Silver, 52    564.99
BK-M18B-40     Mountain-500 Black, 40     539.99
BK-M18B-42     Mountain-500 Black, 42     539.99
BK-M18B-44     Mountain-500 Black, 44     539.99
BK-M18B-48     Mountain-500 Black, 48     539.99
BK-M18B-52     Mountain-500 Black, 52     539.99

54 row(s) returned

Executed in 1 ms
mssql>
```

## Lab 3

### 1.1

> As an initial step towards generating the invoice report, write a
> query that returns the company name from the SalesLT.Customer table,
> and the sales order ID and total due from the
> SalesLT.SalesOrderHeader table.

```
mssql> SELECT CompanyName, SalesOrderID, TotalDue FROM SalesLT.Customer JOIN SalesLT.SalesOrderHeader ON Customer.CustomerID = SalesOrderHeader.CustomerID ;
CompanyName                      SalesOrderID  TotalDue
-------------------------------  ------------  -----------
Professional Sales and Service   71782         43962.7901
Remarkable Bike Store            71935         7330.8972
Bulk Discount Store              71938         98138.2131
Coalition Bike Company           71899         2669.3183
Futuristic Bikes                 71895         272.6468
Channel Outlet                   71885         608.1766
Aerobic Exercise Company         71915         2361.6403
Vigorous Sports Store            71867         1170.5376
Thrilling Bike Tours             71858         15275.1977
Extreme Riding Supplies          71796         63686.2708
Action Bicycle Specialists       71784         119960.824
Central Bicycle Specialists      71946         43.0437
The Bicycle Accessories Company  71923         117.7276
Riding Cycles                    71797         86222.8072
Good Toys                        71774         972.785
Paints and Solvents Company      71897         14017.9083
Closest Bicycle Store            71832         39531.6085
Many Bikes Store                 71902         81834.9826
Instruments and Parts Company    71898         70698.9922
Trailblazing Sports              71845         45992.3665
Eastside Department Store        71783         92663.5609
Sports Products Store            71863         3673.3249
Discount Tours                   71920         3293.7761
Tachometers and Accessories      71831         2228.0566
Essential Bike Works             71917         45.1995
Engineered Bike Systems          71816         3754.9733
Transport Bikes                  71856         665.4251
Metropolitan Bicycle Supply      71936         108597.9536
West Side Mart                   71776         87.0851
Thrifty Parts and Sales          71815         1261.444
Sports Store                     71846         2711.4098
Nearby Cycle Shop                71780         42452.6519

32 row(s) returned

Executed in 1 ms
mssql>
```

### 1.2

> Retrieve customer orders with addresses Extend your customer orders
> query to include the Main Office address for each customer,
> including the full street address, city, state or province, postal
> code, and country or region

> Tip: Note that each customer can have multiple addressees in the
> SalesLT.Address table, so the database developer has created the
> SalesLT.CustomerAddress table to enable a many-to-many relationship
> between customers and addresses. Your query will need to include
> both of these tables, and should filter the join to
> SalesLT.CustomerAddress so that only Main Office addresses are
> included.

Tried various ways of nesting joins, but I think I need to review some examples, as I kept getting syntax error near JOIN.

Thankfully iterm2 cached my exploratory queries and showed them on restart:

```(sql)
mssql> SELECT TOP 1 * FROM SALESLT.ADDRESS
AddressID  AddressLine1       AddressLine2  City     StateProvince  CountryRegion  PostalCode  rowguid                               ModifiedDate
---------  -----------------  ------------  -------  -------------  -------------  ----------  ------------------------------------  ------------------------
9          8713 Yosemite Ct.  null          Bothell  Washington     United States  98011       268AF621-76D7-4C78-9441-144FD139821A  2006-07-01T00:00:00.000Z

1 row(s) returned

Executed in 1 ms
mssql> SELECT TOP 1 * FROM SALESLT.customerADDRESS
CustomerID  AddressID  AddressType  rowguid                               ModifiedDate
----------  ---------  -----------  ------------------------------------  ------------------------
29485       1086       Main Office  16765338-DBE4-4421-B5E9-3836B9278E63  2007-09-01T00:00:00.000Z

1 row(s) returned

Executed in 1 ms
mssql> SELECT distinct addresstype FROM SALESLT.customerADDRESS
addresstype
-----------
Main Office
Shipping

2 row(s) returned

Executed in 1 ms
mssql> SELECT TOP 10 AddressLine1, AddressLine2, City, StateProvince, CountryRegion, PostalCode FROM  SALESLT.ADDRESSES WHERE addresstype = 'Main Office';
Error: Invalid object name 'SALESLT.ADDRESSES'.
mssql> SELECT TOP 10 AddressLine1, AddressLine2, City, StateProvince, CountryRegion, PostalCode FROM  SALESLT.ADDRESS JOIN saleslt.customeraddress WHERE addresstype = 'Main Office';
Error: Incorrect syntax near the keyword 'WHERE'.
mssql> SELECT TOP 10 AddressLine1, AddressLine2, City, StateProvince, CountryRegion, PostalCode FROM  SALESLT.ADDRESS as a JOIN saleslt.customeraddress AS ca ON a.addressid = ca.addressid WHERE addresstype = 'Main Office';
AddressLine1                    AddressLine2  City          StateProvince     CountryRegion  PostalCode
------------------------------  ------------  ------------  ----------------  -------------  ----------
57251 Serene Blvd               null          Van Nuys      California        United States  91411
Tanger Factory                  null          Branch        Minnesota         United States  55056
6900 Sisk Road                  null          Modesto       California        United States  95354
Lewiston Mall                   null          Lewiston      Idaho             United States  83501
Blue Ridge Mall                 null          Kansas City   Missouri          United States  64106
No. 25800-130 King Street West  null          Toronto       Ontario           Canada         M4B 1V5
6500 East Grant Road            null          Tucson        Arizona           United States  85701
Eastridge Mall                  null          Casper        Wyoming           United States  82601
252851 Rowan Place              null          Richmond      British Columbia  Canada         V6B 3P7
White Mountain Mall             null          Rock Springs  Wyoming           United States  82901

10 row(s) returned

Executed in 1 ms
mssql> SELECT TOP 10 addresstype, AddressLine1, AddressLine2, City, StateProvince, CountryRegion, PostalCode FROM  SALESLT.ADDRESS as a JOIN saleslt.customeraddress AS ca ON a.addressid = ca.addressid WHERE addresstype = 'Main Office';
addresstype  AddressLine1                    AddressLine2  City          StateProvince     CountryRegion  PostalCode
-----------  ------------------------------  ------------  ------------  ----------------  -------------  ----------
Main Office  57251 Serene Blvd               null          Van Nuys      California        United States  91411
Main Office  Tanger Factory                  null          Branch        Minnesota         United States  55056
Main Office  6900 Sisk Road                  null          Modesto       California        United States  95354
Main Office  Lewiston Mall                   null          Lewiston      Idaho             United States  83501
Main Office  Blue Ridge Mall                 null          Kansas City   Missouri          United States  64106
Main Office  No. 25800-130 King Street West  null          Toronto       Ontario           Canada         M4B 1V5
Main Office  6500 East Grant Road            null          Tucson        Arizona           United States  85701
Main Office  Eastridge Mall                  null          Casper        Wyoming           United States  82601
Main Office  252851 Rowan Place              null          Richmond      British Columbia  Canada         V6B 3P7
Main Office  White Mountain Mall             null          Rock Springs  Wyoming           United States  82901

10 row(s) returned

Executed in 1 ms
mssql> SELECT TOP 10 CompanyName, SalesOrderID, TotalDue, AddressLine1, AddressLine2, City, StateProvince, CountryRegion, PostalCode FROM SALESLT.ADDRESS AS a JOIN saleslt.customeraddress AS ca ON a.addressid = ca.addressid WHERE addresstype = 'Main Office' JOIN (SELECT SalesLT.Customer JOIN SalesLT.SalesOrderHeader ON Customer.CustomerID = SalesOrderHeader.CustomerID) AS orders ON ca.customerid = orders.customerid ;
Error: Incorrect syntax near the keyword 'JOIN'.
mssql> SELECT TOP 10 CompanyName, SalesOrderID, TotalDue, AddressLine1, AddressLine2, City, StateProvince, CountryRegion, PostalCode FROM SALESLT.ADDRESS AS a JOIN saleslt.customeraddress AS ca ON a.addressid = ca.addressid WHERE addresstype = 'Main Office' JOIN saleslt.salesorderheader AS soh ON addressid = billtoaddressid;
Error: Incorrect syntax near the keyword 'JOIN'.
```

DRAFT need to check schema ::
```(sql)
SELECT CompanyName, SalesOrderID, TotalDue, <lots of address fields>
FROM SalesLT.Customer AS cust
JOIN SalesLT.SalesOrderHeader
ON Customer.CustomerID = SalesOrderHeader.CustomerID
JOIN SalesLT.CustomerAddress as ca
ON cust.CustomerID = ca.CustomerID
WHERE ca.Type = 'Main Office'
JOIN SalesLT.Address AS a
ON a.Address
```

would be nice to export schema separately from tables. I wonder how.



---

Proof of concept connecting to SQL using Java
https://msdn.microsoft.com/en-us/library/mt720656.aspx

I downloaded Squirrel java installer, and the unix tarball of the
Microsoft JDBC driver

http://www.squirrelsql.org/#installation

https://www.microsoft.com/en-us/download/details.aspx?displaylang=en&id=11774


See
http://squirrel-sql.sourceforge.net/user-manual/quick_start.html#the_driver

---

SELECT CompanyName, SalesOrderID, TotalDue, addresstype
FROM SalesLT.Customer AS cust
JOIN SalesLT.SalesOrderHeader
ON Customer.CustomerID = SalesOrderHeader.CustomerID
JOIN SalesLT.CustomerAddress as ca
ON cust.CustomerID = ca.CustomerID
WHERE ca.addresstypeType = 'Main Office'
JOIN SalesLT.Address AS a
ON a.Address


Error: Incorrect syntax near the keyword 'JOIN'.

ON Customer.CustomerID = SalesOrderHeader.CustomerID JOIN SalesLT.CustomerAddress as ca ON cust.CustomerID = ca.CustomerID WHERE ca.addresstype = 'Main Office' ;
Error: The multi-part identifier "Customer.CustomerID" could not be bound.

progress

mssql> SELECT CompanyName, SalesOrderID, TotalDue, addresstype FROM SalesLT.Customer AS cust JOIN SalesLT.SalesOrderHeader ON SalesLT.Customer.CustomerID = SalesOrderHeader.CustomerID JOIN SalesLT.CustomerAddress as ca ON cust.CustomerID = ca.CustomerID WHERE ca.addresstype = 'Main Office' ;
Error: The multi-part identifier "SalesLT.Customer.CustomerID" could not be bound.


```
mssql> SELECT TOP 1 * FROM SalesLT.Customer;
CustomerID  NameStyle  Title  FirstName  MiddleName  LastName  Suffix  CompanyName   SalesPerson              EmailAddress  Phone         PasswordHash                                  PasswordSalt  rowguid                               ModifiedDate
----------  ---------  -----  ---------  ----------  --------  ------  ------------  -----------------------  ------------  ------------  --------------------------------------------  ------------  ------------------------------------  ------------------------
1           false      Mr.    Orlando    N.          Gee       null    A Bike Store  adventure-works\pamela0  null          245-555-0173  L/Rlwxzp4w7RWmEgXX+/A7cXaePEPcp+KwQhl2fJL7w=  1KjXYs4=      3F5AE95E-B87D-4AED-95B4-C3797AFCB74F  2005-08-01T00:00:00.000Z

1 row(s) returned
```


Turned out that once I had aliased it, I *had* to use the alias:

mssql> SELECT CompanyName, SalesOrderID, TotalDue, addresstype FROM SalesLT.Customer AS cust JOIN SalesLT.SalesOrderHeader ON cust.CustomerID = SalesOrderHeader.CustomerID JOIN SalesLT.CustomerAddress as ca ON cust.CustomerID = ca.CustomerID WHERE ca.addresstype = 'Main Office' ;
CompanyName                      SalesOrderID  TotalDue     addresstype
-------------------------------  ------------  -----------  -----------
Eastside Department Store        71783         92663.5609   Main Office
Riding Cycles                    71797         86222.8072   Main Office
Engineered Bike Systems          71816         3754.9733    Main Office
Tachometers and Accessories      71831         2228.0566    Main Office
Closest Bicycle Store            71832         39531.6085   Main Office
Trailblazing Sports              71845         45992.3665   Main Office
Transport Bikes                  71856         665.4251     Main Office
Sports Products Store            71863         3673.3249    Main Office
Paints and Solvents Company      71897         14017.9083   Main Office
Instruments and Parts Company    71898         70698.9922   Main Office
Many Bikes Store                 71902         81834.9826   Main Office
Essential Bike Works             71917         45.1995      Main Office
Discount Tours                   71920         3293.7761    Main Office
The Bicycle Accessories Company  71923         117.7276     Main Office
Metropolitan Bicycle Supply      71936         108597.9536  Main Office
Good Toys                        71774         972.785      Main Office
Central Bicycle Specialists      71946         43.0437      Main Office
Bulk Discount Store              71938         98138.2131   Main Office
Remarkable Bike Store            71935         7330.8972    Main Office
Aerobic Exercise Company         71915         2361.6403    Main Office
Coalition Bike Company           71899         2669.3183    Main Office
Futuristic Bikes                 71895         272.6468     Main Office
Channel Outlet                   71885         608.1766     Main Office
Vigorous Sports Store            71867         1170.5376    Main Office
Thrilling Bike Tours             71858         15275.1977   Main Office
Extreme Riding Supplies          71796         63686.2708   Main Office
Action Bicycle Specialists       71784         119960.824   Main Office
Professional Sales and Service   71782         43962.7901   Main Office
Sports Store                     71846         2711.4098    Main Office
Thrifty Parts and Sales          71815         1261.444     Main Office
Nearby Cycle Shop                71780         42452.6519   Main Office
West Side Mart                   71776         87.0851      Main Office

32 row(s) returned


Tested with Squirrel - much easier to use than sql-cli


```
SELECT CompanyName, SalesOrderID, TotalDue, addr.AddressLine1 , addr.AddressLine2, addr.City,
addr.StateProvince, addr.PostalCode
FROM SalesLT.Customer AS cust
JOIN SalesLT.SalesOrderHeader ON cust.CustomerID = SalesOrderHeader.CustomerID
JOIN SalesLT.CustomerAddress AS ca ON cust.CustomerID = ca.CustomerID
JOIN SalesLT.Address AS addr ON addr.AddressID = ca.AddressID
WHERE ca.addresstype = 'Main Office'
;
```

See from the instructors solution that it is probably smarter - at least equivalent and arguably more readable, to JOIN on a logical AND, as

    JOIN SalesLT.CustomerAddress AS ca
    ON c.CustomerID = ca.CustomerID AND AddressType = 'Main Office'

instead of the WHERE clause.

The sqlite docs suggest they are equivalent except in LEFT JOINs :

> In a LEFT JOIN, the extra NULL row for the right-hand table is added
> after ON clause processing but before WHERE clause processing.

### 2

In sql files - using Squirrel - working nicely.

I notice that I am not using ISNULL in addresses where this would help:

    ISNULL(a.AddressLine2, '')

I also quite like the way the solutions have a new line for the ON phrase

Is `LEFT JOIN` a synonym for `LEFT OUTER JOIN`?

I am almost certain from the SQLite docs that it is. Noticed that
SQLite doesn't have a RIGHT JOIN or RIGHT OUTER JOIN.

Also noticed that SQLite doesn't have T-SQL's `FULL JOIN`.

In T-SQL `FULL JOIN` means `FULL OUTER JOIN`. It is the union of the
`LEFT JOIN` and the `RIGHT JOIN`.

It looks like I got 2.3 completely wrong:

> -- Customers and products for which there are no orders

The provided solution has three FULL JOINs, followed by a WHERE clause:

    WHERE oh.SalesOrderID IS NULL

I don't think I can fully picture what is there, but I _think_ that
the first 2 full joins keep the NULL customers, who have never
ordered, and the last FULL JOIN with the WHERE clause seems to add
rows for all the Products that were never sold.

I am not _sure_ why the third join is a FULL JOIN, but I suspect that
if it isn't, all the NULL customers get dropped again.. I wonder what
gets lost if I use LEFT JOINs for the first two joins.

Also I am not sure why the WHERE clause doesn't drop all the null
customers. Probably because the LEFT part of the joins brought in lots
of NULL products when they created the rows for customers with no
orders. I wonder if a smarter way to do the whole thing would be with
a UNION of two queries.

I also read that MySQL doesn't have FULL OUTER JOIN, and MySQL users
synthesise it it with LEFT JOIN ... UNION ... RIGHT JOIN.

- [ ] see how far off my query was in results from the solution
- [ ] see if my query is fixable
- [ ] play with various combinations of OUTER JOIN in the query

I wonder what `project` means in AREL. Something to do with relational
algebra, I guess.

- [ ] read https://en.wikipedia.org/wiki/Projection_(relational_algebra)

In AREL, what is the difference between `project` and `where`?


## Lab 4

Noticed that Azure doesn't seem to accept implicit JOIN ON columns like this:

```
SELECT COUNT(*)
FROM "SalesLT"."Customer" AS c
JOIN "SalesLT"."CustomerAddress" AS ca
ON c.CustomerID = ca.CustomerID AND ca.AddressType = 'Main Office'
JOIN "SalesLT"."Address" AS a
ON AddressID
;

Error: An expression of non-boolean type specified in a context where a condition is expected, near ';'.
SQLState:  S1000
ErrorCode: 4145
```

or more simply

```
SELECT COUNT(*)
FROM "SalesLT"."Customer" AS c
JOIN "SalesLT"."CustomerAddress" AS ca
ON CustomerID

Error: An expression of non-boolean type specified in a context where a condition is expected, near 'CustomerID'.
SQLState:  S1000
ErrorCode: 4145
```
