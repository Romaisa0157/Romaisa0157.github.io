--Table of the user that will be lodging the complaint
CREATE TABLE complaint_users
(
    user_ID SERIAL PRIMARY KEY,
    user_email    varchar(20) not null unique,
    user_name     varchar(20) not null,
    user_password text not null,
    role VARCHAR(50) NOT NULL
);


--user can be student
CREATE TABLE student
(
    stu_ID SERIAL PRIMARY KEY REFERENCES complaint_users(user_ID),
    batch INTEGER NOT NULL,
    faculty VARCHAR(255) NOT NULL,
    deg_program VARCHAR(255) NOT NULL,
    hostel INTEGER NOT NULL,
    room_no INTEGER NOT NULL,
    CONSTRAINT student_user_fk FOREIGN KEY (user_ID) REFERENCES complaint_users(user_ID)
);

--user can be faculty member
CREATE TABLE faculty_member
(
   faculty_ID VARCHAR(40) PRIMARY KEY,
    faculty VARCHAR(100) NOT NULL,
    occupation  VARCHAR(100) NOT NULL,
    office_no TEXT,

    CONSTRAINT faculty_ID_fk FOREIGN KEY (faculty_ID) REFERENCES complaint_users(user_ID)
);

--user can be any worker
CREATE TABLE workers
(
    workers_ID INTEGER PRIMARY KEY,
	hostel_no text,
    service varchar(20) not null,
    faculty varchar(20),
    CONSTRAINT workers_ID_fk FOREIGN KEY (workers_ID) REFERENCES complaint_users(user_ID)
);

--table for complaint information
CREATE TABLE complaint
(
    complaint_ID SERIAL PRIMARY KEY,
    issue_date DATE NOT NULL,
    resolve_date DATE,
    complaint_type TEXT NOT NULL,
    description TEXT NOT NULL,
    lodger_ID INTEGER NOT NULL,

    CONSTRAINT complaint_lodger_fk FOREIGN KEY (lodger_ID) REFERENCES complaint_users(user_ID)
);


--admin will be managing the complaints
CREATE TABLE admin
(
    admin_ID SERIAL PRIMARY KEY,
    admin_email TEXT NOT NULL,
    admin_password TEXT NOT NULL,
    complaint_ID int not null,
    respondent_email text not null ,

    CONSTRAINT admin_complaint_fk FOREIGN KEY (complaint_ID) REFERENCES complaint(complaint_ID),
    CONSTRAINT admin_respondent_fk  FOREIGN KEY (respondent_email) REFERENCES
	respondent(respondent_email)
);

--table to store information of the respondant
CREATE TABLE respondent
(
    respondent_ID INTEGER NOT NULL PRIMARY KEY,
    respondent_email TEXT NOT NULL UNIQUE,
    respondent_password TEXT NOT NULL,
    respondent_name VARCHAR(20) NOT NULL,
    assigned_complaint INTEGER NOT NULL,
    CONSTRAINT respondent_admin_fk FOREIGN KEY (admin_ID) REFERENCES admin(admin_ID),
    CONSTRAINT respondent_assigned_complaint_fk FOREIGN KEY (assigned_complaint) REFERENCES complaint(complaint_ID)
);

-- Table for file attachments
CREATE TABLE attachments (
    attachment_ID SERIAL PRIMARY KEY,
    complaint_ID INTEGER REFERENCES complaint(complaint_ID),
    file_path TEXT NOT NULL,
    CONSTRAINT attachment_complaint_fk FOREIGN KEY (complaint_ID) REFERENCES complaint(complaint_ID)
);

-- Table for complaint history and audit trails
CREATE TABLE complaint_history (
    history_ID SERIAL PRIMARY KEY,
    complaint_ID INTEGER REFERENCES complaint(complaint_ID),
    user_ID INTEGER REFERENCES complaint_users(user_ID),
    action TEXT NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT history_complaint_fk FOREIGN KEY (complaint_ID) REFERENCES complaint(complaint_ID),
    CONSTRAINT history_user_fk FOREIGN KEY (user_ID) REFERENCES complaint_users(user_ID)
);

--to get the status of the lodged complaints
CREATE TABLE resolves
(
    res_ID SERIAL NOT NULL,
    complaint_ID INT NOT NULL,
    status VARCHAR(20) NOT NULL,

    CONSTRAINT res_ID_complain_ID_pk PRIMARY KEY (res_ID, complaint_ID),
    CONSTRAINT resolves_respondent_fk  FOREIGN KEY (res_ID) REFERENCES respondent(respondent_ID),
    CONSTRAINT resolves_complaint_ID_fk FOREIGN KEY (complaint_ID) REFERENCES complaint(complaint_ID)
);

--Inserting Dummy values into the given tables

INSERT INTO complaint_users (user_ID, user_email, user_name, user_password, role)
VALUES
(2021538, 'romaisa@gmail.com', 'Romaisa', 'password123', 'student'),
(2021173, 'zainab@gmail.com', 'Zainab', 'password456', 'student'),
(2019777, 'obaid@gmail.com', 'Obaid', 'password789', 'student'),
(2990, 'ahsham@gmail.com', 'Ahsham', 'password923', 'faculty member'),
(3445, 'aliMurad@gmail.com', 'ALi Murad', 'password776', 'worker');

INSERT INTO student (stu_ID, batch, faculty, deg_program, hostel, room_no)
VALUES
(2019765, 29,'FES' 'Engineering Sciences', 4, 101)
(2021538, 31,'FCSE' 'Computer Engineering',  7, 161),
(2021173, 31,'FCSE' 'Computer Engineering',  7, 53),
(2022765, 32, 'Mechanical Engineering',  6, 32)
;
INSERT INTO faculty_member (faculty_ID, faculty, occupation, office_no)
VALUES
(101, 'FES', 'Professor', '123A'),
(102, 'FCSE', 'Associate Professor', 'G-30'),
(103, 'FMCE', 'Assistant Professor', 'G-50');

INSERT INTO workers (workers_ID, hostel_no, service) 
VALUES
(123, 'Hostel GH', 'Cleaning')
(126, 'Hostel 10', 'Maintenance')
(145, 'Hostel 11', 'Security')
;
INSERT INTO complaint (complaint_ID, issue_date, resolve_date, complaint_type, description, lodger_ID)
VALUES
(1, '2022-04-01', '2022-04-03', 'Hostel', 'Broken light fixture', 2021234)
(2, '2022-05-15', '2022-05-17', 'Medical Centre', 'N/A', 3)
(3, '2022-06-20', NULL, 'Mess', 'N/A', 1);