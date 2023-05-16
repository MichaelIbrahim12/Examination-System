----mariam---
create proc StudentinfoR1 @dept_no int
as
select s.Student_ssn,s.fname,s.lname,s.email,s.address,s.Bday,d.Dept_name from Student s inner join Department d 
on s.Dept_id=d.Dept_id
where s.Dept_id=@dept_no
----StudentinfoR1 1
go

create proc StudentgradesR2 @std_id int
as
select sc.Std_ssn,c.name,sc.grade from Student_Course sc inner join Course c
on c.Id=sc.Crs_id 
where sc.Std_ssn=@std_id
go 
-----StudentgradesR2 5
create proc instcrsR3 @ins_ssn int
as
select i.Ins_name, c.name ,Count(sc.Crs_id) as [Student No]from Instructor_course ic inner join  Instructor i 
on ic.ins_ssn=i.Ins_ssn inner join Student_Course sc
on sc.Crs_id=ic.Crs_id inner join Course c
on c.Id=sc.Crs_id
where
i.Ins_ssn=@ins_ssn
group by i.Ins_name , c.name
----instcrsR3 6 

go
create proc course_topicsR4 @id int
as
select c.name as [course name], t.name as [topic name] from Topic t , Course c 
where t.Crs_id=c.Id and
c.Id=@id
 -----course_topicsR4 1
 go

 

 create proc stdansR6  @ex_id int ,@std_id int
as
select esq.Std_ssn, q.title,esq.Student_answer ,q.model_ans from Exam_student_question esq , Question q 
where esq.quest_id=q.id
and esq.ex_id=@ex_id and esq.Std_ssn=@std_id
-----stdansR6 9 , 1  
go

create proc examidR5 @ex_id int 
as
declare @count int =1
declare c1 cursor  ----declare cursor for numbering the questions 
for 
select q.title,LEAD(q.title) over (order by id) as titleNext ,qc.choice from Question q inner join Question_Choices qc 
on q.id=qc.ques_id inner join Exam_student_question esq on 
esq.quest_id=q.id where esq.ex_id=@ex_id
for read only
declare @currentTitle varchar(200),@nextTitle varchar(200),@choice varchar(200) --declare variables for data in cursor 
declare @Table table (title varchar(200),choice varchar(200)) ----table to store titles of questions with its count and choice
open c1
fetch c1 into @currentTitle,@nextTitle,@choice ---first row 
while @@FETCH_STATUS=0 -- if it is qual zero there is more rows to fetch
begin
declare @title varchar(200)= concat(@count,') ',@currentTitle) ---title = count) title of question
insert into @Table values (@title,@choice)
if @currentTitle!=@nextTitle
set @count=@count+1
fetch c1 into @currentTitle,@nextTitle,@choice 
end
close c1 
deallocate c1
select * from @Table

 
---- examidR5 9





