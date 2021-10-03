-----CREATE DATABASE

CREATE DATABASE "P5_GROUP4"

-----USE DATABASE
USE P5_GROUP4

----CREATE SCHEMA
CREATE SCHEMA  mydb  ;
USE mydb ;

------CREATE TABLES


CREATE TABLE mydb.UserInfo (
  [UserID] INT NOT NULL,
  [FirstName] VARCHAR(45) NOT NULL,
  [LastName] VARCHAR(45) NOT NULL,
  [Mobile] VARCHAR(45) NOT NULL,
  [Password] VARCHAR(45) NOT NULL,
  [Street] VARCHAR(45) NOT NULL,
  [City] VARCHAR(45) NOT NULL,
  [State] VARCHAR(45) NOT NULL,
  [ZipCode] INT NOT NULL,
  PRIMARY KEY ([UserID]))
;



CREATE TABLE mydb.CardInfo (
  [CardID] INT NOT NULL,
  [CardNo] VARCHAR(max) NOT NULL,
  [SecurityCode] INT NOT NULL,
  [ExpiryMonth] INT NOT NULL,
  [ExpiryYear] NUMERIC(4) NOT NULL,
  [ZipCode] INT NOT NULL,
  [UserInfo_UserID] INT NOT NULL,
  PRIMARY KEY ([CardID]),
  FOREIGN KEY (UserInfo_UserID) REFERENCES mydb.UserInfo (UserID));



CREATE TABLE mydb.Region (
  [RegionID] INT NOT NULL,
  [RegionName] VARCHAR(45) NULL,
  PRIMARY KEY ([RegionID]))
;





CREATE TABLE mydb.Ami (
  [AmiID] INT NOT NULL,
  [AmiName] VARCHAR(max) NULL,
  [AmiOS] VARCHAR(45) NULL,
  [CreationDate] DATE NULL,
  [TerminationDate] DATE NULL,
  [AmiStatus] VARCHAR(40) NULL,
  [Region_RegionID] INT NOT NULL,
  PRIMARY KEY ([AmiID]),
  
    FOREIGN KEY (Region_RegionID)  REFERENCES mydb.Region (RegionID),
	);
 

 

CREATE TABLE mydb.EC2Class (
  [InstanceType] VARCHAR(45) NOT NULL,
  [InstanceFamily] VARCHAR(45) NULL,
  [InstanceCPU] INT NULL,
  [RAM] INT NULL,
  PRIMARY KEY ([InstanceType]))
;



CREATE TABLE mydb.EC2 (
  [InstanceID] VARCHAR(45) NOT NULL,
  [MemoryDisk] INT NULL,
  [CreateDate] DATE NULL,
  [TerminationDate] DATE NULL,
  [Status] VARCHAR(45) NULL,
  [UserInfo_UserID] INT NOT NULL,
  [Region_RegionID] INT NOT NULL,
  [Ami_AmiID] INT NOT NULL,
  [EC2Class_InstanceType] VARCHAR(45) NOT NULL,
  PRIMARY KEY ([InstanceID]),

    FOREIGN KEY (UserInfo_UserID) REFERENCES mydb.UserInfo (UserID),
    FOREIGN KEY ([Region_RegionID]) REFERENCES mydb.Region (RegionID),
    FOREIGN KEY ([Ami_AmiID]) REFERENCES mydb.Ami ([AmiID]),
    FOREIGN KEY ([EC2Class_InstanceType]) REFERENCES mydb.EC2Class([InstanceType]),);
 




CREATE TABLE mydb.Storage (
  [StorageID] INT NOT NULL,
  [Size] INT NULL,
  [VolumeType] VARCHAR(45) NULL,
  [IOPS] DECIMAL(10,0) NULL,
  [EC2_InstanceID] VARCHAR(45) NOT NULL,
  PRIMARY KEY ([StorageID]),
    FOREIGN KEY ([EC2_InstanceID]) REFERENCES mydb.EC2([InstanceID]),);




CREATE TABLE mydb.StorageClass (
  [StorageID] INT NOT NULL,
  [StorageName] VARCHAR(45) NULL,
  PRIMARY KEY ([StorageID]))
;




CREATE TABLE mydb.Bucket (
  [BucketID] INT NOT NULL,
  [BucketName] VARCHAR(45) NULL,
  [Access] VARCHAR(45) NULL,
  [ARN] VARCHAR(45) NULL,
  [CreateDate] DATE NULL,
  [TerminationDate] DATE NULL,
  [Status] VARCHAR(45) NULL,
  [Encrypytion] SMALLINT NOT NULL,
  [StorageClass_StorageID] INT NOT NULL,
  [Region_RegionID] INT NOT NULL,
  PRIMARY KEY ([BucketID]),
  FOREIGN KEY ([StorageClass_StorageID]) REFERENCES mydb.StorageClass(StorageID),
  FOREIGN KEY ([Region_RegionID]) REFERENCES mydb.Region ([RegionID]));
    



CREATE TABLE mydb.Object (
  [ObjectID] INT NOT NULL,
  [ObjectName] VARCHAR(45) NULL,
  [Size] DECIMAL(10,0) NOT NULL,
  [CreateDate] DATE NULL,
  [TerminationDate] DATE NULL,
  [Status] VARCHAR(45) NULL,
  [ObjectURL] VARCHAR(45) NULL,
  [Bucket_UserInfo_UserID] INT NOT NULL,
  [UserInfo_UserID] INT NOT NULL,
  [Bucket_BucketID] INT NOT NULL,
  PRIMARY KEY ([ObjectID]),
  FOREIGN KEY ([UserInfo_UserID]) REFERENCES mydb.UserInfo ([UserID]),
  FOREIGN KEY ([Bucket_BucketID]) REFERENCES mydb.Bucket ([BucketID]));
 

CREATE TABLE mydb.DbStorage (
  [ClassID] INT NOT NULL,
  [StorageType] VARCHAR(45) NOT NULL,
  [StorageSize] INT NOT NULL,
  [Dbiops] DECIMAL(10,0) NOT NULL,
  PRIMARY KEY ([ClassID]))
;




CREATE TABLE mydb.Engine (
  [EngineID] INT NOT NULL,
  [EngineName] VARCHAR(45) NOT NULL,
  [Version] VARCHAR(45) NOT NULL,
  PRIMARY KEY ([EngineID]))
;



	CREATE TABLE mydb.DbClass (
	  [DbClassType] VARCHAR(45) NOT NULL,
	  [DbFamily] VARCHAR(45) NOT NULL,
	  [CPU] INT NOT NULL,
	  [RAM] INT NOT NULL,
	  [Network] INT NOT NULL,
	  PRIMARY KEY ([DbClassType]))
	;


	
CREATE TABLE mydb.Db (
  [DbID] INT NOT NULL,
  [CreateDate] DATE NOT NULL,
  [TerminationDate] DATE NULL,
  [Status] VARCHAR(45) NULL,
  [DbHostName] VARCHAR(255) NOT NULL,
  [DbPassword] VARCHAR(45) NULL,
  [DbUserName] VARCHAR(45) NULL,
  [DbportNumber] INT NOT NULL,
  [DbStorage_ClassID] INT NOT NULL,
  [Engine_EngineID] INT NOT NULL,
  [UserInfo_UserID] INT NOT NULL,
  [Region_RegionID] INT NOT NULL,
  [DbClass_DbClassType] VARCHAR(45) NOT NULL,
  PRIMARY KEY ([DbID]),
    FOREIGN KEY ([DbStorage_ClassID]) REFERENCES mydb.DbStorage ([ClassID]),
      FOREIGN KEY ([Engine_EngineID]) REFERENCES mydb.Engine ([EngineID]),
    FOREIGN KEY ([UserInfo_UserID]) REFERENCES mydb.UserInfo ([UserID]),
    FOREIGN KEY ([Region_RegionID]) REFERENCES mydb.Region ([RegionID]),
    FOREIGN KEY ([DbClass_DbClassType]) REFERENCES mydb.DbClass ([DbClassType]));



CREATE TABLE mydb.ActivityTrackerDb (
  [DbActivityID] INT NOT NULL,
  [TotalActiveTime] VARCHAR(45) NOT NULL,
  [Db_DbID] INT NOT NULL,
  PRIMARY KEY ([DbActivityID]),

    FOREIGN KEY ([Db_DbID]) REFERENCES mydb.Db ([DbID]));
 


CREATE TABLE mydb.ActivityTrackerS3 (
  [S3ActivityID] INT NOT NULL,
  [TotalActiveTime] VARCHAR(45) NULL,
  [Object_Bucket_BucketName1] VARCHAR(45) NOT NULL,
  [ActivityTrackerS3col] VARCHAR(45) NULL,
  [Bucket_BucketID] INT NOT NULL,
  PRIMARY KEY ([S3ActivityID]),
  
    FOREIGN KEY ([Bucket_BucketID]) REFERENCES mydb.Bucket ([BucketID]));
    



CREATE TABLE mydb.ActivityTrackerEC2 (
  [EC2ActivityID] INT NOT NULL,
  [TotalActiveTime] VARCHAR(45) NULL,
  [EC2_InstanceID] VARCHAR(45) NOT NULL,
  PRIMARY KEY ([EC2ActivityID]),
    FOREIGN KEY ([EC2_InstanceID]) REFERENCES mydb.EC2 ([InstanceID]));
   


CREATE TABLE mydb.TotalSales (
  [SaleID] INT NOT NULL,
  [TotalBillAmount] DECIMAL(10,0) NOT NULL,
  [ActivityTrackerDb_DbActivityID] INT NOT NULL,
  [ActivityTrackerS3_S3ActivityID] INT NOT NULL,
  [ActivityTrackerEC2_EC2ActivityID] INT NOT NULL,
  PRIMARY KEY ([SaleID]),
    FOREIGN KEY ([ActivityTrackerDb_DbActivityID]) REFERENCES mydb.ActivityTrackerDb ([DbActivityID]),
    FOREIGN KEY ([ActivityTrackerS3_S3ActivityID]) REFERENCES mydb.ActivityTrackerS3 ([S3ActivityID]),
    FOREIGN KEY ([ActivityTrackerEC2_EC2ActivityID]) REFERENCES mydb.ActivityTrackerEC2 ([EC2ActivityID]));

   
 CREATE TABLE mydb.Billing (
  [BillingID] INT NOT NULL,
  [TotalSales_SaleID] INT NOT NULL,
  PRIMARY KEY ([BillingID]),
    FOREIGN KEY ([TotalSales_SaleID]) REFERENCES mydb.TotalSales ([SaleID]));


CREATE TABLE mydb.Transactions (
  [TransactionID] INT NOT NULL,
  [DueDate] DATE NOT NULL,
  [PaymentStatus] VARCHAR(45) NOT NULL,
  [paid_at_date] DATE NULL,
  [Billing_BillingID] INT NOT NULL,
  [CardInfo_CardID] INT NOT NULL,
  PRIMARY KEY ([TransactionID]),
    FOREIGN KEY ([Billing_BillingID]) REFERENCES mydb.Billing ([BillingID]),
    FOREIGN KEY ([CardInfo_CardID]) REFERENCES mydb.CardInfo ([CardID]));






--- DATA INSERTION INTO USERINFO


INSERT INTO mydb.UserInfo (UserID, FirstName, LastName, Mobile, Password, Street, City, State, Zipcode) 
VALUES (100201, 'Jason','Adam', '(1) 675 550-1222', 'jadm123', '111 Pudong Rd', 'Boston','MA',02108)


INSERT INTO mydb.UserInfo (UserID, FirstName, LastName, Mobile, Password, Street, City, State, Zipcode) 
VALUES (100251, 'Linda','Wall', '(1) 781 706-3393', 'lwall123', '19 Thatcher St',  'Milton','MA',02187)


INSERT INTO mydb.UserInfo (UserID, FirstName, LastName, Mobile, Password, Street, City, State, Zipcode) 
VALUES (110266, 'Emma','Sanderson', '(1) 781 776-9093', 'esand123', '2013 Pride Ave',  'Boston','MA',02211)


INSERT INTO mydb.UserInfo (UserID, FirstName, LastName, Mobile, Password, Street, City, State, Zipcode) 
VALUES (110336, 'Terry','Vincet', '(1) 857 838-3194', 'tvincent123', '1115 Coventry Avenue',  'Cheltenham','Pennsylvania',19012)


INSERT INTO mydb.UserInfo (UserID, FirstName, LastName, Mobile, Password, Street, City, State, Zipcode) 
VALUES (110238, 'John','Williams', '(1) 732 555-7222', 'jwill123',  '14 Otis Lane', 'Bellport','New York',11713)


INSERT INTO mydb.UserInfo (UserID, FirstName, LastName, Mobile, Password, Street, City, State, Zipcode) 
VALUES (123098, 'Lisa','Felix', '(312) 747-2342', 'lfelix123', '122 N Aberdeen St' , 'Chicago','Illinois',60607)


INSERT INTO mydb.UserInfo (UserID, FirstName, LastName, Mobile, Password, Street, City, State, Zipcode) 
VALUES (126078, 'Anna','Becker', '(312) 747-2342', 'abecker123', '24 Gage Ave',  'Los Angeles','California',90001)


INSERT INTO mydb.UserInfo (UserID, FirstName, LastName, Mobile, Password, Street, City, State, Zipcode) 
VALUES (185697, 'Toan', 'Parker', '972 555-6374','tparker123', '228 Rio Rita Dr',  'Garland','Texas',75040)



INSERT INTO mydb.UserInfo (UserID, FirstName, LastName, Mobile, Password, Street, City, State, Zipcode) 
VALUES (100250, 'Sarah', 'Davis', '(1) 215 555-9222', 'sdavis123', '206-9291 Nisi Rd.',  'Alma','Colorado',81217)


INSERT INTO mydb.UserInfo (UserID, FirstName, LastName, Mobile, Password, Street, City, State, Zipcode) 
VALUES (190127, 'Mark', 'Taylor', '(1) 415 555-1222', 'mtaylor123', '248 Monteray Ave', 'Dayton','Ohio',45419)


INSERT INTO mydb.UserInfo (UserID, FirstName, LastName, Mobile, Password, Street, City, State, Zipcode) 
VALUES (174438, 'Lauren', 'Rivera', '(1) 312 555-3222', 'lrivera123',  '2001 Catharine St', 'Philadelphia','Pennsylvania',19003)

 
INSERT INTO mydb.UserInfo (UserID, FirstName, LastName, Mobile, Password, Street, City, State, Zipcode) 
VALUES (111038, 'Jordon', 'Robinson', '1 (617) 555-0222', 'jrobin123',  '1 East Jingling Rd', 'Princeton','New York',8540)



---INSERT DATA INTO CARDINFO

INSERT INTO mydb.CardInfo (CardID, CardNo, SecurityCode, ExpiryMonth, ExpiryYear, ZipCode, UserInfo_UserID)
VALUES (  712991808  ,'7106-4239-7093-1515', 910, 05, 2024, 02108, (SELECT UserID FROM mydb.UserInfo WHERE UserID = 100201))

INSERT INTO mydb.CardInfo (CardID, CardNo, SecurityCode, ExpiryMonth, ExpiryYear, ZipCode, UserInfo_UserID)
VALUES (  709029408  , '6492-5655-8241-3530', 788, 01, 2023, 02187, (SELECT UserID FROM mydb.UserInfo WHERE UserID = 100251))


INSERT INTO mydb.CardInfo (CardID, CardNo, SecurityCode, ExpiryMonth, ExpiryYear, ZipCode, UserInfo_UserID)
VALUES (   788658483 , '1438-6906-2509-8219', 833, 05, 2022, 02211, (SELECT UserID FROM mydb.UserInfo WHERE UserID = 110266))

INSERT INTO mydb.CardInfo (CardID, CardNo, SecurityCode, ExpiryMonth, ExpiryYear, ZipCode, UserInfo_UserID)
VALUES (  787937058  , '2764-7023-8396-5255', 768, 09, 2021, 19012, (SELECT UserID FROM mydb.UserInfo WHERE UserID = 110336))


INSERT INTO mydb.CardInfo (CardID, CardNo, SecurityCode, ExpiryMonth, ExpiryYear, ZipCode, UserInfo_UserID)
VALUES (  715318008  , '6691-5105-1556-4131 ', 311, 07, 2024,  11713, (SELECT UserID FROM mydb.UserInfo WHERE UserID = 110336))


INSERT INTO mydb.CardInfo (CardID, CardNo, SecurityCode, ExpiryMonth, ExpiryYear, ZipCode, UserInfo_UserID)
VALUES (  713962233  , '1355-1728-8274-9593 ', 532, 12, 2023, 60607,  (SELECT UserID FROM mydb.UserInfo WHERE UserID = 123098))


INSERT INTO mydb.CardInfo (CardID, CardNo, SecurityCode, ExpiryMonth, ExpiryYear, ZipCode, UserInfo_UserID)
VALUES (  785432733  , '9621-6787-7890-7470 ', 199, 11, 2022,  90001, (SELECT UserID FROM mydb.UserInfo WHERE UserID = 126078))


INSERT INTO mydb.CardInfo (CardID, CardNo, SecurityCode, ExpiryMonth, ExpiryYear, ZipCode, UserInfo_UserID)
VALUES (   715190283 , ' 6385-4594-8055-9081', 231, 1, 2024, 75040,   (SELECT UserID FROM mydb.UserInfo WHERE UserID = 185697))


INSERT INTO mydb.CardInfo (CardID, CardNo, SecurityCode, ExpiryMonth, ExpiryYear, ZipCode, UserInfo_UserID)
VALUES (   827111283 , '2595-8621-2855-9119 ', 877, 11, 2025, 81217, (SELECT UserID FROM mydb.UserInfo WHERE UserID = 100250))


INSERT INTO mydb.CardInfo (CardID, CardNo, SecurityCode, ExpiryMonth, ExpiryYear, ZipCode, UserInfo_UserID)
VALUES (  799723908  , ' 7908-3850-6633-2606', 156, 04, 2023, 45419, (SELECT UserID FROM mydb.UserInfo WHERE UserID = 190127))


INSERT INTO mydb.CardInfo (CardID, CardNo, SecurityCode, ExpiryMonth, ExpiryYear, ZipCode, UserInfo_UserID)
VALUES (  807986133  , '6239-8641-8524-9441 ', 845, 02, 2024, 19003, (SELECT UserID FROM mydb.UserInfo WHERE UserID = 174438))


INSERT INTO mydb.CardInfo (CardID, CardNo, SecurityCode, ExpiryMonth, ExpiryYear, ZipCode, UserInfo_UserID)
VALUES (  789973308  , '1113-9175-3253-8426 ', 090, 12, 2022,  19003, (SELECT UserID FROM mydb.UserInfo WHERE UserID = 111038))


--- DATA INSERTION INTO Region

INSERT INTO mydb.Region (RegionID, RegionName)
VALUES (001, 'US East (Ohio)')

INSERT INTO mydb.Region (RegionID, RegionName)
VALUES (002, 'US East (N. Virginia)')

INSERT INTO mydb.Region (RegionID, RegionName)
VALUES (003, 'US West (N. California)')


INSERT INTO mydb.Region (RegionID, RegionName)
VALUES (004, 'US West (Oregon)')


INSERT INTO mydb.Region (RegionID, RegionName)
VALUES (005, 'Asia Pacific (Hong Kong)')

INSERT INTO mydb.Region (RegionID, RegionName)
VALUES (006, 'Asia Pacific (Mumbai)')

INSERT INTO mydb.Region (RegionID, RegionName)
VALUES (007, 'Asia Pacific (Singapore)')

INSERT INTO mydb.Region (RegionID, RegionName)
VALUES (008, 'Canada (Central)')

INSERT INTO mydb.Region (RegionID, RegionName)
VALUES (009, 'Europe (Frankfurt)')

INSERT INTO mydb.Region (RegionID, RegionName)
VALUES (010, 'Europe (London)')

INSERT INTO mydb.Region (RegionID, RegionName)
VALUES (011, 'South America (São Paulo)')

INSERT INTO mydb.Region (RegionID, RegionName)
VALUES (012, 'Africa (Cape Town)')




---DATA INSERTION INTO AMI

INSERT INTO mydb.Ami (AmiID, AmiName, AmiOS, CreationDate, TerminationDate, AmiStatus, Region_RegionID)
VALUES (025612, 'ami-Sample1', 'Linux', '03/22/2020', '03/21/2023', 'Available', 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 001))


INSERT INTO mydb.Ami (AmiID, AmiName, AmiOS, CreationDate, TerminationDate, AmiStatus, Region_RegionID)
VALUES (025630, 'ami-Sample2', 'macOS', '03/02/2021', '03/28/2023', 'Available', 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 002))


INSERT INTO mydb.Ami (AmiID, AmiName, AmiOS, CreationDate, TerminationDate, AmiStatus, Region_RegionID)
VALUES (025711, 'ami-Sample3', 'macOS', '04/02/2020', '04/28/2024', 'Available', 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 003))


INSERT INTO mydb.Ami (AmiID, AmiName, AmiOS, CreationDate, TerminationDate, AmiStatus, Region_RegionID)
VALUES (025901, 'ami-Sample4', 'Linux', '01/02/2021', '11/28/2023', 'Available', 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 004))



INSERT INTO mydb.Ami (AmiID, AmiName, AmiOS, CreationDate, TerminationDate, AmiStatus, Region_RegionID)
VALUES (025939, 'ami-Sample5', 'Windows', '01/12/2020', '12/24/2022', 'Available', 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 005))



INSERT INTO mydb.Ami (AmiID, AmiName, AmiOS, CreationDate, TerminationDate, AmiStatus, Region_RegionID)
VALUES (025999, 'ami-Sample6', 'Linux', '01/11/2020', '12/24/2021', 'Available', 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 006))



INSERT INTO mydb.Ami (AmiID, AmiName, AmiOS, CreationDate, TerminationDate, AmiStatus, Region_RegionID)
VALUES (025345, 'ami-Sample7', 'Linux', '01/01/2020', '09/01/2021', 'Available', 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 007))


INSERT INTO mydb.Ami (AmiID, AmiName, AmiOS, CreationDate, TerminationDate, AmiStatus, Region_RegionID)
VALUES (025090, 'ami-Sample8', 'macOS', '02/04/2022', '03/01/2025', 'Available', 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 008))


INSERT INTO mydb.Ami (AmiID, AmiName, AmiOS, CreationDate, TerminationDate, AmiStatus, Region_RegionID)
VALUES (025233, 'ami-Sample9', 'macOS', '01/06/2021', '10/01/2025', 'Available', 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 009))


INSERT INTO mydb.Ami (AmiID, AmiName, AmiOS, CreationDate, TerminationDate, AmiStatus, Region_RegionID)
VALUES (025655, 'ami-Sample10', 'Windows', '10/06/2021', '12/01/2024', 'Available', 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 010))


INSERT INTO mydb.Ami (AmiID, AmiName, AmiOS, CreationDate, TerminationDate, AmiStatus, Region_RegionID)
VALUES (025008, 'ami-Sample11', 'Windows', '01/02/2020', '10/11/2024', 'Available', 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 011))



INSERT INTO mydb.Ami (AmiID, AmiName, AmiOS, CreationDate, TerminationDate, AmiStatus, Region_RegionID)
VALUES (025200, 'ami-Sample12', 'Linux', '12/06/2020', '12/01/2022', 'Available', 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 012))



--- DATA INSERTION INTO EC2 CLASS 

INSERT INTO mydb.EC2Class (InstanceType, InstanceFamily, InstanceCPU, RAM)
VALUES ('m4.large', 'General Purpose', 2, 16)

INSERT INTO mydb.EC2Class (InstanceType, InstanceFamily, InstanceCPU, RAM)
VALUES ('m5ad.2xlarge', 'General Purpose', 8, 32)


INSERT INTO mydb.EC2Class (InstanceType, InstanceFamily, InstanceCPU, RAM)
VALUES ('r5d.8xlarge', 'Memory Optimized', 32, 256)


INSERT INTO mydb.EC2Class (InstanceType, InstanceFamily, InstanceCPU, RAM)
VALUES ('t2.large', 'General Purpose', 2, 8)


INSERT INTO mydb.EC2Class (InstanceType, InstanceFamily, InstanceCPU, RAM)
VALUES ('r5.2xlarge', 'Memory Optimized', 8, 64)


INSERT INTO mydb.EC2Class (InstanceType, InstanceFamily, InstanceCPU, RAM)
VALUES ('i3en.large', 'Storage Optimized', 2, 16)



INSERT INTO mydb.EC2Class (InstanceType, InstanceFamily, InstanceCPU, RAM)
VALUES ('c5d.4xlarge', 'Compute Optimized', 16, 32)


INSERT INTO mydb.EC2Class (InstanceType, InstanceFamily, InstanceCPU, RAM)
VALUES ('d2.xlarge', 'Storage Optimized', 4, 31)


INSERT INTO mydb.EC2Class (InstanceType, InstanceFamily, InstanceCPU, RAM)
VALUES ('p2.xlarge', 'GPU instance', 4, 61)

INSERT INTO mydb.EC2Class (InstanceType, InstanceFamily, InstanceCPU, RAM)
VALUES ('r5.4xlarge', 'Memory Optimized', 16, 128)

INSERT INTO mydb.EC2Class (InstanceType, InstanceFamily, InstanceCPU, RAM)
VALUES ('z1d.metal', 'Memory Optimized', 48, 384)

INSERT INTO mydb.EC2Class (InstanceType, InstanceFamily, InstanceCPU, RAM)
VALUES ('f1.2xlarge', 'FPGA Instances', 8, 122)


---DATA INSERTION INTO EC2 

INSERT INTO mydb.EC2 (InstanceID, MemoryDisk, CreateDate, TerminationDate, Status, UserInfo_UserID, Region_RegionID, Ami_AmiID, EC2Class_InstanceType)
VALUES ('i-012-ab', 256 , '03/21/2020', '03/20/2023', 'Running', 
(SELECT UserID FROM mydb.UserInfo WHERE UserID = 111038), (SELECT RegionID FROM mydb.Region WHERE RegionID = 001), 
(SELECT AmiID FROM mydb.Ami WHERE AmiID = 25612),(SELECT InstanceType FROM mydb.EC2Class WHERE InstanceType = 'm4.large'))


INSERT INTO mydb.EC2 (InstanceID, MemoryDisk, CreateDate, TerminationDate, Status, UserInfo_UserID, Region_RegionID, Ami_AmiID, EC2Class_InstanceType)
VALUES ('i-013-cd', 128 , '03/11/2021', '03/10/2022', 'Running', 
(SELECT UserID FROM mydb.UserInfo WHERE UserID = 100201), (SELECT RegionID FROM mydb.Region WHERE RegionID = 002), 
(SELECT AmiID FROM mydb.Ami WHERE AmiID = 025630),(SELECT InstanceType FROM mydb.EC2Class WHERE InstanceType = 'm5ad.2xlarge'))



INSERT INTO mydb.EC2 (InstanceID, MemoryDisk, CreateDate, TerminationDate, Status, UserInfo_UserID, Region_RegionID, Ami_AmiID, EC2Class_InstanceType)
VALUES ('i-014-ef', 128 , '04/11/2021', '03/11/2022', 'Running', 
(SELECT UserID FROM mydb.UserInfo WHERE UserID = 100251), (SELECT RegionID FROM mydb.Region WHERE RegionID = 003), 
(SELECT AmiID FROM mydb.Ami WHERE AmiID = 025711),(SELECT InstanceType FROM mydb.EC2Class WHERE InstanceType = 'r5d.8xlarge'))



INSERT INTO mydb.EC2 (InstanceID, MemoryDisk, CreateDate, TerminationDate, Status, UserInfo_UserID, Region_RegionID, Ami_AmiID, EC2Class_InstanceType)
VALUES ('i-014-gh', 512 , '02/01/2020', '03/19/2022', 'Running', 
(SELECT UserID FROM mydb.UserInfo WHERE UserID = 110266), (SELECT RegionID FROM mydb.Region WHERE RegionID = 004), 
(SELECT AmiID FROM mydb.Ami WHERE AmiID = 025901),(SELECT InstanceType FROM mydb.EC2Class WHERE InstanceType = 't2.large'))


INSERT INTO mydb.EC2 (InstanceID, MemoryDisk, CreateDate, TerminationDate, Status, UserInfo_UserID, Region_RegionID, Ami_AmiID, EC2Class_InstanceType)
VALUES ('i-015-ij', 256 , '03/11/2021', '03/11/2023', 'Running', 
(SELECT UserID FROM mydb.UserInfo WHERE UserID = 110336), (SELECT RegionID FROM mydb.Region WHERE RegionID = 005), 
(SELECT AmiID FROM mydb.Ami WHERE AmiID = 025939),(SELECT InstanceType FROM mydb.EC2Class WHERE InstanceType = 'r5.2xlarge'))


INSERT INTO mydb.EC2 (InstanceID, MemoryDisk, CreateDate, TerminationDate, Status, UserInfo_UserID, Region_RegionID, Ami_AmiID, EC2Class_InstanceType)
VALUES ('i-016-kl', 128 , '03/20/2020', '09/10/2022', 'Running', 
(SELECT UserID FROM mydb.UserInfo WHERE UserID = 110238), (SELECT RegionID FROM mydb.Region WHERE RegionID = 006), 
(SELECT AmiID FROM mydb.Ami WHERE AmiID = 025999),(SELECT InstanceType FROM mydb.EC2Class WHERE InstanceType = 'i3en.large'))



INSERT INTO mydb.EC2 (InstanceID, MemoryDisk, CreateDate, TerminationDate, Status, UserInfo_UserID, Region_RegionID, Ami_AmiID, EC2Class_InstanceType)
VALUES ('i-017-mn', 256 , '03/20/2021', '09/21/2022', 'Running', 
(SELECT UserID FROM mydb.UserInfo WHERE UserID = 123098), (SELECT RegionID FROM mydb.Region WHERE RegionID = 007), 
(SELECT AmiID FROM mydb.Ami WHERE AmiID = 025090),(SELECT InstanceType FROM mydb.EC2Class WHERE InstanceType = 'c5d.4xlarge'))



INSERT INTO mydb.EC2 (InstanceID, MemoryDisk, CreateDate, TerminationDate, Status, UserInfo_UserID, Region_RegionID, Ami_AmiID, EC2Class_InstanceType)
VALUES ('i-018-op', 256 , '03/11/2021', '03/10/2022', 'Running', 
(SELECT UserID FROM mydb.UserInfo WHERE UserID = 126078), (SELECT RegionID FROM mydb.Region WHERE RegionID = 008), 
(SELECT AmiID FROM mydb.Ami WHERE AmiID = 025233),(SELECT InstanceType FROM mydb.EC2Class WHERE InstanceType = 'd2.xlarge'))



INSERT INTO mydb.EC2 (InstanceID, MemoryDisk, CreateDate, TerminationDate, Status, UserInfo_UserID, Region_RegionID, Ami_AmiID, EC2Class_InstanceType)
VALUES ('i-019-qr', 128 , '03/09/2020', '03/10/2020', 'Running', 
(SELECT UserID FROM mydb.UserInfo WHERE UserID = 185697), (SELECT RegionID FROM mydb.Region WHERE RegionID = 009), 
(SELECT AmiID FROM mydb.Ami WHERE AmiID = 025655),(SELECT InstanceType FROM mydb.EC2Class WHERE InstanceType = 'p2.xlarge'))


INSERT INTO mydb.EC2 (InstanceID, MemoryDisk, CreateDate, TerminationDate, Status, UserInfo_UserID, Region_RegionID, Ami_AmiID, EC2Class_InstanceType)
VALUES ('i-020-st', 128 , '12/11/2021', '11/30/2022', 'Running', 
(SELECT UserID FROM mydb.UserInfo WHERE UserID = 100250), (SELECT RegionID FROM mydb.Region WHERE RegionID = 010), 
(SELECT AmiID FROM mydb.Ami WHERE AmiID = 025008),(SELECT InstanceType FROM mydb.EC2Class WHERE InstanceType = 'r5.4xlarge'))



INSERT INTO mydb.EC2 (InstanceID, MemoryDisk, CreateDate, TerminationDate, Status, UserInfo_UserID, Region_RegionID, Ami_AmiID, EC2Class_InstanceType)
VALUES ('i-021-uv', 512 , '03/30/2021', '07/31/2022', 'Running', 
(SELECT UserID FROM mydb.UserInfo WHERE UserID = 190127), (SELECT RegionID FROM mydb.Region WHERE RegionID = 011), 
(SELECT AmiID FROM mydb.Ami WHERE AmiID = 025200),(SELECT InstanceType FROM mydb.EC2Class WHERE InstanceType = 'z1d.metal'))



INSERT INTO mydb.EC2 (InstanceID, MemoryDisk, CreateDate, TerminationDate, Status, UserInfo_UserID, Region_RegionID, Ami_AmiID, EC2Class_InstanceType)
VALUES ('i-022-wx', 512 , '03/11/2021', '03/10/2022', 'Running', 
(SELECT UserID FROM mydb.UserInfo WHERE UserID = 174438), (SELECT RegionID FROM mydb.Region WHERE RegionID = 012), 
(SELECT AmiID FROM mydb.Ami WHERE AmiID = 025345),(SELECT InstanceType FROM mydb.EC2Class WHERE InstanceType = 'z1d.metal'))



---- DATA INSERTION INTO STORAGE

INSERT INTO mydb.Storage (StorageID, Size, VolumeType, IOPS, EC2_InstanceID)
VALUES (40501, 250, 'EBS Only' , 1200.5, (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-012-ab'))


INSERT INTO mydb.Storage (StorageID, Size, VolumeType, IOPS, EC2_InstanceID)
VALUES (40502, 1000, '1 x 1900 NVMe SSD' , 16000.5, (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-013-cd'))



INSERT INTO mydb.Storage (StorageID, Size, VolumeType, IOPS, EC2_InstanceID)
VALUES (40503, 350, 'EBS Only' , 1000, (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-014-ef'))


INSERT INTO mydb.Storage (StorageID, Size, VolumeType, IOPS, EC2_InstanceID)
VALUES (40504, 16, '1 x 75 NVMe SSD' , 100.9889, (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-014-gh'))



INSERT INTO mydb.Storage (StorageID, Size, VolumeType, IOPS, EC2_InstanceID)
VALUES (40505, 32, 'EBS Only' , 100.9889, (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-015-ij'))



INSERT INTO mydb.Storage (StorageID, Size, VolumeType, IOPS, EC2_InstanceID)
VALUES (40506, 384, '4 x 7500 NVMe SSD' , 10000.00, (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-016-kl'))


INSERT INTO mydb.Storage (StorageID, Size, VolumeType, IOPS, EC2_InstanceID)
VALUES (40507, 16, '1 x 32 SSD' , 500.2455, (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-017-mn'))


INSERT INTO mydb.Storage (StorageID, Size, VolumeType, IOPS, EC2_InstanceID)
VALUES (40508, 244, '1 x 240 SSD' , 5000.005, (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-018-op'))



INSERT INTO mydb.Storage (StorageID, Size, VolumeType, IOPS, EC2_InstanceID)
VALUES (40509, 512, 'EBS only' , 5000.005, (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-19-qr'))



INSERT INTO mydb.Storage (StorageID, Size, VolumeType, IOPS, EC2_InstanceID)
VALUES (40510, 30, '1 x 80 SSD' , 2002.4435, (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-20-st'))



INSERT INTO mydb.Storage (StorageID, Size, VolumeType, IOPS, EC2_InstanceID)
VALUES (40511, 512, '4 x 900 NVMe SSD' , 12000.8787, (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-21-uv'))



INSERT INTO mydb.Storage (StorageID, Size, VolumeType, IOPS, EC2_InstanceID)
VALUES (40512, 383, '2 x 320 SSD' , 14000.5567, (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-22-wx'))


---DATA INSERTION StorageClass

INSERT INTO mydb.StorageClass (StorageID, StorageName)
VALUES (0100, 'SampleStorage1')

INSERT INTO mydb.StorageClass (StorageID, StorageName) 
VALUES (0200, 'SampleStorage2') 

INSERT INTO mydb.StorageClass (StorageID, StorageName) 
VALUES (0300, 'SampleStorage3') 

INSERT INTO mydb.StorageClass (StorageID, StorageName) 
VALUES (0400, 'SampleStorage4') 

INSERT INTO mydb.StorageClass (StorageID, StorageName) 
VALUES (0500, 'SampleStorage5') 

INSERT INTO mydb.StorageClass (StorageID, StorageName) 
VALUES (0600, 'SampleStorage6') 

INSERT INTO mydb.StorageClass (StorageID, StorageName) 
VALUES (0700, 'SampleStorage7') 

INSERT INTO mydb.StorageClass (StorageID, StorageName)
VALUES (0800, 'SampleStorage8') 

INSERT INTO mydb.StorageClass (StorageID, StorageName) 
VALUES (0900, 'SampleStorage9') 

INSERT INTO mydb.StorageClass (StorageID, StorageName)
VALUES (1000, 'SampleStorage10') 

INSERT INTO mydb.StorageClass (StorageID, StorageName)
VALUES (1100, 'SampleStorage11') 

INSERT INTO mydb.StorageClass (StorageID, StorageName)
VALUES (1200, 'SampleStorage12') 

 


--- DATA INSERTION INTO Bucket

INSERT INTO mydb.Bucket (BucketID, BucketName, Access, ARN, CreateDate, TerminationDate, Status, Encrypytion, 
StorageClass_StorageID, Region_RegionID)
VALUES (1001, 'bucket1' ,'Public', 'arn:aws:s3:::ab1', '05/05/2021', '06/20/2023', 'Available', 000, (SELECT StorageID FROM mydb.StorageClass WHERE StorageID = 0100),
(SELECT RegionID FROM mydb.Region WHERE RegionID = 001))


INSERT INTO mydb.Bucket (BucketID, BucketName, Access, ARN, CreateDate, TerminationDate, Status, Encrypytion,
StorageClass_StorageID, Region_RegionID) 
VALUES (1002, 'bucket2' ,'Public', 'arn:aws:s3:::ab2', '12/05/2021', '06/04/2022', 'Available', 000, (SELECT StorageID FROM mydb.StorageClass WHERE StorageID = 0200), 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 002)) 

 

INSERT INTO mydb.Bucket (BucketID, BucketName, Access, ARN, CreateDate, TerminationDate, Status, Encrypytion,  
StorageClass_StorageID, Region_RegionID) 
VALUES (1003, 'bucket3', 'Public', 'arn:aws:s3:::ab3', '03/07/2021', '09/22/2021', 'Available', 000, (SELECT StorageID FROM mydb.StorageClass WHERE StorageID = 0300), 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 003)) 

 

INSERT INTO mydb.Bucket (BucketID, BucketName, Access, ARN, CreateDate, TerminationDate, Status, Encrypytion,  
StorageClass_StorageID, Region_RegionID) 
VALUES (1004, 'bucket4', 'Public', 'arn:aws:s3:::ab4', '04/18/2021', '02/08/2023', 'Available', 000, (SELECT StorageID FROM mydb.StorageClass WHERE StorageID = 0400), 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 004)) 

 

INSERT INTO mydb.Bucket (BucketID,BucketName, Access, ARN, CreateDate, TerminationDate, Status, Encrypytion,  
StorageClass_StorageID, Region_RegionID) 
VALUES (1005, 'bucket5', 'Public', 'arn:aws:s3:::ab1', '10/12/2021', '11/20/2023', 'Available', 000, (SELECT StorageID FROM mydb.StorageClass WHERE StorageID = 0500), 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 005)) 

 

INSERT INTO mydb.Bucket (BucketID,BucketName, Access, ARN, CreateDate, TerminationDate, Status, Encrypytion,  
StorageClass_StorageID, Region_RegionID) 
VALUES (1006, 'bucket6' , 'Public', 'arn:aws:s3:::ab6', '03/29/2021', '04/20/2023', 'Available', 000, (SELECT StorageID FROM mydb.StorageClass WHERE StorageID = 0600), 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 006)) 

 

INSERT INTO mydb.Bucket (BucketID, BucketName,Access, ARN, CreateDate, TerminationDate, Status, Encrypytion,  
StorageClass_StorageID, Region_RegionID) 
VALUES (1007, 'bucket7', 'Public', 'arn:aws:s3:::ab7', '11/10/2021', '07/07/2023', 'Available', 000, (SELECT StorageID FROM mydb.StorageClass WHERE StorageID = 0700), 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 007)) 

 

INSERT INTO mydb.Bucket (BucketID,BucketName, Access, ARN, CreateDate, TerminationDate, Status, Encrypytion,  
StorageClass_StorageID, Region_RegionID) 
VALUES (1008, 'bucket8', 'Public', 'arn:aws:s3:::ab8', '01/02/2021', '12/20/2023', 'Available', 000, (SELECT StorageID FROM mydb.StorageClass WHERE StorageID = 0800), 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 008)) 

 

INSERT INTO mydb.Bucket (BucketID,BucketName, Access, ARN, CreateDate, TerminationDate, Status, Encrypytion,  
StorageClass_StorageID, Region_RegionID) 
VALUES (1009, 'bucket9', 'Public', 'arn:aws:s3:::ab9', '12/05/2021', '04/06/2023', 'Available', 000, (SELECT StorageID FROM mydb.StorageClass WHERE StorageID = 0900), 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 009)) 

 

INSERT INTO mydb.Bucket (BucketID,BucketName, Access, ARN, CreateDate, TerminationDate, Status, Encrypytion,  
StorageClass_StorageID, Region_RegionID) 
VALUES (1010, 'bucket10', 'Public', 'arn:aws:s3:::ab10', '09/09/2021', '07/29/2023', 'Available', 000, (SELECT StorageID FROM mydb.StorageClass WHERE StorageID = 1000), 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 010)) 

 

INSERT INTO mydb.Bucket (BucketID, BucketName,Access, ARN, CreateDate, TerminationDate, Status, Encrypytion,  
StorageClass_StorageID, Region_RegionID) 
VALUES (1011, 'bucket11', 'Public', 'arn:aws:s3:::ab11', '06/11/2021', '01/02/2023', 'Available', 000, (SELECT StorageID FROM mydb.StorageClass WHERE StorageID = 1100), 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 011)) 

 

INSERT INTO mydb.Bucket (BucketID,BucketName, Access, ARN, CreateDate, TerminationDate, Status, Encrypytion,  
StorageClass_StorageID, Region_RegionID) 
VALUES (1012, 'bucket12', 'Public', 'arn:aws:s3:::ab12', '10/10/2021', '11/05/2023', 'Available', 000, (SELECT StorageID FROM mydb.StorageClass WHERE StorageID = 1200), 
(SELECT RegionID FROM mydb.Region WHERE RegionID = 012)) 

 
---DATA INSERTION INTO Object
 

INSERT INTO mydb.Object (ObjectID, ObjectName, Size, CreateDate, TerminationDate, Status, ObjectURL,  UserInfo_UserID, Bucket_BucketID) 

VALUES (51, 'Object1', 12.788, '01/09/2021', '06/20/2023', 'Available', 'http://s3.amazonaws.com/object1',  

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 100201), (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1001) )

 INSERT INTO mydb.Object (ObjectID, ObjectName, Size, CreateDate, TerminationDate, Status, ObjectURL,  UserInfo_UserID, Bucket_BucketID) 

VALUES (52, 'Object2', 14.66, '02/19/2021', '12/01/2023', 'Available', 'http://s3.amazonaws.com/object2',  

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 100251), (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1002) )

INSERT INTO mydb.Object (ObjectID, ObjectName, Size, CreateDate, TerminationDate, Status, ObjectURL,  UserInfo_UserID, Bucket_BucketID) 

VALUES (53, 'Object3', 21.33, '11/29/2021', '02/02/2023', 'Available', 'http://s3.amazonaws.com/object3',  

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 110266), (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1003) )

INSERT INTO mydb.Object (ObjectID, ObjectName, Size, CreateDate, TerminationDate, Status, ObjectURL,  UserInfo_UserID, Bucket_BucketID) 

VALUES (54, 'Object4', 121.02, '07/19/2021', '12/20/2022', 'Available', 'http://s3.amazonaws.com/object4',  

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 110336), (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1004) )

INSERT INTO mydb.Object (ObjectID, ObjectName, Size, CreateDate, TerminationDate, Status, ObjectURL,  UserInfo_UserID, Bucket_BucketID) 

VALUES (55, 'Object5', 14.32, '06/13/2021', '11/21/2022', 'Available', 'http://s3.amazonaws.com/object5',  

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 110238), (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1005) )

INSERT INTO mydb.Object (ObjectID, ObjectName, Size, CreateDate, TerminationDate, Status, ObjectURL,  UserInfo_UserID, Bucket_BucketID) 

VALUES (56, 'Object6', 17.98, '01/26/2021', '06/10/2023', 'Available', 'http://s3.amazonaws.com/object6',  

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 123098), (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1001) )

INSERT INTO mydb.Object (ObjectID, ObjectName, Size, CreateDate, TerminationDate, Status, ObjectURL,  UserInfo_UserID, Bucket_BucketID) 

VALUES (57, 'Object7', 9.32, '12/09/2021', '01/21/2023', 'Available', 'http://s3.amazonaws.com/object1',  

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 126078), (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1007) )

INSERT INTO mydb.Object (ObjectID, ObjectName, Size, CreateDate, TerminationDate, Status, ObjectURL,  UserInfo_UserID, Bucket_BucketID) 

VALUES (58, 'Object8', 31.21, '05/15/2021', '09/01/2023', 'Available', 'http://s3.amazonaws.com/object8',  

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 185697), (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1008) )

INSERT INTO mydb.Object (ObjectID, ObjectName, Size, CreateDate, TerminationDate, Status, ObjectURL,  UserInfo_UserID, Bucket_BucketID) 

VALUES (59, 'Object9', 12.12, '03/13/2021', '07/21/2023', 'Available', 'http://s3.amazonaws.com/object9',  

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 100250), (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1009) )

INSERT INTO mydb.Object (ObjectID, ObjectName, Size, CreateDate, TerminationDate, Status, ObjectURL,  UserInfo_UserID, Bucket_BucketID) 

VALUES (60, 'Object10', 27.88, '10/03/2021', '06/20/2023', 'Available', 'http://s3.amazonaws.com/object10',  

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 190127), (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1010) )

INSERT INTO mydb.Object (ObjectID, ObjectName, Size, CreateDate, TerminationDate, Status, ObjectURL,  UserInfo_UserID, Bucket_BucketID) 

VALUES (61, 'Object11', 44.21, '10/10/2021', '06/10/2023', 'Available', 'http://s3.amazonaws.com/object11',  

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 174438), (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1011) )

INSERT INTO mydb.Object (ObjectID, ObjectName, Size, CreateDate, TerminationDate, Status, ObjectURL,  UserInfo_UserID, Bucket_BucketID) 

VALUES (62, 'Object12', 88.21, '12/19/2021', '08/10/2023', 'Available', 'http://s3.amazonaws.com/object12',  

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 111038), (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1012) )




---DATA INSERTION dB Storage
 

INSERT INTO mydb.DbStorage (ClassID, StorageType, StorageSize, Dbiops) 

VALUES (10, 'SSD', 256, 100.20) 

INSERT INTO mydb.DbStorage (ClassID, StorageType, StorageSize, Dbiops) 

VALUES (11, 'HDD', 512, 50.20) 

INSERT INTO mydb.DbStorage (ClassID, StorageType, StorageSize, Dbiops) 

VALUES (12, 'SSD', 1024, 300.40) 

INSERT INTO mydb.DbStorage (ClassID, StorageType, StorageSize, Dbiops) 

VALUES (13, 'SSD', 256, 500.30) 

INSERT INTO mydb.DbStorage (ClassID, StorageType, StorageSize, Dbiops) 

VALUES (14, 'SSD', 512, 200.20) 

INSERT INTO mydb.DbStorage (ClassID, StorageType, StorageSize, Dbiops) 

VALUES (15, 'HDD', 256, 300.20) 

INSERT INTO mydb.DbStorage (ClassID, StorageType, StorageSize, Dbiops) 

VALUES (16, 'SSD', 512, 600.20) 

INSERT INTO mydb.DbStorage (ClassID, StorageType, StorageSize, Dbiops) 

VALUES (17, 'SSD', 256, 200.20) 

INSERT INTO mydb.DbStorage (ClassID, StorageType, StorageSize, Dbiops) 

VALUES (18, 'HDD', 512, 300.60) 

INSERT INTO mydb.DbStorage (ClassID, StorageType, StorageSize, Dbiops) 

VALUES (19, 'SSD', 1024, 300.20) 

INSERT INTO mydb.DbStorage (ClassID, StorageType, StorageSize, Dbiops) 

VALUES (20, 'SSD', 256, 400.20) 

INSERT INTO mydb.DbStorage (ClassID, StorageType, StorageSize, Dbiops) 

VALUES (21, 'HDD', 512, 100.90) 


---DATA INSERTION db Engine

INSERT INTO mydb.Engine (EngineID, EngineName, Version)
VALUES (801, 'PostGres', 'PostGres 3.0.1')


INSERT INTO mydb.Engine (EngineID, EngineName, Version)
VALUES (802, 'SQL Sever', 'SQL Sever 19.0.0.1')


INSERT INTO mydb.Engine (EngineID, EngineName, Version)
VALUES (803, 'MySQL', 'MySQL 5.0.0.4')


INSERT INTO mydb.Engine (EngineID, EngineName, Version)
VALUES (804, 'SQL Sever', 'SQL Sever 19.0.0.2')

INSERT INTO mydb.Engine (EngineID, EngineName, Version)
VALUES (805, 'MySQL', 'MySQL 5.0.0.3')


INSERT INTO mydb.Engine (EngineID, EngineName, Version)
VALUES (806, 'PostGres', 'PostGres 4.0.1')


INSERT INTO mydb.Engine (EngineID, EngineName, Version)
VALUES (807, 'SQL Sever', 'SQL Sever 18.0.0.1')


INSERT INTO mydb.Engine (EngineID, EngineName, Version)
VALUES (808, 'MySQL', 'MySQL 5.0.0.1')


INSERT INTO mydb.Engine (EngineID, EngineName, Version)
VALUES (809, 'SQL Sever', 'SQL Sever 19.0.0.4')

INSERT INTO mydb.Engine (EngineID, EngineName, Version)
VALUES (810, 'MySQL', 'MySQL 5.0.0.4')

INSERT INTO mydb.Engine (EngineID, EngineName, Version)
VALUES (811, 'SQL Sever', 'SQL Sever 19.0.0.3')

INSERT INTO mydb.Engine (EngineID, EngineName, Version)
VALUES (812, 'MySQL', 'MySQL 4.0.0.9')




--DATA INSERTION dbClass
  

INSERT INTO mydb.DbClass (DbClassType, DbFamily, CPU, RAM, Network) 

VALUES ('db.r5.2xlarge.1', 'Aurora',2, 16, 4750) 

 INSERT INTO mydb.DbClass (DbClassType, DbFamily, CPU, RAM, Network) 

VALUES ('db.r5.large.2', 'Aurora',4, 08, 4750) 

INSERT INTO mydb.DbClass (DbClassType, DbFamily, CPU, RAM, Network) 

VALUES ('db.r5.4xlarge.3', 'Aurora',8, 32, 4750) 

INSERT INTO mydb.DbClass (DbClassType, DbFamily, CPU, RAM, Network) 

VALUES ('db.r5.6xlarge.4', 'Aurora',2, 16, 4750) 

INSERT INTO mydb.DbClass (DbClassType, DbFamily, CPU, RAM, Network) 

VALUES ('db.r5.2xlarge.5', 'Aurora',4, 16, 4750) 

INSERT INTO mydb.DbClass (DbClassType, DbFamily, CPU, RAM, Network) 

VALUES ('db.r5.16xlarge.6', 'Aurora',4, 4, 4750) 

INSERT INTO mydb.DbClass (DbClassType, DbFamily, CPU, RAM, Network) 

VALUES ('db.r5.24xlarge.7', 'Aurora',8, 8, 4750) 

INSERT INTO mydb.DbClass (DbClassType, DbFamily, CPU, RAM, Network) 

VALUES ('db.r5.2xlarge.8', 'Aurora',16, 8, 4750) 

INSERT INTO mydb.DbClass (DbClassType, DbFamily, CPU, RAM, Network) 

VALUES ('db.r5.4xlarge.9', 'Aurora',4, 16, 4750) 

INSERT INTO mydb.DbClass (DbClassType, DbFamily, CPU, RAM, Network) 

VALUES ('db.r5.2xlarge.10', 'Aurora',2, 32, 4750) 

INSERT INTO mydb.DbClass (DbClassType, DbFamily, CPU, RAM, Network) 

VALUES ('db.r5.large.11', 'Aurora',2, 4, 4750) 

INSERT INTO mydb.DbClass (DbClassType, DbFamily, CPU, RAM, Network) 

VALUES ('db.r5.8xlarge.12', 'Aurora',8, 16, 4750) 



--DATA INSERTION DB
 

 

INSERT INTO mydb.Db (DbID, CreateDate, TerminationDate, Status, DbHostName, DbPassword, DbUserName, DbportNumber,  
DbStorage_ClassID, Engine_EngineID, 
UserInfo_UserID, Region_RegionID, DbClass_DbClassType) 

VALUES (2001, '01/23/2020', ' ', 'ON', 'mydb.123456789012.us-east-1.rds.amazonaws.com', 'dbabc123', 'Jason', 3306,  

(SELECT ClassID FROM mydb.DbStorage WHERE ClassID = 10), (SELECT EngineID FROM mydb.Engine WHERE EngineID = 801),

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 100201) ,

(SELECT RegionID FROM mydb.Region WHERE RegionID = 001), 

(SELECT DbClassType FROM mydb.DbClass WHERE DbClassType = 'db.r5.2xlarge.1' ) )

 

INSERT INTO mydb.Db (DbID, CreateDate, TerminationDate, Status, DbHostName, DbPassword, DbUserName, DbportNumber,  

DbStorage_ClassID, Engine_EngineID, 

UserInfo_UserID, Region_RegionID, DbClass_DbClassType) 

VALUES (2002, '01/23/2020', '10/02/2020 ', 'OFF', 'mydb.123456985642.us-east-2.rds.amazonaws.com', 'dbabc123', 'Linda', 3306,  

(SELECT ClassID FROM mydb.DbStorage WHERE ClassID = 11), (SELECT EngineID FROM mydb.Engine WHERE EngineID = 802) ,

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 100251) ,

(SELECT RegionID FROM mydb.Region WHERE RegionID = 002) ,

(SELECT DbClassType FROM mydb.DbClass WHERE DbClassType = 'db.r5.large.2' ) )

 

INSERT INTO mydb.Db (DbID, CreateDate, TerminationDate, Status, DbHostName, DbPassword, DbUserName, DbportNumber,  

DbStorage_ClassID, Engine_EngineID, 

UserInfo_UserID, Region_RegionID, DbClass_DbClassType) 

VALUES (2003, '01/23/2021', ' ', 'ON', 'mydb.123456789032.us-west-1.rds.amazonaws.com', 'powerup', 'Emma', 3306,  

(SELECT ClassID FROM mydb.DbStorage WHERE ClassID = 12), (SELECT EngineID FROM mydb.Engine WHERE EngineID = 803), 

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 110266) ,

(SELECT RegionID FROM mydb.Region WHERE RegionID = 003) ,

(SELECT DbClassType FROM mydb.DbClass WHERE DbClassType = 'db.r5.4xlarge.3' ) )

 

INSERT INTO mydb.Db (DbID, CreateDate, TerminationDate, Status, DbHostName, DbPassword, DbUserName, DbportNumber,  

DbStorage_ClassID, Engine_EngineID, 

UserInfo_UserID, Region_RegionID, DbClass_DbClassType) 

VALUES (2004, '01/23/2020', '02/02/2021', 'OFF', 'mydb.123456789789.us-east-1.rds.amazonaws.com', 'dataone', 'Terry', 5432,  

(SELECT ClassID FROM mydb.DbStorage WHERE ClassID = 13), (SELECT EngineID FROM mydb.Engine WHERE EngineID = 804) ,

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 110336) ,

(SELECT RegionID FROM mydb.Region WHERE RegionID = 004), 

(SELECT DbClassType FROM mydb.DbClass WHERE DbClassType = 'db.r5.6xlarge.4' ) )

 

INSERT INTO mydb.Db (DbID, CreateDate, TerminationDate, Status, DbHostName, DbPassword, DbUserName, DbportNumber,  

DbStorage_ClassID, Engine_EngineID, 

UserInfo_UserID, Region_RegionID, DbClass_DbClassType) 

VALUES (2005, '01/23/2020', '08/05/2021', 'OFF', 'mydb.123456789312.us-east-2.rds.amazonaws.com', 'datadata', 'John', 3306,  

(SELECT ClassID FROM mydb.DbStorage WHERE ClassID = 14), (SELECT EngineID FROM mydb.Engine WHERE EngineID = 805) ,

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 110238) ,

(SELECT RegionID FROM mydb.Region WHERE RegionID = 005) ,

(SELECT DbClassType FROM mydb.DbClass WHERE DbClassType = 'db.r5.2xlarge.5' ) )

 

INSERT INTO mydb.Db (DbID, CreateDate, TerminationDate, Status, DbHostName, DbPassword, DbUserName, DbportNumber,  

DbStorage_ClassID, Engine_EngineID, 

UserInfo_UserID, Region_RegionID, DbClass_DbClassType) 

VALUES (2006, '01/23/2020', ' ', 'ON', 'mydb.123456789012.us-east-1.rds.amazonaws.com', 'dbabc123', 'Lisa', 3306,  

(SELECT ClassID FROM mydb.DbStorage WHERE ClassID = 15),(SELECT EngineID FROM mydb.Engine WHERE EngineID = 806) ,

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 123098) ,

(SELECT RegionID FROM mydb.Region WHERE RegionID = 006) ,

(SELECT DbClassType FROM mydb.DbClass WHERE DbClassType = 'db.r5.16xlarge.6' ) )

 

INSERT INTO mydb.Db (DbID, CreateDate, TerminationDate, Status, DbHostName, DbPassword, DbUserName, DbportNumber,  

DbStorage_ClassID, Engine_EngineID, 

UserInfo_UserID, Region_RegionID, DbClass_DbClassType) 

VALUES (2007, '01/23/2020', ' ', 'ON', 'mydb.123456789012.us-east-1.rds.amazonaws.com', 'dbabc123', 'Anna', 3306,  

(SELECT ClassID FROM mydb.DbStorage WHERE ClassID = 16), (SELECT EngineID FROM mydb.Engine WHERE EngineID = 807) ,

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 126078) ,

(SELECT RegionID FROM mydb.Region WHERE RegionID = 001) ,

(SELECT DbClassType FROM mydb.DbClass WHERE DbClassType = 'db.r5.24xlarge.7' ) )

 

INSERT INTO mydb.Db (DbID, CreateDate, TerminationDate, Status, DbHostName, DbPassword, DbUserName, DbportNumber,  

DbStorage_ClassID, Engine_EngineID, 

UserInfo_UserID, Region_RegionID, DbClass_DbClassType) 

VALUES (2008, '01/23/2020', '02/05/2021', 'OFF', 'mydb.123456789870.us-east-1.rds.amazonaws.com', 'hellodata', 'Toan', 3306,  

(SELECT ClassID FROM mydb.DbStorage WHERE ClassID = 17),(SELECT EngineID FROM mydb.Engine WHERE EngineID = 808) ,

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 185697) ,

(SELECT RegionID FROM mydb.Region WHERE RegionID = 008) ,

(SELECT DbClassType FROM mydb.DbClass WHERE DbClassType = 'db.r5.2xlarge.8' ) )

 

INSERT INTO mydb.Db (DbID, CreateDate, TerminationDate, Status, DbHostName, DbPassword, DbUserName, DbportNumber,  

DbStorage_ClassID, Engine_EngineID, 

UserInfo_UserID, Region_RegionID, DbClass_DbClassType) 

VALUES (2009, '01/23/2020', ' ', 'ON', 'mydb.123456789036.us-east-1.rds.amazonaws.com', 'datadb', 'Sarah', 3306,  

(SELECT ClassID FROM mydb.DbStorage WHERE ClassID = 18), (SELECT EngineID FROM mydb.Engine WHERE EngineID = 809) ,

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 100250) ,

(SELECT RegionID FROM mydb.Region WHERE RegionID = 009) ,

(SELECT DbClassType FROM mydb.DbClass WHERE DbClassType = 'db.r5.4xlarge.9' ) )

 

INSERT INTO mydb.Db (DbID, CreateDate, TerminationDate, Status, DbHostName, DbPassword, DbUserName, DbportNumber,  

DbStorage_ClassID, Engine_EngineID, 

UserInfo_UserID, Region_RegionID, DbClass_DbClassType) 

VALUES (2010, '01/23/2020', ' ', 'ON', 'mydb.123456789321.us-east-1.rds.amazonaws.com', 'dbabc123', 'Mark', 3306,  

(SELECT ClassID FROM mydb.DbStorage WHERE ClassID = 19), (SELECT EngineID FROM mydb.Engine WHERE EngineID = 810), 

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 190127) ,

(SELECT RegionID FROM mydb.Region WHERE RegionID = 010) ,

(SELECT DbClassType FROM mydb.DbClass WHERE DbClassType = 'db.r5.2xlarge.10' ) )

 

INSERT INTO mydb.Db (DbID, CreateDate, TerminationDate, Status, DbHostName, DbPassword, DbUserName, DbportNumber,  

DbStorage_ClassID, Engine_EngineID, 

UserInfo_UserID, Region_RegionID, DbClass_DbClassType) 

VALUES (2011, '01/23/2020', ' ', 'ON', 'mydb.123456789012.us-east-1.rds.amazonaws.com', 'dbabc123', 'Lauren', 3306,  

(SELECT ClassID FROM mydb.DbStorage WHERE ClassID = 20), (SELECT EngineID FROM mydb.Engine WHERE EngineID = 811), 

(SELECT UserID FROM mydb.UserInfo WHERE UserID = 174438) ,

(SELECT RegionID FROM mydb.Region WHERE RegionID = 011) ,
(SELECT DbClassType FROM mydb.DbClass WHERE DbClassType = 'db.r5.large.11' ) )

 

INSERT INTO mydb.Db (DbID, CreateDate, TerminationDate, Status, DbHostName, DbPassword, DbUserName, DbportNumber,  

DbStorage_ClassID, Engine_EngineID, 

UserInfo_UserID, Region_RegionID, DbClass_DbClassType) 

VALUES (2012, '01/23/2020', ' ', 'ON', 'mydb.128856879812.us-west-2.rds.amazonaws.com', 'dbabc123', 'Jordan', 5432,  

(SELECT ClassID FROM mydb.DbStorage WHERE ClassID = 21),(SELECT EngineID FROM mydb.Engine WHERE EngineID = 812),
(SELECT UserID FROM mydb.UserInfo WHERE UserID = 111038) ,

(SELECT RegionID FROM mydb.Region WHERE RegionID = 012) ,

(SELECT DbClassType FROM mydb.DbClass WHERE DbClassType = 'db.r5.8xlarge.12' ) )




---DATA INSERTION ActivityTracker for EC2

INSERT INTO mydb.ActivityTrackerEC2(EC2ActivityID, TotalActiveTime, EC2_InstanceID)
VALUES (900819, '450', (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-012-ab'))


INSERT INTO mydb.ActivityTrackerEC2(EC2ActivityID, TotalActiveTime, EC2_InstanceID)
VALUES (900820, '300', (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-013-cd'))


INSERT INTO mydb.ActivityTrackerEC2(EC2ActivityID, TotalActiveTime, EC2_InstanceID)
VALUES (900821, '100', (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-014-ef'))


INSERT INTO mydb.ActivityTrackerEC2(EC2ActivityID, TotalActiveTime, EC2_InstanceID)
VALUES (900822, '555', (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-014-gh'))



INSERT INTO mydb.ActivityTrackerEC2(EC2ActivityID, TotalActiveTime, EC2_InstanceID)
VALUES (900823, '650', (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-015-ij'))


INSERT INTO mydb.ActivityTrackerEC2(EC2ActivityID, TotalActiveTime, EC2_InstanceID)
VALUES (900824, '233', (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-016-kl'))



INSERT INTO mydb.ActivityTrackerEC2(EC2ActivityID, TotalActiveTime, EC2_InstanceID)
VALUES (900825, '200', (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-017-mn'))




INSERT INTO mydb.ActivityTrackerEC2(EC2ActivityID, TotalActiveTime, EC2_InstanceID)
VALUES (900826, '50', (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-018-op'))



INSERT INTO mydb.ActivityTrackerEC2(EC2ActivityID, TotalActiveTime, EC2_InstanceID)
VALUES (900827, '437', (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-019-qr'))




INSERT INTO mydb.ActivityTrackerEC2(EC2ActivityID, TotalActiveTime, EC2_InstanceID)
VALUES (900828, '700', (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-020-st'))


INSERT INTO mydb.ActivityTrackerEC2(EC2ActivityID, TotalActiveTime, EC2_InstanceID)
VALUES (900829, '99', (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-021-uv'))



INSERT INTO mydb.ActivityTrackerEC2(EC2ActivityID, TotalActiveTime, EC2_InstanceID)
VALUES (900830, '456', (SELECT InstanceID FROM mydb.EC2 WHERE InstanceID = 'i-022-wx'))



DELETE FROM mydb.ActivityTrackerEC2 WHERE EC2ActivityID IS NOT NULL

---DATA INSERTION ActivityTrackerS3

INSERT INTO mydb.ActivityTrackerS3 (S3ActivityID, TotalActiveTime, Bucket_BucketID)
VALUES (8001, '98', (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1001))


INSERT INTO mydb.ActivityTrackerS3 (S3ActivityID, TotalActiveTime, Bucket_BucketID)
VALUES (8002, '200', (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1002))


INSERT INTO mydb.ActivityTrackerS3 (S3ActivityID, TotalActiveTime, Bucket_BucketID)
VALUES (8003, '657', (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1003))

INSERT INTO mydb.ActivityTrackerS3 (S3ActivityID, TotalActiveTime, Bucket_BucketID)
VALUES (8004, '570', (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1004))

INSERT INTO mydb.ActivityTrackerS3 (S3ActivityID, TotalActiveTime, Bucket_BucketID)
VALUES (8005, '564', (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1005))

INSERT INTO mydb.ActivityTrackerS3 (S3ActivityID, TotalActiveTime, Bucket_BucketID)
VALUES (8006, '234', (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1006))


INSERT INTO mydb.ActivityTrackerS3 (S3ActivityID, TotalActiveTime, Bucket_BucketID)
VALUES (8007, '456', (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1007))


INSERT INTO mydb.ActivityTrackerS3 (S3ActivityID, TotalActiveTime, Bucket_BucketID)
VALUES (8008, '700 ', (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1008))


INSERT INTO mydb.ActivityTrackerS3 (S3ActivityID, TotalActiveTime, Bucket_BucketID)
VALUES (8009, '540', (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1009))


INSERT INTO mydb.ActivityTrackerS3 (S3ActivityID, TotalActiveTime, Bucket_BucketID)
VALUES (8010, '80', (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1010))


INSERT INTO mydb.ActivityTrackerS3 (S3ActivityID, TotalActiveTime, Bucket_BucketID)
VALUES (8011, '99', (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1011))


INSERT INTO mydb.ActivityTrackerS3 (S3ActivityID, TotalActiveTime, Bucket_BucketID)
VALUES (8012, '509', (SELECT BucketID FROM mydb.Bucket WHERE BucketID = 1012))

DELETE FROM mydb.ActivityTrackerS3 WHERE S3ActivityID IS NOT NULL

---DATA INSERTION ActivityTrackerDB

INSERT INTO mydb.ActivityTrackerDb (DbActivityID, TotalActiveTime, Db_DbID)
VALUES (7001, '643' , (SELECT DbID FROM mydb.Db WHERE DbID = 2001) )


INSERT INTO mydb.ActivityTrackerDb (DbActivityID, TotalActiveTime, Db_DbID)
VALUES (7002, '566' , (SELECT DbID FROM mydb.Db WHERE DbID = 2002) )


INSERT INTO mydb.ActivityTrackerDb (DbActivityID, TotalActiveTime, Db_DbID)
VALUES (7003, '200' , (SELECT DbID FROM mydb.Db WHERE DbID = 2003) )


INSERT INTO mydb.ActivityTrackerDb (DbActivityID, TotalActiveTime, Db_DbID)
VALUES (7004, '340' , (SELECT DbID FROM mydb.Db WHERE DbID = 2004) )


INSERT INTO mydb.ActivityTrackerDb (DbActivityID, TotalActiveTime, Db_DbID)
VALUES (7005, '90' , (SELECT DbID FROM mydb.Db WHERE DbID = 2005) )

INSERT INTO mydb.ActivityTrackerDb (DbActivityID, TotalActiveTime, Db_DbID)
VALUES (7006, '355' , (SELECT DbID FROM mydb.Db WHERE DbID = 2006) )


INSERT INTO mydb.ActivityTrackerDb (DbActivityID, TotalActiveTime, Db_DbID)
VALUES (7007, '234' , (SELECT DbID FROM mydb.Db WHERE DbID = 2007) )


INSERT INTO mydb.ActivityTrackerDb (DbActivityID, TotalActiveTime, Db_DbID)
VALUES (7008, '222' , (SELECT DbID FROM mydb.Db WHERE DbID = 2008) )


INSERT INTO mydb.ActivityTrackerDb (DbActivityID, TotalActiveTime, Db_DbID)
VALUES (7009, '500' , (SELECT DbID FROM mydb.Db WHERE DbID = 2009) )


INSERT INTO mydb.ActivityTrackerDb (DbActivityID, TotalActiveTime, Db_DbID)
VALUES (7010, '678' , (SELECT DbID FROM mydb.Db WHERE DbID = 2010) )



INSERT INTO mydb.ActivityTrackerDb (DbActivityID, TotalActiveTime, Db_DbID)
VALUES (7011, '126' , (SELECT DbID FROM mydb.Db WHERE DbID = 2011) )



INSERT INTO mydb.ActivityTrackerDb (DbActivityID, TotalActiveTime, Db_DbID)
VALUES (7012, '444' , (SELECT DbID FROM mydb.Db WHERE DbID = 2012) )



----DATA INSERTION TOTAL SALES


INSERT INTO mydb.TotalSales (SaleID, TotalBillAmount, ActivityTrackerDb_DbActivityID, ActivityTrackerS3_S3ActivityID, 
ActivityTrackerEC2_EC2ActivityID)
VALUES (55501, 346 ,  (SELECT DbActivityID FROM mydb.ActivityTrackerDb WHERE DbActivityID = 7001),
(SELECT S3ActivityID FROM mydb.ActivityTrackerS3 WHERE S3ActivityID = 8001),
(SELECT EC2ActivityID FROM mydb.ActivityTrackerEC2 WHERE EC2ActivityID = 900819))



INSERT INTO mydb.TotalSales (SaleID, TotalBillAmount, ActivityTrackerDb_DbActivityID, ActivityTrackerS3_S3ActivityID, 
ActivityTrackerEC2_EC2ActivityID)
VALUES (55502, 219 ,  (SELECT DbActivityID FROM mydb.ActivityTrackerDb WHERE DbActivityID = 7002),
(SELECT S3ActivityID FROM mydb.ActivityTrackerS3 WHERE S3ActivityID = 8002),
(SELECT EC2ActivityID FROM mydb.ActivityTrackerEC2 WHERE EC2ActivityID = 900820))


INSERT INTO mydb.TotalSales (SaleID, TotalBillAmount, ActivityTrackerDb_DbActivityID, ActivityTrackerS3_S3ActivityID, 
ActivityTrackerEC2_EC2ActivityID)
VALUES (55503, 156 ,  (SELECT DbActivityID FROM mydb.ActivityTrackerDb WHERE DbActivityID = 7003),
(SELECT S3ActivityID FROM mydb.ActivityTrackerS3 WHERE S3ActivityID = 8003),
(SELECT EC2ActivityID FROM mydb.ActivityTrackerEC2 WHERE EC2ActivityID = 900821))



INSERT INTO mydb.TotalSales (SaleID, TotalBillAmount, ActivityTrackerDb_DbActivityID, ActivityTrackerS3_S3ActivityID, 
ActivityTrackerEC2_EC2ActivityID)
VALUES (55504, 178 ,  (SELECT DbActivityID FROM mydb.ActivityTrackerDb WHERE DbActivityID = 7004),
(SELECT S3ActivityID FROM mydb.ActivityTrackerS3 WHERE S3ActivityID = 8004),
(SELECT EC2ActivityID FROM mydb.ActivityTrackerEC2 WHERE EC2ActivityID = 900822))


INSERT INTO mydb.TotalSales (SaleID, TotalBillAmount, ActivityTrackerDb_DbActivityID, ActivityTrackerS3_S3ActivityID, 
ActivityTrackerEC2_EC2ActivityID)
VALUES (55505, 190 ,  (SELECT DbActivityID FROM mydb.ActivityTrackerDb WHERE DbActivityID = 7005),
(SELECT S3ActivityID FROM mydb.ActivityTrackerS3 WHERE S3ActivityID = 8005),
(SELECT EC2ActivityID FROM mydb.ActivityTrackerEC2 WHERE EC2ActivityID = 900823))


INSERT INTO mydb.TotalSales (SaleID, TotalBillAmount, ActivityTrackerDb_DbActivityID, ActivityTrackerS3_S3ActivityID, 
ActivityTrackerEC2_EC2ActivityID)
VALUES (55506, 211 ,  (SELECT DbActivityID FROM mydb.ActivityTrackerDb WHERE DbActivityID = 7006),
(SELECT S3ActivityID FROM mydb.ActivityTrackerS3 WHERE S3ActivityID = 8006),
(SELECT EC2ActivityID FROM mydb.ActivityTrackerEC2 WHERE EC2ActivityID = 900824))


INSERT INTO mydb.TotalSales (SaleID, TotalBillAmount, ActivityTrackerDb_DbActivityID, ActivityTrackerS3_S3ActivityID, 
ActivityTrackerEC2_EC2ActivityID)
VALUES (55507, 127 ,  (SELECT DbActivityID FROM mydb.ActivityTrackerDb WHERE DbActivityID = 7007),
(SELECT S3ActivityID FROM mydb.ActivityTrackerS3 WHERE S3ActivityID = 8007),
(SELECT EC2ActivityID FROM mydb.ActivityTrackerEC2 WHERE EC2ActivityID = 900825))


INSERT INTO mydb.TotalSales (SaleID, TotalBillAmount, ActivityTrackerDb_DbActivityID, ActivityTrackerS3_S3ActivityID, 
ActivityTrackerEC2_EC2ActivityID)
VALUES (55508, 213 ,  (SELECT DbActivityID FROM mydb.ActivityTrackerDb WHERE DbActivityID = 7008),
(SELECT S3ActivityID FROM mydb.ActivityTrackerS3 WHERE S3ActivityID = 8008),
(SELECT EC2ActivityID FROM mydb.ActivityTrackerEC2 WHERE EC2ActivityID = 900826))



INSERT INTO mydb.TotalSales (SaleID, TotalBillAmount, ActivityTrackerDb_DbActivityID, ActivityTrackerS3_S3ActivityID, 
ActivityTrackerEC2_EC2ActivityID)
VALUES (55509, 112 ,  (SELECT DbActivityID FROM mydb.ActivityTrackerDb WHERE DbActivityID = 7009),
(SELECT S3ActivityID FROM mydb.ActivityTrackerS3 WHERE S3ActivityID = 8009),
(SELECT EC2ActivityID FROM mydb.ActivityTrackerEC2 WHERE EC2ActivityID = 900827))



INSERT INTO mydb.TotalSales (SaleID, TotalBillAmount, ActivityTrackerDb_DbActivityID, ActivityTrackerS3_S3ActivityID, 
ActivityTrackerEC2_EC2ActivityID)
VALUES (55510, 244 ,  (SELECT DbActivityID FROM mydb.ActivityTrackerDb WHERE DbActivityID = 7010),
(SELECT S3ActivityID FROM mydb.ActivityTrackerS3 WHERE S3ActivityID = 8010),
(SELECT EC2ActivityID FROM mydb.ActivityTrackerEC2 WHERE EC2ActivityID = 900828))



INSERT INTO mydb.TotalSales (SaleID, TotalBillAmount, ActivityTrackerDb_DbActivityID, ActivityTrackerS3_S3ActivityID, 
ActivityTrackerEC2_EC2ActivityID)
VALUES (55511, 300 ,  (SELECT DbActivityID FROM mydb.ActivityTrackerDb WHERE DbActivityID = 7011),
(SELECT S3ActivityID FROM mydb.ActivityTrackerS3 WHERE S3ActivityID = 8011),
(SELECT EC2ActivityID FROM mydb.ActivityTrackerEC2 WHERE EC2ActivityID = 900829))



INSERT INTO mydb.TotalSales (SaleID, TotalBillAmount, ActivityTrackerDb_DbActivityID, ActivityTrackerS3_S3ActivityID, 
ActivityTrackerEC2_EC2ActivityID)
VALUES (55512, 201 ,  (SELECT DbActivityID FROM mydb.ActivityTrackerDb WHERE DbActivityID = 7012),
(SELECT S3ActivityID FROM mydb.ActivityTrackerS3 WHERE S3ActivityID = 8012),
(SELECT EC2ActivityID FROM mydb.ActivityTrackerEC2 WHERE EC2ActivityID = 900830))



----Check constraint for Valid Card Number

CREATE FUNCTION fn_isValidCard(@CardNumber VARCHAR(50))
RETURNS INT
BEGIN
RETURN IIF(LEN (TRIM((@CardNumber) <=  20, 1, 0)
END

GO

drop function fn_isValidCard;
ALTER TABLE mydb.CardInfo
ADD CONSTRAINT CheckCardNo CHECK (dbo.fn_isValidCard(CardNo) = 1)

select * from mydb.CardInfo
alter table  mydb.CardInfo drop Constraint CheckCardNo



---------Constraint for card expired year < current year

CREATE FUNCTION fn_is_not_expired(@exp_year int)
RETURNS INT
BEGIN
RETURN IIF((@exp_year) >=  cast((YEAR(CURRENT_TIMESTAMP) ) as int ), 1, 0)
END


ALTER TABLE mydb.CardInfo
ADD CONSTRAINT CheckCardNo CHECK (dbo.fn_is_not_expired(ExpiryYear) = 1)

GO
drop function fn_is_not_expired;



----DATA INSERTION billing

INSERT INTO mydb.Billing (BillingID, TotalSales_SaleID)
VALUES (0101, (SELECT SaleID FROM mydb.TotalSales WHERE SaleID = 55501))

INSERT INTO mydb.Billing (BillingID, TotalSales_SaleID)
VALUES (0102, (SELECT SaleID FROM mydb.TotalSales WHERE SaleID = 55502))

INSERT INTO mydb.Billing (BillingID, TotalSales_SaleID)
VALUES (0103, (SELECT SaleID FROM mydb.TotalSales WHERE SaleID = 55503))


INSERT INTO mydb.Billing (BillingID, TotalSales_SaleID)
VALUES (0104, (SELECT SaleID FROM mydb.TotalSales WHERE SaleID = 55504))


INSERT INTO mydb.Billing (BillingID, TotalSales_SaleID)
VALUES (0105, (SELECT SaleID FROM mydb.TotalSales WHERE SaleID = 55505))


INSERT INTO mydb.Billing (BillingID, TotalSales_SaleID)
VALUES (0106, (SELECT SaleID FROM mydb.TotalSales WHERE SaleID = 55506))


INSERT INTO mydb.Billing (BillingID, TotalSales_SaleID)
VALUES (0107, (SELECT SaleID FROM mydb.TotalSales WHERE SaleID = 55507))


INSERT INTO mydb.Billing (BillingID, TotalSales_SaleID)
VALUES (0108, (SELECT SaleID FROM mydb.TotalSales WHERE SaleID = 55508))



INSERT INTO mydb.Billing (BillingID, TotalSales_SaleID)
VALUES (0109, (SELECT SaleID FROM mydb.TotalSales WHERE SaleID = 55509))



INSERT INTO mydb.Billing (BillingID, TotalSales_SaleID)
VALUES (0110, (SELECT SaleID FROM mydb.TotalSales WHERE SaleID = 55510))



INSERT INTO mydb.Billing (BillingID, TotalSales_SaleID)
VALUES (0111, (SELECT SaleID FROM mydb.TotalSales WHERE SaleID = 55511))


INSERT INTO mydb.Billing (BillingID, TotalSales_SaleID)
VALUES (0112, (SELECT SaleID FROM mydb.TotalSales WHERE SaleID = 55512))




--Views

--VIEW FOR RDS USAGE

CREATE VIEW rdsusage AS
SELECT u.UserID, 
	   u.FirstName, u.LastName, 
	   db.CreateDate, db.TerminationDate, 
	   DATEDIFF(DAY, db.CreateDate, db.TerminationDate) AS [TotalUsasge in Days]
FROM P5_GROUP4.mydb.UserInfo u
INNER JOIN P5_GROUP4.mydb.Db db
ON u.UserID = db.UserInfo_UserID
GROUP BY u.UserID, u.FirstName, u.LastName, db.CreateDate, db.TerminationDate



--VIEW FOR S3 USAGE

CREATE VIEW S3usage AS
SELECT u.UserID, 
	   u.FirstName, u.LastName, 
	   s.CreateDate, s.TerminationDate, 
	   DATEDIFF(DAY, s.CreateDate, s.TerminationDate) AS [TotalUsasge in Days]
FROM P5_GROUP4.mydb.UserInfo u
INNER JOIN P5_GROUP4.mydb.Object s
ON u.UserID = s.UserInfo_UserID

GROUP BY u.UserID, u.FirstName, u.LastName, s.CreateDate, s.TerminationDate




--VIEW FOR EC2 USAGE


CREATE VIEW EC2usage AS
SELECT u.UserID, 
	   u.FirstName, u.LastName, 
	   e.CreateDate, e.TerminationDate, 
	   DATEDIFF(DAY, e.CreateDate, e.TerminationDate) AS [TotalUsasge in Days]
FROM P5_GROUP4.mydb.UserInfo u
INNER JOIN P5_GROUP4.mydb.EC2 e
ON u.UserID = e.UserInfo_UserID

GROUP BY u.UserID, u.FirstName, u.LastName, e.CreateDate, e.TerminationDate



--- views to see the count of ec2, db and  s3 objects for each user

CREATE VIEW TotalUSe AS
SELECT u.UserID, COUNT(ec2.InstanceID) AS InstanceCnt, COUNT(o.ObjectID) AS ObjectCnt, COUNT(db.DbID) AS DbCnt
FROM P5_GROUP4.mydb.UserInfo u
INNER JOIN P5_GROUP4.mydb.Db db
ON u.UserID = db.UserInfo_UserID
INNER JOIN P5_GROUP4.mydb.Object o
ON u.UserID = o.UserInfo_UserID
INNER JOIN P5_GROUP4.mydb.EC2 ec2
ON u.UserID =ec2.UserInfo_UserID
GROUP BY u.UserID, ec2.InstanceID, o.ObjectID, db.DbID

SELECT * FROM dbo.TotalUSe



-----------------view to summarize all resource of a particular person  i.e bucket, rds, ec2


Create view  mydb.AWSServices as 
select u.UserID, u.FirstName , u.LastName, u.Mobile,u.City,ecc.InstanceType as EC2,dbc.DbClassType as RDS,b.BucketName as S3
from mydb.UserInfo u 
JOIN mydb.EC2 ec
ON u.UserID = ec.UserInfo_UserID
JOIN mydb.EC2Class ecc 
ON ec.EC2Class_InstanceType = ecc.InstanceType
JOIN mydb.Db d
ON d.UserInfo_UserID = u.UserID
JOIN mydb.DbClass dbc
ON d.DbClass_DbClassType =dbc.DbClassType
JOIN mydb.Object o
ON o.UserInfo_UserID= u.UserID
JOIN mydb.Bucket b
ON b.BucketID = o.Bucket_BucketID;

SELECT * FROM mydb.AWSServices



---COMMANDS TO EXECUTE VIEWS
SELECT * FROM P5_GROUP4.dbo.rdsusage rds

SELECT * FROM P5_GROUP4.dbo.S3usage s3

SELECT * FROM P5_GROUP4.dbo.EC2usage ec2






-----FUNCTIONS 

---Total Time for EC2

CREATE Function TotalTime(@totald INT)
returns INT
as
	begin
		declare @total INT = 
			(Select TotalActiveTime
			from mydb.ActivityTrackerEC2 e
			join mydb.totalsales s
			on e.EC2ActivityID = s.ActivityTrackerEC2_EC2ActivityID
			where e.TotalActiveTime= @totald);
		set @total = isnull (@total, 0);		
		return @total;
end


---Total Time for S3

  
CREATE Function TotalTime2(@totald2 INT)
returns INT
as
	begin
		declare @total INT = 
			(Select TotalActiveTime
			from mydb.ActivityTrackerS3 p
			join mydb.totalsales s
			on p.S3ActivityID = s.ActivityTrackerS3_S3ActivityID
			where p.TotalActiveTime= @totald2);
		set @total = isnull (@total, 0);		
		return @total;
end
  

---Total Time for Db

CREATE Function TotalTime3(@totald3 INT)
returns INT
as
	begin
		declare @total INT = 
			(Select TotalActiveTime
			from mydb.ActivityTrackerDb d
			join mydb.totalsales s
			on d.DbActivityID = s.ActivityTrackerDb_DbActivityID
			where d.TotalActiveTime= @totald3);
		set @total = isnull (@total, 0);		
		return @total;
end



------COMPUTE TAX FOR TOTAL BILL AMOUNT
select * from mydb.TotalSales


CREATE function fn_calculate_tax (@total_amount decimal)
RETURNs int 
AS
BEGIN
DECLARE @tax_amount int = cast (round(0.12 * @total_amount , 2) as int)

RETURN @tax_amount;
END

alter table mydb.TotalSales add tax as (dbo.fn_calculate_tax(TotalBillAmount))

select * from mydb.TotalSales
alter table  mydb.TotalSales drop column tax
drop function fn_calculate_tax;	



------------ COMPUTE FINAL PRICE --> FINAL PRICE = TOTALBILLAMOUNT + 12% TAX


select * from mydb.Billing


CREATE FUNCTION fn_total(@saleid INT)
RETURNS INT
AS
  BEGIN
      RETURN
        (SELECT cast((TotalBillAmount * 0.12) +TotalBillAmount as int)
         FROM   mydb.TotalSales
         WHERE  SaleID = @saleid)
  END 


alter table mydb.Billing add FinalPrice as (dbo.fn_total(TotalSales_SaleID))


select * from mydb.Billing
alter table  mydb.Billing drop column FinalPrice
drop function fn_total;


-----Data Insertion Transactions-


INSERT INTO mydb.Transactions (TransactionID, DueDate, PaymentStatus, paid_at_date, Billing_BillingID, CardInfo_CardID) 
VALUES (20021, '01/23/2020', 'Paid', '01/19/2020',(SELECT BillingID FROM mydb.Billing WHERE BillingID = 101), (SELECT CardID FROM mydb.CardInfo WHERE CardID = 709029408))

INSERT INTO mydb.Transactions (TransactionID, DueDate, PaymentStatus, paid_at_date, Billing_BillingID, CardInfo_CardID) 
VALUES (20022, '01/23/2020', 'Unpaid', '',(SELECT BillingID FROM mydb.Billing WHERE BillingID = 102), (SELECT CardID FROM mydb.CardInfo WHERE CardID = 712991808))

INSERT INTO mydb.Transactions (TransactionID, DueDate, PaymentStatus, paid_at_date, Billing_BillingID, CardInfo_CardID) 
VALUES (20023, '05/07/2020', 'Paid', '11/19/2020',(SELECT BillingID FROM mydb.Billing WHERE BillingID = 103), (SELECT CardID FROM mydb.CardInfo WHERE CardID = 788658483 ))


INSERT INTO mydb.Transactions (TransactionID, DueDate, PaymentStatus, paid_at_date, Billing_BillingID, CardInfo_CardID) 
VALUES (20024, '02/02/2020', 'Paid', '02/19/2020',(SELECT BillingID FROM mydb.Billing WHERE BillingID = 104), (SELECT CardID FROM mydb.CardInfo WHERE CardID = 787937058  ))


INSERT INTO mydb.Transactions (TransactionID, DueDate, PaymentStatus, paid_at_date, Billing_BillingID, CardInfo_CardID) 
VALUES (20025, '06/01/2020', 'UnPaid', '',(SELECT BillingID FROM mydb.Billing WHERE BillingID = 105), (SELECT CardID FROM mydb.CardInfo WHERE CardID = 715318008  ))


INSERT INTO mydb.Transactions (TransactionID, DueDate, PaymentStatus, paid_at_date, Billing_BillingID, CardInfo_CardID) 
VALUES (20026, '01/23/2020', 'Paid', '01/19/2020',(SELECT BillingID FROM mydb.Billing WHERE BillingID = 106), (SELECT CardID FROM mydb.CardInfo WHERE CardID = 713962233  ))



INSERT INTO mydb.Transactions (TransactionID, DueDate, PaymentStatus, paid_at_date, Billing_BillingID, CardInfo_CardID) 
VALUES (20027, '08/15/2020', 'Paid', '08/21/2020',(SELECT BillingID FROM mydb.Billing WHERE BillingID = 107), (SELECT CardID FROM mydb.CardInfo WHERE CardID = 785432733  ))


INSERT INTO mydb.Transactions (TransactionID, DueDate, PaymentStatus, paid_at_date, Billing_BillingID, CardInfo_CardID) 
VALUES (20028, '01/23/2021', 'UnPaid', '',(SELECT BillingID FROM mydb.Billing WHERE BillingID = 108), (SELECT CardID FROM mydb.CardInfo WHERE CardID = 715190283 ))


INSERT INTO mydb.Transactions (TransactionID, DueDate, PaymentStatus, paid_at_date, Billing_BillingID, CardInfo_CardID) 
VALUES (20029, '05/22/2020', 'Paid', '06/23/2020',(SELECT BillingID FROM mydb.Billing WHERE BillingID = 109), (SELECT CardID FROM mydb.CardInfo WHERE CardID = 827111283 ))

INSERT INTO mydb.Transactions (TransactionID, DueDate, PaymentStatus, paid_at_date, Billing_BillingID, CardInfo_CardID) 
VALUES (20030, '12/30/2020', 'UnPaid', '',(SELECT BillingID FROM mydb.Billing WHERE BillingID = 110), (SELECT CardID FROM mydb.CardInfo WHERE CardID = 799723908  ))

INSERT INTO mydb.Transactions (TransactionID, DueDate, PaymentStatus, paid_at_date, Billing_BillingID, CardInfo_CardID) 
VALUES (20031, '01/23/2020', 'Paid', '01/19/2020',(SELECT BillingID FROM mydb.Billing WHERE BillingID = 111), (SELECT CardID FROM mydb.CardInfo WHERE CardID = 807986133  ))

INSERT INTO mydb.Transactions (TransactionID, DueDate, PaymentStatus, paid_at_date, Billing_BillingID, CardInfo_CardID) 
VALUES (20032, '11/03/2020', 'Paid', '12/19/2020',(SELECT BillingID FROM mydb.Billing WHERE BillingID = 112), (SELECT CardID FROM mydb.CardInfo WHERE CardID = 789973308  ))



------------------------- extra work ----------------


-- trigger to set the termination date = current date as soon as ec2 is terminated


CREATE TRIGGER terminated_status ON mydb.EC2
AFTER UPDATE 
AS
  UPDATE f 
  set TerminationDate = CONVERT(date, GETDATE())
  --set status ='terminated';
  FROM 
   mydb.EC2 AS f 
  INNER JOIN inserted 
  AS i 
  ON f.InstanceID = i.InstanceID and f.Status='terminated';

  ------ to run the trigger 
update mydb.EC2 
set Status ='terminated'
WHERE InstanceID = 'i-012-zzy'
-- this will set the termination date
 
select * from mydb.EC2


------ trigger to set the status of ec2 as "running" as soon as a data is entered --> insert data without status column --> will be filled by trigger

CREATE TRIGGER terminated_date_insert ON mydb.EC2 
AFTER INSERT 
AS
  UPDATE mydb.EC2 
  SET Status = 'Running'
  FROM Inserted i where mydb.EC2.TerminationDate is NULL


  ---- to run the trigger ---
INSERT INTO mydb.EC2 (InstanceID, MemoryDisk, CreateDate, UserInfo_UserID, Region_RegionID, Ami_AmiID, EC2Class_InstanceType)
VALUES ('i-012-y3y', 900 , '06/21/2020', 
(SELECT UserID FROM mydb.UserInfo WHERE UserID = 111038), (SELECT RegionID FROM mydb.Region WHERE RegionID = 001), 
(SELECT AmiID FROM mydb.Ami WHERE AmiID = 25612),(SELECT InstanceType FROM mydb.EC2Class WHERE InstanceType = 'm4.large'))
