--Verification of the all the users
--User Verification
SELECT *FROM complaint_users
WHERE user_email = %user_email
AND user_password = %user_password;
--Admin Verification
SELECT *FROM admin
WHERE admin_email = %admin_email
AND admin_password = %admin_password;
--Respondant Verification
SELECT *FROM respondent 
WHERE respondent_email = %respondent_email
AND respondent_password = %respondent_password;

--for displaying the information of all the users
--Fetching user information
SELECT * FROM complaint_users WHERE user_ID = %user_ID;
--Fetching student information
SELECT * FROM student WHERE stu_ID = %stu_ID;
--Fetching faculty member information
SELECT * FROM faculty_member WHERE faculty_ID = %faculty_ID;
--Fetching worker information
SELECT * FROM worker WHERE workers_ID = %workers_ID;

--for lodging of the complaints
--inserting a complaint
INSERT INTO complaint (issue_date, complaint_type, description, lodger_ID)
VALUES 
('%complaint_id', '%issue_date', '%complaint_type', '%description',  '%lodger_ID');

--Fetching the complaint
SELECT * FROM complaint WHERE lodger_ID = %lodger_ID;


