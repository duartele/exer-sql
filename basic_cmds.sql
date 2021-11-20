#See if a database is active
#status - just work in the terminal/console
#exit - just work in the terminal/console

# Active a database
use college;

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
modify column amount_paid smallint; #modifying the type of a column - use change if you want to change the name of the column

alter table payments
change column amount_paid qtd int unsigned; #change the name of a column - you need to specify again the type and the constrains
#the key unsigned is used when the amount is always positive
#the key unique is different of primary key

alter table payments
rename to payment; #rename is when you want to change the name of the table

 
