create database qlsinhvien;
use qlsinhvien;

create table Department (
	DeptID varchar(5) primary key,
    DeptName varchar(50) not null
);

create table Student (
	StudentID varchar(6) primary key,
    FullName varchar(50) not null,
    Gender varchar(10) not null,
    BirthDate date not null,
    DeptID varchar(5) not null,
    foreign key(DeptID) references Department(DeptID)
);

create table Course (
	CourseID varchar(5) primary key,
    CourseName varchar(50) not null,
    Credits int not null
);

create table Enrollment (
	StudentID varchar(6),
    CourseID varchar(6),
    Score decimal(4, 2),
	primary key (StudentID, CourseID),
    foreign key(StudentID) references Student(StudentID),
    foreign key(CourseID) references Course(CourseID)
);

insert into Department values
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

insert into Student values
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

create view ViewStudentBasic 
as
select StudentID, FullName, DeptName
from Student s
join Department d
on s.DeptID = d.DeptID;
select * from ViewStudentBasic;

create index idxFullName 
on Student(FullName);

delimiter //
create procedure GetStudentsIT()
begin
	select 
		s.StudentID,
        s.FullName,
        s.Gender,
        s.BirthDate,
        d.DeptName
	from Student s
    join Department d
    on s.DeptID = d.DeptID
    where d.DeptName = 'Information Technology';
end //
delimiter ;
call GetStudentsIT();

create view ViewStudentCountByDept as
select
	d.DeptName,
    count(s.StudentID) as TotalStudents
from Department d
left join Student s
on d.DeptID = s.DeptID
group by d.DeptName;

select * from ViewStudentCountByDept
where TotalStudents = (
	select max(TotalStudents)
    from ViewStudentCountByDept
);

delimiter //
create procedure GetTopScoreStudent(
	in varCourseID varchar(6)
)
begin
	select
		s.StudentID,
        s.FullName,
        c.CourseName,
        e.Score
	from Enrollment e
    join Student s
    on e.StudentID = s.StudentID
    join Course c
    on e.CourseID = c.CourseID
    where e.CourseID = varCourseID
    and e.Score = (
		select max(Score)
        from Enrollment
        where CourseID = varCourseID
    );
end //
delimiter ;
call GetTopScoreStudent('C00001');








