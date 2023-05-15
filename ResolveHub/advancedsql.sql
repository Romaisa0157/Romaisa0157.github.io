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

--find status of the lodged complaints
Select r.res_ID, c.complaint_ID,c*
From complaint c 
Join resolves r on
c.complaint_ID =  r.complaint_ID
where c.lodger_ID = $_SESSION [lodger_ID]

--Updating the resolve status of the complaints
UPDATE resolves SET status = 'Resolved' WHERE complaint_ID = %complaint_ID 
ANd res_ID = %res_ID ;

--inserting into resolve
INSERT INTO resolves (complaint_ID, status)
VALUES (complaint_id_value, 'resolved');

--fetching resolved complaints
SELECT c.complaint_ID, c.issue_date, c.resolve_date, c.complaint_type, c.description, u.user_name
FROM complaint c
JOIN complaint_users u ON c.lodger_ID = u.user_ID
JOIN resolves r ON c.complaint_ID = r.complaint_ID
WHERE r.status = 'Resolved';

--assigning complaints
UPDATE respondent
SET assigned_complaint = %complaint_ID
WHERE respondent_ID = %res_ID;

--adding attachement to the attachment table

INSERT INTO attachments (complaint_ID, file_path)
VALUES (1, %'/path/to/file.pdf');


--counting complaints for each type
SELECT complaint_type, COUNT(*) AS total_count
FROM complaint
GROUP BY complaint_type;

--average resolution time of the complaints
SELECT AVG(resolve_date - issue_date) AS avg_resolution_time
FROM complaint
WHERE resolve_date IS NOT NULL;

--list of the unassigned complaints
SELECT complaint_ID, issue_date, complaint_type, description
FROM complaint
WHERE complaint_ID NOT IN (SELECT assigned_complaint FROM respondent)

--list of the assigned complaints
SELECT c.complaint_ID, c.issue_date, c.complaint_type, c.description, r.respondent_name
FROM complaint c
JOIN respondent r ON c.complaint_ID = r.assigned_complaint

--list of the resolved complaints
SELECT c.complaint_ID, c.issue_date, c.resolve_date, c.complaint_type, c.description, r.respondent_name
FROM complaint c
JOIN respondent r ON c.complaint_ID = r.assigned_complaint
WHERE c.resolve_date IS NOT NULL --indication that the they have been resolved

--list of unresolved complaints
SELECT c.complaint_ID, c.issue_date, c.complaint_type, c.description, r.respondent_name
FROM complaint c
LEFT JOIN respondent r ON c.complaint_ID = r.assigned_complaint
WHERE c.resolve_date IS NULL
--OR
SELECT c.complaint_ID, c.issue_date, c.complaint_type, c.description, r.respondent_name
FROM complaint c
LEFT JOIN respondent r ON c.complaint_ID = r.assigned_complaint
WHERE c.complaint_ID NOT IN (
    SELECT complaint_ID
    FROM resolves
)


--function to insert the complaint
-- Create a stored procedure to insert a new complaint
CREATE OR REPLACE PROCEDURE insert_complaint(
    in_issue_date DATE,
    in_complaint_type TEXT,
    in_description TEXT,
    in_lodger_ID INTEGER
)
AS $$
BEGIN
    INSERT INTO complaint (issue_date, complaint_type, description, lodger_ID)
    VALUES (in_issue_date, in_complaint_type, in_description, in_lodger_ID);
    
    COMMIT;
END;
$$ LANGUAGE plpgsql;

-- Call the stored procedure to insert a new complaint
CALL insert_complaint('2023-05-13', 'Technical Issue', 'The internet connection is not working', 1);

-- Create a trigger to update the resolve_date when a complaint is resolved
CREATE OR REPLACE FUNCTION update_resolve_date()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Resolved' THEN
        NEW.resolve_date := CURRENT_DATE;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_resolve_date_trigger
BEFORE UPDATE ON resolves
FOR EACH ROW
EXECUTE FUNCTION update_resolve_date();

--views
-- Create a view to display the details of resolved complaints
CREATE VIEW resolved_complaints_view AS
SELECT c.complaint_ID, c.issue_date, c.resolve_date, c.complaint_type, c.description, u.user_name
FROM complaint c
JOIN complaint_users u ON c.lodger_ID = u.user_ID
JOIN resolves r ON c.complaint_ID = r.complaint_ID
WHERE r.status = 'Resolved';

-- Query the view to retrieve the details of resolved complaints
SELECT * FROM resolved_complaints_view;


