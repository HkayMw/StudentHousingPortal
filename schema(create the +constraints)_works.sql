-- Create Schema
CREATE SCHEMA IF NOT EXISTS shp DEFAULT CHARACTER SET utf8;
USE shp;

-- Create Tables

-- Table shp.students
CREATE TABLE IF NOT EXISTS shp.students (
  reg_number VARCHAR(15) NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  surname VARCHAR(45) NOT NULL,
  sex INT NOT NULL,
  marital_status INT NULL,
  date_of_birth DATE NOT NULL,
  phone_number VARCHAR(25) NULL,
  email VARCHAR(45) NULL,
  home_address VARCHAR(150) NULL,
  guardian_name VARCHAR(45) NULL,
  guardian_phone VARCHAR(45) NULL,
  guardian_relation_type VARCHAR(45) NULL,
  role ENUM('student', 'admin') NOT NULL,
  faculty VARCHAR(250) NOT NULL,
  department VARCHAR(250) NOT NULL,
  programme VARCHAR(250) NOT NULL,
  created_on DATETIME NULL,
  updated_on DATETIME NULL,
  PRIMARY KEY (reg_number)
) ENGINE = InnoDB;

-- Table shp.landlords
CREATE TABLE IF NOT EXISTS shp.landlords (
  national_id_number VARCHAR(8) NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  surname VARCHAR(45) NOT NULL,
  sex INT NULL,
  phone_number VARCHAR(45) NOT NULL,
  email VARCHAR(45) NULL,
  payment_details VARCHAR(45) NOT NULL,
  permanent_address VARCHAR(45) NOT NULL,
  created_on DATETIME NULL,
  updated_on DATETIME NULL,
  PRIMARY KEY (national_id_number)
) ENGINE = InnoDB;

-- Table shp.users
CREATE TABLE IF NOT EXISTS shp.users (
  id INT NOT NULL AUTO_INCREMENT,
  user_name VARCHAR(45) NOT NULL,
  password VARCHAR(45) NULL DEFAULT NULL,
  role ENUM('student', 'admin', 'landlord') NOT NULL,
  related_id VARCHAR(15) NULL DEFAULT NULL,
  created_on DATETIME NULL DEFAULT NULL,
  updated_on DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX (user_name ASC),
  INDEX (related_id ASC)
) ENGINE = InnoDB;

-- Table shp.accommodations
CREATE TABLE IF NOT EXISTS shp.accommodations (
  id INT NOT NULL AUTO_INCREMENT,
  type ENUM('house', 'hostel', 'standalone') NOT NULL,
  location VARCHAR(45) NULL,
  created_on DATETIME NULL,
  updated_on DATETIME NULL,
  number_of_rooms INT NULL,
  landlord_id VARCHAR(8) NOT NULL,
  PRIMARY KEY (id),
  INDEX (landlord_id ASC)
) ENGINE = InnoDB;

-- Table shp.rooms
CREATE TABLE IF NOT EXISTS shp.rooms (
  id INT NOT NULL AUTO_INCREMENT,
  type ENUM('single', 'shared') NOT NULL,
  price DECIMAL(10, 2) NULL,
  status VARCHAR(45) NULL,
  capacity INT NULL,
  accommodation_id INT NULL,
  PRIMARY KEY (id),
  INDEX (accommodation_id ASC)
) ENGINE = InnoDB;

-- Table shp.bookings
CREATE TABLE IF NOT EXISTS shp.bookings (
  id INT NOT NULL AUTO_INCREMENT,
  booking_date DATETIME NULL,
  booking_status VARCHAR(50) NULL,
  room_id INT NULL,
  PRIMARY KEY (id)
) ENGINE = InnoDB;

-- Table shp.assignments
CREATE TABLE IF NOT EXISTS shp.assignments (
  id INT NOT NULL AUTO_INCREMENT,
  booking_id INT NOT NULL,
  student_id VARCHAR(15) NOT NULL,
  room_id INT NOT NULL,
  assignment_date DATETIME NULL,
  PRIMARY KEY (id),
  INDEX (booking_id ASC),
  INDEX (student_id ASC),
  INDEX (room_id ASC)
) ENGINE = InnoDB;

-- Table shp.queries
CREATE TABLE IF NOT EXISTS shp.queries (
  id INT NOT NULL AUTO_INCREMENT,
  message VARCHAR(1000) NOT NULL,
  sender_id VARCHAR(15) NOT NULL,
  receiver_id VARCHAR(15) NULL,
  room_id INT NULL,
  creation_date DATETIME NULL,
  PRIMARY KEY (id),
  INDEX (sender_id ASC),
  INDEX (receiver_id ASC),
  INDEX (room_id ASC)
) ENGINE = InnoDB;

-- Create Constraints

ALTER TABLE shp.users
ADD CONSTRAINT fk_users_students FOREIGN KEY (related_id) REFERENCES shp.students (reg_number) ON DELETE RESTRICT;

ALTER TABLE shp.users
ADD CONSTRAINT fk_users_landlords FOREIGN KEY (related_id) REFERENCES shp.landlords (national_id_number) ON DELETE RESTRICT;

ALTER TABLE shp.users
ADD CONSTRAINT fk_users_admin FOREIGN KEY (related_id) REFERENCES shp.students (reg_number) ON DELETE RESTRICT;

ALTER TABLE shp.accommodations
ADD CONSTRAINT fk_accommodations_landlords FOREIGN KEY (landlord_id) REFERENCES shp.landlords (national_id_number) ON DELETE RESTRICT;

ALTER TABLE shp.rooms
ADD CONSTRAINT fk_rooms_accommodations FOREIGN KEY (accommodation_id) REFERENCES shp.accommodations (id) ON DELETE RESTRICT;

ALTER TABLE shp.bookings
ADD CONSTRAINT fk_bookings_rooms FOREIGN KEY (room_id) REFERENCES shp.rooms (id) ON DELETE RESTRICT;

ALTER TABLE shp.assignments
ADD CONSTRAINT fk_assignments_bookings FOREIGN KEY (booking_id) REFERENCES shp.bookings (id) ON DELETE RESTRICT;

ALTER TABLE shp.assignments
ADD CONSTRAINT fk_assignments_students FOREIGN KEY (student_id) REFERENCES shp.students (reg_number) ON DELETE RESTRICT;

ALTER TABLE shp.assignments
ADD CONSTRAINT fk_assignments_rooms FOREIGN KEY (room_id) REFERENCES shp.rooms (id) ON DELETE RESTRICT;

ALTER TABLE shp.queries
ADD CONSTRAINT fk_queries_students_sender FOREIGN KEY (sender_id) REFERENCES shp.students (reg_number) ON DELETE RESTRICT;

ALTER TABLE shp.queries
ADD CONSTRAINT fk_queries_landlords_sender FOREIGN KEY (sender_id) REFERENCES shp.landlords (national_id_number) ON DELETE RESTRICT;

ALTER TABLE shp.queries
ADD CONSTRAINT fk_queries_students_receiver FOREIGN KEY (receiver_id) REFERENCES shp.students (reg_number) ON DELETE RESTRICT;

ALTER TABLE shp.queries
ADD CONSTRAINT fk_queries_landlords_receiver FOREIGN KEY (receiver_id) REFERENCES shp.landlords (national_id_number) ON DELETE RESTRICT;

ALTER TABLE shp.queries
ADD CONSTRAINT fk_queries_rooms FOREIGN KEY (room_id) REFERENCES shp.rooms (id) ON DELETE RESTRICT;
