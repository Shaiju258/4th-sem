-- Create and use database
IF DB_ID('StoredProcDB') IS NOT NULL DROP DATABASE StoredProcDB;
CREATE DATABASE StoredProcDB;
GO

USE StoredProcDB;
GO

-- Students table
CREATE TABLE Students(
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(50),
    Age INT,
    City VARCHAR(50)
);

-- Courses table
CREATE TABLE Courses(
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    CourseName VARCHAR(50),
    CreditHours INT
);

-- Enrollments table
CREATE TABLE Enrollments(
    EnrollID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollDate DATE,
    CONSTRAINT FK_Student FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Course FOREIGN KEY(CourseID) REFERENCES Courses(CourseID)
);

-- Insert data
INSERT INTO Students(FullName, Age, City) VALUES
('Aarav Shrestha', 20, 'Kathmandu'),
('Sita Lama', 22, 'Pokhara'),
('Rohan KC', 19, 'Lalitpur'),
('Bibek Rai', 21, 'Bhaktapur');

Select * from Students;

INSERT INTO Courses(CourseName, CreditHours) VALUES
('Database Systems', 3),
('Java Programming', 4),
('Networking', 3);

Select * from Courses;

INSERT INTO Enrollments(StudentID, CourseID, EnrollDate) VALUES
(1, 1, '2024-02-01'),
(2, 1, '2024-02-03'),
(1, 2, '2024-02-05'),
(3, 3, '2024-02-10');

Select * from Enrollments;

GO

--Basic Stored Procedures (NO PARAMETERS)
--List all students
CREATE PROCEDURE sp_GetAllStudents
AS
BEGIN
    SELECT * FROM Students;
END;
GO

-- Execute:
EXEC sp_GetAllStudents;
GO

--List courses (select subset of columns)
CREATE PROCEDURE sp_GetCourses
AS
BEGIN
    SELECT CourseID, CourseName, CreditHours FROM Courses;
END;
GO

EXEC sp_GetCourses;
GO

--List enrollments with student & course names
CREATE PROCEDURE sp_GetEnrollmentsFull
AS
BEGIN
    SELECT e.EnrollID, s.FullName, c.CourseName, e.EnrollDate
    FROM Enrollments e
    JOIN Students s ON e.StudentID = s.StudentID
    JOIN Courses c ON e.CourseID = c.CourseID
    ORDER BY e.EnrollID;
END;
GO

EXEC sp_GetEnrollmentsFull;
GO

--Aggregate: students per city
CREATE PROCEDURE sp_StudentsByCity
AS
BEGIN
    SELECT City, COUNT(*) AS TotalStudents
    FROM Students
    GROUP BY City;
END;
GO

EXEC sp_StudentsByCity;
GO


--Stored Procedures WITH INPUT PARAMETERS
--Get student by ID
CREATE PROCEDURE sp_GetStudentByID
    @ID INT
AS
BEGIN
    SELECT * FROM Students WHERE StudentID = @ID;
END;
GO

EXEC sp_GetStudentByID @ID = 2;
GO

--Students enrolled in a specific course (using course id)
CREATE PROCEDURE sp_GetStudentsByCourse
    @CourseID INT
AS
BEGIN
    SELECT s.StudentID, s.FullName, c.CourseName, e.EnrollDate
    FROM Enrollments e
    JOIN Students s ON e.StudentID = s.StudentID
    JOIN Courses c ON e.CourseID = c.CourseID
    WHERE c.CourseID = @CourseID;
END;
GO

EXEC sp_GetStudentsByCourse @CourseID = 1;
GO

--Get courses with credits >= parameter
CREATE PROCEDURE sp_GetCoursesByMinCredits
    @MinCredits INT
AS
BEGIN
    SELECT * FROM Courses WHERE CreditHours >= @MinCredits;
END;
GO

EXEC sp_GetCoursesByMinCredits @MinCredits = 3;
GO

--Default city parameter
--Students by city (string parameter)
CREATE PROCEDURE sp_DefaultCity
    @City VARCHAR(50) = 'Kathmandu'
AS
BEGIN
    SELECT * FROM Students WHERE City = @City;
END;
GO

-- Call without parameter:
EXEC sp_DefaultCity;
-- Call with parameter:
EXEC sp_DefaultCity @City = 'Pokhara';
GO

--Range of enrollment dates with defaults
CREATE PROCEDURE sp_EnrollmentsInRange
    @StartDate DATE = '2024-02-01',
    @EndDate DATE = '2024-02-28'
AS
BEGIN
    SELECT * FROM Enrollments WHERE EnrollDate BETWEEN @StartDate AND @EndDate;
END;
GO

EXEC sp_EnrollmentsInRange;  -- uses defaults
GO


--Stored Procedures RETURNING DATA (OUTPUT parameters & RETURN)
--OUTPUT parameter: total students
CREATE PROCEDURE sp_GetStudentCount
    @Total INT OUTPUT
AS
BEGIN
    SELECT @Total = COUNT(*) FROM Students;
END;
GO

-- Using it:
DECLARE @T INT;
EXEC sp_GetStudentCount @Total = @T OUTPUT;
SELECT @T AS TotalStudents;
GO

--OUTPUT parameter: enrollments count per course (single value)
CREATE PROCEDURE sp_GetEnrollmentCountForCourse
    @CourseID INT,
    @Count INT OUTPUT
AS
BEGIN
    SELECT @Count = COUNT(*) FROM Enrollments WHERE CourseID = @CourseID;
END;
GO

DECLARE @c INT;
EXEC sp_GetEnrollmentCountForCourse @CourseID = 1, @Count = @c OUTPUT;
SELECT @c AS EnrollCount;
GO

--RETURNing an integer (return code)
CREATE PROCEDURE sp_TotalCoursesReturn
AS
BEGIN
    DECLARE @Cnt INT;
    SELECT @Cnt = COUNT(*) FROM Courses;
    RETURN @Cnt; -- returns as int return code
END;
GO

-- Usage:
DECLARE @ret INT;
EXEC @ret = sp_TotalCoursesReturn;
SELECT @ret AS TotalCourses;
GO

-- MANAGING Stored Procedures: ALTER, DROP
-- ALTER a procedure (modify behavior)

-- First create a simple proc
CREATE PROCEDURE sp_GetCourseNames
AS
BEGIN
    SELECT CourseID, CourseName FROM Courses;
END;
GO

-- Now alter to include credits
ALTER PROCEDURE sp_GetCourseNames
AS
BEGIN
    SELECT CourseID, CourseName, CreditHours FROM Courses;
END;
GO

EXEC sp_GetCourseNames;
GO

--DROP PROCEDURE
DROP PROCEDURE IF EXISTS sp_GetCourseNames;
GO

--You can simply use CREATE OR ALTER while creating stored proc as well
CREATE OR ALTER PROCEDURE sp_GetCourseNames
AS
BEGIN
    SELECT CourseID, CourseName, CreditHours FROM Courses;
END;
GO

EXEC sp_GetCourseNames;
GO

--EXEC multiple procedures and parameter passing
EXEC sp_GetAllStudents;
EXEC sp_GetCourses;
EXEC sp_GetStudentsByCourse @CourseID = 2;