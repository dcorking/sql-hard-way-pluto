UPDATE person SET first_name = "Hilarious Guy"
WHERE first_name = "Zed";

UPDATE pet SET name = "Fancy Pants"
WHERE id = 0;

SELECT * FROM person;
SELECT * FROM pet;

-- extra credit
UPDATE person SET first_name = "Zed"
WHERE id = 0;

SELECT * FROM person;
SELECT * FROM pet;

UPDATE pet SET name = "DECEASED"
WHERE dead = 1;

SELECT * FROM pet;

-- this is wrong; it updates name to the contents of pet.dead, that is
-- '1'
UPDATE pet SET name = "DEAD"
WHERE dead = 1;

SELECT * FROM pet;

-- mark all pets as dead with age greater than 20 and id greater than 1
UPDATE pet SET dead = 1
WHERE age > 20 AND id >= 2;

SELECT * FROM pet;

-- SET two attributes in one update

-- use a subquery

-- use a subquery that joins 2 tables
