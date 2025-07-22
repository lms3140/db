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