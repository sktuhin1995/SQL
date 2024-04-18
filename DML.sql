Use Dengue_DiseaseDB

Insert Into Doctors_Info(DoctorId, DoctorName,  EducationalQualification, HospitalName)
Values(1, 'Dr. Dewan Almina Mishu', 'MBBS', 'Mohakhali DNCC hospital'), 
      (2, 'Dr. Tanvir Abir',  'MBBS', 'Dhaka Medical College'),
      (3, 'Dr. Nazmul Ahsan Kalimullah', 'FCPS (Internal Medicine)', 'Ibn Sina Hospitals'), 
	  (4, 'Dr. Kalimullah',  'MBBS', 'Samorita Hospital Ltd'),
	  (5, 'Dr. Abdullah Al Mamun', 'MBBS', 'Popular Specialized Hospital Ltd'), 
	  (6, 'Dr.  Shamim Hyder Talukder',  'FCPS(Infectious Diseases & Tropical Medicine)', 'Square Hospital');

Insert Into TypeOfDengue(DengueId, DenguesType)
Values(1, 'DENV-1'), (2, 'DENV-2'), (3, 'DENV-3'), (4, 'DENV-4');

Insert Into Patients_Info(PatientID, PatientName, Age, Gender, Mail, DengueId)
Values(1, 'Nazrul Islam', 50, 'Male', 'nazrulislam@gmail.com', 1), 
	  (2, 'Sheikh Shahin', 28, 'Male', 'sheikhshahin@gmail.com', 3),
      (3, 'Imrul Hossan', 28, 'Male', 'imrulhossan@gmail.com', 2), 
	  (4, 'Imrul Hossan', 20, 'Male', 'imrulhossan@gmail.com', 2),
	  (5, 'Reksho Akter', 40, 'Feale', 'rekshoakter@gmail.com', 1), 
	  (6, 'Sonali Begum', 35, 'Feale', 'Sonalibegum@gmail.com', 4),
	  (7, 'Toyeb Ali', 33, 'Male', 'toyebali@gmail.com', 3), 
	  (8, 'Sujon Mahmud', 37, 'Male', 'sujonmahmud@gmail.com', 1),
	  (9, 'Nayem Hossan', 27, 'Male', 'nayemhossan@gmail.com', 1), 
	  (10, 'MD Al-Amin', 50, 'Male', 'mdalamin@gmail.com', 2);

Insert Into CountOfPlatelets(CountNo, Platelets)
Values(1,  100000), (2, 80000), (3, 60000), (4, 40000), (5,  20000);

Insert Into Treatment_Info(SLNo, [Date], DoctorId, PatientID, CountNo)
Values(1, '2023/09/01', 1, 1, 1), (2, '2023/09/02', 2, 3, 5), 
      (3, '2023/09/03', 4, 5, 1), (4, '2023/09/04', 5, 4, 4), 
	  (5, '2023/09/05', 3, 2, 3), (6, '2023/09/06', 2, 8, 2), 
	  (7, '2023/09/07', 3, 10, 5), (8, '2023/09/08', 5, 7, 3), 
	  (9, '2023/09/09', 4, 6, 4), (10, '2023/09/10', 1, 9, 1);

--------------------------------------------------------------------------------------------------------------
--Join Query--
Select Treatment_Info.SLNo, Treatment_Info.[Date], Patients_Info.PatientID, Patients_Info.PatientName
From Treatment_Info 
Join Patients_Info on Treatment_Info.PatientID = Patients_Info.PatientID
Join TypeOfDengue on Patients_Info.DengueId = TypeOfDengue.DengueId
Where DenguesType = 'DENV-3';

--Subquery--
Select CountNo, Platelets
from CountOfPlatelets 
Where Platelets <
(select Avg(Platelets) From CountOfPlatelets)
Order by CountNo;

--Offset Fetch--
Select * from CountOfPlatelets 
Where Platelets Between 20000 And 80000
Order by CountNo desc
Offset 0 rows
fetch first 2 rows only;

--Grater Then--
Select * from CountOfPlatelets 
Where  Platelets > 60000;

--Between--
Select * from CountOfPlatelets 
Where Platelets 
Between 40000 And 80000;

--Like--
Select * from Doctors_Info 
Where EducationalQualification like 'MB%';

--Like--
Select * From Doctors_Info 
where DoctorName Like '%[A,E,I,O,U]%';

--In--
Select * From Doctors_Info 
where EducationalQualification Like 'MBB[A-Z]';

--Not In--
Select * From Doctors_Info 
where EducationalQualification Like 'MBB[^A-Z]';

--Through--
Select * from Patients_Info
Order By PatientID
Offset 3 rows
Fetch first 5 rows only;

--Average--
Select CountNo, Avg(Platelets) as "Avg Of Platelets"
From CountOfPlatelets 
Group by CountNo Having Avg(Platelets) > 40000
Order By CountNo;

--With cube Operator--
Select PatientID, PatientName,  Count(*) As "QtyPatient"
From Patients_Info Where Gender In ('Male')
Group by PatientID, PatientName with cube
Order by  PatientID desc;

--With rollup Operator--
Select PatientID, PatientName,  Count(*) As "QtyPatient"
From Patients_Info Where Gender In ('Male')
Group by PatientID, PatientName  with rollup
Order by  PatientID desc;

--Grouping Sets Operator--
Select PatientName, Gender, Count(*) As "QtyVendor"
From Patients_Info Where Gender In ('Male')
Group by Grouping Sets (PatientName, Gender) 
Order by  PatientName;

--Over Clause--
Select CountNo, Platelets,
Sum(Platelets) over(Partition by CountNo) As "DataSum",
Count(Platelets) over(Partition by CountNo) As "DataCount",
Avg(Platelets) over(Partition by CountNo) As "DataAvg"
from CountOfPlatelets 
order by CountNo desc;

--Any Keyword--
Select PatientID, PatientName, Mail
from Patients_Info join TypeOfDengue on Patients_Info.DengueId = TypeOfDengue.DengueId
Where DenguesType >
Any (Select DenguesType from TypeOfDengue Where DengueId = 2);

--All Keyword--
Select PatientID, PatientName, Mail
from Patients_Info join TypeOfDengue on Patients_Info.DengueId = TypeOfDengue.DengueId
Where DenguesType <
All (Select DenguesType from TypeOfDengue Where DengueId = 3);

--Some Keyword--
Select PatientID, PatientName, Mail
from Patients_Info join TypeOfDengue on Patients_Info.DengueId = TypeOfDengue.DengueId
Where DenguesType >
Some (Select DenguesType from TypeOfDengue Where DengueId = 2)

--Corelated Subquery--
Select CountNo, Platelets
from CountOfPlatelets as M_CountOfPlatelets
Where Platelets >
(select Avg(Platelets) From CountOfPlatelets as S_CountOfPlatelets
Where M_CountOfPlatelets.CountNo = S_CountOfPlatelets.CountNo)
Order by CountNo;

--Exists Operator--
Select PatientID, PatientName, Mail
From Patients_Info
Where Exists 
(Select * from TypeOfDengue 
Where Patients_Info.DengueId = TypeOfDengue.DengueId);

--Insert--
Insert Into Treatment_Info(SLNo, [Date], DoctorId, PatientID, CountNo)
Values(11, '2023/09/11', 1, 3, 4);

--Delete--
Delete from Treatment_Info
where SLNo = 11;

--IIf--
Select DengueId, DenguesType, iif(DenguesType='DENV-1','Bad','Worst') as NewColumn 
From TypeOfDengue;

--Choose--
Select DengueId, DenguesType, Choose(DengueId,'DENV-1','Bad','Worst') as NewColumn 
From TypeOfDengue

--Insert Into--
Insert into  TypeOfDengue(DengueId, DenguesType) 
values(5,null),(6,null),(7,null);

Select * From TypeOfDengue;

--Isnull--
Select DengueId, DenguesType, isnull(DenguesType, 'Bad') as NewColumn 
from TypeOfDengue;

--Coalesce--
Select DengueId, DenguesType, coalesce(DenguesType,'Bad') as NewColumn 
From TypeOfDengue;

--Grouping--
Select DengueId, DenguesType, grouping(DenguesType) From TypeOfDengue
Group by DengueId, DenguesType;

--Row_number--
Select DenguesType, row_number() over (partition by DenguesType order by DengueId) as NewColumn 
from TypeOfDengue;

--Rank--
Select DenguesType, rank() over (partition by DenguesType order by DengueId) as NewColumn 
From TypeOfDengue;

--Dense_rank--
Select DenguesType, dense_rank() over (partition by DenguesType order by DengueId) as NewColumn 
From TypeOfDengue;

--Ntile--
Select DenguesType, ntile(4) over (partition by DenguesType order by DengueId) as NewColumn 
From TypeOfDengue;

--first_value--
Select DenguesType, first_value(DenguesType) over(partition by DenguesType order by DengueId) as NewColumn 
From TypeOfDengue;

--Last_value--
Select DenguesType, last_value(DenguesType) over(partition by DenguesType order by DengueId) as NewColumn 
From TypeOfDengue;

--Lag--
Select DenguesType, lag(DenguesType) over(partition by DenguesType order by DengueId) as NewColumn 
From TypeOfDengue;

--Lead--
Select DenguesType, lead(DenguesType) over(partition by DenguesType order by DengueId) as NewColumn 
From TypeOfDengue;

--Percent_rank--
Select DenguesType, percent_rank() over(partition by DenguesType order by DengueId) as NewColumn 
From TypeOfDengue;

--Cume_dist--
Select DenguesType, cume_dist() over(partition by DenguesType order by DengueId) as NewColumn 
From TypeOfDengue;

--percentile_cont--
Select DenguesType, percentile_cont(0.5) within group(order by DengueId) over(partition by DenguesType) as NewColumn 
From TypeOfDengue;

--Percentile_disc--
Select DenguesType, percentile_disc(0.5) within group(order by DengueId) over(partition by DenguesType) as NewColumn 
From TypeOfDengue;