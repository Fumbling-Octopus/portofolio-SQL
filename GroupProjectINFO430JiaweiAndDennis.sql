 
USE group_5_INFO430
 
--Create Table statements
 
CREATE TABLE #Election(
BallotID INT ,
VoterID INT ,
County VARCHAR(30) ,
VoterFName VARCHAR(60),
VoterLName VARCHAR(60),
Gender CHAR(1),
Election_Type VARCHAR(60),
Ballot_Status VARCHAR(30),
Challenge VARCHAR(60),
Sent_Date DATE,
Received_Date DATE,
Addy VARCHAR(150),
City VARCHAR(100),
[State] VARCHAR(100),
ZIP VARCHAR(60),
COUNTRY VARCHAR(20),
Split VARCHAR(60),
Precinct VARCHAR (60),
Return_Meth VARCHAR (30),
Return_location VARCHAR(60)
)
 
CREATE TABLE tblDistrict(
DistrictID INT PRIMARY KEY IDENTITY(1,1),
DistrictName VARCHAR(60) NOT NULL
)
 
CREATE TABLE tblParty(
PartyID INT PRIMARY KEY IDENTITY(1,1),
PartyName VARCHAR(60) NOT NULL,
PartyDescr VARCHAR(255) NULL
)
 
CREATE TABLE tblPosition(
PositionID INT PRIMARY KEY IDENTITY(1,1),
PositionName VARCHAR(60) NOT NULL,
PositionDescr VARCHAR(255) NULL
)
 
CREATE TABLE tblIssues(
IssueID INT PRIMARY KEY IDENTITY(1,1),
IssueName VARCHAR(60) NOT NULL,
IssueDescr VARCHAR(255) NULL
)
 
CREATE TABLE tblMunicipality(
MunicipalityID INT PRIMARY KEY IDENTITY(1,1),
MuninicipalityName VARCHAR(60) NOT NULL
)
 
CREATE TABLE tblCounty(
CountyID INT PRIMARY KEY IDENTITY(1,1),
CountyName VARCHAR(60) NOT NULL,
DistrictID INT REFERENCES tblDistrict(DistrictID)
)
 
CREATE TABLE tblCity(
CityID INT PRIMARY KEY IDENTITY(1,1),
CityName VARCHAR(60) NOT NULL,
CountyID INT REFERENCES tblCounty (CountyID),
POPULATION INT NOT NULL
)
 
CREATE TABLE tblDropbox(
DropboxID INT PRIMARY KEY IDENTITY(1,1),
DropboxName VARCHAR(60) NOT NULL,
CityID INT REFERENCES tblCity (CityID)
)
 
CREATE TABLE tblPrecinct(
PrecinctID INT PRIMARY KEY IDENTITY(1,1),
PrecinctName VARCHAR(60) NOT NULL,
CityID INT REFERENCES tblCity (CityID)
)
 
CREATE TABLE tblVoters(
VoterID INT PRIMARY KEY IDENTITY(1,1),
VoterFirstName VARCHAR(60) NOT NULL,
VoterLastName VARCHAR(60) NOT NULL,
PrecinctID INT REFERENCES tblPrecinct (PrecinctID),
VoterDateOfBirth DATE NOT NULL,
Gender CHAR(1) NOT NULL
)
 
CREATE TABLE tblCandidate(
CandidateID INT PRIMARY KEY IDENTITY(1,1),
CandidateFirstName VARCHAR(60) NOT NULL,
CandidateLastName VARCHAR(60) NOT NULL,
PartyID INT REFERENCES tblParty (PartyID),
CandidateDateOfBirth DATE NOT NULL,
Gender CHAR(1) NOT NULL,
DistrictID INT REFERENCES tblDistrict (DistrictID),
PositionID INT REFERENCES tblPosition (PositionID)
)
 
CREATE TABLE tblCandidateIssue(
IssueID INT REFERENCES tblIssues (IssueID),
CandidateID INT REFERENCES tblCandidate (CandidateID),
ElectionYear DATE NOT NULL
)
 
CREATE TABLE tblVoterCandidate(
VoterID INT REFERENCES tblVoters (VoterID),
CandidateID INT REFERENCES tblCandidate (CandidateID),
ElectionYear DATE NOT NULL
)
 
CREATE TABLE tblDropBoxVoter(
VoterID INT REFERENCES tblVoters (VoterID),
DropboxID INT REFERENCES tblDropbox (DropboxID),
ElectionYear DATE NOT NULL
)
 
CREATE TABLE tblPrecinctMunicipality(
PrecinctID INT REFERENCES tblPrecinct (PrecinctID),
MunicipalityID INT REFERENCES tblMunicipality (MunicipalityID),
PrecinctMuniID INT PRIMARY KEY IDENTITY(1,1)
)

--Stored procedures

GO
CREATE PROCEDURE GetDistrict
@DistrictName VARCHAR(60),
@DistrictID INT
AS
SET @DistrictID = (SELECT DistrictID FROM tblDistrict
                   WHERE DistrictName = @DistrictName)
 
 
GO
CREATE PROCEDURE GetParty
@PartyName VARCHAR(60),
@PartyID INT
AS
SET @PartyID = (SELECT PartyID FROM tblParty
                   WHERE PartyName = @PartyName)
 
GO
CREATE PROCEDURE GetPosition
@PositionName VARCHAR(60),
@PositionID INT
AS
SET @PositionID = (SELECT PositionID FROM tblPosition
                   WHERE PositionName = @PositionName)
 
GO
CREATE PROCEDURE GetMunicipality
@MunicipalityName VARCHAR(60),
@MunicipalityID INT
AS
SET @MunicipalityID = (SELECT MunicipalityID FROM tblMunicipality
                   WHERE MunicipalityName = @MunicipalityName)
GO
CREATE OR ALTER PROCEDURE GetIssues
@IssueName VARCHAR(60),
@IssueID INT OUTPUT
AS
SET @IssueID = (SELECT IssueID FROM tblIssues
                   WHERE IssueName = @IssueName)
 
 
 
 
GO
CREATE OR ALTER PROCEDURE GetCandidate
@CandidateFirstName VARCHAR (60),
@CandidateLastName VARCHAR (60),
@CandidateDateOfBirth DATE,
@CandidateID INT OUTPUT
AS
SET @CandidateID = (SELECT c.CandidateID FROM tblCandidate c
                    WHERE c.CandidateFirstName = @CandidateFirstname
                    AND c.CandidateLastName = @CandidateLastName
                    AND c.CandidateDateOfBirth = @CandidateDateOfBirth)
GO
CREATE OR ALTER PROCEDURE GetPrecinct
@PrecinctName VARCHAR(60),
@PrecinctID INT OUTPUT
AS
SET @PrecinctID = (SELECT PrecinctID FROM tblPrecinct
                    WHERE PrecinctName = @PrecinctName)
 
-- Insert values

INSERT INTO tblDistrict(DistrictName)
VALUES ('Mordor')
INSERT INTO tblDistrict(DistrictName)
VALUES ('Isengard')
INSERT INTO tblDistrict(DistrictName)
VALUES ('Rohan')
INSERT INTO tblDistrict(DistrictName)
VALUES ('Gondor')
INSERT INTO tblDistrict(DistrictName)
VALUES ('Iron Hills')
INSERT INTO tblDistrict(DistrictName)
VALUES ('Yaven IV')
INSERT INTO tblDistrict(DistrictName)
VALUES ('Tatooine')

INSERT INTO tblCounty (CountyName, DistrictID)
SELECT DISTINCT(d.County), e.DistrictID
FROM DataElection2022 d, tblDistrict e

UPDATE DataElection2022
SET City = 'UNKNOWN'
WHERE City IS NULL
UPDATE DataElection2022
SET City = 'Tira'
WHERE City LIKE 'TIRA%'

INSERT INTO tblCity (CityName, CountyID, Pop)
SELECT DISTINCT(d.City), e.CountyID, CAST(RAND() * 100000 AS INT)
FROM DataElection2022 d, tblCounty e

UPDATE DataElection2022
SET First_Name = 'UNKNOWN'
WHERE First_Name IS NULL

INSERT INTO tblDropbox (DropboxName, CityID)
SELECT DISTINCT(d.First_Name), c.CityID
FROM DataElection2022 d, tblCity c

INSERT INTO tblIssues (IssueName)
VALUES('Gun Control')
INSERT INTO tblIssues (IssueName)
VALUES('Environment')
INSERT INTO tblIssues (IssueName)
VALUES('Energy')
INSERT INTO tblIssues (IssueName)
VALUES('Immigration')
INSERT INTO tblIssues (IssueName)
VALUES('Abortion')
INSERT INTO tblIssues (IssueName)
VALUES('Death Penalty')
INSERT INTO tblIssues (IssueName)
VALUES('Economy')
INSERT INTO tblIssues (IssueName)
VALUES('Foreign Policy')

INSERT INTO tblMunicipality(MunicipalityName)
VALUES ('Coleslaw')
INSERT INTO tblMunicipality(MunicipalityName)
VALUES ('Hamburger')
INSERT INTO tblMunicipality(MunicipalityName)
VALUES ('Chicken Salad')
INSERT INTO tblMunicipality(MunicipalityName)
VALUES ('Ham Sandwich')
INSERT INTO tblMunicipality(MunicipalityName)
VALUES ('Philly Cheesesteak')

INSERT INTO tblParty (PartyName)
VALUES ('Democrat')
INSERT INTO tblParty (PartyName)
VALUES ('Republican')
INSERT INTO tblParty (PartyName)
VALUES ('Independent')
INSERT INTO tblParty (PartyName)
VALUES ('Libertarian')
INSERT INTO tblParty (PartyName)
VALUES ('Green')
INSERT INTO tblParty (PartyName)
VALUES ('Tea')

INSERT INTO tblVoters(VoterFirstName, VoterLastName, VoterDateOfBirth, Gender)
VALUES ('Jeb', 'Bush', '1974-03-21', 'M')
INSERT INTO tblVoters(VoterFirstName, VoterLastName, VoterDateOfBirth, Gender)
VALUES ('Mark', 'Bush', '1974-03-22', 'M')
INSERT INTO tblVoters(VoterFirstName, VoterLastName, VoterDateOfBirth, Gender)
VALUES ('Theodore', 'Bush', '1974-03-23', 'M')
INSERT INTO tblVoters(VoterFirstName, VoterLastName, VoterDateOfBirth, Gender)
VALUES ('Fred', 'Bush', '1974-03-24', 'M')
INSERT INTO tblVoters(VoterFirstName, VoterLastName, VoterDateOfBirth, Gender)
VALUES ('Geisel', 'Bush', '1974-03-25', 'M')
INSERT INTO tblVoters(VoterFirstName, VoterLastName, VoterDateOfBirth, Gender)
VALUES ('Patricia', 'Stein', '1972-04-16', 'F')
INSERT INTO tblVoters(VoterFirstName, VoterLastName, VoterDateOfBirth, Gender)
VALUES ('Alice', 'Stein', '1972-04-17', 'F')
INSERT INTO tblVoters(VoterFirstName, VoterLastName, VoterDateOfBirth, Gender)
VALUES ('Grimauldine', 'Stein', '1972-04-18', 'F')
INSERT INTO tblVoters(VoterFirstName, VoterLastName, VoterDateOfBirth, Gender)
VALUES ('Gloria', 'Stein', '1972-04-19', 'F')
INSERT INTO tblVoters(VoterFirstName, VoterLastName, VoterDateOfBirth, Gender)
VALUES ('Adolfa', 'Stein', '1972-04-20', 'F')

-- Business rules

GO
CREATE FUNCTION check_18()
RETURNS INT
AS
BEGIN
DECLARE @RET INT = 0
IF EXISTS (SELECT v.VoterID
           FROM tblVoters v
           WHERE DATEADD(YEAR,-18,GETDATE()) < v.VoterDateOfBirth
           )
SET @RET = 1
RETURN @RET
END
GO
 
Alter TABLE tblVoter
Add CONSTRAINT jhu_Project4_BusinessRule1
CHECK (dbo.check_18() = 0)
GO
 
CREATE FUNCTION check_voter()
RETURNS INT
AS
BEGIN
DECLARE @RET INT = 0
IF EXISTS (SELECT v.VoterID, v.PrecinctID
           FROM tblVoters v
           JOIN tblPrecinct p on v.PrecinctID = p.PrecinctID
           JOIN tblCity c on p.CityID = c.CityID
           WHERE v.PrecinctID IN (
                   SELECT pr.PrecinctID
                   FROM tblDropbox d, tblPrecinct pr
                   WHERE pr.CityID = d.CityID
				   AND pr.PrecinctName = 'Annie'
      
           )
           )
SET @RET = 1
RETURN @RET
END
GO
Alter TABLE tblVoter
Add CONSTRAINT jhu_Project4_BusinessRule2
CHECK (dbo.check_voter() = 0)
GO
 
-- The voters who have G start for their last name, cannot vote for the candidates who have Z start for their first name
 
Create FUNCTION jhu_NameVote()
RETURNS INT
AS BEGIN
DECLARE @RET INT = 0
IF EXISTS (SELECT V.VoterID, V.VoterFirstName, V.VoterFirstName, C.CandidateFirstName, C.CandidateLastName, C.CandidateID
   FROM tblCandidate C
       JOIN tblVoterCandidate VC ON C.CandidateID = VC.CandidateID
       JOIN tblVoters V ON VC.VoterID = V.VoterID
       WHERE V.VoterLastName LIKE 'G%'
       AND C.CandidateFirstName Like 'C%')
SET @RET = 1
RETURN @RET
END
GO
Alter TABLE tblVoterCandidate
Add CONSTRAINT jhu_Project4_BusinessRule3
CHECK (dbo.jhu_NameVote() = 0)
GO
 
CREATE FUNCTION jhu_Age_Candidate()
RETURNS INT
AS
BEGIN
DECLARE @RET INT = 0
IF EXISTS (SELECT C.CandidateID
           FROM tblCandidate C
           WHERE DATEADD(YEAR,-30,GETDATE()) < C.CandidateDateOfBirth
           )
SET @RET = 1
RETURN @RET
END
GO
Alter TABLE tblCandidate
Add CONSTRAINT jhu_Project4_BusinessRule4
CHECK (dbo.jhu_Age_Candidate() = 0)
GO
 
-- Computed columns
 
CREATE OR ALTER FUNCTION fn_jhu_CountVote(@PK INT)
RETURNS INTEGER
AS
BEGIN
 
DECLARE @RET INT = (SELECT (Count(V.VoterID)) AS TotalVote
FROM tblVoterCandidate V
WHERE V.CandidateID = @PK
GROUP BY ROLLUP (V.CandidateID, ElectionYear))
 
RETURN @RET
END
GO
 
ALTER TABLE tblVoterCandidate
ADD fn_CountVote
AS (dbo.fn_jhu_CountVote(CandidateID))
GO
 
CREATE OR ALTER FUNCTION fn_jhu_CountPartisan(@PK INT)
RETURNS INTEGER
AS
BEGIN
 
DECLARE @RET INT = (SELECT COUNT(C.CandidateID) AS PeepsNum
FROM tblCandidate C
WHERE C.PartyID = @PK
GROUP BY C.PartyID)
 
RETURN @RET
END
GO
 
ALTER TABLE tblCandidate
ADD fn_PartisanFromEachParty
AS (dbo.fn_jhu_CountPartisan(PartyID))
 
GO
CREATE OR ALTER FUNCTION fn_jhu_CountIssues(@PK INT)
RETURNS INTEGER
AS
BEGIN
 
DECLARE @RET INT = (SELECT COUNT(CI.CandidateID) AS PeepsNum
FROM tblCandidateIssue CI
WHERE CI.IssueID = @PK
GROUP BY CI.IssueID)
 
RETURN @RET
END
GO
 
ALTER TABLE tblCandidateIssue
ADD fn_Issues_StatedTimes_Candidates
AS (dbo.fn_jhu_CountIssues(IssueID))
 
GO
CREATE OR ALTER FUNCTION fn_jhu_CountVote_DropBox(@PK INT)
RETURNS INTEGER
AS
BEGIN
 
DECLARE @RET INT = (SELECT COUNT(VoterID) AS PeepsNum
FROM tblDropBoxVoter CI
WHERE DropboxID = @PK
GROUP BY ROLLUP (DropboxID, ElectionYear))
 
RETURN @RET
END
GO
 
ALTER TABLE tblDropBoxVoter
ADD fn_totalVotes_DropBOX
AS (dbo.fn_jhu_CountVote_DropBox(DropboxID))
 
 
-- Views
GO
CREATE VIEW Men_By_Precinct AS
SELECT  B.PrecinctName,  COUNT(A.VoterID) as num_men
FROM (
   SELECT V.VoterID, V.VoterFirstName, V.VoterLastName
   FROM tblVoters V
   WHERE Gender = 'M'
GROUP BY V.VoterID, V.VoterFirstName, V.VoterLastName) A,
(SELECT V.VoterID, P.PrecinctName
   FROM tblVoters V
       JOIN tblPrecinct P ON V.PrecinctID = P.PrecinctID
   --WHERE P.PrecinctName = 'ALDERWOOD'
GROUP BY V.VoterID, P.PrecinctName) B,
(SELECT V.VoterID, C.CountyName
   FROM tblVoters V
       JOIN tblPrecinct P ON V.PrecinctID = P.PrecinctID
       JOIN tblCounty C ON P.CountyID = C.CountyID
   WHERE C.CountyName = 'King'
GROUP BY V.VoterID, C.CountyName)C
WHERE A.VoterID = B.VoterID
AND A.VoterID = C.VoterID
GROUP BY B.PrecinctName

GO
CREATE VIEW Women_By_Precinct AS
SELECT  B.PrecinctName,  COUNT(A.VoterID) as num_women
FROM (
   SELECT V.VoterID, V.VoterFirstName, V.VoterLastName
   FROM tblVoters V
   WHERE Gender = 'F'
GROUP BY V.VoterID, V.VoterFirstName, V.VoterLastName) A,
(SELECT V.VoterID, P.PrecinctName
   FROM tblVoters V
       JOIN tblPrecinct P ON V.PrecinctID = P.PrecinctID
   --WHERE P.PrecinctName = 'ALDERWOOD'
GROUP BY V.VoterID, P.PrecinctName) B,
(SELECT V.VoterID, C.CountyName
   FROM tblVoters V
       JOIN tblPrecinct P ON V.PrecinctID = P.PrecinctID
       JOIN tblCounty C ON P.CountyID = C.CountyID
   WHERE C.CountyName = 'King'
GROUP BY V.VoterID, C.CountyName)C
WHERE A.VoterID = B.VoterID
AND A.VoterID = C.VoterID
GROUP BY B.PrecinctName

GO
CREATE VIEW jhu_AgeCity AS
SELECT (CASE
   WHEN CurrentAge < 19 AND CityName = 'SEATTLE'
       THEN 'Blue'
   WHEN (CurrentAge BETWEEN 19 AND 25) AND (CityName = 'BOTHELL')
       THEN 'Green'
   WHEN (CurrentAge BETWEEN 26 AND 60) AND (CityName = 'EVERETT')
       THEN 'Purple'
ELSE 'Orange'
END) ColumnLabel, COUNT(*) AS NumPeeps
 
FROM
(SELECT A.VoterID, A.CurrentAge, B.CityName
FROM
(SELECT V.VoterID, DateDiff(Year, V.VoterDateOfBirth, GETDATE()) AS CurrentAge
FROM tblVoters V
GROUP BY V.VoterID, V.VoterDateOfBirth) A,
 
(SELECT V.VoterID, CI.CityName
FROM tblVoters V
  JOIN tblPrecinct P ON V.PrecinctID = P.PrecinctID
  JOIN tblCity CI ON CI.CityID = P.CityID
 
GROUP BY V.VoterID, CI.CityName) B
WHERE A.VoterID = B.VoterID) C
 
GROUP BY (CASE
   WHEN CurrentAge < 19 AND CityName = 'SEATTLE'
       THEN 'Blue'
   WHEN (CurrentAge BETWEEN 19 AND 25) AND (CityName = 'BOTHELL')
       THEN 'Green'
   WHEN (CurrentAge BETWEEN 26 AND 60) AND (CityName = 'EVERETT')
       THEN 'Purple'
ELSE 'Orange'
END)
 
GO
CREATE VIEW GenderAge AS
SELECT (CASE
WHEN GenderAge.VoterDateOfBirth > '1995' AND GenderAge.Gender = 'M'
    THEN 'Blue'
WHEN GenderAge.VoterDateOfBirth > '1995' AND GenderAge.Gender = 'F'
    THEN 'Green'
WHEN GenderAge.VoterDateOfBirth > '1965' AND GenderAge.Gender = 'M' AND
    GenderAge.VoterDateOfBirth < '1995'
    THEN 'Yellow'
WHEN  GenderAge.VoterDateOfBirth > '1965' AND GenderAge.Gender = 'F' AND
    GenderAge.VoterDateOfBirth < '1995'
    THEN 'Purple'
ELSE 'Red'
    END) ColumnLabel, COUNT(*) AS NumPeeps
 
FROM ( SELECT a.CandidateID, a.VoterDateOfBirth, b.Gender
      FROM
 (SELECT v.VoterID, v.VoterDateOfBirth, c.CandidateID
    FROM tblVoters v, tblVoterCandidate c
    WHERE v.VoterID = c.VoterID)A,
     
  (SELECT v.VoterID, v.Gender, c.CandidateID
    FROM tblVoters v, tblVoterCandidate c
    WHERE v.VoterID = c.VoterID) B
WHERE a.CandidateID = b.CandidateID
) AS GenderAge
 
GROUP BY
(CASE
WHEN GenderAge.VoterDateOfBirth > '1995' AND GenderAge.Gender = 'M'
    THEN 'Blue'
WHEN GenderAge.VoterDateOfBirth > '1995' AND GenderAge.Gender = 'F'
    THEN 'Green'
WHEN GenderAge.VoterDateOfBirth > '1965' AND GenderAge.Gender = 'M' AND
    GenderAge.VoterDateOfBirth < '1995'
    THEN 'Yellow'
WHEN  GenderAge.VoterDateOfBirth > '1965' AND GenderAge.Gender = 'F' AND
    GenderAge.VoterDateOfBirth < '1995'
    THEN 'Purple'
ELSE 'Red'
    END)
	
GO
CREATE VIEW CityTally AS
SELECT a.CityID, a.tally
FROM
(SELECT c.CityID, COUNT(t.CandidateID) as tally
    FROM tblCity c
    JOIN tblCounty o on c.CountyID = o.CountyID
    JOIN tblPrecinct p on p.CountyID = o.CountyID
    JOIN tblVoters v on p.PrecinctID = v.PrecinctID
    JOIN tblVoterCandidate t on v.VoterID = t.VoterID
    GROUP BY c.cityID) A,
(SELECT ct.CountyID, c.CityID
    FROM tblCounty ct
    JOIN tblCity c on ct.CountyID = c.CityID
    ) B
WHERE a.CityID = b.CityID
 
GO
CREATE VIEW VotersByCity AS
SELECT  B.CityName, COUNT(A.VoterID) as num_voters_per_city
FROM
(SELECT V.VoterID, DateDiff(Year, V.VoterDateOfBirth, GETDATE()) AS CurrentAge
FROM tblVoters V
GROUP BY V.VoterID, DateDiff(Year, V.VoterDateOfBirth, GETDATE())) A,
 
(SELECT V.VoterID, CI.CityName
FROM tblVoters V
  JOIN tblPrecinct P ON V.PrecinctID = P.PrecinctID
  JOIN tblCity CI ON CI.CityID = P.CityID
) B
WHERE A.VoterID = B.VoterID
GROUP BY B.CityName
 
 
-- Insert stored procedures and synthetic transactions
GO
CREATE OR ALTER PROCEDURE InsertCandidateIssue
@Iname VARCHAR (60),
@CFname VARCHAR (60),
@CLname VARCHAR (60),
@CDOB DATE,
@ElectionYear DATE
AS
DECLARE @IID INT, @CID INT
EXEC GetIssues
@IssueName = @Iname,
@IssueID = @IID OUTPUT
IF @IID IS NULL
    BEGIN
        PRINT '@IID is empty, computer exploding';
        THROW 54662, '@IID cannot be empty; calling the cops!!!', 1;
    END
EXEC GetCandidate
@CandidateFirstName = @CFname,
@CandidateLastName = @CLname,
@CandidateDateOfBirth = @CDOB,
@CandidateID = @CID OUTPUT
IF @CID IS NULL
    BEGIN
        PRINT '@CID is empty, computer exploding';
        THROW 54662, '@CID cannot be empty;calling the cops!!!',1;
    END
BEGIN TRANSACTION T1
INSERT INTO tblCandidateIssue (IssueID, CandidateID, ElectionYear)
VALUES (@IID, @CID, @ElectionYear)
IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRAN T1
    END
ELSE
    COMMIT TRAN T1
 
GO                    
CREATE OR ALTER PROCEDURE wrapperdennig2InsertCandidateIssue
@Run INT
AS
DECLARE @iname VARCHAR (60), @cfname VARCHAR (60), @clname VARCHAR (60),
@cdob DATE, @eyear DATE
 
DECLARE @CandidateRowCount INT = (SELECT COUNT(*) FROM tblCandidate)
DECLARE @IssueRowCount INT = (SELECT COUNT(*) FROM tblIssues)
DECLARE @cid INT, @iid INT
 
WHILE @Run > 0
BEGIN
 
SET @cid = (SELECT RAND() * @CandidateRowCount + 1)
SET @iid = (SELECT RAND() * @IssueRowCount +1)
 
SET @iname = (SELECT IssueName FROM tblIssues WHERE IssueID = @iid)
SET @cfname = (SELECT CandidateFirstName FROM tblCandidate WHERE CandidateID = @cid)
SET @clname = (SELECT CandidateLastName FROM tblCandidate WHERE CandidateID = @cid)
SET @cdob = (SELECT CandidateDateOfBirth FROM tblCandidate WHERE CandidateID = @cid)
SET @eyear = (SELECT GetDate() - (SELECT RAND() * 1913 +1))
 
/*Don't have to check for nulls here because CandidateFirstName, CandidateLastName,
CandidateDateOfBirth, and IssueName are all constrained as NOT NULL */
 
EXEC InsertCandidateIssue
@Iname = @iname,
@CFname = @cfname,
@CLname = @clname,
@CDOB = @cdob,
@ElectionYear = @eyear
 
SET @Run = @Run -1
END





GO

CREATE OR ALTER PROCEDURE jhu_Insert_Precinct
@Final_CityName VARCHAR(60),
@CountyName VARCHAR(60),
@PName VARCHAR(60),
@Population INT
AS
DECLARE @CountyId INT, @Final_CityID INT
EXEC GetCounty
@Cname = @CountyName,
@CID = @CountyID OUTPUT
IF @CountyID IS NULL
   BEGIN 
       PRINT 'HEY...@CountyID come back empty; this will fail';
       THROW 54446, '@CountyID cannot be null; process is terminating', 1;
   END
 
EXEC GetCity
@CityName = @Final_CityName,
@Pop = @Population,
@CityID = @Final_Cityid OUTPUT
IF @Final_Cityid IS NULL
   BEGIN 
       PRINT 'HEY...@Final_Cityid come back empty; this will fail';
       THROW 54446, '@Final_Cityid cannot be null; process is terminating', 1;
   END
 
BEGIN TRANSACTION T1
INSERT INTO tblPrecinct(CityID, CountyID, PrecinctName)
VALUES (@Final_CityID, @CountyId, @PName)
 
IF @@ERROR <> 0
   BEGIN
       ROLLBACK TRAN T1
   END
ELSE
   COMMIT TRAN T1
 
GO
 
CREATE TABLE #PrecinctName (
   PrecinctID INT PRIMARY KEY IDENTITY(1,1),
PrecinctName VARCHAR(60))
 
 
GO
 
INSERT INTO #PrecinctName (PrecinctName)
SELECT DISTINCT Precinct
FROM DataElection2022
SELECT *
FROM #PrecinctName
 
GO
 
CREATE OR ALTER PROCEDURE jhu_tblPrecinct_Insert_Value
@Run INT
AS
DECLARE @CityName VARCHAR(60), @CouName VARCHAR(60), @PreName VARCHAR(60),
@Popu INT
 
DECLARE @CityRowCount INT = (SELECT COUNT(*) FROM tblCity)
DECLARE @CountyRowCount INT = (SELECT COUNT(*) FROM tblCounty)
DECLARE @PrecinctRowCOunt INT = (SELECT COUNT(*) FROM tblPrecinct)
DECLARE @Final_Cityid INT, @Countyid INT, @PID INT
 
WHILE @Run > 0
BEGIN
SET @Final_Cityid = (SELECT RAND() * @CityRowCount + 2638)
SET @Countyid = (SELECT RAND() * @CountyRowCount +1)
SET @PID = (SELECT RAND() * @PrecinctRowCOunt + 1)
SET @CityName = (SELECT CityName FROM tblCity WHERE CityID = @Final_Cityid)
SET @CouName = (SELECT CountyName FROM tblCounty WHERE CountyID = 3)
SET @PreName = (Select PrecinctName FROM #PrecinctName WHERE PrecinctID = @PID)
SET @Popu = (Select Pop from tblCity WHERE CityID = @Final_Cityid)
 
EXEC jhu_Insert_Precinct
@Final_CityName = @CityName,
@CountyName = @CouName,
@PName = @PreName,
@Population = @Popu
 
SET @Run = @Run -1
END
EXEC jhu_tblPrecinct_Insert_Value
@Run = 5

GO
CREATE OR ALTER PROCEDURE InsertVoters
@PName VARCHAR(60),
@VFName VARCHAR(60),
@VLName VARCHAR(60),
@VDOB DATE,
@Gender CHAR(1)
AS
DECLARE @PID INT
EXEC GetPrecinct
@PrecinctName = @PName,
@PrecinctID = @PID OUTPUT
BEGIN TRANSACTION T1
INSERT INTO tblVoters (VoterFirstName, VoterLastName, VoterDateOfBirth,PrecinctID, Gender)
VALUES (@VFName, @VLName, @VDOB, @PID, @Gender)
COMMIT TRANSACTION T1

CREATE TABLE #Raw_Table(
VoterID INT PRIMARY KEY  IDENTITY(1,1),
VoterFirstName VARCHAR(MAX),
VoterLastName VARCHAR(MAX),
VoterDateOfBirth DATE,
Gender CHAR(1)
)

CREATE TABLE #Raw_New_PK1(
  VoterID INT IDENTITY (1, 1) PRIMARY KEY,
  VoterFirstName VARCHAR(255) NULL,
  VOTERLASTNAME VARCHAR(255) NULL,
  VoterBirth DATE NULL,
  GEDNER VARCHAR(60) NULL,
  PrecinctName VARCHAR (255) NULL
)
 
 
 
INSERT INTO #Raw_New_PK1 (VoterFirstName, VOTERLASTNAME, GEDNER, VoterBirth, PrecinctName)
 
SELECT First_Name, Last_Name, Gender, Sent_Date, Precinct
FROM DATAELECTION2022
 
CREATE TABLE #RAW_NEW_PK_Precinct
(
   PrecinctID INT IDENTITY (1,1) PRIMARY KEY,
   PRECINCTName VARCHAR(255) NULL
)
 
INSERT INTO #RAW_NEW_PK_Precinct
SELECT DISTINCT Precinct FROm DataElection2022
GO
 
CREATE OR ALTER PROCEDURE jhu_Insert_Voters
 
AS
DECLARE @VFname VARCHAR(60), @VLname VARCHAR(60), @PreName VARCHAR(60),
@VDate DATE, @Gender CHAR(1)
DECLARE @VID INT, @PrecinctID INT, @PKID INT, @PKPID INT
 
DECLARE @VCount INT = (SELECT COUNT(*) FROM DataElection2022 )
DECLARE @PCOUNT INT = (SELECT COUNT(*) FROM tblPrecinct)
 
WHILE @VCount > 0
BEGIN
SET @PKID = (SELECT MIN(VoterID) FROM #Raw_New_PK1)
SET @PKPID = (SELECT RAND() * @PCOUNT +1)
 
SET @VID = (SELECT VoterID FROM #Raw_New_PK1 WHERE VoterID = @PKID)
SET @PreName = (SELECT PrecinctName FROM #RAW_NEW_PK1 WHERE VoterID = @PKID)
SET @VFname = (SELECT VoterFirstName FROM #Raw_New_PK1 WHERE VoterID = @PKID)
SET @VLname = (SELECT VoterLastName FROM #Raw_New_PK1 WHERE VoterID = @PKID)
SET @VDate = (SELECT VoterBirth FROM #Raw_New_PK1 WHERE VoterID = @PKID)
SET @Gender = (Select GEDNER FROM #RAW_NEW_PK1 where VoterID = @PKID)
SET @PrecinctID = (Select PrecinctID FROM #RAW_New_PK_Precinct where PrecinctID = @PKPID)
 
EXEC GetPrecinct
@PName = @PreName,
@PID = @PrecinctID OUTPUT
IF @PrecinctID IS NULL
   BEGIN
       PRINT '@PrecinctID is empty...check spelling';
       THROW 54662, '@PrecinctID cannot be NULL; process is terminating', 1;
   END
BEGIN TRANSACTION T1
 
INSERT INTO tblVoters(VoterFirstName, VoterLastName, PrecinctID, VoterDateOfBirth, Gender)
VALUES (@VFname, @VLname, @PrecinctID, @VDate, @Gender)
COMMIT TRANSACTION T1
DELETE FROM #Raw_New_PK1 WHERE VoterID = @PKID
 
SET @VCount = @VCount - 1
END
 
EXEC jhu_Insert_Voters







