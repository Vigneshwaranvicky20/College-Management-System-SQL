
-- College Management System

-- 1. Create Schema
CREATE SCHEMA IF NOT EXISTS college_management;

-- 2. Create Tables

-- Table for student details
CREATE TABLE IF NOT EXISTS college_management.students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15),
    enrollment_date DATE,
    department_id INT,
    CONSTRAINT fk_department
        FOREIGN KEY (department_id) 
        REFERENCES college_management.departments (department_id)
);

-- Table for department details
CREATE TABLE IF NOT EXISTS college_management.departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) UNIQUE,
    hod_id INT,  -- Head of department, a teacher
    CONSTRAINT fk_hod
        FOREIGN KEY (hod_id) 
        REFERENCES college_management.teachers (teacher_id)
);

-- Table for teacher details
CREATE TABLE IF NOT EXISTS college_management.teachers (
    teacher_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15),
    hire_date DATE,
    department_id INT,
    CONSTRAINT fk_teacher_department
        FOREIGN KEY (department_id) 
        REFERENCES college_management.departments (department_id)
);

-- Table for course details
CREATE TABLE IF NOT EXISTS college_management.courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    department_id INT,
    course_head INT,  -- Teacher heading the course
    CONSTRAINT fk_course_department
        FOREIGN KEY (department_id) 
        REFERENCES college_management.departments (department_id),
    CONSTRAINT fk_course_head
        FOREIGN KEY (course_head) 
        REFERENCES college_management.teachers (teacher_id)
);

-- Table for course enrollment
CREATE TABLE IF NOT EXISTS college_management.enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id) 
        REFERENCES college_management.students (student_id),
    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id) 
        REFERENCES college_management.courses (course_id)
);

-- 3. Insert Sample Data

-- Insert data into departments
INSERT INTO college_management.departments (department_name, hod_id)
VALUES ('Computer Science', NULL),
       ('Mathematics', NULL),
       ('Physics', NULL);

-- Insert data into teachers
INSERT INTO college_management.teachers (first_name, last_name, email, phone_number, hire_date, department_id)
VALUES ('John', 'Doe', 'john.doe@college.edu', '1234567890', '2020-05-01', 1),
       ('Jane', 'Smith', 'jane.smith@college.edu', '0987654321', '2019-06-15', 2),
       ('Robert', 'Brown', 'robert.brown@college.edu', '1112223334', '2021-08-10', 3);

-- Update HODs (assuming the above teachers are now HODs)
UPDATE college_management.departments
SET hod_id = 1
WHERE department_id = 1;
UPDATE college_management.departments
SET hod_id = 2
WHERE department_id = 2;

-- Insert data into students
INSERT INTO college_management.students (first_name, last_name, date_of_birth, email, phone_number, enrollment_date, department_id)
VALUES ('Alice', 'Walker', '2000-01-01', 'alice.walker@college.edu', '1233211234', '2023-09-01', 1),
       ('Bob', 'Johnson', '1999-12-12', 'bob.johnson@college.edu', '9876543210', '2023-09-01', 1),
       ('Charlie', 'Davis', '2001-05-20', 'charlie.davis@college.edu', '5556667778', '2023-09-01', 2);

-- Insert data into courses
INSERT INTO college_management.courses (course_name, department_id, course_head)
VALUES ('Data Structures', 1, 1),
       ('Algorithms', 1, 1),
       ('Calculus', 2, 2),
       ('Quantum Mechanics', 3, 3);

-- Insert data into enrollments
INSERT INTO college_management.enrollments (student_id, course_id, enrollment_date)
VALUES (1, 1, '2023-09-02'),
       (1, 2, '2023-09-02'),
       (2, 1, '2023-09-03'),
       (3, 3, '2023-09-04');

-- 4. Example Queries

-- List all students enrolled in a specific course (e.g., Data Structures)
SELECT s.first_name, s.last_name, c.course_name
FROM college_management.students s
JOIN college_management.enrollments e ON s.student_id = e.student_id
JOIN college_management.courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Data Structures';

-- List all courses offered by a department (e.g., Computer Science)
SELECT c.course_name, t.first_name AS teacher_first_name, t.last_name AS teacher_last_name
FROM college_management.courses c
JOIN college_management.teachers t ON c.course_head = t.teacher_id
JOIN college_management.departments d ON c.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- Get a list of all teachers along with their respective departments
SELECT t.first_name, t.last_name, d.department_name
FROM college_management.teachers t
JOIN college_management.departments d ON t.department_id = d.department_id;

-- Show all students in a particular department (e.g., Computer Science)
SELECT s.first_name, s.last_name, d.department_name
FROM college_management.students s
JOIN college_management.departments d ON s.department_id = d.department_id
WHERE d.department_name = 'Computer Science';
