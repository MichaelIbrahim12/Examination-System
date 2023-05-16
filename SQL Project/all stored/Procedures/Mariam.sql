-----stored topic----
----topic-----------------------------------------------------------------------------------------------------
---- insert into topic---
create proc ins_topic  @name varchar(100), @crs_id int
as 
begin try
insert into Topic values(@name,@crs_id)
end try 
begin catch
select 'error in insert topic please check if crs id is exsit'
end catch 
go

---ins_topic 'delegte',5
---select topic ----
create proc select_topic @id int= -1, @name varchar(100)=' '
as
if @id=-1 and @name!=' ' ---select with name if it not null
begin 
if exists(select name from Topic where name=@name)
select t.id as topic_id, t.name as topic_name, t.Crs_id as course_id,c.name as course_name from Topic t, Course c
where t.Crs_id=c.Id and
t.name=@name
else select 'topic not found'
end 
else if @id!=-1 and @name=' '---select with id if not -1
begin
if exists(select id from Topic where id=@id)
select t.id as topic_id, t.name as topic_name, t.Crs_id as course_id,c.name as course_name from Topic t, Course c
where t.Crs_id=c.Id and
t.id=@id
else select 'topic not found'
end 
else -- select with both id and name
select t.id as topic_id, t.name as topic_name, t.Crs_id as course_id,c.name as course_name from Topic t, Course c
where t.Crs_id=c.Id
---select_topic @name='first'
----select_topic 1
go 
---update topic-------------
create proc update_topic @id int, @name varchar(100) =' ',@crs_id int =0
as
if exists(select id from Topic where id=@id)
begin
begin try
if(@name!=' ') --update with name
update Topic set name= @name where id=@id
if(@crs_id!=0)--update with crsid
update Topic set Crs_id=@crs_id where id= @id
end try
begin catch
select 'an error happened while updating in topic'
end catch
end
else 
select 'topic not found'
----update_topic 1 ,@crs_id=4
----update_topic 1 ,'second'
 
go
---delete topic-----
create proc delete_topic @id int 
as
delete from Topic where id=@id
go
------exam-----------------------------------------------------------------------------------
----select from exam with id---
create proc select_exam @id int=-1 
as 
if @id!=-1
begin
if exists(select id from Exam where id=@id)
select e.id as exam_id, e.duration as exam_time,c.name as course_name from Exam e, Course c
where e.Crs_id=c.Id and
e.id=@id
else select 'exam not found'
end
else  select 'exam not found'
---select_exam 2
go

----insert into exam--
create proc insert_exam  @duration int=3,@crs_id int
as 
begin try
insert into Exam values(@duration,@crs_id)
end try
begin catch
select 'an error happened while inserting in exam'
end catch
-----insert_exam 3,4 
go 
----- update exam----
create procedure update_exam @id int,@time int=-1,@crsid int=-1
as
if exists(select id from Exam where id=@id)
begin
begin try
if @time!=-1
update Exam set duration=@time where id=@id
if @crsid!=-1
update Exam set Crs_id=@crsid where id=@id
end try
begin catch
select 'error in foreign key'
end catch
end
else
select 'no matched id'
----update_exam 1,@crsid=1
go
------delete from exam--------------
create procedure delete_exam @id int
as
delete from Exam_student_question ---delete from child first
where ex_id=@id
delete from Exam
where id=@id
-----delete_exam 1
go
------exam-student-question table---------------
----select-----------------------
create proc select_exstdques @ex_id int=0,@std_id int=0, @quest_id int=0
as
if (@ex_id!=0 and @std_id =0 and @quest_id=0)

select esq.ex_id as exam_id, esq.Std_ssn as student_id,CONCAT(s.fname,' ',s.lname) as StudentName, esq.quest_id as QuestionID,q.title as QuestionHeader,
	esq.date as ExamDate, esq.Student_answer as StudentAnswer 
	from Exam_student_question esq , Student s,Exam e , Question q
	where esq.Std_ssn=s.Student_ssn and
	esq.ex_id=e.id and
	esq.quest_id=q.id and
	esq.ex_id=@ex_id 
else if (@ex_id=0 and @std_id !=0 and @quest_id=0)
select esq.ex_id as exam_id, esq.Std_ssn as student_id,CONCAT(s.fname,' ',s.lname) as StudentName, esq.quest_id as QuestionID,q.title as QuestionHeader,
	esq.date as ExamDate, esq.Student_answer as StudentAnswer 
	from Exam_student_question esq , Student s,Exam e , Question q
	where esq.Std_ssn=s.Student_ssn and
	esq.ex_id=e.id and
	esq.quest_id=q.id and esq.Std_ssn=@std_id
else if (@ex_id=0 and @std_id =0 and @quest_id!=0)
select esq.ex_id as exam_id, esq.Std_ssn as student_id,CONCAT(s.fname,' ',s.lname) as StudentName, esq.quest_id as QuestionID,q.title as QuestionHeader,
	esq.date as ExamDate, esq.Student_answer as StudentAnswer 
	from Exam_student_question esq , Student s,Exam e , Question q
	where esq.Std_ssn=s.Student_ssn and
	esq.ex_id=e.id and
	esq.quest_id=q.id and esq.quest_id=@quest_id
else 
	select esq.ex_id as exam_id, esq.Std_ssn as student_id,CONCAT(s.fname,' ',s.lname) as StudentName, esq.quest_id as QuestionID,q.title as QuestionHeader,
	esq.date as ExamDate, esq.Student_answer as StudentAnswer 
	from Exam_student_question esq , Student s,Exam e , Question q
	where esq.Std_ssn=s.Student_ssn and
	esq.ex_id=e.id and
	esq.quest_id=q.id

---select_exstdques 1 with exam id only
---select_exstdques @std_id=1 with std id
-----select_exstdques @quest_id=3 
----select_exstdques 3,1,3 done
----select_exstdques 5
go
--insert into exam_std_quest-----------------------------
create proc insert_exstdques @ex_id int,@std_ssn int ,@quest_id int , @std_answer varchar(10)
as
begin try
insert into Exam_student_question values(@ex_id,@std_ssn,@quest_id,GETDATE(),@std_answer)
end try
begin catch
select 'Please enter valid data'
end catch 
---insert_exstdques 2,1,5,'1.1.2015', 'c'

go 
-------update date and answer----------------------------------
create proc update_exstdques @ex_id int,@std_ssn int , @quest_id int,@date date ='',@std_answer varchar(10)=''
as
begin try
if(@date!='') ----change the value of date with the three primary keys  
	update Exam_student_question set date=@date where ex_id=@ex_id and quest_id=@quest_id and Std_ssn=@std_ssn
if(@std_answer!='')----change the value of std answer with the three primary keys 
update Exam_student_question set Student_answer=@std_answer where ex_id=@ex_id and quest_id=@quest_id and Std_ssn=@std_ssn
end try
begin catch
select 'Please enter valid data'
end catch
 -----update_exstdques 2,1,1,'1.2.2018'
 ----------- update_exstdques 2,1,5, @std_answer='d'
 -----update_exstdques 2,1,5 ,' '----nothing 
 go
 -----------delete ---------------------
 create proc delete_exstdques @ex_id int =0,@std_ssn int =0,@quest_id int =0
 as
 if(@ex_id!=0 and @quest_id=0 and @std_ssn=0)----delete with exam id only
 delete from Exam_student_question where ex_id=@ex_id
 else if (@ex_id=0 and @quest_id!=0 and @std_ssn=0) ---delete with q id only
 delete from Exam_student_question where quest_id=@quest_id
 else if (@ex_id=0 and @quest_id=0 and @std_ssn!=0) ---delete with std id only
 delete from Exam_student_question where Std_ssn=@std_ssn 
 else if (@ex_id!=0 and @quest_id!=0 and @std_ssn!=0)---delete with the 3 primary
	delete from Exam_student_question where quest_id=@quest_id and ex_id=@ex_id and Std_ssn=@std_ssn
else 
	select 'you must enter either examId or StudentSSN or Question ID or ALL'
------delete_exstdques 2