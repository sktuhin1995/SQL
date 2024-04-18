Create Database Dengue_DiseaseDB
On Primary
(
	Name = Dengue_DiseaseDB_Data_1,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Dengue_DiseaseDB_Data_1.mdf',
	Size = 25MB,
	MaxSize = 100MB,
	FileGrowth = 5%
)
Log on
(
	Name = Dengue_DiseaseDB_Log_1,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Dengue_DiseaseDB_Data_1.ldf',
	Size = 2MB,
	MaxSize = 25MB,
	FileGrowth = 1%
);

Use Dengue_DiseaseDB

Create Table Doctors_Info
(
	DoctorId Int Primary Key,
	DoctorName Varchar(50),
	EducationalQualification Varchar(50),
	HospitalName Varchar (50)
);

Create Table TypeOfDengue
(
	DengueId Int Primary key,
	DenguesType Varchar(50)
);

Create Table Patients_Info
(
	PatientID int Primary key,
	PatientName varchar(50),
	Age Int,
	Gender Varchar(10),
	Mail Varchar(50),
	DengueId int References TypeOfDengue(DengueId)
);

Create Table CountOfPlatelets
(
	CountNo Int Primary key,
	Platelets Int
);

Create Table Treatment_Info
(
	SLNo int,
	[Date] Date,
	DoctorId int References Doctors_Info(DoctorId),
	PatientID int References Patients_Info(PatientID),
	CountNo int References CountOfPlatelets(CountNo)
);

--Insert--
Insert Into Treatment_Info(SLNo, [Date], DoctorId, PatientID, CountNo)
Values(11, '2023/09/11', 1, 3, 4);

--Delete--
Delete from Treatment_Info
where SLNo = 11;

Insert into  TypeOfDengue(DengueId, DenguesType) 
values(5,null),(6,null),(7,null);

Create Table Tableone 
(
	Tableonecolumnone int primary key,
	Tableonecolumntwo varchar(50)
);

Create table Tabletwo
(
	Tabletwocolumnone int primary key,
	Tabletwocolumntwo varchar(50)
);

--Add Column--
Alter table tableone
Add tableonecolumnthree int;

--Drop Column--
Alter table tabletwo
Drop column tabletwocolumntwo;

--Merge into--
Merge into Tabletwo
Using Tableone 
On Tabletwo.tabletwocolumnone = Tableone.Tableonecolumnone
When matched then
Update set Tabletwo.Tabletwocolumnone = Tableone.Tableonecolumnone
When not matched then
Insert (Tabletwocolumnone) values(Tableone.Tableonecolumnone);

--View--
Create View VW_TypeOfDengue
As
Select * from TypeOfDengue
Where DengueId = 2;

--Test--
Select * From VW_TypeOfDengue

--View with Encryption--
Create View VW_Encrp
With Encryption
As
Select * from TypeOfDengue
Group by DengueId, DenguesType
having DenguesType = 'DENV-4';

--Test--
Select * From VW_Encrp

--View with Schemabinding--
Create View Vw_Sch
With Schemabinding
As
Select DengueId, DenguesType
From Dbo.TypeOfDengue
Where DenguesType = 'DENV-2';

--Test--
Select * From Vw_Sch

--Case--
Select DengueId, DenguesType, Case
When DenguesType= 'DENV-1' Then 'Bad'
When DenguesType= 'DENV-2' Then 'Worse'
Else 'Worst'
End as NewColumn
From TypeOfDengue;

--Table Function--
Create Function FN_TypeOfDengue
()
Returns Table
Return
(
	Select * From TypeOfDengue
	Group by DengueId, DenguesType
	Having DenguesType = 'DENV-1'
);

--Test--
Select * From dbo.TypeOfDengue

--Scalar Function--
Create Function FN__Sca_CountOfPlatelets
()
Returns int
Begin
Declare @T Int;
Select @T = Count(*) From CountOfPlatelets;
Return @T;
End;

--Test--
Select dbo.FN__Sca_CountOfPlatelets()

--Multi statement function--
Create Function FN_CountOfPlatelets
()
Returns @table Table
(
	CountNo Int,
	Platelets money,
	Platelets_Extent Money
)
Begin
Insert Into @table(CountNo, Platelets, Platelets_Extent)
Select CountNo, Platelets, Platelets_Extent = Platelets + 10000
from CountOfPlatelets
Return
End;

--Test--
Select * From dbo.FN_CountOfPlatelets()

--Stored Procedure SELECT, INSERT, UPDATE, DELETE--
Select * Into TypeOfDengue_Copy
From TypeOfDengue

Create Procedure SP_TypeOfDengue_Copy
(
	@DengueId Int,
	@DenguesType Varchar(50),
	@StatementType Varchar(50) = ''
)
As
If @StatementType = 'Select'
Begin 
Select * From TypeOfDengue_Copy
Where DenguesType = 'DENV-1'
End

If @StatementType = 'Insert'
Begin 
Insert Into TypeOfDengue_Copy(DengueId, DenguesType)
Values(@DengueId, @DenguesType)
End

If @StatementType = 'Update'
Begin
Update TypeOfDengue_Copy Set DenguesType = @DenguesType
Where DengueId = @DengueId
End;

If @StatementType = 'Delete'
Begin
Delete TypeOfDengue_Copy 
Where DengueId = @DengueId
End;
--Test--
Execute SP_TypeOfDengue_Copy 5, 'DENV-5', 'Insert'
Execute SP_TypeOfDengue_Copy 5 , 'DENV-5', 'Update'
Execute SP_TypeOfDengue_Copy 5 , 'DENV-5', 'Delete'

-- PROCEDURE IN PARAMETER--
Create Procedure SP_In
(
	@DengueId Int,
	@DenguesType Varchar(50)
)
As
Insert Into TypeOfDengue_Copy(DengueId, DenguesType)
Values(@DengueId, @DenguesType)
--Test--
Exec SP_TypeOfDengue_Copy 4, 'DENV-4'

--Out--
Create Procedure SP_Out
(
	@DengueId Int Output
)
As
Select Count(*) From TypeOfDengue_Copy
--Test--
Execute SP_Out 5

-- PROCEDURE WITH RETURN STATEMENT--
Create Procedure SP_Return
(
	@DengueId Int
)
As
Select DengueId, DenguesType
From TypeOfDengue_Copy
Where DengueId = @DengueId
--Test--
Declare @Return_Vaue Int
Execute @Return_Vaue = SP_Return @DengueId = 4
Select 'Return Value' = @Return_Vaue;

--After Trigger--
Create table BackTypeOfDengue
(
	DengueId int primary key,
	DenguesType varchar(50)
);

Create Trigger Tr_After
On TypeOfDengue_Copy
After Insert, Update
As
Insert Into BackTypeOfDengue(DengueId, DenguesType)
Select Inserted.DengueId, Inserted.DenguesType From Inserted;

--Test--
Insert into TypeOfDengue_Copy(DengueId,DenguesType)values(4, 'DENV-4')

select * from TypeOfDengue_Copy
select * from BackTypeOfDengue

--Instead Trigger--
Create Table DengueLog
(
	LogId Int Identity(1,1),
	DengueId int,
	ActionLog Varchar(50)
);
Drop Trigger TR_Dengue
Create Trigger TR_Dengue
On TypeOfDengue_Copy
Instead Of Delete
As
Begin
		Declare @DengueId Int
		Select @DengueId = Deleted.DengueId
		From Deleted
		If @DengueId = 3
		Begin
				Raiserror('ID 3 record can not be Deleted', 16, 1)
				Rollback
				Insert Into DengueLog
				Values(@DengueId, 'record can not be Deleted.')
		End
		Else
		Begin
				Delete TypeOfDengue_Copy
				Where DengueId = @DengueId
				Insert Into DengueLog
				Values(@DengueId, 'record can not be Deleted.')
		End
End

Delete TypeOfDengue_Copy
Where DengueId = 3
Select * From DengueLog
Select * From TypeOfDengue_Copy