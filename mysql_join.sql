/*
	조인(JOIN) : 두 개 이상의 테이블을 연동해서 sql을 실행
    ERD(Entity Relationship Diagrem) : 데이터베이스 구조도(설계도)
		- 데이터 모델링 : 정규화 과정
	ANSI SQL : 데이터베이스 시스템들의 표준 SQL
    조인 종류
    (1) cross join(cateisian) - 합집합 : 테이블들을들의 데이터 전체를 조인 테이블 10 * 10 
	(2) inner join(netural) - 교집합 : 두 개 이상의 테이블을 조인 연결 고리룰 통해 조인 실행
    (3) outer join - inner join + 선택한 테이블의 조인 제외 row 포함 
    (4) self join : 한 테이블을 두 개 테이블 처럼 조인해서 실행

*/

-- cross join
select *
from employee,department;

select count(*)
from employee corss join department;

select count(*)
from vacation;

select count(*)
from vacation,department,employee;

select count(*) 
from employee cross join department cross join vacation;

-- inner join
select *
from employee,department
where employee.dept_id = department.dept_id -- 이거 추가하면 inner임
order by emp_id;

-- inner join :ansi 
select *
from employee inner join department
on employee.dept_id = department.dept_id
order by emp_id;


-- 사원테이블, 부서테이블, 본부테이블 inner join

select *
from employee emp,department dept,unit
where emp.dept_id = dept.dept_id and dept.unit_id = unit.unit_id
order by emp.emp_id;

-- ansi inner join
select *
from employee emp inner join department dept on emp.dept_id = dept.dept_id inner join unit on dept.unit_id = unit.unit_id
order by emp.emp_id;

-- 사원테이블, 부서테이블, 본부테이블, 휴가테이블 inner join : ansi

select *
from employee emp
	inner join vacation v
    on emp.emp_id = v.emp_id
	inner join department dept
    on emp.dept_id = dept.dept_id
    inner join unit
	on unit.unit_id = dept.unit_id
order by emp.emp_id;

select *
from employee emp, department dept, unit, vacation v
where emp.emp_id = v.emp_id
		and emp.dept_id = dept.dept_id
        and dept.unit_id = unit.unit_id
order by emp.emp_id;
    
-- 모든 사원들의 사번, 사원명, 부서아이디, 부서명, 입사일, 급여를 조회

select emp.emp_id, emp.emp_name, emp.dept_id, dept.dept_name, emp.hire_date, concat("$",format(ifnull(emp.salary,0),0)) as salary
from employee emp, department dept
where emp.dept_id = dept.dept_id
order by emp.emp_id;

-- 영업부에 속한 사원들의 사번, 사원명, 입사일, 퇴사일, 폰번호, 급여, 부서아이디, 부서명 조회
select 	emp.emp_id 		as 사원, 
		emp.emp_name 	as 사원명, 
        emp.hire_date 	as 입사일, 
        emp.retire_date as 퇴사일, 
        emp.phone 		as 폰번호, 
        concat("$ ",format(ifnull(emp.salary,0),0)) as 급여,
        dept.dept_id 	as 부서아이디, 
        dept.dept_name 	as 부서명
from employee emp, department dept
where emp.dept_id = dept.dept_id 
	and dept.dept_name = "영업"
order by emp.emp_id;

-- 인사과에 속한 사원들 중에 휴가를 사용한 사원들의 내역 조회

select * from vacation;
select * from department;

select e.emp_id, e.emp_name, d.dept_name, v.*
from employee e,department d,vacation v
where e.dept_id = d.dept_id
	and e.emp_id = v.emp_id
    and d.dept_name = "인사"
order by e.emp_id;


-- 영업부서 사원의 사원명, 폰번호, 부서명, 휴가사용 이유 조회
-- 휴가 사용 이유가 '두통'인 사원, 소속본부 조회

select e.emp_name 사원명, e.phone 폰번호, d.dept_name 부서명,v.reason "휴가사용 이유",u.unit_name 소속본부
from employee e, department d, vacation v, unit u
where e.dept_id = d.dept_id
	and e.emp_id = v.emp_id
    and d.unit_id = u.unit_id
    and d.dept_name = "영업"
    and v.reason = "두통"
order by e.emp_id;

-- 2014년 부터 2016년까지 입사한 사원들 중에서 퇴사하지 않은 사원들의
-- 소속아이디, 사원명, 부서명, 입사일, 소속본부를 조회
-- 소속본부 기준으로 오름차순 정렬

select 	u.unit_id as 소속아이디, 
		e.emp_name as 사원명, 
		d.dept_name as 부서명, 
        e.hire_date as 입사일, 
        u.unit_name as 소속본부
from employee e, department d, unit u
where e.dept_id = d.dept_id
	and d.unit_id = u.unit_id
    and left(e.hire_date,4) between 2014 and 2016
    and e.retire_date is not null
order by u.unit_name;

-- 부서별 총급여, 평균급여, 총 휴가 사용일수를 조회
desc vacation;

select e.dept_id,sum(salary) from employee e group by e.dept_id;

select 	d.dept_name,
		concat("$ ",format(s.salary,0)) as 총급여,
		concat("$ ",format(floor(avg_salary),0)) as 평균급여, 
        sum(v.duration) as "총 휴가 일수"
from employee e, vacation v,department d,
        (select e.dept_id,sum(salary) as salary,
				avg(salary) as avg_salary 
		 from employee e 
         group by e.dept_id) s
where e.dept_id = d.dept_id
	and e.emp_id = v.emp_id
    and s.dept_id = e.dept_id
    
group by d.dept_name,s.salary,s.avg_salary
order by d.dept_name;


-- outer join : inner join + 조인에서 제외된 row(테이블 지정)
-- oracle 형식의 outer join은 사용불가, ansi sql 형식만 사용가능

-- select [컬럼리스트] 
-- from [테이블명1 테이블별칭] left/right outer join 테이블명2 [테이블 별칭]...
-- on [테이블명1.조인컬럼 = 테이블명2.조인컬럼]

-- 모든 부서의 부서아이디, 부서명, 본부명을 조회
select d.dept_id, d.dept_name, ifnull(u.unit_name,"협의중") as unit_name
from department d
	left outer join unit u
	on d.unit_id = u.unit_id
order by unit_name;



select u.unit_name, d.dept_name ,sum(v.duration)
from employee e 
	left outer join vacation v
		on e.emp_id = v.emp_id
	right outer join department d 
		on e.dept_id = d.dept_id
	left outer join unit u
		on d.unit_id = u.unit_id
group by u.unit_name,d.dept_name
order by u.unit_name desc;


-- 2017년도부터 2018년도까지 입사한 사원들의 사원명, 입사일, 연봉, 부서명 조회
-- 단, 퇴사한 사원들 제외
-- 소속본부를 모두 조회

select u.unit_name,e.emp_name, e.hire_date, e.salary, d.dept_name
from employee e, department d, unit u
where e.dept_id = d.dept_id
	and d.unit_id = u.unit_id
	and e.retire_date is null
order by u.unit_name;

select  e.emp_name, e.hire_date, e.salary, d.dept_name,u.unit_name
from employee e 
	inner join department d 
		on e.dept_id = d.dept_id
    left outer join unit u
		on d.unit_id = u.unit_id
where e.retire_date is null 
	and left(e.hire_date,4) between 2017 and 2018 
order by u.unit_name;


-- self join : 자기 자신의 테이블을 조인
-- self join은 서브쿼리 형태로 실행하는 경우가 대부분임
-- select [컬럼리스트] from [테이블1], [테이블2] where [테이블1.a] = [테이블2.a]
-- 사원테이블을 self join

select e.emp_id, e2.email
from employee e , employee e2
where e.emp_id = e2.emp_id;

show databases;
use hrdb2019;
select database();

select *
from employee e, department d
where e.dept_id = d.dept_id;

select *
from employee e left outer join department d
on e.dept_id = d.dept_id;
























