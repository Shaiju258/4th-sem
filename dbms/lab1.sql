CREATE DATABASE HospitalDB
ON PRIMARY(
   NAME = HospitalDB_Data,
   FILENAME = 'C:\SQL\HospitalDB_Data.mdf',
   SIZE = 5MB,
   FILEGROWTH = 2MB
   )

   LOG ON(
     NAME = HospitalDB_Log,
     FILENAME = 'C:\SQL\HospitalDB_Log.ldf',
     SIZE = 2MB,
     FILEGROWTH = 1MB
     );

     USE HospitalDB;
     SELECT name
FROM sys.database_files;

    --INCREASE PRIMARY FILE SIZE TO 10 MB
    ALTER DATABASE HospitalDB 
    MODIFY FILE
    (
       NAME = HospitalDB_Data,
       SIZE= 10MB
     );

     --CREATING PATIENTS TABLE
     CREATE TABLE Patients
     (
        PatientID INT PRIMARY KEY,
        PatientName VARCHAR(50),
        Age INT,
        Gender VARCHAR(10)
        );

        Select * from Patients;
       
      --CREATING Doctors table with constraints
      CREATE TABLE Doctors
      (
        DoctorID INT PRIMARY KEY,
        DoctorName VARCHAR(50) NOT NULL,
        Specialty VARCHAR(50) CONSTRAINT DF_Specialty DEFAULT 'General',
        Experience INT CHECK (Experience >=0)
    );

    select * from Doctors;
   -- INSERT INTO Doctors(DoctorID,DoctorName,Experience,Email)
    --VALUES('201','Emma jonas',2,'Emma@gmail.com');

    --Create appointments table with foreign keys
    CREATE TABLE Appointments
    (
      AppointmentID INT PRIMARY KEY,
      PatientID INT,
      DoctorID INT,
      AppointmentDate DATE,

      FOREIGN KEY(PatientID) REFERENCES Patients(PatientID),
      FOREIGN KEY(DoctorID) REFERENCES Doctors(DoctorID)
      );

      select * from Appointments;
      --Add phone number column to patients
      ALTER TABLE Patients
      ADD PhoneNumber VARCHAR(15);

      --Drop the column age from patients
      ALTER TABLE Patients
      DROP COLUMN Age;

     --Add check constraint on Gender
     ALTER TABLE Patients
     ADD CONSTRAINT CK_Gender CHECK (Gender IN('Male', 'Female', 'Other'));

    -- INSERT INTO Patients
--VALUES (102, 'Johny Doe', 'abc','9801340374');
     --Drop the Gender check constraint
     ALTER TABLE Patients
     DROP CONSTRAINT CK_Gender;

     --Add email column to Doctors and make it not null
     ALTER TABLE Doctors
     ADD Email VARCHAR(100) NOT NULL ;

     --Drop the default constraint from specialty
     ALTER TABLE Doctors
     DROP CONSTRAINT DF_Specialty;

     --Drop appointments table
     DROP TABLE Appointments;
     
     --Drop Doctors table
     DROP TABLE Doctors;

     --Drop HospitalDB databae
     USE master;
     DROP DATABASE HospitalDB;