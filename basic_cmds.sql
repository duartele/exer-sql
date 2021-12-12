#See if a database is active
#status - just work in the terminal/console
#exit - just work in the terminal/console

# Active a database
use college;

#Show tables from the active database
show tables;

# Create a database
create database college
default character set utf8
default collate utf8_general_ci;

# Create tables Student and Scholarship - you can use the key 'if no exists' to avoid overwritting one existent
create table if not exists students(
id int auto_increment,
name varchar(30),
gender enum('M', 'F'),
born date,
nationality varchar(30) default 'Brazil',
primary key(id)
)default charset = utf8; #I know I don't need to put this charset because it's already utf8

#Some useful cmds
describe scholarship;
desc students; #here desc means describe 
show databases;
show tables;
drop database xyz;

alter table payments
add column tuition boolean default 0; #add column at the end
#add column tuition boolean default 0 first; #or you can use 'after column xpto'. 

#if you want to create a column that will be a primary key, you need to first create a column and then define it as primay key.
alter table payments
add primary key (tuition);

alter table payments
drop column tuition; #drop column

alter table payments
modify column amount_paid smallint; #modifying the type of a column - use "change" if you want to change the name of the column

alter table payments
change column amount_paid qtd int unsigned; #change the name of a column - you need to specify again the type and the constrains
#the key unsigned is used when the amount is always positive
#the key unique is different of primary key

alter table payments
rename to payment; #rename is when you want to change the name of the table

update courses
set name = 'HTML5', year = '2015'
where id_course = '1'
limit 1; #Use limit to safe update - just change 1 instance (many columns of that instance)

#To delete instances:
delete from courses
where id_course = 8
limit 3; #Here again you can specify the max limit of changes 

#Delete all instances of a table - it's different of drop table because when using delete the table still exists.
truncate courses;

#To create a Backup - here is called Dump
#Go to server - Data Export
#Its good to export the structure and the Data
#You can choose to use a folder os put everything in a file and Its good to Include the Create Schema

#More about Select cmd
select name, workload, tot_classes  from courses # you can choose the order od the columns
where year <= '2016' and tot_classes <> 20
#where year != '2016' != or <> is different
#where year in ('2014', '2015', '2016')
#where tot_classes between '20' and '30'
order by name asc; #you don't need to put asc 
# order by name desc, year - desc = descending order - you can put more the one column here (is asc because it's after the keyword desc)

#Operator LIKE - wildcard %
select name, tot_classes from courses
where name like 'P%'; # % is 0 or many caracthers and search for 'p%' as well - YOU CAN USE 'NOT LIKE'
#where name like '%P'; # it's different from 'p%'
#where name like '%P%';
#where name like 'Ph%P%'; #bring things like PHOTOSHOP or php5
#where name not like '%P%';

#Operator LIKE - wildcard _
select name, tot_classes from courses
where name like 'p_'; #This wildcard replace exactly one value.
#where name like 'p_p%'; #Must have a letter. For example: 'PHP' OR 'PHP5'
#where name like 'p__p%'; #Here I put 2 _

select distinct name from courses; #distinct select just one of each, but it's not a grouping!!!

#Aggregation functions - COUNT, MAX, MIN, SUM, AVG
select count(tot_classes) from courses;
select count(*) from courses
where tot_classe > 40;

select max(tot_classes) from courses;

#Group and Having
select tot_classes, count(*) from courses
where year = '2016'
group by tot_classes; #you can use 'where' with group However, when you used a grouped column, you need to use 'HAVING'

select tot_classes, count(*) from courses
where year = '2016'
group by tot_classes
having count(*) > '5'; # tot_classes or count are grouped colums. So you need to use having

#Using select inside a select
select tot_classes, count(*) from courses
group by tot_classes 
having tot_classes > (select avg(tot_classes) from courses);

#Foreign key - First create a column
alter table payments
add column id_user int; #need to have the same type of the original column

#The sign as a foreign key
alter table payments
add foreign key (id_user)
references students(id);
#If you don't put students(id) won't show error, but the key will be just normal (not foreign key)

#Case when - need to use 'end' to show that you finished all cases/transformation
select *,
case
	when aux_p = 1 or aux_s = 1 then 0
    else 1
end as aux_d #here I create a variable called 'aux_d' that can assume two values: 0 or 1
from temp4;
