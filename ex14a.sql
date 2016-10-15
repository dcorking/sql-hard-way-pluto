-- ex14a.sql

-- 'extra credit' experiment with transactions on INSERT and UPDATE

UPDATE person SET dead = 0 ;

UPDATE person SET phone_number = 5551111
WHERE first_name = "Zed" ;

UPDATE person SET salary = 90000 ;

    BEGIN TRANSACTION;

INSERT INTO person (first_name, last_name, phone_number)
VALUES ('Henrietta', 'Rattus', 5553245);

UPDATE person SET last_name = 'Shostakovich'
WHERE first_name = "Zed";

UPDATE person SET SET dob = DATE('1990-03-15')
WHERE first_name = "Zed";

INSERT INTO person (first_name, last_name)
VALUES ('Jose', 'Baynes');

INSERT INTO person (id, first_name, last_name)
VALUES (15, 'Jose', 'Baynes');

INSERT INTO person (id, first_name, last_name)
VALUES (99, 'Jose', 'Baynes');

    ROLLBACK TRANSACTION;

UPDATE person_pet SET purchased_on = '2001-04-12'
WHERE pet_id =
    (SELECT id from pet
    WHERE name='Fluffy');
