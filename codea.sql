-- Exercise 8 extra credit, combined with previous exercises

DROP TABLE IF EXISTS person;
CREATE TABLE person (
        id INTEGER PRIMARY KEY,
        first_name TEXT,
        last_name TEXT,
        age INTEGER
        );

DROP TABLE IF EXISTS pet;
CREATE TABLE pet (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT,
        age INTEGER,
        dead INTEGER
        );

DROP TABLE IF EXISTS person_pet;
CREATE TABLE person_pet (
        person_id INTEGER,
        pet_id INTEGER
        );

DROP TABLE IF EXISTS car;
CREATE TABLE car (
        id INTEGER PRIMARY KEY,
        make TEXT,
        model TEXT,
        engine_size INTEGER,
        colour TEXT
        );

DROP TABLE IF EXISTS person_car;
CREATE TABLE person_car (
        person_id INTEGER,
        car_id INTEGER
        );

INSERT INTO person (id, first_name, last_name, age)
    VALUES (0, "Zed", "Shaw", 37);

INSERT INTO pet (id, name, breed, age, dead)
    VALUES (0, "Fluffy", "Unicor", 1000, 0);

INSERT INTO pet VALUES (1, "Gigantor", "Robot", 1, 1);

-- ex4.sql
INSERT INTO person_pet (person_id, pet_id) VALUES (0, 0);
INSERT INTO person_pet VALUES (0, 1);
-- ex5.sql
SELECT * FROM person;

SELECT name, age FROM pet;

SELECT name, age FROM pet WHERE dead = 0;

SELECT * FROM person WHERE first_name != "Zed";
-- ex6.sql
SELECT pet.id, pet.name, pet.age, pet.dead
    FROM pet, person_pet, person
    WHERE
    pet.id = person_pet.pet_id AND
    person_pet.person_id = person.id AND
    person.first_name = "Zed";

-- dead pets?
SELECT name, age FROM pet WHERE dead = 1;

-- poor robot
DELETE FROM pet WHERE dead = 1;

    /* but I didn't delete the join table rows */

-- is he gone?
SELECT * FROM pet;

-- resurrection
INSERT INTO pet VALUES (1, "Gigantor", "Robot", 1, 0);

-- Life!
SELECT * FROM pet;

-- but only because we haven't learnt UPDATE yet


-- ex8a.sql Exercise 8 extra credit

INSERT INTO pet (id, name, breed, age, dead)
    VALUES (2, "Hedwig", "Owl", 25, 0);

INSERT INTO pet (id, name, breed, age, dead)
    VALUES (3, "Rover", "Dog", 12, 0);

INSERT INTO pet (id, name, breed, age, dead)
    VALUES (4, "Trev", "Parrot", 5, 1);

INSERT INTO person (id, first_name, last_name, age)
    VALUES (2, "Harry", "Potter", 26);

INSERT INTO person (id, first_name, last_name, age)
    VALUES (3, "Yours", "Truly", 41);

INSERT INTO person_pet (person_id, pet_id)
    VALUES (2, 2);

INSERT INTO person_pet (person_id, pet_id)
    VALUES (3, 3);

INSERT INTO person_pet (person_id, pet_id)
    VALUES (3, 4);

-- Rover is a family pet
INSERT INTO person (id, first_name, last_name, age)
    VALUES (4, "Junior", "Truly", 17);
INSERT INTO person_pet (person_id, pet_id)
    VALUES (4, 3);

SELECT pet.id
FROM pet, person_pet, person
WHERE
    person.id = person_pet.person_id AND
    pet.id = person_pet.pet_id AND
    person.first_name = "Zed";

-- delete all Zed's pets, and their associations
DELETE FROM pet WHERE id IN (
    SELECT pet.id
    FROM pet, person_pet, person
    WHERE
        person.id = person_pet.person_id AND
        pet.id = person_pet.pet_id AND
        person.first_name = "Zed"
        );

SELECT * FROM pet;
SELECT * FROM person_pet;

DELETE FROM person_pet
WHERE pet_id NOT IN (
    SELECT id FROM pet
        );

SELECT * FROM person_pet;

-- delete my own dead pets, and their associations
--
-- again writing the join out in full, without the JOIN keyword
DELETE FROM pet WHERE id IN (
    SELECT pet.id
    FROM pet, person_pet, person
    WHERE
        person.first_name = "Yours" AND
        person.id = person_pet.person_id AND
        pet.id = person_pet.pet_id AND
        pet.dead = 1
        );

DELETE FROM person_pet
WHERE pet_id NOT IN (
SELECT id FROM pet
        );

-- list my own pets
SELECT DISTINCT * FROM pet, person_pet, person
WHERE
    person.first_name = "Yours" AND
    person.id = person_pet.person_id AND
    pet.id = person_pet.pet_id;

-- Delete the association records of the dead pets, but keep the pet
-- records
DELETE FROM person_pet WHERE pet_id IN (
    SELECT id FROM pet
    WHERE pet.dead = 1
        );

-- list each pet with their owners
SELECT DISTINCT
    pet.name,
    pet.dead,
    person.first_name,
    person.last_name
FROM pet, person_pet, person
WHERE
    pet.id = person_pet.pet_id AND
    person.id = person_pet.person_id;

-- list each pet with their owner
SELECT DISTINCT
    pet.name,
    pet.dead,
    person.first_name,
    person.last_name
FROM pet, person_pet, person
WHERE
    pet.id = person_pet.pet_id AND
    person.id = person_pet.person_id;

-- restore the deleted pets, still dead
INSERT INTO pet (id, name, breed, age, dead)
    VALUES (0, "Fluffy", "Unicorn", 1000, 0);
INSERT INTO pet VALUES (1, "Gigantor", "Robot", 1, 1);
INSERT INTO person_pet (person_id, pet_id) VALUES (0, 0);
INSERT INTO person_pet VALUES (0, 1);
INSERT INTO pet (id, name, breed, age, dead)
    VALUES (4, "Trev", "Parrot", 5, 1);
INSERT INTO person_pet (person_id, pet_id)
    VALUES (3, 4);

-- list each pet with their owner
SELECT DISTINCT
    pet.name,
    pet.dead,
    person.first_name,
    person.last_name
FROM pet, person_pet, person
WHERE
    pet.id = person_pet.pet_id AND
    person.id = person_pet.person_id;

-- delete people with dead pets
DELETE FROM person WHERE id IN (
    SELECT DISTINCT person.id
    FROM person, person_pet, pet
    WHERE
        pet.id = person_pet.pet_id AND
        person.id = person_pet.person_id AND
        pet.dead = 1
        );

-- list each pet with their owner
SELECT DISTINCT
    pet.name,
    pet.dead,
    person.first_name,
    person.last_name
FROM pet, person_pet, person
WHERE
    pet.id = person_pet.pet_id AND
    person.id = person_pet.person_id;

-- restore the deleted people
INSERT INTO person (id, first_name, last_name, age)
    VALUES (0, "Zed", "Shaw", 37);
INSERT INTO person (id, first_name, last_name, age)
    VALUES (3, "Yours", "Truly", 41);

-- Junior Truly also owns the dead parrot
INSERT INTO person_pet (person_id, pet_id)
    VALUES (4, 4);

-- list each pet with their owner
SELECT DISTINCT
    pet.name,
    pet.dead,
    person.first_name,
    person.last_name
FROM pet, person_pet, person
WHERE
    pet.id = person_pet.pet_id AND
    person.id = person_pet.person_id;

-- remove the associations of each dead pet with owners
DELETE FROM person_pet
WHERE pet_id IN (
    SELECT id FROM pet
    WHERE dead = 1
        );

-- list each pet with their owner
SELECT DISTINCT
    pet.name,
    pet.dead,
    person.first_name,
    person.last_name
FROM pet, person_pet, person
WHERE
    pet.id = person_pet.pet_id AND
    person.id = person_pet.person_id;

SELECT * FROM person;

    ALTER TABLE person ADD COLUMN height FLOAT;
    ALTER TABLE person ADD COLUMN weight FLOAT;

SELECT * FROM person;
