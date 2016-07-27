-- ex13.sql
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
-- Add a dob column to both person and pet that is a DATETIME.
    ALTER TABLE person
    ADD COLUMN dob DATETIME;
    ALTER TABLE pet
    ADD COLUMN dob DATETIME;
-- Add a purchased_on column to person_pet of type DATETIME.
    ALTER TABLE person_pet
    ADD COLUMN purchased_on DATETIME;
-- Add a parent to pet column that's an INTEGER and holds the id for this pet's parent.
    ALTER TABLE pet
    ADD COLUMN parent INTEGER;

-- Update the existing database records with the new column data using
-- UPDATE statements. Don't forget about the purchased_on column in
-- person_pet relation table to indicate when that person bought the
-- pet.

UPDATE person SET dead = 0 ;

UPDATE person SET phone_number = 5551111
WHERE first_name = "Zed" ;

UPDATE person SET salary = 90000 ;

UPDATE person SET dob = '1970-03-15'
WHERE first_name = "Zed" ;

UPDATE person_pet SET purchased_on = '2001-04-12'
WHERE pet_id =
    (SELECT id from pet
    WHERE name='Fluffy');

-- Add 4 more people and 5 more pets and assign their ownership and
-- what pets are parents. On this last part remember that you get the
-- id of the parent, then set it in the parent column.

INSERT INTO person (id, first_name, last_name, age, salary, phone_number, dead, dob)
    VALUES (1, 'Angela', 'Spacey', 61, '29000', 5559883, 0, '1955-02-03');

INSERT INTO person (id, first_name, last_name, age, salary, phone_number, dead, dob)
    VALUES (5, 'Sally', 'Smithson', 23, 120000.00, 5551234, 0, '1995-07-01');

INSERT INTO person (id, first_name, last_name, age, salary, phone_number, dead, dob)
    VALUES (6, 'Spenser', 'Dixon', 123, 25000.50, 5552212, 0, '1903-02-29');

INSERT INTO person (id, first_name, last_name, age, salary, phone_number, dead, dob)
    VALUES (7, 'Jaxon', 'Whitebait', 82, 0, NULL, 1, '1912-02-18');

INSERT INTO person (id, first_name, last_name, age, salary, phone_number, dead, dob)
    VALUES (8, 'Davina', 'Collybird', 56, 210005.98, 0, 0, '1961-04-22');

INSERT INTO pet (id, name, breed, age, dead, dob, parent)
    VALUES (5, 'Diesel', 'Goldfish', 0, 0, '2016-03-01', 8);

INSERT INTO pet (id, name, breed, age, dead, dob, parent)
    VALUES (6, 'Inky', 'Goldfish', 0, 1, '2016-07-01', 5);

INSERT INTO pet (id, name, breed, age, dead, dob, parent)
    VALUES (7, 'Spot', 'Goldfish', 0, 0, '2016-06-30', 5);

INSERT INTO pet (id, name, breed, age, dead, dob, parent)
    VALUES (8, 'Mercedes', 'Goldfish', 1, 1, '2009-02-12', NULL);

INSERT INTO pet (id, name, breed, age, dead, dob, parent)
    VALUES (9, 'Bounce', 'Spaniel', 6, 0, '2010-02-01', NULL);

INSERT INTO person_pet (person_id, pet_id, purchased_on)
    VALUES (6, 5, NULL);

INSERT INTO person_pet (person_id, pet_id, purchased_on)
    VALUES (6, 7, NULL);

INSERT INTO person_pet (person_id, pet_id, purchased_on)
    VALUES (1, 7, '2009-03-15');

INSERT INTO person_pet (person_id, pet_id, purchased_on)
    VALUES (8, 9, '2010-06-02');

-- Write a query that can find all the names of pets and their owners
-- bought after 2004. Key to this is to map the person_pet based on
-- the purchased_on column to the pet and parent.

SELECT pet.name, person.first_name, person.last_name, person_pet.purchased_on
FROM pet, person_pet, person
WHERE
    person_pet.person_id = person.id AND
    person_pet.pet_id = pet.id AND
    date(person_pet.purchased_on) > date('2004-12-31');

-- Write a query that can find the pets that are children of a given
-- pet. Again look at the pet.parent to do this. It's actually easy so
-- don't over think it.

-- All children of Diesel
SELECT name, parent
FROM pet
WHERE
    parent =
    (SELECT id
    FROM pet
    WHERE
        pet.name = 'Diesel');

-- extra credit - all pets and their parents, where their parents are
-- known
SELECT pets1.name, pets1.parent, pets2.name
FROM pet AS pets1, pet AS pets2
WHERE pets1.parent = pets2.id;
