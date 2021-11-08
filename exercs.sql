# 1 - Create a query that count how many students have a scholarship

# Create a database
create database college
default character set utf8
default collate utf8_general_ci;

# Create tables Student and Scholarship
create table students(
id int auto_increment,
name varchar(30),
gender enum('M', 'F'),
born date,
nationality varchar(30) default 'Brazil',
primary key(id)
)default charset = utf8; #I know I don't need to put this charset because it's already utf8

create table scholarship(
id int auto_increment,
id_user int,
scholarship char(1) default 'S', 
primary key(id),
foreign key(id_user) references students(id)
); #introduce the command foreign key

#Insert some valeus to both tables
insert into students
(name, gender, born, nationality)
values
('Leandro', 'M', '1986-05-24', default),
('Marcio', 'M', '1986-06-18', default),
('Rodrigo', 'M', '1986-07-14', 'Portugal'),
('Saoirse', 'F', '1986-03-02', 'Ireland'),
('Saray', 'F', '1986-02-01', 'Spain'),
('Maria', 'F', '1986-01-02', 'Mexico')
('Yumi', 'F', '2000-01-02', 'Japan'); #as I don't put all columns, I need to specify them

insert into scholarship values 
(default, '4',default), 
(default, '1',default),
(default, '6',default);

# Use select and count to get the desied output
select count(s.id) from
students s left join scholarship b
on s.id = b.id_user
group by b.scholarship
having b.scholarship ='S'; #the 'having' cmd just work in grouped columns - so this worked and give me the correct answer

#I find others solutions
#1.1
select count(b.id_user) from
students s inner join scholarship b
on s.id = b.id_user; #using the inner join, we dont need to group the ids and the answer coming!!

#1.2
select count(s.id) from
students s left join scholarship b
on s.id = b.id_user
where b.id_user is not null; #I believe this 'bring' the column id_user to students and check who it not null 

# 2 - Create a query that count how much students have payed this month
#Primeira vez que modifico pelo Visual o código - agora sim estou evoluindo ^_^




