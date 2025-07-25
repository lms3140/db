/*
	서브 쿼리 (subQuery) : 메인쿼리에 다른 쿼리를 추가하여 실행하는 방식
    형식 : select	[컬럼리스트]	<--(스칼라쿼리	- scalarQuery) -절대 쓰지 마라-
		  from 	[테이블명]		<--(인라인 뷰	- inline view)
          where	[조건절]		<--(서브쿼리	- subQuery)
*/

use hrdb2019;

-- 정보 시스템 부서의 사원들을 모두 조회
-- 사번, 사원명, 부서아이디, 부서명, 급여 폰번호

select * from department;
select dept_id from department where dept_name = '정보시스템';


select emp_id, emp_name, dept_id, phone, salary
from employee
where dept_id = (select dept_id from department where dept_name = '정보시스템');

select dept_id, dept_name from department;

select 	emp_id, 
		emp_name, 
		dept_id, 
        (select dept_name from department where dept_name = '정보시스템') as dept_name, -- 권장하지 않음
        phone, 
        salary
from employee
where dept_id = (select dept_id from department where dept_name = '정보시스템');

-- 홍길동 사원이 속한 부서명을 조회
-- 조건절 비교하는 경우, 단일행 서브쿼리 
select dept_name
from department
where dept_id = (select dept_id from employee where emp_name = '홍길동'); 


-- 홍길동 사원의 휴가사용 내역을 조회

select begin_date, end_date, reason, duration
from vacation
where emp_id = 
	(select emp_id from employee where emp_name = "홍길동");

-- 제3본부에 속한 모든 부서를 조회

select dept_name
from department
where unit_id = (select unit_id from unit where unit_name = '제3본부');

select * from unit;
select * from department;

-- 급여가 가장 높은 사원의 정보를 조회

select *
from employee
where salary = (select max(salary) from employee);

select *
from employee
where salary = (select min(salary) from employee);

-- 가장 빨리 입사한 사원의 정보 출력
select *
from employee
where hire_date = (select max(hire_date) as hire_date from employee);

select *
from employee
where hire_date = (select min(hire_date) from employee);


select *
from employee
where dept_id in (	
				select dept_id
				from department
				where unit_id = (	
								select unit_id 
								from unit 
								where unit_name = '제3본부')
);

-- '제3본부' 에 속한 모든 사원들의 휴가 사용 내역 조회

select *
from vacation
where emp_id in (
	select emp_id
	from employee
	where dept_id in (	
					select dept_id
					from department
					where unit_id = (	
									select unit_id 
									from unit 
									where unit_name = '제3본부')
						)
	);

-- [인라인 뷰 : 메인쿼리의 테이블 자리에 들어가는 서브쿼리 형식]
-- [휴가를 사요용한 사원정보만]
-- 사원별 휴가사용 일수를 그룹핑하여, 사원아이디, 사원명, 입사일,연봉, 휴가사용일수를 조회해주세요

select e.emp_id, e.emp_name, e.hire_date, ifnull(e.salary,"협의중") as salary, ifnull(v.duration,0) as duration
from employee e left outer join (
	select emp_id, sum(duration) as duration
	from vacation
	group by emp_id
) v
on e.emp_id = v.emp_id;

-- 1. [2016~2017 년도 입사한 사원들의 정보 조회]
-- 2. 1번의 실행결과와 vaction 테이블을 조인하여 휴가사용 내역 출력
select *
from employee e, vacation v
where e.emp_id = v.emp_id 
and left(hire_date,4) between'2016' and '2017';

select *
from employee e,(select * from vacation)v
where e.emp_id = v.emp_id and left(hire_date,4) between'2016' and '2017';

select emp_name, v.*
from vacation v, (select emp_id, emp_name from employee where left(hire_date,4) between'2016' and '2017')e
where v.emp_id = e.emp_id;

-- 1. 부서별 총급여, 평균급여를 구하여 30000 이상인 부서의 테이블 조회
-- 2. 1번의 실행결과와 employee 테이블을 조인하여 사원아이디, 사원명, 급여, 부서아이디, 부서명, 부서별 총 급여,평균급여 출력

select dept_id,sum(salary) as total_salary, avg(salary) as avg_salary
from employee
group by dept_id
having sum(salary) >= 30000;

select e.emp_id, e.emp_name, e.salary, e.dept_id, d.dept_name, e2.total_salary, e2.avg_salary
from employee e left outer join (select dept_id,sum(salary) as total_salary, avg(salary) as avg_salary
								from employee
								group by dept_id
								having sum(salary) >= 30000
                                ) 
                                e2 on e.dept_id = e2.dept_id left outer join department d on d.dept_id = e2.dept_id;


/*
	테이블 결과 합치기 : union, union all -> 결국 쓸일이 잘 없음. 아예 멀찍이 다른 테이블이면 채택가능
    형식 > 쿼리1 실행 결과 union 쿼리2 실행결과 -> 겹치는건 없애고 출력
    형식 > 쿼리1 실행 결과 union all 쿼리2 실행결과 -> 중복출력
	실행결과 컬림이 동일해야함 ( 컬럼명, 데이터타입)
*/

-- 영업부, 정보시스템 부서의 사원아이디, 사원명, 급여, 부서아이디 조회
select emp_id,emp_name,salary,dept_id
from employee
where dept_id = (select dept_id from department where dept_name = "영업")
union all
select emp_id,emp_name,salary,dept_id
from employee
where dept_id = (select dept_id from department where dept_name = "영업")
union all
select emp_id,emp_name,salary,dept_id
from employee
where dept_id = (select dept_id from department where dept_name = "정보시스템")
order by dept_id;


/*
	논리적인 테이블: view(뷰), SQL을 실행하여 생성된 결과를 가상테이블로 정의
    뷰 생성 : create view [view 이름]
			as [SQL 정의];   
	뷰 삭제 : drop view [view 이름]
    뷰 생성시 일부 sql은 권한을 할당받아야함  - mysql, maria는 안해도됨      
*/

select *
from information_schema.views
where table_schema = 'hrdb2019';

create view view_salary_something 
as select e.emp_id, e.emp_name, e.salary, e.dept_id, d.dept_name, e2.total_salary, e2.avg_salary
from employee e join (select dept_id,sum(salary) as total_salary, avg(salary) as avg_salary
								from employee
								group by dept_id
								having sum(salary) >= 30000
                                ) 
                                e2 on e.dept_id = e2.dept_id join department d on d.dept_id = e2.dept_id;

-- 부서 총 급여가 30000 이상인 부서 테이블

select * from view_salary_something;

-- view 삭제
drop view view_salary_something;