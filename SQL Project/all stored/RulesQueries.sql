CREATE RULE ansnwers  
AS   
@list IN ('a', 'b', 'c','d');  
go

sp_bindrule ansnwers, 'Question.Model_ans'

go

CREATE RULE Qtype  
AS   
@list IN ('T','C' );  

go

sp_bindrule Qtype , 'Question.type'

go

CREATE RULE Qstans  
AS   
@list IN ('a','b','c','d' ); 

go

sp_bindrule ansnwers, 'Exam_student_question.Student_answer'