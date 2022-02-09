USE jec229;

DROP TABLE IF EXISTS animal;
DROP TABLE IF EXISTS adopter;
DROP TABLE IF EXISTS shelter;
DROP TABLE IF EXISTS admission;
DROP TABLE IF EXISTS visitation;
DROP TABLE IF EXISTS adoption;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS animal_adopter;
DROP TABLE IF EXISTS animal_staff;
DROP TABLE IF EXISTS adopter_visitation;
DROP TABLE IF EXISTS adopter_adoption;

-- ANIMAL TABLE
CREATE TABLE IF NOT EXISTS animal (
	animal_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    dob DATETIME NOT NULL,
    gender CHAR(1) NOT NULL,	-- M or F for Male or Female
    species VARCHAR(100) NOT NULL,
    breed VARCHAR(100) NOT NULL,
    color VARCHAR(100) NOT NULL,
    size CHAR(1) NOT NULL,		-- S,M,L for Small, Medium, Large
    date_created DATETIME NOT NULL,
    last_updated TIMESTAMP NOT NULL
);

-- ADOPTER TABLE
CREATE TABLE IF NOT EXISTS adopter (
    adopter_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    animal_id INT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    dob DATETIME NOT NULL,
    street_address VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state CHAR(2) NOT NULL,
    zipcode VARCHAR(5) NOT NULL,
    phone_number VARCHAR(10) NOT NULL,
    email VARCHAR(100) NOT NULL,
    date_created DATETIME NOT NULL,
    last_updated TIMESTAMP NOT NULL
);

-- SHELTER TABLE
CREATE TABLE IF NOT EXISTS shelter (
	shelter_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    shelter_name VARCHAR(100) NOT NULL,
    street_address VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state CHAR(2) NOT NULL,
    zipcode VARCHAR(5) NOT NULL,
    phone_number VARCHAR(10) NOT NULL,	-- for contacting/appointment purposes
    email VARCHAR(100) NOT NULL,		-- for contacting/appointment purposes
    date_created DATETIME NOT NULL,
    last_updated TIMESTAMP NOT NULL
);

-- STAFF TABLE
CREATE TABLE IF NOT EXISTS staff (
	staff_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    dob DATETIME NOT NULL,
    street_address VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state CHAR(2) NOT NULL,
    zipcode VARCHAR(5) NOT NULL,
    phone_number VARCHAR(10) NOT NULL,
    email VARCHAR(100) NOT NULL,
    date_created DATETIME NOT NULL,
    last_updated TIMESTAMP NOT NULL
);

-- ADMISSION TABLE
CREATE TABLE IF NOT EXISTS admission (
	admission_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    animal_id INT NOT NULL,
    shelter_id INT NOT NULL,
    staff_id INT NOT NULL,
    date_admitted DATETIME NOT NULL,
    stray_prevOwned CHAR(2) NOT NULL,	-- ST or PO for Stray or Previously Owned
    description VARCHAR(1000) NOT NULL,
    status VARCHAR(4) NOT NULL,			-- CONF, PEND, CNCL for Confirmed, Pending, Cancelled
    date_created DATETIME NOT NULL,
    last_updated TIMESTAMP NOT NULL
);

-- VISITATION TABLE
CREATE TABLE IF NOT EXISTS visitation (
	visitation_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    animal_id INT NOT NULL,
    adopter_id INT NOT NULL,
    shelter_id INT NOT NULL,
    staff_id INT NOT NULL,
    date_visited DATETIME NOT NULL,
    status VARCHAR(4) NOT NULL,		-- CONF, PEND, CNCL for Confirmed, Pending, Cancelled
    showed_up TINYINT(1),			-- 1 or 0 for True or False
    date_created DATETIME NOT NULL,
    last_updated TIMESTAMP NOT NULL
);

-- ADOPTION TABLE
CREATE TABLE IF NOT EXISTS adoption (
	adoption_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    animal_id INT NOT NULL,
    adopter_id INT NOT NULL,
    shelter_id INT NOT NULL,
    staff_id INT NOT NULL,
    date_adopted DATETIME NOT NULL,
	status VARCHAR(4) NOT NULL,					-- CONF, PEND, CNCL for Confirmed, Pending, Cancelled
	other_pets INT NOT NULL,					-- do they have other pets? how many?
    children INT NOT NULL,						-- do they have children? how many?
    esignature VARCHAR(100) NOT NULL,			-- electric signature
    date_created DATETIME NOT NULL,
    last_updated TIMESTAMP NOT NULL
);

-- PAYMENT TABLE
CREATE TABLE IF NOT EXISTS payment (
	payment_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    adopter_id INT NOT NULL,
    staff_id INT NOT NULL,
    adoption_fee DOUBLE NOT NULL,
    first_name VARCHAR(100) NOT NULL,		-- credit card information
    last_name VARCHAR(100) NOT NULL,		--
    card_number VARCHAR(16) NOT NULL,		--
    cvv_code CHAR(3) NOT NULL,				--
    expiration_date VARCHAR(4) NOT NULL,	--
    zipcode VARCHAR(5) NOT NULL,			-- credit card information
    esignature VARCHAR(100) NOT NULL,		-- electric signature
    date_created DATETIME NOT NULL,
    last_updated TIMESTAMP NOT NULL
);

-- add respective foreign keys for each table after creating all the tables
ALTER TABLE adopter
ADD FOREIGN KEY (animal_id) REFERENCES animal(animal_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE admission
ADD FOREIGN KEY (animal_id) REFERENCES animal(animal_id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (shelter_id) REFERENCES shelter(shelter_id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE visitation
ADD FOREIGN KEY (animal_id) REFERENCES animal(animal_id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (adopter_id) REFERENCES adopter(adopter_id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (shelter_id) REFERENCES shelter(shelter_id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE adoption
ADD FOREIGN KEY (animal_id) REFERENCES animal(animal_id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (adopter_id) REFERENCES adopter(adopter_id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (shelter_id) REFERENCES shelter(shelter_id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE payment
ADD FOREIGN KEY (adopter_id) REFERENCES adopter(adopter_id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE ON UPDATE CASCADE;

-- JUNCTION TABLE FOR M:N REALTIONSHIPS
-- ANIMAL_ADOPTER TABLE
CREATE TABLE IF NOT EXISTS animal_adopter (
    animal_id INT NOT NULL,
    adopter_id INT NOT NULL,
    CONSTRAINT pk_animal_adopter PRIMARY KEY AUTO_INCREMENT (animal_id , adopter_id),
    FOREIGN KEY (animal_id) REFERENCES animal(animal_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (adopter_id) REFERENCES adopter(adopter_id) ON DELETE CASCADE ON UPDATE CASCADE,
    date_created DATETIME NOT NULL,
    last_updated TIMESTAMP NOT NULL
);

-- ANIMAL_STAFF TABLE
CREATE TABLE IF NOT EXISTS animal_staff (
    animal_id INT NOT NULL,
    staff_id INT NOT NULL,
    CONSTRAINT pk_animal_staff PRIMARY KEY AUTO_INCREMENT (animal_id , staff_id),
    FOREIGN KEY (animal_id) REFERENCES animal(animal_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE ON UPDATE CASCADE,
    date_created DATETIME NOT NULL,
    last_updated TIMESTAMP NOT NULL
);

-- ADOPTER_VISITATION TABLE
CREATE TABLE IF NOT EXISTS adopter_visitation (
	adopter_id INT NOT NULL,
    visitation_id INT NOT NULL,
    CONSTRAINT pk_adopter_visitation PRIMARY KEY AUTO_INCREMENT (adopter_id, visitation_id),
    FOREIGN KEY (adopter_id) REFERENCES adopter(adopter_id)ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (visitation_id) REFERENCES visitation(visitation_id)ON DELETE CASCADE ON UPDATE CASCADE,
    date_created DATETIME NOT NULL,
    last_updated TIMESTAMP NOT NULL
);

-- ADOPTER_ADOPTION TABLE
CREATE TABLE IF NOT EXISTS adopter_adoption (
	adopter_id INT NOT NULL,
    adoption_id INT NOT NULL,
    CONSTRAINT pk_adopter_adoption PRIMARY KEY AUTO_INCREMENT (adopter_id, adoption_id),
    FOREIGN KEY (adopter_id) REFERENCES adopter(adopter_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (adoption_id) REFERENCES adoption(adoption_id) ON DELETE CASCADE ON UPDATE CASCADE,
    date_created DATETIME NOT NULL,
    last_updated TIMESTAMP NOT NULL
);

-- INSERT DATA FOR EACH TABLE (10 rows)
-- INSERT INTO ANIMAL TABLE
INSERT INTO animal (animal_id, name, age, dob, gender, species, breed, color, size, date_created, last_updated) 
VALUES (1, 'Tofu', 1, '2020-06-03', 'F', 'Cat', 'Tabby', 'Grey', 'S', 
'2021-12-10', '2021-12-10 10:45:00');
INSERT INTO animal (animal_id, name, age, dob, gender, species, breed, color, size, date_created, last_updated) 
VALUES (2, 'Sunny', 13, '2008-08-07', 'M', 'Dog', 'Pug', 'Tan', 'M', 
'2021-12-10', '2021-12-10 2:15:45');
INSERT INTO animal (animal_id, name, age, dob, gender, species, breed, color, size, date_created, last_updated) 
VALUES (3, 'Snickers', 3, '2018-05-14', 'M', 'Dog', 'Miniature Pinscher', 'Brown', 'S', 
'2021-11-01', '2021-11-01 01:49:28');
INSERT INTO animal (animal_id, name, age, dob, gender, species, breed, color, size, date_created, last_updated) 
VALUES (4, 'Max', 5, '2016-02-03', 'M', 'Cat', 'Siamese', 'Grey-Black', 'S', 
'2021-11-02', '2021-11-02 12:37:49');
INSERT INTO animal (animal_id, name, age, dob, gender, species, breed, color, size, date_created, last_updated) 
VALUES (5, 'Hachi', 3, '2018-08-23', 'M', 'Dog', 'Shiba Inu', 'Orange', 'M', 
'2021-02-27', '2021-02-27 10:50:53');
INSERT INTO animal (animal_id, name, age, dob, gender, species, breed, color, size, date_created, last_updated) 
VALUES (6, 'Lucy', 9, '2012-10-07', 'F', 'Dog', 'Husky', 'Grey-White', 'L', 
'2021-04-05', '2021-04-05 07:05:00');
INSERT INTO animal (animal_id, name, age, dob, gender, species, breed, color, size, date_created, last_updated) 
VALUES (7, 'Domo', 2, '2019-12-20', 'M', 'Dog', 'German Shepard', 'Black-Brown', 'L', 
'2021-12-10', '2021-12-10 04:15:34');
INSERT INTO animal (animal_id, name, age, dob, gender, species, breed, color, size, date_created, last_updated) 
VALUES (8, 'Yumi', 7, '2014-06-05', 'F', 'Cat', 'Tuxedo', 'Black-White', 'S', 
'2021-06-17', '2021-06-17 06:49:39');
INSERT INTO animal (animal_id, name, age, dob, gender, species, breed, color, size, date_created, last_updated) 
VALUES (9, 'Snowball', 12, '2009-06-03', 'F', 'Cat', 'British Shorthair', 'Orange', 'S', 
'2021-09-10', '2021-09-10 02:30:56');
INSERT INTO animal (animal_id, name, age, dob, gender, species, breed, color, size, date_created, last_updated) 
VALUES (10, 'Gus', 1, '2020-07-20', 'M', 'Dog', 'Poodle', 'Brown', 'L', 
'2021-12-14', '2021-12-14 10:52:00');

-- INSERT INTO ADOPTER TABLE
INSERT INTO adopter (adopter_id, animal_id, first_name, last_name, dob, street_address,
city, state, zipcode, phone_number, email, date_created, last_updated)
VALUES (1, 1, 'Lauren', 'Scott', '1997-08-29', '123 ABC Street', 'Pittsburgh', 'PA', '12345',
'3955049284', 'lscott@gmail.com', '2021-12-10', '2021-12-10 01:15:00');
INSERT INTO adopter (adopter_id, animal_id, first_name, last_name, dob, street_address,
city, state, zipcode, phone_number, email, date_created, last_updated)
VALUES (2, 2, 'Max', 'Smith', '2003-04-02', '123 ABC Street', 'Pittsburgh', 'PA', '12345',
'6974825960', 'msmith@gmail.com', '2021-12-10', '2021-12-10 01:30:00');
INSERT INTO adopter (adopter_id, animal_id, first_name, last_name, dob, street_address,
city, state, zipcode, phone_number, email, date_created, last_updated)
VALUES (3, 3, 'Karen', 'Lopez', '2005-03-09', '456 XYZ Street', 'Pittsburgh', 'PA', '12345',
'6830672759', 'klopez@gmail.com', '2021-12-10', '2021-12-10 02:15:00');
INSERT INTO adopter (adopter_id, animal_id, first_name, last_name, dob, street_address,
city, state, zipcode, phone_number, email, date_created, last_updated)
VALUES (4, 3, 'Ethan', 'Park', '1973-12-12', '456 XYZ Street', 'Pittsburgh', 'PA', '12345',
'4058305830', 'epark@gmail.com', '2021-12-10', '2021-12-10 02:30:00');
INSERT INTO adopter (adopter_id, animal_id, first_name, last_name, dob, street_address,
city, state, zipcode, phone_number, email, date_created, last_updated)
VALUES (5, 5, 'Robert', 'Gibson', '1995-07-14', '456 XYZ Street', 'Pittsburgh', 'PA', '12345',
'1236049685', 'rgibson@gmail.com', '2021-12-10', '2021-12-10 03:15:00');
INSERT INTO adopter (adopter_id, animal_id, first_name, last_name, dob, street_address,
city, state, zipcode, phone_number, email, date_created, last_updated)
VALUES (6, 6, 'Gina', 'Jones', '1975-03-30', '789 LOL Avenue', 'Pittsburgh', 'PA', '12345',
'6704302480', 'gjones@gmail.com', '2021-12-10', '2021-12-10 03:30:00');
INSERT INTO adopter (adopter_id, animal_id, first_name, last_name, dob, street_address,
city, state, zipcode, phone_number, email, date_created, last_updated)
VALUES (7, 7, 'Patty', 'Washington', '1982-01-15', '789 LOL Avenue', 'Pittsburgh', 'PA', '12345',
'2346975737', 'pwashington@gmail.com', '2021-12-10', '2021-12-10 04:15:00');
INSERT INTO adopter (adopter_id, animal_id, first_name, last_name, dob, street_address,
city, state, zipcode, phone_number, email, date_created, last_updated)
VALUES (8, 7, 'Daniel', 'Joseph', '2001-11-02', '789 LOL Avenue', 'Pittsburgh', 'PA', '12345',
'2949853854', 'djoseph@gmail.com', '2021-12-10', '2021-12-10 04:30:00');
INSERT INTO adopter (adopter_id, animal_id, first_name, last_name, dob, street_address,
city, state, zipcode, phone_number, email, date_created, last_updated)
VALUES (9, 9, 'Valerie', 'Tate', '2000-05-13', '293 OMG Lane', 'Pittsburgh', 'PA', '12345',
'5063483283', 'vtate@gmail.com', '2021-12-10', '2021-12-10 05:15:00');
INSERT INTO adopter (adopter_id, animal_id, first_name, last_name, dob, street_address,
city, state, zipcode, phone_number, email, date_created, last_updated)
VALUES (10, 10, 'Jen', 'Chen', '1992-05-08', '293 OMG Lane', 'Pittsburgh', 'PA', '12345',
'1239593720', 'jchen@gmail.com', '2021-12-10', '2021-12-10 05:30:00');

-- INSERT INTO SHELTER TABLE
INSERT INTO shelter (shelter_id, shelter_name, street_address, city, state, zipcode, phone_number, email,
date_created, last_updated)
VALUES (1, 'Shelter 1', '123 Pet Street', 'Pittsburgh', 'PA', '15213', '4823045839', 'shelter1@gmail.com',
'2021-12-10', '2021-12-10 12:00:00');
INSERT INTO shelter (shelter_id, shelter_name, street_address, city, state, zipcode, phone_number, email,
date_created, last_updated)
VALUES (2, 'Shelter 2', '345 Pet Street', 'Pittsburgh', 'PA', '15213', '2039547495', 'shelter2@gmail.com',
'2021-12-10', '2021-12-10 12:05:00');
INSERT INTO shelter (shelter_id, shelter_name, street_address, city, state, zipcode, phone_number, email,
date_created, last_updated)
VALUES (3, 'Shelter 3', '567 Pet Street', 'Pittsburgh', 'PA', '15213', '6928395868', 'shelter3@gmail.com',
'2021-12-10', '2021-12-10 12:10:00');
INSERT INTO shelter (shelter_id, shelter_name, street_address, city, state, zipcode, phone_number, email,
date_created, last_updated)
VALUES (4, 'Shelter 4', '789 Pet Street', 'Pittsburgh', 'PA', '15213', '2346074933', 'shelter4@gmail.com',
'2021-12-10', '2021-12-10 12:15:00');
INSERT INTO shelter (shelter_id, shelter_name, street_address, city, state, zipcode, phone_number, email,
date_created, last_updated)
VALUES (5, 'Shelter 5', '583 Pet Street', 'Pittsburgh', 'PA', '15213', '7928402849', 'shelter5@gmail.com',
'2021-12-10', '2021-12-10 12:20:00');
INSERT INTO shelter (shelter_id, shelter_name, street_address, city, state, zipcode, phone_number, email,
date_created, last_updated)
VALUES (6, 'Shelter 6', '702 Pet Street', 'Pittsburgh', 'PA', '15213', '1032940324', 'shelter6@gmail.com',
'2021-12-10', '2021-12-10 12:25:00');
INSERT INTO shelter (shelter_id, shelter_name, street_address, city, state, zipcode, phone_number, email,
date_created, last_updated)
VALUES (7, 'Shelter 7', '535 Pet Street', 'Pittsburgh', 'PA', '15213', '2840394673', 'shelter7@gmail.com',
'2021-12-10', '2021-12-10 12:30:00');
INSERT INTO shelter (shelter_id, shelter_name, street_address, city, state, zipcode, phone_number, email,
date_created, last_updated)
VALUES (8, 'Shelter 8', '343 Pet Street', 'Pittsburgh', 'PA', '15213', '2048583839', 'shelter8@gmail.com',
'2021-12-10', '2021-12-10 12:35:00');
INSERT INTO shelter (shelter_id, shelter_name, street_address, city, state, zipcode, phone_number, email,
date_created, last_updated)
VALUES (9, 'Shelter 9', '167 Pet Street', 'Pittsburgh', 'PA', '15213', '1038472944', 'shelter9@gmail.com',
'2021-12-10', '2021-12-10 12:40:00');
INSERT INTO shelter (shelter_id, shelter_name, street_address, city, state, zipcode, phone_number, email,
date_created, last_updated)
VALUES (10, 'Shelter 10', '832 Pet Street', 'Pittsburgh', 'PA', '15213', '6837285923', 'shelter10@gmail.com',
'2021-12-10', '2021-12-10 12:45:00');

-- INSERT INTO STAFF TABLE
INSERT INTO staff (staff_id, first_name, last_name, dob, street_address, city, state, zipcode, phone_number,
email, date_created, last_updated)
VALUES (1, 'Melinda', 'Hart', '1980-01-01', '123 Staff Street', 'Pittsburgh', 'PA', '15213', '4594535858',
'mhart@gmail.com', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO staff (staff_id, first_name, last_name, dob, street_address, city, state, zipcode, phone_number,
email, date_created, last_updated)
VALUES (2, 'Ralph', 'Bass', '1981-02-02', '234 Staff Street', 'Pittsburgh', 'PA', '15213', '1037538643',
'rbass@gmail.com', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO staff (staff_id, first_name, last_name, dob, street_address, city, state, zipcode, phone_number,
email, date_created, last_updated)
VALUES (3, 'Cecil', 'Christison', '1982-03-03', '345 Staff Street', 'Pittsburgh', 'PA', '15213', '1294838596',
'cchristison@gmail.com', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO staff (staff_id, first_name, last_name, dob, street_address, city, state, zipcode, phone_number,
email, date_created, last_updated)
VALUES (4, 'Yvonne', 'Russel', '1983-04-04', '456 Staff Street', 'Pittsburgh', 'PA', '15213', '2149035678',
'yrussel@gmail.com', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO staff (staff_id, first_name, last_name, dob, street_address, city, state, zipcode, phone_number,
email, date_created, last_updated)
VALUES (5, 'Hedley', 'Nowell', '1984-05-05', '567 Staff Street', 'Pittsburgh', 'PA', '15213', '3245967829',
'hnowell@gmail.com', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO staff (staff_id, first_name, last_name, dob, street_address, city, state, zipcode, phone_number,
email, date_created, last_updated)
VALUES (6, 'Rosamund', 'Thwaite', '1985-06-06', '678 Staff Street', 'Pittsburgh', 'PA', '15213', '1230485749',
'rthwaite@gmail.com', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO staff (staff_id, first_name, last_name, dob, street_address, city, state, zipcode, phone_number,
email, date_created, last_updated)
VALUES (7, 'Kylie', 'Fulton', '1986-07-07', '789 Staff Street', 'Pittsburgh', 'PA', '15213', '4958294596',
'kfulton@gmail.com', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO staff (staff_id, first_name, last_name, dob, street_address, city, state, zipcode, phone_number,
email, date_created, last_updated)
VALUES (8, 'Sheldon', 'Joseph', '1987-08-08', '684 Staff Street', 'Pittsburgh', 'PA', '15213', '0392346849',
'sjoseph@gmail.com', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO staff (staff_id, first_name, last_name, dob, street_address, city, state, zipcode, phone_number,
email, date_created, last_updated)
VALUES (9, 'Leanne', 'Devine', '1988-09-09', '942 Staff Street', 'Pittsburgh', 'PA', '15213', '2469382958',
'ldevine@gmail.com', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO staff (staff_id, first_name, last_name, dob, street_address, city, state, zipcode, phone_number,
email, date_created, last_updated)
VALUES (10, 'Genevieve', 'Radcliff', '1989-10-10', '343 Staff Street', 'Pittsburgh', 'PA', '15213', '5673024938',
'gradcliff@gmail.com', '2021-12-10', '2021-12-10 12:00:00');

-- INSERT INTO ADMISSION TABLE
INSERT INTO admission (admission_id, animal_id, shelter_id, staff_id, date_admitted, stray_prevOwned,
description, status, date_created, last_updated)
VALUES (1, 1, 1, 1, '2021-02-23', 'ST', 'Lorem Ipsum', 'CONF', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO admission (admission_id, animal_id, shelter_id, staff_id, date_admitted, stray_prevOwned,
description, status, date_created, last_updated)
VALUES (2, 2, 2, 1, '2021-01-10', 'PO', 'Lorem Ipsum', 'PEND', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO admission (admission_id, animal_id, shelter_id, staff_id, date_admitted, stray_prevOwned,
description, status, date_created, last_updated)
VALUES (3, 3, 3, 2, '2021-02-04', 'ST', 'Lorem Ipsum', 'CNCL', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO admission (admission_id, animal_id, shelter_id, staff_id, date_admitted, stray_prevOwned,
description, status, date_created, last_updated)
VALUES (4, 4, 4, 3, '2021-11-10', 'ST', 'Lorem Ipsum', 'CONF', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO admission (admission_id, animal_id, shelter_id, staff_id, date_admitted, stray_prevOwned,
description, status, date_created, last_updated)
VALUES (5, 5, 5, 4, '2021-04-13', 'PO', 'Lorem Ipsum', 'CONF', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO admission (admission_id, animal_id, shelter_id, staff_id, date_admitted, stray_prevOwned,
description, status, date_created, last_updated)
VALUES (6, 6, 6, 5, '2021-03-05', 'PO', 'Lorem Ipsum', 'PEND', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO admission (admission_id, animal_id, shelter_id, staff_id, date_admitted, stray_prevOwned,
description, status, date_created, last_updated)
VALUES (7, 7, 7, 6, '2021-05-30', 'ST', 'Lorem Ipsum', 'PEND', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO admission (admission_id, animal_id, shelter_id, staff_id, date_admitted, stray_prevOwned,
description, status, date_created, last_updated)
VALUES (8, 8, 8, 7, '2021-08-26', 'PO', 'Lorem Ipsum', 'CNCL', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO admission (admission_id, animal_id, shelter_id, staff_id, date_admitted, stray_prevOwned,
description, status, date_created, last_updated)
VALUES (9, 9, 9, 8, '2021-10-10', 'ST', 'Lorem Ipsum', 'CNCL', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO admission (admission_id, animal_id, shelter_id, staff_id, date_admitted, stray_prevOwned,
description, status, date_created, last_updated)
VALUES (10, 10, 10, 10, '2021-09-15', 'PO', 'Lorem Ipsum', 'CONF', '2021-12-10', '2021-12-10 12:00:00');

-- INSERT INTO VISITATION TABLE 
INSERT INTO visitation (visitation_id, animal_id, adopter_id, shelter_id, staff_id, date_visited, status,
showed_up, date_created, last_updated)
VALUES (1, 1, 1, 10, 3, '2021-12-09', 'CONF', 1, '2021-12-09', '2021-12-10 12:00:00');
INSERT INTO visitation (visitation_id, animal_id, adopter_id, shelter_id, staff_id, date_visited, status,
showed_up, date_created, last_updated)
VALUES (2, 2, 2, 9, 7, '2021-12-08', 'CONF', 1, '2021-12-08', '2021-12-10 12:00:00');
INSERT INTO visitation (visitation_id, animal_id, adopter_id, shelter_id, staff_id, date_visited, status,
showed_up, date_created, last_updated)
VALUES (3, 3, 3, 8, 5, '2021-12-07', 'CONF', 0, '2021-12-07', '2021-12-10 12:00:00');
INSERT INTO visitation (visitation_id, animal_id, adopter_id, shelter_id, staff_id, date_visited, status,
showed_up, date_created, last_updated)
VALUES (4, 4, 4, 7, 9, '2021-12-06', 'PEND', 1, '2021-12-06', '2021-12-10 12:00:00');
INSERT INTO visitation (visitation_id, animal_id, adopter_id, shelter_id, staff_id, date_visited, status,
showed_up, date_created, last_updated)
VALUES (5, 5, 5, 6, 10, '2021-12-05', 'CNCL', 0, '2021-12-05', '2021-12-10 12:00:00');
INSERT INTO visitation (visitation_id, animal_id, adopter_id, shelter_id, staff_id, date_visited, status,
showed_up, date_created, last_updated)
VALUES (6, 6, 6, 5, 1, '2021-12-04', 'PEND', 1, '2021-12-04', '2021-12-10 12:00:00');
INSERT INTO visitation (visitation_id, animal_id, adopter_id, shelter_id, staff_id, date_visited, status,
showed_up, date_created, last_updated)
VALUES (7, 7, 7, 4, 2, '2021-12-03', 'CNCL', 1, '2021-12-03', '2021-12-10 12:00:00');
INSERT INTO visitation (visitation_id, animal_id, adopter_id, shelter_id, staff_id, date_visited, status,
showed_up, date_created, last_updated)
VALUES (8, 8, 8, 3, 4, '2021-12-02', 'PEND', 1, '2021-12-02', '2021-12-10 12:00:00');
INSERT INTO visitation (visitation_id, animal_id, adopter_id, shelter_id, staff_id, date_visited, status,
showed_up, date_created, last_updated)
VALUES (9, 9, 9, 2, 6, '2021-12-01', 'PEND', 0, '2021-12-01', '2021-12-10 12:00:00');
INSERT INTO visitation (visitation_id, animal_id, adopter_id, shelter_id, staff_id, date_visited, status,
showed_up, date_created, last_updated)
VALUES (10, 10, 10, 1, 8, '2021-12-01', 'CNCL', 0, '2021-12-01', '2021-12-10 12:00:00');

-- INSERT INTO ADOPTION TABLE
INSERT INTO adoption (adoption_id, animal_id, adopter_id, shelter_id, staff_id, date_adopted, status, other_pets,
children, esignature, date_created, last_updated)
VALUES (1, 1, 1, 1, 1, '2021-12-10', 'CONF', 0, 0, 'Lauren Scott', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adoption (adoption_id, animal_id, adopter_id, shelter_id, staff_id, date_adopted, status, other_pets,
children, esignature, date_created, last_updated)
VALUES (2, 2, 2, 2, 1, '2021-12-10', 'CONF', 1, 0, 'Max Smith', '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adoption (adoption_id, animal_id, adopter_id, shelter_id, staff_id, date_adopted, status, other_pets,
children, esignature, date_created, last_updated)
VALUES (3, 3, 3, 3, 2, '2021-12-11', 'CONF', 0, 0, 'Karen Lopez', '2021-12-11', '2021-12-11 01:00:00');
INSERT INTO adoption (adoption_id, animal_id, adopter_id, shelter_id, staff_id, date_adopted, status, other_pets,
children, esignature, date_created, last_updated)
VALUES (4, 4, 4, 4, 3, '2021-12-11', 'PEND', 0, 2, 'Ethan Park', '2021-12-11', '2021-12-11 01:00:00');
INSERT INTO adoption (adoption_id, animal_id, adopter_id, shelter_id, staff_id, date_adopted, status, other_pets,
children, esignature, date_created, last_updated)
VALUES (5, 5, 5, 5, 4, '2021-12-12', 'CONF', 2, 2, 'Robert Gibson', '2021-12-12', '2021-12-12 02:00:00');
INSERT INTO adoption (adoption_id, animal_id, adopter_id, shelter_id, staff_id, date_adopted, status, other_pets,
children, esignature, date_created, last_updated)
VALUES (6, 6, 6, 6, 5, '2021-12-12', 'PEND', 5, 2, 'Gina Jones', '2021-12-12', '2021-12-12 02:00:00');
INSERT INTO adoption (adoption_id, animal_id, adopter_id, shelter_id, staff_id, date_adopted, status, other_pets,
children, esignature, date_created, last_updated)
VALUES (7, 7, 7, 7, 5, '2021-12-13', 'CONF', 1, 1, 'Patty Washington', '2021-12-13', '2021-12-13 03:00:00');
INSERT INTO adoption (adoption_id, animal_id, adopter_id, shelter_id, staff_id, date_adopted, status, other_pets,
children, esignature, date_created, last_updated)
VALUES (8, 8, 8, 8, 6, '2021-12-13', 'CONF', 1, 2, 'Daniel Joseph', '2021-12-13', '2021-12-13 03:00:00');
INSERT INTO adoption (adoption_id, animal_id, adopter_id, shelter_id, staff_id, date_adopted, status, other_pets,
children, esignature, date_created, last_updated)
VALUES (9, 9, 9, 9, 7, '2021-12-14', 'PEND', 0, 0, 'Valerie Tate', '2021-12-14', '2021-12-14 04:00:00');
INSERT INTO adoption (adoption_id, animal_id, adopter_id, shelter_id, staff_id, date_adopted, status, other_pets,
children, esignature, date_created, last_updated)
VALUES (10, 10, 10, 10, 8, '2021-12-14', 'PEND', 2, 0, 'Jen Chen', '2021-12-14', '2021-12-14 04:00:00');

-- INSERT INTO PAYMENT TABLE
INSERT INTO payment (payment_id, adopter_id, staff_id, adoption_fee, first_name, last_name, card_number,
cvv_code, expiration_date, zipcode, esignature, date_created, last_updated)
VALUES (1, 1, 1, 100.00, 'Lauren', 'Scott', '4920372947204737', '123', '1025', '12345', 'Lauren Scott',
'2021-12-10', '2021-12-10 12:00:00');
INSERT INTO payment (payment_id, adopter_id, staff_id, adoption_fee, first_name, last_name, card_number,
cvv_code, expiration_date, zipcode, esignature, date_created, last_updated)
VALUES (2, 2, 2, 100.00, 'Max', 'Smith', '5048204850724023', '495', '1025', '12345', 'Max Smith',
'2021-12-10', '2021-12-10 12:00:00');
INSERT INTO payment (payment_id, adopter_id, staff_id, adoption_fee, first_name, last_name, card_number,
cvv_code, expiration_date, zipcode, esignature, date_created, last_updated)
VALUES (3, 3, 3, 100.00, 'Karen', 'Lopez', '1238969048592835', '405', '1025', '12345', 'Karen Lopez',
'2021-12-11', '2021-12-11 01:00:00');
INSERT INTO payment (payment_id, adopter_id, staff_id, adoption_fee, first_name, last_name, card_number,
cvv_code, expiration_date, zipcode, esignature, date_created, last_updated)
VALUES (4, 4, 4, 100.00, 'Ethan', 'Park', '5670274957372749', '592', '1025', '12345', 'Ethan Park',
'2021-12-11', '2021-12-11 01:00:00');
INSERT INTO payment (payment_id, adopter_id, staff_id, adoption_fee, first_name, last_name, card_number,
cvv_code, expiration_date, zipcode, esignature, date_created, last_updated)
VALUES (5, 5, 5, 100.00, 'Robert', 'Gibson', '1230694824859887', '304', '1025', '12345', 'Robert Gibson',
'2021-12-12', '2021-12-12 02:00:00');
INSERT INTO payment (payment_id, adopter_id, staff_id, adoption_fee, first_name, last_name, card_number,
cvv_code, expiration_date, zipcode, esignature, date_created, last_updated)
VALUES (6, 6, 6, 100.00, 'Gina', 'Jones', '1111222233334444', '223', '1025', '12345', 'Gina Jones',
'2021-12-12', '2021-12-12 02:00:00');
INSERT INTO payment (payment_id, adopter_id, staff_id, adoption_fee, first_name, last_name, card_number,
cvv_code, expiration_date, zipcode, esignature, date_created, last_updated)
VALUES (7, 7, 7, 100.00, 'Patty', 'Washington', '5069323959383688', '076', '1025', '12345', 'Patty Washington',
'2021-12-13', '2021-12-13 03:00:00');
INSERT INTO payment (payment_id, adopter_id, staff_id, adoption_fee, first_name, last_name, card_number,
cvv_code, expiration_date, zipcode, esignature, date_created, last_updated)
VALUES (8, 8, 8, 100.00, 'Daniel', 'Joseph', '5490355612935039', '303', '1025', '12345', 'Daniel Joseph',
'2021-12-13', '2021-12-13 03:00:00');
INSERT INTO payment (payment_id, adopter_id, staff_id, adoption_fee, first_name, last_name, card_number,
cvv_code, expiration_date, zipcode, esignature, date_created, last_updated)
VALUES (9, 9, 9, 100.00, 'Valerie', 'Tate', '7865292740382749', '230', '1025', '12345', 'Valerie Tate',
'2021-12-14', '2021-12-14 04:00:00');
INSERT INTO payment (payment_id, adopter_id, staff_id, adoption_fee, first_name, last_name, card_number,
cvv_code, expiration_date, zipcode, esignature, date_created, last_updated)
VALUES (10, 10, 10, 100.00, 'Jen', 'Chen', '5032456799764325', '042', '1025', '12345', 'Jen Chen',
'2021-12-14', '2021-12-14 04:00:00');

-- INSERT INTO ANIMAL_ADOPTER TABLE
INSERT INTO animal_adopter (animal_id, adopter_id, date_created, last_updated)
VALUES (1,1, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_adopter (animal_id, adopter_id, date_created, last_updated)
VALUES (2,2, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_adopter (animal_id, adopter_id, date_created, last_updated)
VALUES (3,3, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_adopter (animal_id, adopter_id, date_created, last_updated)
VALUES (4,4, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_adopter (animal_id, adopter_id, date_created, last_updated)
VALUES (5,5, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_adopter (animal_id, adopter_id, date_created, last_updated)
VALUES (6,6, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_adopter (animal_id, adopter_id, date_created, last_updated)
VALUES (7,7, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_adopter (animal_id, adopter_id, date_created, last_updated)
VALUES (8,8, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_adopter (animal_id, adopter_id, date_created, last_updated)
VALUES (9,9, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_adopter (animal_id, adopter_id, date_created, last_updated)
VALUES (10,10, '2021-12-10', '2021-12-10 12:00:00');

-- INSERT INTO ANIMAL_STAFF TABLE
INSERT INTO animal_staff (animal_id, staff_id, date_created, last_updated)
VALUES (1,1, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_staff (animal_id, staff_id, date_created, last_updated)
VALUES (2,2, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_staff (animal_id, staff_id, date_created, last_updated)
VALUES (3,3, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_staff (animal_id, staff_id, date_created, last_updated)
VALUES (4,4, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_staff (animal_id, staff_id, date_created, last_updated)
VALUES (5,5, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_staff (animal_id, staff_id, date_created, last_updated)
VALUES (6,6, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_staff (animal_id, staff_id, date_created, last_updated)
VALUES (7,7, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_staff (animal_id, staff_id, date_created, last_updated)
VALUES (8,8, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_staff (animal_id, staff_id, date_created, last_updated)
VALUES (9,9, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO animal_staff (animal_id, staff_id, date_created, last_updated)
VALUES (10,10, '2021-12-10', '2021-12-10 12:00:00');

-- INSERT INTO ADOPTER_VISITATION TABLE
INSERT INTO adopter_visitation (adopter_id, visitation_id, date_created, last_updated)
VALUES (1,1, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_visitation (adopter_id, visitation_id, date_created, last_updated)
VALUES (2,2, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_visitation (adopter_id, visitation_id, date_created, last_updated)
VALUES (3,3, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_visitation (adopter_id, visitation_id, date_created, last_updated)
VALUES (4,4, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_visitation (adopter_id, visitation_id, date_created, last_updated)
VALUES (5,5, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_visitation (adopter_id, visitation_id, date_created, last_updated)
VALUES (6,6, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_visitation (adopter_id, visitation_id, date_created, last_updated)
VALUES (7,7, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_visitation (adopter_id, visitation_id, date_created, last_updated)
VALUES (8,8, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_visitation (adopter_id, visitation_id, date_created, last_updated)
VALUES (9,9, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_visitation (adopter_id, visitation_id, date_created, last_updated)
VALUES (10,10, '2021-12-10', '2021-12-10 12:00:00');

-- INSERT INTO ADOPTER_ADOPTION TABLE
INSERT INTO adopter_adoption (adopter_id, adoption_id, date_created, last_updated)
VALUES (1,1, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_adoption (adopter_id, adoption_id, date_created, last_updated)
VALUES (2,2, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_adoption (adopter_id, adoption_id, date_created, last_updated)
VALUES (3,3, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_adoption (adopter_id, adoption_id, date_created, last_updated)
VALUES (4,4, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_adoption (adopter_id, adoption_id, date_created, last_updated)
VALUES (5,5, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_adoption (adopter_id, adoption_id, date_created, last_updated)
VALUES (6,6, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_adoption (adopter_id, adoption_id, date_created, last_updated)
VALUES (7,7, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_adoption (adopter_id, adoption_id, date_created, last_updated)
VALUES (8,8, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_adoption (adopter_id, adoption_id, date_created, last_updated)
VALUES (9,9, '2021-12-10', '2021-12-10 12:00:00');
INSERT INTO adopter_adoption (adopter_id, adoption_id, date_created, last_updated)
VALUES (10,10, '2021-12-10', '2021-12-10 12:00:00');

-- SELECT QUERY SOLUTIONS
/* 1 */ SELECT * FROM animal;
/* 2 */ SELECT CONCAT(adopter.first_name, ' ', adopter.last_name) AS adopterName, animal.name
		FROM adopter
		INNER JOIN animal ON adopter.animal_id = animal.animal_id
        WHERE animal.animal_id = 7;
/* 3 */ SELECT CONCAT(staff.first_name, ' ', staff.last_name) AS staffName, staff.phone_number, staff.email, payment.esignature AS adopter
		FROM staff
		LEFT JOIN payment ON staff.staff_id = payment.staff_id
		WHERE payment.esignature = "Ethan Park";
/* 4 */ SELECT AVG(age) AS averageAge
		FROM animal
		WHERE gender = "M" AND species = "Dog";
/* 5 */ SELECT SUM(adoption_fee) AS totalAmount, COUNT(payment_id) AS numOfPayments
		FROM payment;
/* 6 */ SELECT COUNT(age) AS numOfAnimalsSameAge, age
		FROM animal
		GROUP BY age;
/* 7 */ SELECT COUNT(age) AS numOfAnimalsSameAge, age
		FROM animal
		GROUP BY age
		HAVING COUNT(age) > 1;
/* 8 */ SELECT esignature AS adopter, other_pets AS numOfPets 
		FROM adoption
		ORDER BY other_pets ASC;
/* 9 */ SELECT animal.name, visitation.status, visitation.showed_up
		FROM animal
		JOIN visitation ON animal.animal_id = visitation.animal_id
		WHERE visitation.status = "CONF" AND visitation.showed_up = 1
		LIMIT 2;
/* 10 */ SELECT payment.esignature AS adopter, payment.card_number, CONCAT(staff.first_name, ' ', staff.last_name) AS staffName, staff.city
		 FROM payment
		 JOIN staff ON payment.staff_id = staff.staff_id
		 WHERE city = "Pittsburgh" IN
         (SELECT CONCAT(staff.first_name, ' ', staff.last_name) AS staffName FROM staff);