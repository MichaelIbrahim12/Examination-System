-- Select Question---
go
create proc selectQuestion @id int = -1 
as 
if(@id!=-1)
begin
select  q.id , q.title ,q.type , q.model_ans , q.grade , q.crs_id , c.name
from Question q inner join Course c on q.crs_id=c.Id
where q.id=@id
end
else
begin
select  q.id , q.title ,q.type , q.model_ans , q.grade , q.crs_id , c.name
from Question q inner join Course c on q.crs_id=c.Id
end

---Insert Question-----
--update question table identity on ID
go
create proc insertQuestion @title nvarchar(max) ,@type nvarchar(2), @model_Ans nvarchar(2),@crs_ID int, @grade int=1
as
begin try
insert into Question
values (@title,@type,@model_Ans,@grade,@crs_ID)
end try 
begin catch
select 'An Error occured will entring data please enter 5 valid parameters'
end catch

---Delete Question---
--update Relationship diagram "on delete casscade"
go
create proc deleteQuestion @qustion_id int
as
begin try 
delete from Question
where id=@qustion_id
end try
begin catch
select 'please enter a valid ID'
end catch
----Update Question----
go
create proc updateQuestion @qustion_id int,
@model_answer nvarchar(50)='NoChange'
,@title nvarchar(max)='NoChange'
,@grade int=0
,@type nvarchar(50)='NoChange'
,@course_id int=0
as
if exists(select id from Question where id=@qustion_id)
begin
begin try
if @model_answer != 'NoChange'
update Question set model_ans=@model_answer where id= @qustion_id
if @title != 'NoChange'
update Question set title=@title where id = @qustion_id
if @grade != 0
update Question set grade=@grade where id = @qustion_id
if @type != 'NoChange'
update Question set type=@type where id = @qustion_id
if @course_id != 0
update Question set crs_id=@course_id where id = @qustion_id
end try
begin catch
select 'an error occured please enter valid parameters '
end catch
end
else 
begin 
select 'this questions ID does not exist'
end


---Select Choice---
go
create proc selectChoice @id int = -1 
as 
if(@id!=-1)
begin
select  q.id , q.title , c.choice , q.model_ans
from Question q inner join Question_Choices c on q.id=c.ques_id
where q.id=@id
end
else
begin
select  q.id , q.title , c.choice , q.model_ans
from Question q inner join Question_Choices c on q.id=c.ques_id
end

---Insert Choice---
go
create proc insertChoice @Q_id int,@choice nvarchar(90)
as
begin try
insert into Question_Choices
values(@Q_id,@choice)
select 'Choice inserted Successfully'
end try
begin catch
select 'an error occurred [this id not exist]'
end catch

---Update Choice---
go
create proc UpdateChoice @Q_id int,@choice nvarchar(100),@newChoice nvarchar(100)
as
if exists (select ques_id from Question_Choices where ques_id=@Q_id and choice=@choice)
begin
begin try
update Question_Choices
set choice = @newChoice
where ques_id=@Q_id and choice=@choice
end try
begin catch
select 'An Error occurred please enter valid parameters'
end catch
end
else
select 'This Choice Does not exist please enter valid data'

---Delete Choice ---
go
create proc deleteChoice @qustion_id int , @Choice nvarchar(100)
as
if exists (select choice from Question_Choices where ques_id=@qustion_id and choice=@Choice)
begin
delete from Question_Choices 
where ques_id=@qustion_id and choice=@Choice
end
else
select 'This Choice Does not exist'

---Delete All Choices ---
go
create proc deleteAllChoices @qustion_id int 
as
if exists (select ques_id from Question_Choices where ques_id=@qustion_id)
begin
delete from Question_Choices 
where ques_id=@qustion_id
end
else
select 'This Choice Does not exist'

--------------




