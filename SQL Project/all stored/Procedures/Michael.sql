-- insert of student

create proc student_Insert @ssn int,@fname varchar(50),@lname varchar(50)=null,@Bday datetime=null,@address varchar(50)=null,@email varchar(50)=null,@deptid int 
as
begin try
	insert into Student values(@ssn,@fname,@lname,@Bday,@address,@email,@deptid)
end try
begin catch
	select 'something wrong with data'
end catch

go

-- update of student

create proc student_Update @ssn int,@newssn int=0,@fname varchar(50)='',@lname varchar(50)='',@Bday datetime='',@address varchar(50)='',@email varchar(50)='',@deptid int=0
as
if exists(select Student_ssn from Student where Student_ssn=@ssn)
begin
	begin try
		if @newssn !=0
			update Student set Student_ssn=@newssn where Student_ssn=@ssn
		else if @fname !=''
			update Student set fname=@fname where Student_ssn=@ssn
		else if @lname !=''
			update Student set lname=@lname where Student_ssn=@ssn
		else if @Bday !=''
			update Student set Bday=@Bday where Student_ssn=@ssn
		else if @address !=''
			update Student set address=@address where Student_ssn=@ssn
		else if @email !=''
			update Student set email=@email where Student_ssn=@ssn
		else if @deptid !=0
			if exists(select Dept_id from Department where Dept_id=@deptid)
				update Student set Dept_id=@deptid where Student_ssn=@ssn
			else select 'departement is not available'
	end try
	begin catch
		select 'invalid data'
	end catch
end
else select 'student is not available'

go
-- delete of student  
create proc student_delete @ssn int
as
	if exists(select Student_ssn from Student where Student_ssn=@ssn)
	begin
		delete from Student where Student_ssn=@ssn
	end
	else select 'student is not available'

go


-- select of student 

create proc student_select @ssn int=0,@fname varchar(50)='', @deptid int=0
as
if @ssn=0 and @fname='' and @deptid=0
begin
	select s.Student_ssn , s.fname +' '+ s.lname as [Full name],s.Bday [Birthday],s.address ,s.email,s.Dept_id,d.Dept_name  
	from Student s,Department d 
	where d.Dept_id=s.Dept_id
end
else if @ssn !=0 and @fname='' and @deptid=0
begin
	if exists(select Student_ssn from Student where Student_ssn=@ssn)
	begin
		select s.Student_ssn , s.fname +' '+ s.lname as [Full name],s.Bday [Birthday],s.address ,s.email,s.Dept_id,d.Dept_name  
		from Student s,Department d 
		where d.Dept_id=s.Dept_id and s.Student_ssn=@ssn
	end
	else select 'Student Not Available'
end
else if @ssn=0 and @deptid=0 and @fname!=''
begin
	if exists(select Student_ssn from Student where fname=@fname)
		begin
			select s.Student_ssn , s.fname +' '+ s.lname as [Full name],s.Bday [Birthday],s.address ,s.email,s.Dept_id,d.Dept_name  
			from Student s,Department d 
			where d.Dept_id=s.Dept_id and s.fname=@fname
		end
	else select 'Student Not Available'
end
else if @ssn=0 and @deptid!=0 and @fname=''
begin
	if exists(select Student_ssn from Student where Dept_id=@deptid)
		begin
			select s.Student_ssn , s.fname +' '+ s.lname as [Full name],s.Bday [Birthday],s.address ,s.email,s.Dept_id,d.Dept_name  
			from Student s,Department d 
			where d.Dept_id=s.Dept_id and s.Dept_id=@deptid
		end
	else select 'Student Not Available'
end

go
--insert course

create proc course_insert @id int, @name varchar(50)
as
if exists(select Id from Course where Id=@id)
	select 'Course is Already Exists'
else
	insert into Course values (@id,@name)	

go
--update course

create proc course_update @id int,@newid int=0, @name varchar(50)=''
as
if exists (select Id  from Course where Id=@id)
begin
	if @newid=0 and @name!=''
		update Course set name=@name where Id=@id
	else if @newid!=0 and @name='' 
		update Course set Id=@newid where Id=@id
	else if @newid!=0 and @name!=''
		update Course set Id=@newid,name=@name where Id=@id
end
else select 'Course is not Avalilable'

go
--delete course
create proc course_delete @id int=0,@name varchar(50)=''
as
if @id !=0 and @name=''
begin
	if exists (select Id from Course where Id=@id)
		delete from Course where Id=@id
	else select 'course is not available'
end
else if @id =0 and @name!=''
begin
	if exists (select name from Course where name=@name)
		delete from Course where name=@name
		else select 'course is not available'
end

go

--select course
create proc course_select @id int=0,@name varchar(50)=''
as

if @id=0 and @name=''
	select Id,name from Course
else if @id!=0 and @name=''
	select Id,name from Course where Id=@id
else if @id=0 and @name!=''
	select Id,name from Course where name=@name

go

--Exam Generation 
alter proc Exam_Generation @std_ssn int , @crs_name varchar(50), @t_f int , @choice int
as
if (@t_f + @choice !=10)
	select 'Enter 10 Questions '
else 
begin
	begin try
		declare @crs_id int
		declare @questions table (ques_id int)
	--create exam
		--insert in Exam table
		 select @crs_id=Id from Course where name=@crs_name
		 insert into Exam values(60,@crs_id)
		--insert t/f questions	 
		 insert into @questions 
		 select top(@t_f) id 
		 from Question 
		 where type='T' and crs_id=@crs_id
		 order by NEWID()
		 --insert choose questions
		 insert into @questions 
		 select top(@choice) id 
		 from Question 
		 where type='C' and crs_id=@crs_id
		 order by NEWID()
		 -- insert in exam_std_questions table
		 declare @current_exam int
		 select top(1) @current_exam=  id from Exam order by id desc 
		 declare c1 cursor
		 for select * from @questions
		 for read only
		 declare @ques_id int
		 open c1
		 fetch c1 into @ques_id
		 while @@FETCH_STATUS=0
			begin  
				insert into Exam_student_question values (@current_exam,@std_ssn,@ques_id,GETDATE(),null)
				fetch c1 into @ques_id
			end
		close c1
		deallocate c1
		select * 
		from Exam_student_question ex ,Question q
		where ex.quest_id=q.id and ex.ex_id=@current_exam and ex.Std_ssn=@std_ssn
		order by ex.quest_id

	end try
	begin catch
		select 'error happened'
	end catch
end

go
--Enter Answers
alter proc Enter_Answers @exam_id int ,@std_ssn int ,@a1 varchar(10),@a2 varchar(10),@a3 varchar(10) ,@a4 varchar(10),@a5 varchar(10),@a6 varchar(10),@a7 varchar(10),@a8 varchar(10),@a9 varchar(10),@a10 varchar(10)       
as
if exists(select * from Exam_student_question where ex_id=@exam_id and Std_ssn=@std_ssn)
begin
	begin try
		declare @ans_table table (answers varchar(20))
		insert into @ans_table values(@a1),(@a2),(@a3),(@a4),(@a5),(@a6),(@a7),(@a8),(@a9),(@a10)
		declare c1 cursor
		for select quest_id from Exam_student_question where ex_id=@exam_id and Std_ssn=@std_ssn
		for read only
		declare @question_id int 
		open c1 
		fetch c1 into @question_id
		 declare c2 cursor
		 for select * from @ans_table
		 for read only
		 declare @ans varchar(20)
		 open c2
		 fetch c2 into @ans
		 while @@FETCH_STATUS=0
			begin  
				update Exam_student_question set Student_answer=@ans where ex_id=@exam_id and Std_ssn=@std_ssn and quest_id=@question_id
				fetch c1 into @question_id
				fetch c2 into @ans				
			end
		close c1
		close c2
		deallocate c1
		deallocate c2
	end try
	begin catch
	select 'error happened'
	end catch
end
else select 'Enter Valid data'

go

--Exam_Generation 1,'DB',5,5

--Enter_Answers 9,1,'c','a','a','a','a','b','c','b','d','b'

go

--Exam correction
alter proc Exam_Correction @exam_id int, @st_id int
as
declare @totalGrade decimal(5,1)=0
declare @studentGrade decimal(5,1)=0 
declare @percent decimal(5,1)=0
declare c1 cursor
for select ex.Student_answer,q.model_ans,q.grade from Exam_student_question ex,Question q where ex.ex_id=@exam_id and ex.Std_ssn=@st_id and ex.quest_id=q.id
for read only
declare @stdAns varchar(20)
declare @modelAns varchar(20)
declare @grade int
open c1 
fetch c1 into @stdAns,@modelAns,@grade
while @@FETCH_STATUS=0
begin
	if(TRIM(@stdAns)=TRIM(@modelAns))
		begin
			set @totalGrade+=@grade
			set @studentGrade+=@grade
		end
	else
	set @totalGrade+=@grade
fetch c1 into @stdAns,@modelAns,@grade
end
set @percent = (@studentGrade/@totalGrade)*100
select CONCAT(@percent,'%') as StudentGrade
close c1 
deallocate c1
declare @crsId int
select @crsId= e.Crs_id from Exam_student_question ex,Exam e where e.id=ex.ex_id and ex.ex_id=@exam_id and ex.Std_ssn=@st_id 
update Student_Course set grade=@percent where Crs_id=@crsId and Std_ssn=@st_id

--Exam_Correction 9,1