create proc select_Instructor_Course @ins_id int=0,@crs_id int=0
as
begin try
select crs_id as courseID ,C.name as courseName,@ins_id as instructorID ,I.ins_name InstructorName   
from Instructor_course IC
	 ,Course C, Instructor I
	where IC.crs_id=@crs_id and IC.crs_id=C.id and I.ins_ssn=IC.ins_ssn
end try 
begin catch 
select 'Record not found'
end catch   

go 

create proc insert_Instructor_Course @ins_id int ,@crs_id int
as
begin try
if(@ins_id !=0 and @crs_id !=0)
insert into Instructor_Course values(@crs_id,@ins_id)
end try 
begin catch 
select 'please enter valid data'
end catch

go 

create proc update_Instructor_Course @crs_id int , @ins_id int,@ins_newId int=0 , @crs_newId int=0
as
begin try 
update Instructor_Course set ins_ssn=@ins_newId,crs_id=@crs_newId where Crs_id=@crs_id and ins_ssn=@ins_id
end try 
begin catch 
select 'please enter valid data'
end catch

go 

create proc delete_Instructor_Course @ins_id int=0,@crs_id int=0
as
begin try 
delete from Instructor_Course where ins_ssn=@ins_id and crs_id=@crs_id
end try 
begin catch
select 'cant find record'
end catch

go 



create proc insert_Student_Course @crs_Id int, @std_Ssn int
as 
begin try 
insert into Student_Course values (@crs_Id , @std_Ssn,null)
end try 
begin catch 
select 'Failed to Insert'
end catch 

go 

create proc delete_Student_Course @crs_Id int=0,@std_Ssn int=0
as 
begin try 
delete from Student_Course
where 
Crs_id=@crs_Id and Std_ssn=@std_Ssn
end try 
begin catch 
select 'failed to delete'
end catch 

go 

create proc update_Student_Course @crs_id int , @std_ssn int,@crs_newId int=0 , @std_newId int=0
as 
begin try 
update Student_Course set Crs_id=@crs_newId ,Std_ssn=@std_newId
where 
Crs_id=crs_id and Std_ssn=std_ssn
end try 
begin catch
select 'failed to update'
end catch

go 

create proc select_Student_Course @crs_id int=0,@std_ssn int=0
as 
begin try 
select crs_id as CourseID ,std_ssn as StudentSSN ,grade as Grade
from 
Student_Course SC,Course C ,Student S 
where 
SC.Crs_id=C.id and SC.Std_ssn=S.Student_ssn
end try 
begin catch 
select 'failed to select'
end catch 

go 



















 