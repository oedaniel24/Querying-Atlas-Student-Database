-- setting up database
USE [atlas-student-query]
go

-- creating stored procedure to select each table
CREATE PROCEDURE spSelectMember
AS
BEGIN
	SELECT * FROM Member
END

CREATE PROCEDURE spSelectZipcode
AS
BEGIN
	SELECT * FROM Zip_code
END

CREATE PROCEDURE spSelectEvent
AS
BEGIN 
	SELECT * FROM Event
END

CREATE PROCEDURE spSelectAttendance
AS 
BEGIN
	SELECT * FROM Attendance
END

CREATE PROCEDURE spSelectBudget
AS 
BEGIN
	SELECT * FROM Budget
END

CREATE PROCEDURE spSelectExpense
AS 
BEGIN
	SELECT * FROM Expense
END

CREATE PROCEDURE spSelectIncome
AS 
BEGIN
	SELECT * FROM Income
END

-- members activity
WITH activeMembers
AS
(
SELECT  link_to_member, COUNT(link_to_event) as No_Of_Events_Attended
FROM Attendance
GROUP BY link_to_member
)
SELECT 
	 Member.first_name
	, Member.last_name
	, Member.email
	, Member.position
	, Member.member_id
	, activeMembers.No_Of_Events_Attended
	, Member.t_shirt_size
	, Member.phone
	, Member.zip
	, Major.major_name
	, Major.department
	, Major.college
	, Zip_code.city
	, Zip_code.county
	, Zip_code.state
FROM activeMembers
LEFT JOIN Member ON activeMembers.link_to_member=Member.member_id
LEFT JOIN Major ON Member.link_to_major=Major.major_id
LEFT JOIN Zip_code ON Member.zip=Zip_code.zip_code
ORDER BY activeMembers.No_Of_Events_Attended DESC

--count of members per state
SELECT Zip_code.state
	, count(member.member_id) as count
FROM Zip_code
LEFT JOIN Member
ON Member.zip = Zip_code.zip_code
GROUP BY Zip_code.state
ORDER BY count DESC

--day of the week most event held
WITH event_day
AS
(
SELECT
	DATENAME(WEEKDAY, event_date) as  day
	, event_id
FROM
	Event
)
SELECT day
	, COUNT(event_id) as count
FROM
	event_day
GROUP BY  day
ORDER BY count DESC

--event table
WITH budgetAggregate
AS
(
SELECT 
	Budget.link_to_event
	, SUM(Budget.amount) as budget
	, SUM(Budget.spent) as total_spent
	, SUM(Budget.remaining) as total_remaining
FROM Budget
GROUP BY Budget.link_to_event
)

SELECT 
	Event.event_name
	, CAST(Event.event_date as DATE) as date
	, Event.type
	, COUNT(Attendance.link_to_member) as attendance
	, COALESCE(CAST(SUM(budgetAggregate.budget) as nvarchar), '-') as total_budget
	, COALESCE(CAST(SUM(budgetAggregate.total_spent) as nvarchar), '-') as total_spent
	, COALESCE(CAST(SUM(budgetAggregate.total_remaining) as nvarchar), '-') as total_remaining
FROM
 Event
LEFT JOIN Attendance ON Event.event_id = Attendance.link_to_event
LEFT JOIN budgetAggregate ON Event.event_id = budgetAggregate.link_to_event
GROUP BY Event.event_name, Event.event_date, Event.type, budgetAggregate.budget, budgetAggregate.total_spent, budgetAggregate.total_remaining
ORDER BY date, attendance

SELECT Budget.*, Event.event_date FROM Budget INNER JOIN Event ON Budget.link_to_event=Event.event_id WHERE spent = 0 AND event_status = 'Planning'

--attendance per event type
SELECT 
	 Event.type
	, COUNT(Attendance.link_to_member) as total_attendance
	, COUNT(DISTINCT Attendance.link_to_event) as no_of_times_event_held
	, COALESCE((COUNT(Attendance.link_to_member) / NULLIF(COUNT(DISTINCT Attendance.link_to_event), 0)), 0) as average_attendance
FROM
 Event
FULL JOIN
	Attendance
ON Event.event_id = Attendance.link_to_event
GROUP BY Event.type
ORDER BY  average_attendance DESC


-- members that have not paid dues
SELECT Member.member_id
	, Member.first_name
	, Member.last_name
	, Income.source
	, SUM(income.amount) as income
FROM 
	Member
LEFT JOIN 
	Income
ON Member.member_id=Income.link_to_member
WHERE 
	income.amount IS NULL
GROUP BY Member.member_id, Member.first_name, Member.last_name, Income.source

