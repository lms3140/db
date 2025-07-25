/*
	DDL(Data Definition Language) : 생성, 수정, 삭제 - 테이블기준
    DML : C(insert) R(select)  U(update)  D(delete)
*/

show tables;

/* [테이블 생성]
 형식> create table [table name] (
	컬럼명 데이터타입(크기),
    ...
 );

*/

-- 데이터 타입 : 정수형(int, long), 실수형(float, double), 문자형(char, varchar, longtext...)
-- 				이진데이터(longblob)..
desc employee;

select * from employee;

create table emp(
	emp_id 		char(4),
    ename 		varchar(10),
    gender		char(1),
    hire_date 	datetime,
    salary		int
);
show tables;
select * from information_schema.tables
where table_schema = 'hrdb2019';

desc emp;

drop table emp;

-- [테이블 복제]
-- 형식 : create table [테이블명]
--  	 as [SQL 정의]

-- employee 테이블을 복제하여 emp 테이블 생성
select * from employee;

create table emp
as
select * from employee;
show tables;
desc emp;

select * from emp;

-- 2016년도에 입사한 사원의 정보를 복제

create table employee_2016 as
select * from employee where left(hire_date,4) = 2016;

select * from employee_2016;
show tables;

/*
	데이터 생성 (insert : c)
    형식 insert into [테이블명] {컬럼 리스트}
		values(데이터1, 데이터2, .....)
*/

show tables; 

select * from emp;

desc emp;

select * from employee;

insert into emp(emp_id, ename, gender, hire_date, salary)
values("s001","홍길동","M",now(),1000);
insert into emp(emp_id)
values("s002");

-- 테이블 절삭 : 테이블의 데이터만 09삭제

-- 형식> truncate table [테이블명];

truncate table emp; -- 데이터만 비우기~

select * from emp;

drop table emp;

show tables;

CREATE TABLE emp (
    emp_id CHAR(4) NOT NULL,
    ename VARCHAR(10) NOT NULL,
    gender CHAR(1) NOT NULL,
    hire_date DATETIME NULL,
    salary INT NULL
);
desc emp; 

insert into emp(emp_id,ename,gender,hire_date,salary)
values("s222","홍진호","m",now(),2222);

insert into emp
values('s111','감자탕','m',now(),5123);

insert into emp
values(2000,'탕자감','m',curdate(),5123);

select * from emp;

-- [자동 행번호 생성: auto_increment]
-- 정수형으로 번호를 생성 pk unique 제약으로 설정된 컬럼에 주로 사용
CREATE TABLE emp2 (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    ename VARCHAR(10) NOT NULL,
    gender CHAR(1) NOT NULL,
    hire_date DATE,
    salary INT
)
;
show tables;
desc emp2;

insert into emp2(ename,gender,hire_date,salary)
values('레몬탕','m',now(),50294);

insert into emp2(ename,gender,hire_date,salary)
values('사과탕','m',curdate(),50294);

select * from emp2;

/*
	테이블 변경 : alter table
    형식 > 	alter table [테이블명]
			add column [새로 추가하는 컬럼명, 데이터타입] - null 허용 
			modify column [변경하는 컬럼명, 데이터타입] -- 크기를 고려하라~
			drop column [삭제하는 컬럼명] 
*/


show tables;
select * from emp;

alter table emp
	add column phone char(13) null;
    
alter table emp
	drop column phone;

alter table emp
	modify phone char(13) null; -- 저장된 데이터보다 크기가 작으면 에러가 발생한다. 데이터 유실발생 위험이 있다. 그래서 안된다.  ㄴ ㅁ ㄱ ㄱ ㄴ ㅁ ㄱ 
																												
select * from emp;

truncate table emp;

insert into emp
	values('s125','뤠미안','ㅡ',now(),4012,'0101-231-234');

/*
	데이터 수정
    형식 > update [테이블명]
				set [컬럼리스트]
				where [조건절 ~]
	** set sql_safe_update = 1 or 0; -- 1 : 업데이트 불가 , 0 : 업데이트 가능  
*/

select * from emp;
-- 홍길동의 급여를 6000으로 수정
set sql_safe_updates = 0;
update emp
	set salary = 16000
    where emp_id = 's222';

select * from emp

-- 김유신의 입사날짜를 20210725로 수정
;
UPDATE emp 
SET 
    hire_date = CAST('2021-07-25 10:52:33' AS DATETIME)
WHERE
    ename = '감자탕';

desc emp;

desc emp2;

select * from emp2;

alter table emp2
	add retire_date date;
    
UPDATE emp2 
SET 
    retire_date = CURDATE();

alter table emp2
		modify retire_date date not null;
    

/*
	데이터 삭제(delete :D)
    형식> delete from [테이블명]
			where [조건절~]
*/
select * from emp;
-- 학생 한명 삭제

DELETE FROM emp 
WHERE
    emp_id = 's111';

rollback;

-- s004 사원 삭제

SELECT @@autocommit;
set autocommit = 0;


