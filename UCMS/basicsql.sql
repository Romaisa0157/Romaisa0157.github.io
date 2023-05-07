CREATE TABLE complaint_users
(
    user_ID int not null,
    user_email    varchar(20) not null unique,
    user_name     varchar(20) not null,
    user_password text not null,

    CONSTRAINT userID_pk PRIMARY KEY (user_ID)
);

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

CREATE TABLE faculty_member
(
    faculty_ID int not null,
    faculty varchar(20) not null,
    occupation varchar(20) not null,
    office_no text,

    CONSTRAINT faculty_ID_pk PRIMARY KEY (faculty_ID),
    CONSTRAINT faculty_ID_fk FOREIGN KEY (faculty_ID) REFERENCES complaint_users(user_ID)
);

CREATE TABLE workers
(
    workers_ID int not null,
	hostel_no text,
    service varchar(20) not null,
    faculty varchar(20) not null,
   
    CONSTRAINT workers_ID_pk PRIMARY KEY (workers_ID),
    CONSTRAINT workers_ID_fk FOREIGN KEY (workers_ID) REFERENCES complaint_users(user_ID)
);
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
CREATE TABLE resolves
(
    res_ID int not null,
    complaint_ID int not null,
    status varchar(20) not null,

    CONSTRAINT res_ID_complain_ID_pk PRIMARY KEY (res_ID, complaint_ID),
    CONSTRAINT res_ID_fk FOREIGN KEY (res_ID) REFERENCES respondent(respondent_ID),
    CONSTRAINT complaint_ID_fk FOREIGN KEY (complaint_ID) REFERENCES complaint(complaint_ID)
);
