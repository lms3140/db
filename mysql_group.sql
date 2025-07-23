/*
	그룹(집계) 함수 : sum(), avg(), min(), max(), count() 등
    group by 절 - 그룹함수를 적용하기 위한 정의 
    having 절 - 그룹함수에서 사용하는 조건절
*/

-- (1) sum(숫자) : 전체 총합을 구하는 함수 
-- 사원들 전체의 급여 총액을 조회
select * from employee;

select 	concat(format(sum(salary),0)," $") as 총합,
		concat(format(avg(salary),0)," $") as 평균,
		concat(format(min(salary),0)," $") as 최소,
		concat(format(max(salary),0)," $") as 최대 
from employee;

select 	dept_id,
		avg(salary) 
from employee 
group by dept_id;

-- 정보시스템(sys) 부서 전체의 급여 총액과 평균
select 	dept_id,
		concat("$",format(floor(sum(salary)),0)) as "급여 총액", 
		concat("$",format(floor(avg(salary)),0)) as "급여 평균" 
from employee 
where dept_id = 'sys'
group by dept_id;

-- (3) max(숫자) : 최대값 구하는 함수
-- 가장 높은 급여를 받는 사원의 급여를 조회
select max(salary) from employee;


-- (4) min(숫자) : 최소값을 구하는 함수
-- 가장 낮은 급여를 받는 사원의 급여를 조회

select min(salary) from employee;

-- 사원들의 총 급여, 평균급여, 최대급여, 최소급여

select 	concat(format(sum(salary),0)," $") as 총합,
		concat(format(avg(salary),0)," $") as 평균,
		concat(format(min(salary),0)," $") as 최소,
		concat(format(max(salary),0)," $") as 최대 
from employee;

-- (5) count(컬럼)

select  dept_id, count(dept_id)
from employee
group by dept_id;

-- 급여 컬럼의 row count
select count(salary) from employee;

-- 
desc employee;
select count(hire_date)-count(retire_date) as work, count(retire_date) as retired from employee;

select count(hire_date) as 재직사원
from employee
where retire_date is null;

select count(hire_date) as 입사자수
from employee
where left(hire_date,4) = 2015;

select count(*) as 부서
from employee
where dept_id = 'sys';

-- 가장 빠른 입사자, 가장 늦은 입사자

select min(hire_date) as "가장빠른 입사자", max(hire_date) as "가장늦은 입사자"
from employee;

-- 가장 빨리 입사한 사람의 정보를 조회

select *
from employee
where hire_date = (select min(hire_date) from employee);


-- [group by] : 그룹함수와 일반컬럼을 함께 사용할 수 있도록 함
-- ~별 
select dept_id, sum(salary), floor(avg(salary)), count(*), max(salary), min(salary)
from employee
group by dept_id;

select 	left(hire_date,4) 연도,
		count(*)"사원수", 
		format(sum(salary),0) "총 급여",
		format(floor(avg(salary)),0)"평균 급여", 
		format(max(salary),0) "최대급여",
		format(min(salary),0) "최소급여" 
from employee
group by left(hire_date,4);

-- [having] : 그룹함수를 적용한 결과에 조건을 추가
-- 부서별 총급여, 평균급여를 조회
-- 부서의 총 급여가 30000 이상인 부서만 출력

select left(hire_date,4) , sum(salary) 총급여 ,avg(salary) 평균급여 
from employee
where salary is not null
group by left(hire_date,4)
having sum(salary) >= 30000;

-- rollup 함수 : 리포팅을 위한 함수
-- 부서별 사원수, 총급여, 평균급여 조홰


-- rollup한 결과의 부서아이디를 추가
select 	ifnull(dept_id,"합계") 부서, 
		count(*) count, 
		format(sum(ifnull(salary,0)),0) 총급여 ,
		format(avg(ifnull(salary,0)),0) 평균급여 
from employee
group by dept_id with rollup;

select 	left(hire_date,4) 연도, 
		count(*) count, 
		format(sum(ifnull(salary,0)),0) 총급여 ,
		format(avg(ifnull(salary,0)),0) 평균급여 
from employee
group by left(hire_date,4) with rollup;

-- limit 함수 : 출력갯수 제한 함수

select *
from employee
limit 5;

-- 최대 급여 
select *
from employee
order by salary desc
limit 5;                                                  







































