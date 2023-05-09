--Table of the user that will be lodging the complaint
CREATE TABLE complaint_users
(
    user_ID int not null,
    user_email    varchar(20) not null unique,
    user_name     varchar(20) not null,
    user_password text not null,

    CONSTRAINT userID_pk PRIMARY KEY (user_ID)
);


--user can be student
CREATE TABLE student
(
    stu_ID int not null,
    batch int not null unique,
    faculty varchar(20) not null unique,
    deg_program varchar(20) not null,
    hostel int not null,
    room_no int not null,
CONSTRAINT stu_ID_pk PRIMARY KEY (stu_ID),
    CONSTRAINT stu_ID_fk FOREIGN KEY (stu_ID) REFERENCES complaint_users(user_ID)
);

--user can be faculty member
CREATE TABLE faculty_member
(
    faculty_ID int not null,
    faculty varchar(20) not null,
    occupation varchar(20) not null,
    office_no text,

    CONSTRAINT faculty_ID_pk PRIMARY KEY (faculty_ID),
    CONSTRAINT faculty_ID_fk FOREIGN KEY (faculty_ID) REFERENCES complaint_users(user_ID)
);

--user can be any worker
CREATE TABLE workers
(
    workers_ID int not null,
	hostel_no text,
    service varchar(20) not null,
    faculty varchar(20) not null,
   
    CONSTRAINT workers_ID_pk PRIMARY KEY (workers_ID),
    CONSTRAINT workers_ID_fk FOREIGN KEY (workers_ID) REFERENCES complaint_users(user_ID)
);

--table for complaint information
CREATE TABLE complaint
(
    complaint_ID int not null,
    issue_date date not null,
    resolve_date date not null,
    complaint_type text not null,
    description text not null,
    lodger_ID int not null,

    CONSTRAINT complaint_ID_pk PRIMARY KEY (complaint_ID),
    CONSTRAINT lodger_ID_fk FOREIGN KEY (lodger_ID) REFERENCES complaint_users(user_ID)
);


--admin will be managing the complaints
CREATE TABLE admin
(
    admin_ID int not null,
    admin_email text not null,
    admin_password text not null,
    complaint_ID int not null,
    respondent_email text not null ,

    CONSTRAINT admin_ID_complaint_ID_pk PRIMARY KEY (admin_ID, complaint_ID),
    CONSTRAINT respondent_email_fk FOREIGN KEY (respondent_email) REFERENCES
	respondent(respondent_email)
);

--table to store information of the respondant
CREATE TABLE respondent
(
    respondent_ID int not null,
    respondent_email text not null unique,
    respondent_password text not null,
    respondent_name varchar(20) not null,
	assigned_complaint int not null,
	
    CONSTRAINT respondent_ID_name_pk PRIMARY KEY (respondent_ID),
    CONSTRAINT Assigned_complaint FOREIGN KEY (assigned_complaint) REFERENCES
	complaint(complaint_ID)
);

--to get the status of the lodged complaints
CREATE TABLE resolves
(
    res_ID int not null,
    complaint_ID int not null,
    status varchar(20) not null,

    CONSTRAINT res_ID_complain_ID_pk PRIMARY KEY (res_ID, complaint_ID),
    CONSTRAINT res_ID_fk FOREIGN KEY (res_ID) REFERENCES respondent(respondent_ID),
    CONSTRAINT complaint_ID_fk FOREIGN KEY (complaint_ID) REFERENCES complaint(complaint_ID)
);

--Inserting Dummy values into the given tables

INSERT INTO complaint_users (user_ID, user_email, user_name, user_password)
VALUES
(2021538, 'romaisa@gmail.com', 'Romaisa', 'password123'),
(2021173, 'zainab@gmail.com', 'Zainab', 'password456'),
(2019777, 'obaid@gmail.com', 'Obaid', 'password789')
(2990, 'ahsham@gmail.com', 'Ahsham', 'password923')
(3445, 'aliMurad@gmail.com', 'ALi Murad', 'password776')
;

INSERT INTO student (stu_ID, batch, faculty, deg_program, hostel, room_no)
VALUES
(2019765, 'FCSE', 'Computer Science', 'BS', 7, 101)
(2019765, 'FES', 'Engineering Sciences', 'BS', 4, 101)
(2019765, 'FME', 'Mechanical Engineering', 'BS', 6, 101)
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


