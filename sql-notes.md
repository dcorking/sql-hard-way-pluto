Output from running the exercises 2 through 7 without dropping tables or deleting the DB.

```
dcorking@Argo:~/workspace/sql-hard-way-pluto (ex7)$ sqlite3 ex3.db < ex7a.sql
Error: near line 1: table person already exists
Error: near line 8: table pet already exists
Error: near line 16: table person_pet already exists
Error: near line 21: table car already exists
Error: near line 29: table person_car already exists
Error: near line 34: UNIQUE constraint failed: person.id
Error: near line 37: UNIQUE constraint failed: pet.id
Error: near line 40: UNIQUE constraint failed: pet.id
0|Zed|Shaw|37
Fluffy|1000
Gigantor|1
Fluffy|1000
Gigantor|1
0|Fluffy|1000|0
1|Gigantor|1|0
0|Fluffy|1000|0
1|Gigantor|1|0
0|Fluffy|Unicor|1000|0
1|Gigantor|Robot|1|0
Error: near line 73: UNIQUE constraint failed: pet.id
0|Fluffy|Unicor|1000|0
1|Gigantor|Robot|1|0
```


So I put in some drops like this:


    DROP TABLE pet;

I get no errors until I delete the db. Then I get this:

```
Error: near line 1: no such table: person
Error: near line 9: no such table: pet
Error: near line 18: no such table: person_pet
Error: near line 24: no such table: car
Error: near line 33: no such table: person_car
```

and despite the errors, it still works, so do this instead.

    DROP TABLE IF EXISTS pet;

Great ref: https://www.sqlite.org/lang.html

---

## CREATE TABLE

CREATE TABLE can have 'without rowid' - it is an optimization - there
is no logical diifference.

If don't define a PRIMARY KEY column, get

    Error: PRIMARY KEY missing on table bar

Can CREATE TEMP TABLE. Lookup

## INSERT INTO

If don't insert primary key, get

    Error: NOT NULL constraint failed: bar.national_insurance


---

Weird formatting of my schema during ex13
```
$ sqlite3 ex13.db .schema
CREATE TABLE person (
        id INTEGER PRIMARY KEY,
        first_name TEXT,
        last_name TEXT,
        age INTEGER
        , height FLOAT, weight FLOAT, dead INTEGER);
```

why the comma on the newline, then everything else on one line?
Common factor is the last 3 columns were added by ALTER TABLE

Interestingly , sqlite3 tries to keep going after an error. (At least it does if I don't explicitly set error handling options, and don't use a transaction), so when I did this in a table that already had a dead column, this happened:
```
-- Add a dead column to person that's like the one in pet.
    ALTER TABLE person
ADD COLUMN dead INTEGER;
-- Add a phone_number column to person.
    ALTER TABLE person
ADD COLUMN phone_number INTEGER;
-- Add a salary column to person that is float.
-- Float for money? Shame on you!
    ALTER TABLE person
ADD COLUMN salary FLOAT;

dcorking@Argo:~/workspace/sql-hard-way-pluto (ex13)$ sqlite3 ex13.db < ex13.sql
Error: near line 3: duplicate column name: dead
dcorking@Argo:~/workspace/sql-hard-way-pluto (ex13)$ sqlite3 ex13.db .schema
CREATE TABLE person (
        id INTEGER PRIMARY KEY,
        first_name TEXT,
        last_name TEXT,
        age INTEGER
        , height FLOAT, weight FLOAT, dead INTEGER, phone_number INTEGER, salary FLOAT);
```
## July 14 Bastille Day

In sqlite if I search for purchased_on > '2004' like this I get the *wrong records*

``` sql
SELECT pet.name, person.first_name, person.last_name, person_pet.purchased_on
FROM pet, person_pet, person
WHERE
    person_pet.person_id = person.id AND
    person_pet.pet_id = pet.id AND
    person_pet.purchased_on > '2004';

```

```
name        first_name  last_name   purchased_on
----------  ----------  ----------  -------------
Fluffy      Zed         Shaw        12-April-2001
Bounce      Davina      Collybird   2-Jun-2010

```

```
sqlite> SELECT pet.name, person.first_name, person.last_name, person_pet.purchased_on
   ...> FROM pet, person_pet, person
   ...> WHERE
   ...>     person_pet.person_id = person.id AND
   ...>     person_pet.pet_id = pet.id ;
Hedwig|Harry|Potter|
Rover|Yours|Truly|
Rover|Junior|Truly|
Fluffy|Zed|Shaw|12-April-2001
Diesel|Spenser|Dixon|
Spot|Spenser|Dixon|
Bounce|Davina|Collybird|2-Jun-2010
```

Not only is the date filter wrong, but some ownerships just aren't
showing up at all in this query.

Harry Potter has joint ownership of Spot - but Spot only shows up once.

For dates in sqlite there is no special datatype so I need to use these functions

    www.sqlite.org/lang_datefunc.html

## June 22

Experimenting with 'date', it can give odd results if used naively,
but it is pretty powerful.

```
sqlite> date('2004-12-31');
Error: near "date": syntax error
sqlite> SELECT date('2004-12-31');
2004-12-31
sqlite> SELECT date('2004-12-32');

sqlite> SELECT date('2-Jun-2010');

sqlite> SELECT date('2004-12-31') > date('2004-12-30');
1
sqlite> SELECT date('2004-12-31') < date('2004-12-30');
0
sqlite> SELECT date('02-Jun-2010');

sqlite> SELECT date('02-June-2010');

sqlite> SELECT date('2004-12-31') + 1;
2005
sqlite> SELECT date('2004-12-31') + date(1);
-2709
sqlite> SELECT date('2004-12-31') + 1.0;
2005.0
sqlite> select date('1 days');

sqlite> select date('1', 'days');

sqlite> select date('1', days);
Error: no such column: days
sqlite> SELECT date('2004-12-31', '+ 1 days');

sqlite> SELECT date('2004-12-31', '+1 days');
2005-01-01
sqlite>
```

I can SELECT an expression instead of an actual column.

I get a little more convenience, or at least briefer code, with the
(non-standard ?) DATETIME datatypes in MySQL, MariaDB and PostgreSQL

I can't naively store a decimal Julian day as a real. Instead I have
to manipulate it:

```
sqlite> SELECT date('1970-03-15');
1970-03-15
sqlite> SELECT julianday('1970-03-15');
2440660.5
sqlite> SELECT date('2440661');
1970-03-15
sqlite> UPDATE person SET dob = 2440661 WHERE first_name = "Zed";
sqlite> SELECT * FROM person;
0|Zed|Shaw|37|||0|5551111|90000.0|2440661
2|Harry|Potter|26|||0||90000.0|
3|Yours|Truly|41|||0||90000.0|
4|Junior|Truly|17|||0||90000.0|
5|Sally|Smithson|23|||0|5551234|120000.0|1-July-1995
6|Spenser|Dixon|123|||0|5552212|25000.5|29-Feb-1903
7|Jaxon|Whitebait|82|||1||0.0|18-Feb-1912
8|Davina|Collybird|56|||0|0|210005.98|22-Apr-1961

/* WRONG  */
sqlite> SELECT * FROM person WHERE dob=date('1970-03-15');
sqlite> UPDATE person SET dob = date('2440661') WHERE first_name = "Zed";
/* WRONG */
sqlite> SELECT * FROM person WHERE dob=date('1970-03-15');
0|Zed|Shaw|37|||0|5551111|90000.0|1970-03-15
sqlite> UPDATE person SET dob = 2440661 WHERE first_name = "Zed";
/* RIGHT */
sqlite> SELECT * FROM person WHERE date(dob)=date('1970-03-15');
0|Zed|Shaw|37|||0|5551111|90000.0|2440661
sqlite>
```

or just store an ISO8601 string.

'date' only accepts a selection of ISO8601 timestrings - it is not as
flexible as date functions in upscale SQL dialects which accept and
emit various non ISO and locale-specific dates and times.

## July 27

Both of these seem to work ok for me, although the first is probably wrong:
```
sqlite> SELECT * from person_pet
   ...> WHERE purchased_on > date('2004-12-31');
SELECT * from person_pet
WHERE purchased_on > date('2004-12-31');
person_id   pet_id      purchased_on
----------  ----------  ------------
1           7           2009-03-15
8           9           2010-06-02
sqlite> SELECT * from person_pet
   ...> WHERE date(purchased_on) > date('2004-12-31');
SELECT * from person_pet
WHERE date(purchased_on) > date('2004-12-31');
person_id   pet_id      purchased_on
----------  ----------  ------------
1           7           2009-03-15
8           9           2010-06-02
```

Before you add a WHERE clause, SELECT FROM gives the CROSS product of
all the tables in the FROM clause.

Hehe, I am so practiced in Zed's method, I forgot what little I
learned of the JOIN syntax:
```
sqlite> SELECT * FROM person_pet, person
   ...> WHERE person_id = person.id;
person_id   pet_id      id          first_name  last_name   age         height
weight
----------  ----------  ----------  ----------  ----------  ----------  ----------
----------
2           2           2           Harry       Potter      26

3           3           3           Yours       Truly       41

4           3           4           Junior      Truly       17

0           0           0           Zed         Shaw        37

sqlite> SELECT * FROM person_pet, person
   ...> JOIN ON person_id, person.id;
Error: near "ON": syntax error
```

These didn't take very long to write, so I think I am starting to get
a bit of fluency.

```
-- All children of Diesel
SELECT name, parent
FROM pet
WHERE
    parent =
    (SELECT id
    FROM pet
    WHERE
        pet.name = 'Diesel');
name        parent
----------  ----------
Inky        5
Spot        5

-- extra credit - all pets and their parents, where their parents are
-- known
SELECT pets1.name, pets1.parent, pets2.name
FROM pet AS pets1, pet AS pets2
WHERE pets1.parent = pets2.id;
name        parent      name
----------  ----------  ----------
Diesel      8           Mercedes
Inky        5           Diesel
Spot        5           Diesel
```

Oh ^%$@&^%$^&%!
I got the _syntax_ of JOIN but not the _semantics_ haha:
```
sqlite> SELECT *
   ...> FROM person_pet, person
   ...> JOIN person_pet, person
   ...> ON person_id = person.id;
Error: ambiguous column name: main.person_pet.person_id
sqlite> SELECT *
   ...> FROM person_pet, person
   ...> JOIN person_pet, person
   ...> ON person_pet.person_id = person.id;
Error: ambiguous column name: main.person_pet.person_id
```

Two forms of CASE

CASE column_name WHEN value THEN expression....
ELSE ...

CASE WHEN boolean-expression THEN expression
WHEN boolean-expression THEN expression ....
ELSE ...


This gets me into my azure sql database on the Mac

```
npm install -g sql-cli

dcorking@Argo:~$ mssql -s sql-dromedary.database.windows.net -u 'dcorking' -p 5lMChUHHftfqwLwCVDwf -d AdventureWorksLT -e
Connecting to sql-dromedary.database.windows.net...done

sql-cli version 0.4.6
Enter ".help" for usage hints.
mssql>
```

and I can find the tables

```
mssql> .databases;
Error: Could not find stored procedure 'databases'.
mssql> .databases
name
----------------
master
AdventureWorksLT

2 row(s) returned

Executed in 1 ms
mssql> .help

command         description
--------------  ------------------------------------------
.help           Shows this message
.tables         Lists all the tables
.databases      Lists all the databases
.read FILENAME  Execute commands in a file
.run FILENAME   Execute the file as a sql script
.schema TABLE   Shows the schema of a table
.indexes TABLE  Lists all the indexes of a table
.analyze        Analyzes the database for missing indexes.
.quit           Exit the cli

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

Executed in 1 ms
mssql> select * from SalesLT.Customer;
...
30117       false      Mr.    Robert                    R.          Vessa                   null    Totes & Baskets Company                    adventure-works\jillian0  robert13@adventure-works.com                 560-555-0171         UWGC2U8F7AUNA2FuiT4agrBoxAFskHGQSxqP39B7zLQ=  iES3IZA=      6F08E2FB-1CD3-4F6E-A2E6-385669598B19  2005-08-01T00:00:00.000Z
30118       false      Ms.    Caroline                  A.          Vicknair                null    World of Bikes                             adventure-works\jillian0  caroline0@adventure-works.com                695-555-0158         U1/CrPqSzwLTtwgBehfpIl7f1LHSFpZw1qnG1sMzFjo=  QhHP+y8=      2495B4EB-FE8B-459E-A1B6-DBA25C04E626  2006-09-01T00:00:00.000Z

847 row(s) returned
```

I don't know why the tables are namespaced, such as 'SalesLT....'

Where do I put the password in pgloader?

dcorking@Argo:~/workspace/adventureworkslt$ pgloader mssql://dcorking@sql-dromedary/AdventureWorksLT postgresql:///adventureworkslt
2016-07-27T13:39:13.062000+01:00 LOG Main logs in 'NIL'
2016-07-27T13:39:13.065000+01:00 LOG Data errors in '/private/tmp/pgloader/'
An unhandled error condition has been signalled:
   Failed to connect to mssql at "sql-dromedary" (port 1433) as user "dcorking": Connection to the database failed for an unknown reason.

So I put password after colon, per man page, and got

```
dcorking@Argo:~/workspace/adventureworkslt$ pgloader mssql://dcorking:5lMChUHHftfqwLwCVDwf@sql-dromedary/AdventureWorksLT postgresql:///adventureworkslt

2016-07-27T13:41:33.034000+01:00 LOG Main logs in '/private/tmp/pgloader/pgloader.log'
2016-07-27T13:41:33.043000+01:00 LOG Data errors in '/private/tmp/pgloader/'
An unhandled error condition has been signalled:
   Failed to connect to mssql at "sql-dromedary" (port 1433) as user "dcorking": Connection to the database failed for an unknown reason.
```

```
dcorking@Argo:~/workspace/adventureworkslt$ pgloader mssql://dcorking:5lMChUHHftfqwLwCVDwf@sql-dromedary.database.windows.net/AdventureWorksLT postgresq
l:///adventureworkslt
2016-07-27T13:42:51.030000+01:00 LOG Main logs in '/private/tmp/pgloader/pgloader.log'
2016-07-27T13:42:51.039000+01:00 LOG Data errors in '/private/tmp/pgloader/'
Max connections reached, increase value of TDS_MAX_CONN
An unhandled error condition has been signalled:
   Failed to connect to mssql at "sql-dromedary.database.windows.net" (port 1433) as user "dcorking": %dbsqlexec fail
```

I changed the error essage by using the FQDN

Telnet sort of works

```
dcorking@Argo:~/workspace/adventureworkslt$ telnet sql-dromedary.database.windows.net 1433
Trying 191.237.232.75...
Connected to westeurope1-a.control.database.windows.net.
Escape character is '^]'.
Connection closed by foreign host.
```

```
$ pgloader --version
pgloader version "3.2.2"
compiled with SBCL 1.3.7
```

verbose debug log

```
2016-07-27T13:54:14.052000+01:00 NOTICE Starting pgloader, log system is ready.
2016-07-27T13:54:14.078000+01:00 INFO Starting monitor
2016-07-27T13:54:14.083000+01:00 LOG Main logs in '/private/tmp/pgloader/pgloader.log'
2016-07-27T13:54:14.083000+01:00 LOG Data errors in '/private/tmp/pgloader/'
2016-07-27T13:54:14.083000+01:00 INFO SOURCE: #<PGLOADER.MSSQL:MSSQL-CONNECTION mssql://dcorking@sql-dromedary.database.windows.net:1433/NIL {10074E6893}>
2016-07-27T13:54:14.083000+01:00 INFO TARGET: #<PGLOADER.PGSQL:PGSQL-CONNECTION pgsql://dcorking@UNIX:5432/adventureworkslt {10076202C3}>
2016-07-27T13:54:14.083000+01:00 DEBUG LOAD DATA FROM #<PGLOADER.MSSQL:MSSQL-CONNECTION mssql://dcorking@sql-dromedary.database.windows.net:1433/NIL {10074E6893}>
2016-07-27T13:54:14.083000+01:00 DEBUG CONNECTED TO #<PGLOADER.PGSQL:PGSQL-CONNECTION pgsql://dcorking@UNIX:5432/adventureworkslt {10076202C3}>
2016-07-27T13:54:14.489000+01:00 FATAL We have a situation here.
```


Exercise 14 Transactions

I get this

    Error: incomplete SQL: ROLLBACK

Because, despite the implication in the book, BEGIN and ROLLBACK are
statements, not clauses or anything else, and need a semi-colon after
them.

Those 2 semicolons fix the error, though nothing happened to the schema anyway.

BUT, a missing semicolon after BEGIN, and not after ROLLBACK is much more serious:

```
ROLLBACK;
Error: near line 125: cannot rollback - no transaction is active
```

Here all the damage is done!!

So DON'T FORGET THE SEMICOLON if you think your query is in any way
destructive.

Now things are getting bad - I ran the file twice, once with the
broken transaction, and one with a COMMITed transaction, and now my schema looks OK, but I have duplicate data:

```
SELECT pet.name, person.first_name, person.last_name, person_pet.purchased_on
FROM pet, person_pet, person
WHERE
    person_pet.person_id = person.id AND
    person_pet.pet_id = pet.id AND
    date(person_pet.purchased_on) > date('2004-12-31');
name        first_name  last_name   purchased_on
----------  ----------  ----------  ------------
Spot        Angela      Spacey      2009-03-15
Bounce      Davina      Collybird   2010-06-02
Spot        Angela      Spacey      2009-03-15
Bounce      Davina      Collybird   2010-06-02
```

sqlite3 doesn't care if I invent arbitrary datatypes, like
```
CREATE TABLE person (
        id INTEGER PRIMARY KEY,
        first_name TEXT,
        last_name TEXT,
        age INTEGER
        , height FLOAT, weight FLOAT, dead INTEGER, phone_number INTEGER, salary FLOAT, dob FLUBBER);
```

FLUBBER :)

Transaction exercise was fun. I look forward to trying the extra credit.

## July 28

In SQLite3 (an in all SQLs?) table names are not case sensitive: person is the same table as PERSON

But string equality IS case sensitive. 'Zed' != 'ZED'

These bring back the wrong records, without error.

```
SELECT * FROM PERSON WHERE date(dob) > date('1980');
SELECT * FROM PERSON WHERE date(dob) > date(1980);
```

Should be

     SELECT * FROM PERSON WHERE date(dob) > date('1980-01-01');

Look closely: dates are strings, and they are full dates, not just
years.

It seems from the manual that sqlite implements transactions simply,
by locking the whole database until the transaction is completed or
rolled back.

It turns out that if I insert or update in a commit transaction then
get a subsequent error, the INSERT and UPDATE are still committed.

Also noticed that even though up to now I have set `id` explicitly,
sqlite is automatically incrementing it and setting it on INSERTs when
I don't specify the id.  It increments it, not from some hidden
sequence, but from the max value of the id column.  Probably
identifies it from the PRIMARY KEY constraint.



     Error: near line 26: UNIQUE constraint failed: person.id

I found above error when repeating an INSERT on an existing column

The DEFERRED, IMMEDIATE, and EXCLUSIVE keywords in BEGIN determine
more precisely the db locking behaviour among multiple threads.

- [ ] experiment with multiple clis accessing a sqlite db

- [ ] ex15 vetinary mgmt database - schema first
- [ ] ex15 food service or music player - screens first
- [ ] ex15 - which is best for UI and database design

Empty chapters
- [ ] ex16 Making Indices
- [ ] ex17 Optimizing
- [ ] ex18 Triggers
- [ ] ex19 update 1 table from another
- [ ] ex20 Views
- [ ] ex21 Simple Data Analysis with Views
- [ ] ex22 GROUP BY, COUNT
- [ ] ex23 Date and Time (in more detail than the datatypes chapter)
- [ ] ex24 Range Queries by Dates (a BETWEEN keyword??)
- [ ] ex25 Averages
- [ ] ex26 Max and Min
- [ ] ex27 Safe Data Practices With Transactions
- [ ] ex28 Advanced Transactions And Savepoints (what is the goal?
  when do you do this in real life?)
- [ ] ex29 Sums And Totals
- [ ] ex30 Logic And Math Expressions  ( a lot of potential here)
- [ ] ex31 More Statistics And Math (what should be here? built-in
  functions, or clever ways to compose them to do useful work)
- [ ] ex32 String Manipulation (ditto)
- [ ] ex33 Fixing Databases With Bad Input (should be interesting when it is written)


Exercises to try

http://dba.stackexchange.com/questions/65233/how-can-i-make-multiple-joins-on-the-same-table?rq=1

http://dba.stackexchange.com/questions/107316/avoid-joining-to-the-same-table-multiple-times?rq=1

http://dba.stackexchange.com/questions/124610/join-table-into-different-columns?rq=1


# July 29

COPY is the keyword to import table data from a CSV. Export also.

On the Mac (pg from brew) the default db is postgres, so to create a
database I need to specify it specifically on the command line. (Works
fine with Rails)

    psql -d postgres -c "CREATE DATABASE \"Adventureworks\";"

(psql tries to open a 'dcorking' database. pgAdminIII is set up fine for now.)

> Note you can get a list of available databases with psql -l.




## Aug 8

^ is *not* in a LIKE [] character group pattern match.


IN() filters by a dynamic set, for example:

```
SELECT ProductNumber, Name
FROM SalesLT.Product
WHERE Color IN ('Black','Red','White') and Size IN ('S','M');
```

## Sep 6

What is the difference between a derived table and a sub-query?

## Sep 7

A sub-query is only one column and can only be used as such, for example in an IN clause, where as a derived table is two dimensional

Module 7 of Microsoft+DAT201x is about Table Expressions.

Some of these are not portable, so I skipped table variables,
temporary tables and table-valued functions.

I am focussing on things that look to be portable, that is Views,

Derived Tables,

and Common Table Expressions. https://www.postgresql.org/docs/current/static/queries-with.html

## Sep 8

Module 8

 rough correspondences:

Microsoft  Postgres
========   ========

PIVOT      CROSSTAB()
GROUPING_ID  ???
GROUPING SET GROUPING SET
ROLLUP     ROLLUP
CUBE       CUBE

## Sep 15

Another GWR wifi IP  '83.217.96.157'
Another First Bus 82.132.186.241

- [ ] add above IP ranges to azure FW

## Sep 16

Did this in a dev DB because I missed it out of my seeds

    UPDATE addresses SET postal_code = 'BS1 3UT';

## Sep 20

Module 6 : I wonder what the Postgres language for table-valued
functions and CROSS APPLY.

## Sep 21

```
dcorking@Argo:~$ psql postgres
psql (9.5.3)
Type "help" for help.

postgres=# ALTER DATABASE sourcecards_development RENAME sourcecards_broken_dev
postgres-#
postgres-# ;
ERROR:  syntax error at or near "sourcecards_broken_dev"
LINE 1: ALTER DATABASE sourcecards_development RENAME sourcecards_br...
                                                      ^
postgres=# ALTER DATABASE sourcecards_development RENAME TO sourcecards_broken_dev;
ERROR:  database "sourcecards_development" is being accessed by other users
DETAIL:  There is 1 other session using the database.
postgres=# ALTER DATABASE sourcecards_development RENAME TO sourcecards_broken_dev;
ALTER DATABASE
```

## Sep 22

All of my local database are listed in the `postgres` database, in the
SYSTEM TABLE `pg_database`, named inthe `datname` column.

This `postgres` database is the place I want to be to run ADD DATABASE
and DROP DATABASE statements.

## Oct 6

Interestingly GROUP BY doesn't require parens round its arguments, but
GROUP BY ROLLUP does.

## Oct 10

in a CASE expression, ELSE is optional, but END is mandatory.

A CASE expression only matches once, which makes this quite easy (in adventure works lab 8)

```
(CASE
WHEN (GROUPING_ID(a.CountryRegion) = 1)
THEN 'Total'
WHEN GROUPING_ID(a.stateprovince) = 1
THEN (a.countryregion + ' Subtotal')
ELSE ''
END) AS 'Level'
```


## Oct 15

CHOOSE() is an interesting alternative to CASE WHEN
when you can add up GROUPING_ID to get the index for CHOOSE.


