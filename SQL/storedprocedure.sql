create database SQLPractice;

use sqlpractice;

create table userdetails(
    id int auto_increment primary key,
    uname varchar(25),
    age int,
    location varchar(25)
);

DELIMITER $$

-- creating stored procedure here
	
create procedure insertuserdetails()
begin
    declare counter int default 1;
	
    while counter <=100 do
		set @uname = concat('abc', counter);
		set @age = counter;
		set @location = concat('xyz', counter);
    
		insert into userdetails (uname, age, location) values(@uname, @age, @location);
        
		set counter = counter + 1;
		if (counter % 10 = 0) then
			select concat(counter, 'rows inserted') as message;
		end if;
	end while;
end $$

delimiter ;
		
call insertuserdetails();

select * from userdetails;

truncate userdetails;


