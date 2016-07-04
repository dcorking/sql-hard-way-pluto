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
