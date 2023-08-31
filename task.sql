/*Для решения задач используйте базу данных lesson_4
(скрипт создания, прикреплен к 4 семинару).
*/
use semimar_4;

/*1. Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, 
с помощью которой можно переместить любого (одного) пользователя из таблицы users 
в таблицу users_old. (использование транзакции с выбором commit или rollback 
- обязательно)
*/

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);

start transaction;
insert into users_old (id, firstname, lastname, email)
select id, firstname, lastname, email
from users where id = 5;
commit;
select * from users_old;

/*2. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в 
зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать
фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый 
день", с 18:00 до 00:00 - "Добрый вечер", с 00:00 до 06:00 - "Доброй ночи".
*/

set @curent_time := time_format(curtime(), '%k:%i');

select if (@curent_time between time_format('06:00', '%k:%i') and time_format('12:00', '%k:%i'), "Доброе утро", 
			if(@curent_time between time_format('12:00', '%k:%i') and time_format('18:00', '%k:%i'), "Добрый день", 
				if(@curent_time between time_format('18:00', '%k:%i') and time_format('00:00', '%k:%i'), "Добрый вечер", "Доброй ночи"))) 
as hello;

DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello()
RETURNS TEXT READS SQL DATA
BEGIN
set @curent_time := time_format(curtime(), '%k:%i');
select if (@curent_time between time_format('06:00', '%k:%i') and time_format('12:00', '%k:%i'), "Доброе утро", 
			if(@curent_time between time_format('12:00', '%k:%i') and time_format('18:00', '%k:%i'), "Добрый день", 
				if(@curent_time between time_format('18:00', '%k:%i') and time_format('00:00', '%k:%i'), "Добрый вечер", "Доброй ночи"))) 
as hello;
RETURN hello;
END //
DELIMITER ;
SELECT hello();
