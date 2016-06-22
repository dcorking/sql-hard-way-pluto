CREATE TABLE person (
        id INTEGER PRIMARY KEY,
        first_name TEXT,
        last_name TEXT,
        age INTEGER
        );

CREATE TABLE pet (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT,
        age INTEGER,
        dead INTEGER
        );

CREATE TABLE person_pet (
        person_id INTEGER,
        pet_id INTEGER
        );

CREATE TABLE car (
        id INTEGER PRIMARY KEY,
        make TEXT,
        model TEXT,
        engine_size INTEGER,
        colour TEXT
        );

CREATE TABLE person_car (
        person_id INTEGER,
        car_id INTEGER
        );
