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
#By default, the engine selected is MyISAM and it's not good - don't have ACID property.
# So, it is better to use InnoDB or XtraDB

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
('Maria', 'F', '1986-01-02', 'Mexico'),
('Yumi', 'F', '2000-01-02', 'Japan'); #as I don't put all columns, I need to specify them

insert into scholarship values 
(default, '4',default), 
(default, '1',default),
(default, '6',default);

# Use select and count to get the desired output
select count(s.id)  from
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

# 2 - Create a query that count how much students have payed this month - november
#create payments table and put some values
create table payments(
id int auto_increment,
id_user int not null,
amount_paid int not null,
payment_date date not null,
primary key(id),
foreign key(id_user) references students(id)
); #If you don't put the name of the column (id in this example - students(id)). It won't show error, but id_user won't be a foreign key in this case - just a regular key
#And can generate inconsistencies. For example, I don't have the id_student 5 and she(he) paid.

insert into payments values
(default,'5','160','2021-10-10'),
(default,'5','160','2021-11-10'),
(default,'6','20','2021-11-10'),
(default,'6','170','2021-11-10'),
(default,'2','122','2021-10-10')
;

#create a query to get the answe
# I need to consolidate sum(amount_paid) for each student because some students could pay more than once (Maria, for instance)
select id_user, amount_paid 
from payments
where payment_date >= '2021-11-01'
group by id_user
;

#I put the last select in the inner join
select count(s.id) 
from students s join (select id_user, (amount_paid) from payments where payment_date >= '2021-11-01' group by id_user) as p
on s.id = p.id_user
;

#2.1 - Obtain the name, date of the last payment and the amount paid this month of the students who paid
select s.name, max(p.payment_date) as last_payment, sum(p.amount_paid) 
from students s left join payments p
on s.id = p.id_user
where payment_date >= '2021-11-01'
group by s.id
;

# 3 - Show 3 columns - the first with the students who paid 160 or more this mounth,
# the second with the students who received scholarship and the third with the students who need to pay
# Desired Output:  1 3 3'

# If we could create tables, this solution would solve the problem:
create table temp2
select s.* , p.amount_paid, c.scholarship
from students s left join (select id_user, amount_paid from payments where payment_date >= '2021-11-01' group by id_user) as p on s.id = p.id_user
				left join scholarship as c on s.id = c.id_user
;

create table temp3
select *,
case
	when amount_paid >= 160 then 1
    else 0
end as aux_p
from temp2;

create table temp4
select *,
case
	when scholarship = 'S' then 1
    else 0
end as aux_s
from temp3;

create table temp5
select *,
case
	when aux_p = 1 or aux_s = 1 then 0
    else 1
end as aux_d
from temp4;

select sum(aux_p), sum(aux_s), sum(aux_d)
from temp5
;

#Dropping the temporary tables
drop table temp, temp2, temp3, temp4, temp5, temp6;

#Now I am creating other table to show more cms
create table if not exists courses(
name varchar(30) not null unique,
description text,
workload int unsigned,
tot_classes int unsigned,
year year default '2021'
);
# 1) there isn't problem using key as name of columns (I used name and year);
# Primary key is unique, but unique not necessarily a primary key;
# Unsigned is used when you know that the values will only be positive;
# if not exists is used when you don't want to overwrite a table.
# I don't define a primary key because I want to show that you after need to do two steps do put a primary key

desc courses; #When you don't put a primery key, the unique key is assumed to be primary key.

# First, create a column that will be primary key using alter table
alter table courses
add column id_course int first;
# If you don't use First, the column will be append at the end
# If you want to put a column at the middle, you need to use the key after

#Now I can define it as a primary key
alter table courses
add primary key (id_course); 

desc courses; #Now the column name is considered unique, not primary key anymore

#Now I am putting some instances in my table with some miss spelling
insert into courses values
('1','HTML4','HTML5 Course','40','37','2014'),
('2','Algorithms','Programming logic','20','15','2014'),
('3','Photoshop','Photoshop tips','10','8','2014'),
('4','PGP','For beginners','40','20','2010'),
('5','Jarva','Introduction to Java Language','10','29','2000'),
('6','MySQL','Database MySQL','30','15','2016'),
('7','Word','Complete course in Word','40','30','2016'),
('8','Dance','rhythmic dances','40','30','2018'),
('9','Cooking','Learn how to make Kibe','40','30','2018'),
('10','Youtuber','Generate controversy and gain subscribers','5','2','2018');

select * from courses;

#It is possible to modify many instances (lines) at once, but it's dangerous (verify if safe update is active in preferences SQL Editor).
#To avoid this, we can use the key Limit 1
update courses
set name = 'HTML5'
where id_course = '1';

update courses
set name = 'PHP', year = '2015'
where id_course = '4'
limit 1;

#Delete instances - you can use limit as well
delete from courses
where id_course = 8;

#Delete all instances of a table - it's different of drop table because when using delete the table still exists.
truncate courses;

#To create a Backup - here is called Dump
#Go to server - Data Export
#Its good to export the structure and the Data
#You can choose to use a folder os put everything in a file and Its good to Include the Create Schema

#I need to create more case when exercises
#4) Give 20% off if the student paid by the limit date and give 10% fee if she/he paid after the limit date
# I will find the payments of december. Who paid untill 12/12 will receive 20% off

create table temp
select id_user, max(payment_date) as payment_date, sum(amount_paid) as amount_paid
from payments
where month(payment_date) = 12
group by id_user;

select s.id,
case when t.payment_date <= '2021-12-12' then 160*0.8
else 160*1.2
end as tuition 
from students as s left join temp as t 
on s.id = t.id_user
group by s.id
order by tuition;
