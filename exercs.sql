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
foreign key(id_user) references students
);

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
