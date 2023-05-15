--Inserting Dummy values into the given tables

INSERT INTO complaint_users (user_ID, user_email, user_name, user_password, role)
VALUES
(2021538, 'romaisa@gmail.com', 'Romaisa', 'password123', 'student'),
(2021173, 'zainab@gmail.com', 'Zainab', 'password456', 'student'),
(2019777, 'obaid@gmail.com', 'Obaid', 'password789', 'student'),
(2022765, 'huda@gmail.com', 'Huda', 'password933', 'student'),
(2990, 'ahsham@gmail.com', 'Ahsham', 'password923', 'faculty member'),
(3445, 'aliMurad@gmail.com', 'ALi Murad', 'password776', 'worker');

INSERT INTO complaint_users (user_ID, user_email, user_name, user_password, role)
VALUES
(2890, 'zaid@gmail.com', 'Zaid', 'password123', 'faculty member'),
(2876, 'Hasan@gmail.com', 'Hasan', 'password123', 'faculty member')
;

INSERT INTO student (stu_ID, batch, faculty, deg_program, hostel, room_no)
VALUES
(2021538, 31,'FCSE', 'Computer Engineering',  7, 161),
(2021173, 31,'FCSE', 'Computer Engineering',  7, 53),
(2022765, 32,'FME', 'Mechanical Engineering',  6, 32)
;

INSERT INTO faculty_member (faculty_ID, faculty, occupation, office_no)
VALUES
(2990, 'FES', 'Professor', '123A'),
(2890, 'FCSE', 'Instructor', '123B'),
(2876, 'FES', 'LAb Engineer', '123C');

INSERT INTO workers (workers_ID, hostel_no, service) 
VALUES
(3445, 'Hostel GH', 'Cleaning')
;

-- Insert data into the complaint table
INSERT INTO complaint (complaint_ID, issue_date, resolve_date, complaint_type, description, lodger_ID)
VALUES
    (12,'2023-05-01', '2023-05-05', 'Maintenance', 'Leaky faucet', 2021538),
    (13,'2023-05-03', '2023-05-07', 'Hostel', 'Power outage', 2021173),
    (14,'2023-05-02', NULL, 'Security', 'Unauthorized entry', 2019777)
	(15,'2023-06-01', '2023-07-05','Maintenance', 'N/A', 2990),
	(16,'2023-05-04', '2023-06-07','Mess', 'N/A', 2890),
	(17,'2023-03-04', '2023-04-10','Others', 'N/A', 2876);

-- Insert data into the respondent table
INSERT INTO respondent (respondent_ID, respondent_email, respondent_password, respondent_name, assigned_complaint)
VALUES
    (1, 'respondent1@example.com', 'password123', 'Respondent 1', 12),
    (2, 'respondent2@example.com', 'password456', 'Respondent 2', 13),
    (3, 'respondent3@example.com', 'password789', 'Respondent 3', 14);

-- Insert data into the admin table
INSERT INTO admin (admin_ID,admin_email, admin_password, complaint_ID, respondent_ID)
VALUES
    (1001,'admin1@giki.edu.pk', 'adminpassword1', 12, 1),
    (1002,'admin2@giki.edu.pk', 'adminpassword2', 13, 2),
    (1003,'admin3@giki.edu.pk', 'adminpassword3', 14, 3);
	
INSERT INTO resolves(res_ID, complaint_ID, status)
VALUES
	(1, 12, 'Resolved'),
	(2, 13, 'Resolved'),
	(3, 14, 'Unresolved');