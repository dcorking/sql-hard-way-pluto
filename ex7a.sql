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
