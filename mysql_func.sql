show databases;
use hrdb2019;
select database();

/*
	내장함수 : 숫자함수, 문자함수, 날짜함수
	호출되는 위치 - [컬럼리스트], [조건절의 컬럼명]
*/

-- 숫자함수
-- 함수 실습을 위한 테이블 : DUAL 테이블
-- (1) abs(숫자) : 절대값
select abs(100),abs(-100),-100,100 from dual;

-- (2) floor(숫자), truncate(숫자, 자리수) : 소수점 버림
select floor(1.22), truncate(1.21351,2),1.2,ceil(2.5) from dual; 

-- 사원테이블의 sys부서 사원들의 보너스(salary * 0.25)컬럼을 추가하여 조회
-- 보너스 컬럼은 소수점 한자리
desc employee;

select emp_id, emp_name, dept_id, phone, salary, truncate(salary*.25,1) bonus
from employee 
where dept_id = "sys";

-- (3) RAND() : 임의의 수를 난수로 발생시키는 함수 (0~1사이의 난수)

select rand() from dual;

-- 정수 3자리 난수 발생
select floor(rand()*1000) rand from dual; -- 정수 3자리 (0~999) 난수 발생

-- 정수 4자리(0~9999) 난수 발생, 소수점 2자리
select truncate(rand()*10000,2) rand from dual;

-- (4) mod(숫자,나누는수) : 나머지 함수
select mod(23,2) from dual; 

-- (5) 3자리 수를 랜덤으로 발생시켜, 2로 나누어 홀수, 짝수를 구분

select mod(floor(rand()*1000),2) v 
from dual;

-- [문자함수]
-- (1) concat : 문자열 합치는 함수
select concat('안녕',"하",'세요','~'," hong gil dong ",'입니다') as introduce 
from dual;

select emp_id ,emp_name ,concat(emp_id," (",emp_name,")") 사원명2 
from employee;

-- 사번, 사원명, 영어이름, 입사일, 폰번호, 급여를 조회
-- 영어이름의 출력형식을 홍길동/hong 타입으로 출력
-- 영어이름이 null인 경우에는 'smith'를 기본으로 조회
select emp_id, emp_name, concat(emp_name,"/",ifnull(eng_name,"smith")) eng_name, hire_date, phone, salary 
from employee;

-- (2) substring(문자열, 위치,갯수) : 문자열 추출

select substring("대한민국 홍길동",1,4);

-- 사원테이블의 사번, 사원명, 입사년도, 입사월, 입사일, 급여를 조회

select emp_id, emp_name, substring(hire_date,1,4) year, substring(hire_date,6,2) month ,substring(hire_Date,9,2) day
 from employee;

select *
from employee
where substr(hire_date,1,4) = '2018' and dept_id = 'sys';

-- (3) left(문자열, 갯수)
select left("안녕하쇼. 홍길동",5) "left";
select right("안녕하쇼. 홍길동",3) "right";

select left(curdate(),4);

-- 2018년도에 입사한 모든 사원 조회

select * from employee
where left(hire_date,4) = "2018";

select * from employee
where left(hire_date,4) between 2015 and 2017;

select emp_id, emp_name,hire_date, right(phone,4) phone
, salary from employee;

-- (4) upper(문자열), lower(문자열) : 대소문자

select upper('welcomeToMySql'),lower('welcomeToMySql');

-- 사번, 사원명, 영어이름, 부서아이디, 이메일, 급여를 조회
-- 영어 이름은 전체 대문자, 부서 아이디는 전체 소문자, 이메일은 대문자
select emp_id, emp_name, upper(ifnull(eng_name,'smith')), lower(dept_id), upper(email), salary from employee;


-- (5) trim() : 공백 제거 

select trim("         AP"), trim("HP              "),trim("          W           P          ");

-- (6) format(문자열, 소수점자리) : 문자열 포멧

select format(131232,0) as format;
select format('131232',0) as format;


-- 사번, 사원명, 입사일, 폰번호, 급여, 보너스(급여의 20%)
-- 급여, 보너스는 소수점 없이 3자리 콤마로 구분

select 	emp_id, 
		emp_name, 
        hire_date, 
        phone, 
        format(ifnull(salary,0),0) salary, 
        format(ifnull(salary,0)*.2,0) bonus 
from employee
where left(hire_date,4) between 2016 and 2017
order by emp_id desc;



-- [날짜함수]
-- curdate() : 현재 날짜(년, 월, 일)
-- sysdate(), now() : 현재 날짜(년, 월, 일, 시, 분, 초)

select curdate(),sysdate(),now(); 

-- [형변환 함수]
-- cast(변환시킬 값, 변환타입)
-- convert(변환시킬 값 as 변환타입)

select 1234 as number,cast(1234 as char) as string;
select '1234' as string,cast('1234' as signed integer) as number;
select '2025-23-07' as string, cast('20250330' as date);
select now() as date,
 cast(cast(now() as char) as date), 
 cast(cast(now() as char) as datetime) as date
 , cast(curdate() as datetime);

select '12345' as string,
		cast('12345' as signed int) as "int",
		cast('12345' as unsigned int) as "un int",
		cast('123.45' as decimal(10,2)) as "decimal";
		
        
-- [문자 치환 함수]
-- replace(문자열, old, new)

select '홍-길-동'as old, replace(curdate(),"-",""); 

-- 사원 ㅌㅔ이블의 사번, 사원명, 입사일, 퇴사일, 부서아이디, 폰번호, 급여
-- 급여 출력시 3자리 콤마(,) 구분
select 	emp_id,
		emp_name, 
        replace(hire_date,"-","/") 얼음, 
        replace(ifnull(retire_date,curdate()),"-","/") "난 이게임을 해봤어요",
        dept_id "그런놈이 여길 왜 기어들어와!", 
        phone, 
        format(salary,0) 
from employee;


-- '20150101' 입력된 날짜를 기준으로 해당 날짜 이후에 입사한 사원들을 모두 조회
-- 모든 mysql 데이터베이스에서 적용 가능한형태로 작성
select *
from employee
where hire_Date >= cast('20150101' as date);

-- '20150101'~'20171231' 사이에 입사한 사원들을 모두 조회
-- 모든 mysql 데이터베이스에서 적용 가능한 형태로 작성

select *
from employee
where hire_date between cast('20150101' as date) and cast('20171231' as date);
