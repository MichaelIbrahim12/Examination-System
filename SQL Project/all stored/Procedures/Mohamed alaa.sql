


/*inert into depart procedure*/
create proc insert_dept(@id Integer, @Dept_name varchar(20))
as
BEGIN
     
        
            INSERT INTO Department
                        (Dept_id,Dept_name
                         )
            VALUES     (@id,@Dept_name )
END



/*update depart procedure*/
alter proc update_dept(@id Integer, @Dept_name varchar(20))
as
BEGIN
     
        
            UPDATE Department
            SET    Dept_name = @Dept_name
                   
            WHERE  Dept_id = @id
END




update_dept 10,'network'



/*delete  depart by name or id procedure*/

alter proc delete_dept( @Dept_name varchar(20)=NULL ,@id Integer=NULL)
as

BEGIN
/*if you want to delete by id*/
     if(@Dept_name is NULL)

		begin   
             DELETE FROM Department
            WHERE  Dept_id = @id
		end

	else if(@id is NULL)
		begin
		DELETE FROM Department
        WHERE  Dept_name = @Dept_name
		end

END


insert_dept 6 ,'sim'

delete_dept NULL,6

delete_dept 'sim',NULL

/*select  depart procedure*/

create proc view_depert
as
	begin

	select*from Department
	end

view_depert


/*insert into instructor procedure*/

create proc insert_instr(@id Integer, @name varchar(20),@salary int,@email varchar(50),@bday datetime,@dept_id int)
as
BEGIN
     
        
            INSERT INTO Instructor
                        (Ins_ssn,Ins_name,salary,email,Bday,Dept_id)
                         
            VALUES     (@id,@name,@salary,@email,@bday,@dept_id)
END


insert_instr 9,'ouf',3000,'@ouf.com','1999-01-01 00:00:00.000',2


select * from Instructor


/*update instructor procedure*/


create proc update_instr(@ssn Integer, @name varchar(20),@dept_id int=NULL,@update_type varchar(20))
as
BEGIN
     
        if(@update_type='name')
		begin
            UPDATE Instructor
            SET    Ins_name = @name
                   
            WHERE  Ins_ssn = @ssn
		end

		else if(@update_type='department')
		begin
		UPDATE Instructor
            SET    dept_id = @dept_id
                   
            WHERE  Ins_ssn = @ssn
		end

		

END



update_instr  9 ,'mahmoudouf',null , 'name'

update_instr  9 ,null ,3, 'department'

select * from Instructor


/*delete  instructor by name or id procedure*/

create proc delete_instr( @name varchar(20)=NULL ,@ssn Integer=NULL)
as

BEGIN
/*if you want to delete by id*/
     if(@name is NULL)

		begin   
             DELETE FROM Instructor
            WHERE  Ins_ssn = @ssn
		end

	else if(@ssn is NULL)
		begin
		DELETE FROM Instructor
        WHERE  ins_name =@name 
		end

END

delete_instr 'mahmoudouf',null

select * from Instructor


/*view instructor data */
create Proc view_instructor( @col varchar(20),@cond varchar(20))
as
begin
	execute('select '+@col+' from '+'Instructor'+' where '+@cond)
end

execute view_instructor '*','Ins_ssn=2'