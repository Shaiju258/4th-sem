-- Create and use database
IF DB_ID('TransactionDB') IS NOT NULL DROP DATABASE TransactionDB;
CREATE DATABASE TransactionDB;
GO

USE TransactionDB;
GO

-- Students table
CREATE TABLE Students(
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(50),
    Age INT,
    City VARCHAR(50)
);

select * from students;

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

-- TRANSACTION FLOW (Stored procs + transactions)
-- Transaction inside a proc
CREATE PROCEDURE sp_AddStudentAndEnroll
    @FullName VARCHAR(50),
    @Age INT,
    @City VARCHAR(50),
    @CourseID INT
AS
BEGIN
    SET NOCOUNT ON; --SQL Server stops sending "rows affected" messages
    BEGIN TRAN;
    BEGIN TRY
        INSERT INTO Students(FullName, Age, City) VALUES(@FullName, @Age, @City);

        DECLARE @NewID INT = SCOPE_IDENTITY(); -- It returns latest ID
        --Here in students new record is inserted so latest ID will be 5 so scope_identity() gives 5

        INSERT INTO Enrollments(StudentID, CourseID, EnrollDate) VALUES(@NewID, @CourseID, GETDATE());

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

-- Execute: add a new student and enroll
EXEC sp_AddStudentAndEnroll 'Maya Thapa', 20, 'Kathmandu', 1;

--Result: The above procedure wraps two inserts in a transaction: if either insert fails, both are rolled back.
Select * from Students;
Select * from Enrollments;
GO


-- Transaction with explicit rollback on business rule failure
-- Create a proc that refuses to enroll someone in same course twice.
CREATE PROCEDURE sp_AddEnrollmentIfNotExists
    @StudentID INT,
    @CourseID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRAN;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Enrollments WHERE StudentID=@StudentID AND CourseID=@CourseID)
        BEGIN
            RAISERROR('Student already enrolled in course', 16, 1);
        END
        ELSE
        BEGIN
            INSERT INTO Enrollments(StudentID, CourseID, EnrollDate) VALUES(@StudentID, @CourseID, GETDATE());
        END
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

-- Try to enroll Student 1 into Course 1 again (already exists)
EXEC sp_AddEnrollmentIfNotExists @StudentID = 1, @CourseID = 1;
GO

Select * from Enrollments;
GO
-- Result: Stored proc raises error and the insert is not performed. Enrollments table unchanged.