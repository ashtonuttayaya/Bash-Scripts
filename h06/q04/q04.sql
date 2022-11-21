use h6db_aru;
select count(*) as "Number named John" from students where fname="John";
select count(*) as "Number in year 3" from students where year="3";
select count(*) as "Number with GPA > 2.6" from students where gpa>"2.6";
select count(*) as "Number of females" from students where gender="1";
select count(*) as "Number of females with GPA > 3.1" from students where gender="1" and gpa>"3.1";
