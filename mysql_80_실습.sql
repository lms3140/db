/*
	MYSQL : 정형 데이터를 저장하는 데이터베이스
	SQL 문법을 사용하여 데이터를 CRUD 함.
	create read update delete (CRUD)
	insert select update delete (SQL식 CRUD)
    개발자는 DML에 대한 CRUD 명령어를 잘 사용할 수 있어야함
	SQL은 크게 DDL DML DCL DTL 로 구분할 수 있다.
    
    sql은 대소문자 구분하지 않음. 보통 소문자로 작성
    snake 방식의 네이밍 규칙을 가짐
    
    DDL(Data Definition Language) : 데이터 정의어
	 - 데이터를 저장하기 위한 공간을 생성하고 논리적으로 정의하는 언어
		EX ) CREATE, ALTER, TRUNCATE, DROP.... 
    
    DML(Data Manipulation Language) : 데이터 조작어
	 - 데이터를 CRUD 하는 언어
		EX ) INSERT, SELECT, UPDATE, DELETE

	DCL(Data Control Language) : 데이터 제어어
     - 데이터에 대한 권한과 보안을 정의하는 언어
		EX ) GRANT, REVOKE

	DTL(Data Transaction Language, TCL) : 트랜잭션 제어어
     - 데이터베이스의 처리 작업 단위인 트랜잭션을 관리하는 언어
		EX ) COMMIT, SAVE, ROLLBACK
*/


/*	반드시 기억해야하는 명령어 워크벤치 실행마다 명령어 실행해야함. 번거롭네 */
show databases; -- 모든 데이터 베이스를 조회
use hrdb2019; -- 사용할 데이터베이스 오픈
select database(); -- 데이터베이스 선택
show tables; -- 데이터베이스의 모든 테이블 조회


-- use -> select 로 사용하는 db 바꿀 수 있음

/*  ㅇㅅㅇ   */

use market_db;
select database();
show tables;

/* DESC(DESCRIBE - 설명하다) : 테이블 구조 확인 
   desc [테이블명];
*/
show tables;
desc department;
desc employee;
desc unit;
desc vacation;

/*	SELECT : 테이블 내용 조회
	SELECT [COLUMNS] FROM [TABLE];
*/

select emp_id, emp_name from employee;
select * from employee;
select emp_name,eng_name,gender,phone,email from employee;

-- employee table의 사번 사원명 성별 입사일 급여를 조회

show tables;

desc employee;

select emp_id, emp_name,gender,hire_date,salary 
from employee;

-- 모든 부서 조회

show tables;

select * from department;

-- 사원 테이블의.... 대충 한글로 바꾸기

select emp_id as 사번, emp_name as 사원명, gender as 성별 , hire_date as 입사일, salary as 급여 
from employee;

-- 컬럼 가공할때 씀 
select emp_id ID, emp_name "NAME", GENDER, hire_date HDATE, SALARY 
from employee;

-- 사원테이블의 사번, 사원명, 부서명, 폰번호, 이메일, 급여, 보너스(급여 * 10%)
desc employee;

select emp_id,emp_name,dept_id,phone,email, salary,salary * 0.1 bonus
from employee;

-- 현재 날짜 : curdate()
select curdate() dateNow from dual; -- dual은 임시 테이블

/*
	상세조회
    select [column]
    from [table]
    where [condition] <--- 이거
*/

select * from employee where emp_name = "정주고";

-- 부서 아이디가 sys인 

select * from employee where dept_id = "SYS";


-- 사번이 S0005인 사원의 사원명, 성별, 입사일, 부서아이디, 이메일, 급여를 조회

select emp_name,gender,hire_date,dept_id,email,salary from employee where emp_id = "s0001";

-- sys 부서에속한 모든사원들을 조회, 단 출력되는 EMP_ID 컬럼은 '사원번호' 별칭으로 조회

select * from employee where dept_id ="SYS";

-- emp_name '사원명 벼칭 수정'
select emp_name from employee
where emp_name = "홍길동";


-- 전략기획 부서의 모든 사원들의 사번, 사원명, 입사일, 급여를 조회
select * from department;

select * from employee where dept_id = "stg";

-- 입사일이 2024-8-1일인 사원들을 조회
select * from employee where hire_date = '2014-08-01'; -- date 타입은 문자열 처럼, 처리는 숫자처럼

-- 급여가 5000원인 사원들을 조회
select * from employee where salary=5000;
select * from employee where gender="M";
select * from employee where gender="F";

-- null : 아직 정의되지 않은 미지수
-- 숫자에서는 가장 큰 수로 인식, 논리적인 의미를 포함하고 있으므로 등호(=)로는 검색이 불가. IS 키워드와 함께 사용됨

-- 급여가 null인 값을 가진 사원들을 조회
select * from employee where salary is not null;

-- 영어 이름이 정해지지않은 사원들을 조회

select * from employee where eng_name is null;


-- 퇴사 안한사람들
select * from employee where retire_date is null;
select *,salary*.2 bonus from employee where retire_date is null;

-- 퇴사한 직원들
select emp_id, emp_name,email,phone,salary,retire_date from employee where retire_date is not null;


-- null 값 대체 하는법
select emp_name, ifnull(salary,0) as salary from employee where dept_id = "STG";

-- 사원 전체 테이블의 내용을 조회, 단 영어이름이 정해지지 않은 사원들은 'smith' 이름으로 치환

select emp_name, ifnull(eng_name,"smith") as eng_name from employee;

-- MKT 부서의 사원들을 조회, 재직중인 사원들의 Retire_date 컬럼은 현재 날짜로 치환

select emp_name,ifnull(retire_date,curDate()) as retire_date from employee where dept_id = "MKT";


/* DISTINCT : 중복데이터 배제하고 조회 */

select distinct(dept_id) from employee;

-- 주의!! unique한 컬럼과 함께 조회하는 경우 distinct가 적용되지 않음
select distinct dept_id, emp_id from employee;

/*
	select
    from
    where
	ORDER BY절 : 데이터 정렬
*/

select *
from employee
order by salary desc;

-- 모든 사원을 급여, 성별을 기준으로 오름차순 정렬

select * from employee order by gender, salary;

select * 
from employee 
where eng_name is null 
order by hire_date desc;

-- 퇴직한 사원들을 급여 기준으로 내림차순 정렬
-- 급여 별칭으로 orderby
-- where 조건절 데이터 탐색 > 컬럼리스트 > 정렬
select emp_id,emp_name,emp_name,gender,hire_date,retire_date,dept_id,phone,email,salary 급여
from employee 
where retire_date is not null 
order by 급여 desc;

-- 정보시스템(sys) 부서 사원들 중 입사일이 빠른 순서, 급여를 많이 받는 순서로 정렬

select emp_id,emp_name,dept_id,hire_date 입사일,salary 급여
from employee
where dept_id = 'sys'
order by 입사일, 급여 desc;


/*
	특정 범위 혹은 데이터 검색 
    where + 비교연산자
*/
-- 급여가 5000 이상인 사원들 조회
select * 
from employee
where salary >= 5000
order by salary;


select *
from employee
where hire_date > "2017-01-01"
order by hire_date desc;


-- 일사일이 20150101 이후거나 급여가 6000 이상인 사원들을 조회
-- ~이거나, ~또는 : or - 두 개의 조건중 하나만 만족해도 조회가능

select *
from employee
where hire_date >= "2015-01-01" and salary >= 6000;

-- 특정 기간 : 2015-01-01 ~ 2017-12-31 사이에 입사한 모든 사원 조회
select *
from employee
where hire_date >="2015-01-01" and hire_Date <= "2017-12-31"
order by dept_id;

-- 급여가 6000 이상 8000이하인 사원들을 모두 조회
select *
from employee
where salary >= 6000 and salary <= 8000
order by salary desc;


-- MKT 부서의 사원들의 사번, 사원명, 입사일, 이메일, 급여, 보너스(급여*15%)

select emp_id,emp_name,hire_Date,email,salary,ifnull(salary,50)*.2 as bonus
from employee
where dept_id = "MKT" and ifnull(salary,50)*.2 > 1000
order by bonus desc;

-- 사원명이 '일지매','오삼식','김삼순' 인 사원들 조회

select *
from employee
where emp_name in("일지매","오삼식","김삼순");




/* between and  */

select*
from employee;

-- 와일드 문자 (%,_)
/*

	와일드 문자(%,_) LIKE 연산자
	%: 전체 , _ : 한글자 
*/

-- '한' 씨 성을 가진 모든 사원을 조회

select * 
from employee
where emp_name LIKE "한%";







