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
	CourseID varchar(6) primary key,
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

insert into Course values
('C00001','Database Systems',3),
('C00002','Programming',4),
('C00003','Computer Networks',3),
('C00004','Marketing',2),
('C00005','Accounting Principles',3);

insert into Enrollment values
('S00001','C00001',8.5),
('S00001','C00002',7.8),
('S00002','C00001',9.0),
('S00002','C00003',8.2),
('S00003','C00004',7.5),
('S00004','C00005',8.0),
('S00005','C00001',9.5),
('S00005','C00002',8.7),
('S00006','C00004',6.8),
('S00007','C00005',7.9),
('S00008','C00001',8.0);

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








