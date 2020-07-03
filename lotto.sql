-- lotto data analysis
----------------------
-- create 'lotto_master' table

CREATE TABLE lotto_master (
seq_no NUMBER NOT NULL, -- 로또회차
draw_date DATE, -- 추첨일
num1 NUMBER,
num2 NUMBER,
num3 NUMBER,
num4 NUMBER,
num5 NUMBER,
num6 NUMBER,
bonus NUMBER
);

-- create 'lotto_detail' table

CREATE TABLE lotto_detail (
seq_no NUMBER NOT NULL,
rank_no NUMBER NOT NULL,  -- 등수
win_person_no NUMBER, -- 당첨자수
win_money NUMBER -- 1인당 당첨금액
);

ALTER TABLE lotto_detail
ADD CONSTRAINT lotto_detail_pk PRIMARY KEY (seq_no, rank_no); -- primary key 참조

-- lotto_data_insert.sql 실행하기 

-- lotto_master, lotto_detail table 확인

select *
from lotto_master
order by 1;

select *
from lotto_detail
order by 1, 2;

-- 1) 중복 번호 조회
-- num1 컬럼에 대해 전체 회에서 중복 번호는?
-- 집계쿼리 사용하기

select num1, count(*)
from lotto_master
group by num1
order by 1;

-- num1 ~ num6 컬럼에 대해 전체 회에서 중복 번호는?

select num1, num2, num3, num4, num5, num6, count(*)
from lotto_master
group by num1, num2, num3, num4, num5, num6
having count(*) > 1 -- 1회 이상이면 중복 번호가 있는 것
order by 1, 2, 3, 4, 5, 6;

-- 2) 가장 많이 당첨된 번호 조회
-- num1 컬럼에 대해 전체 회에서 가장 많이 당첨된 번호는?

select num1 lotto_num, count(*) CNT
from lotto_master
group by num1
order by 2 DESC;

-- num1과 num2 컬럼 통틀어 가장 많이 당첨된 번호는?

select num1 lotto_num, count(*) CNT
from lotto_master
group by num1
UNION ALL
select num2 lotto_num, count(*) CNT
from lotto_master
group by num2
order by 2 DESC; -- 번호가 num1, 2별로 따로 집계되어 있어서 합계가 필요

-- 서브 쿼리 이용하기

select lotto_num, sum(CNT) as CNT
from (select num1 lotto_num, count(*) CNT
      from lotto_master
      group by num1
      UNION ALL
      select num2 lotto_num, count(*) CNT
      from lotto_master
      group by num2
      )
group by lotto_num
order by 2 DESC;

-- num1 ~ num6 컬럼 통틀어 가장 많이 당첨된 번호는?

select lotto_num, sum(CNT) as CNT
from (select num1 lotto_num, count(*) CNT
      from lotto_master
      group by num1
      UNION ALL
      select num2 lotto_num, count(*) CNT
      from lotto_master
      group by num2
      UNION ALL
      select num3 lotto_num, count(*) CNT
      from lotto_master
      group by num3
      UNION ALL
      select num4 lotto_num, count(*) CNT
      from lotto_master
      group by num4
      UNION ALL
      select num5 lotto_num, count(*) CNT
      from lotto_master
      group by num5
      UNION ALL
      select num6 lotto_num, count(*) CNT
      from lotto_master
      group by num6
      )
group by lotto_num
order by 2 DESC;

-- 3) 가장 많은 당첨금이 나온 회차와 번호, 금액 조회
-- 가장 많은 당첨금? -> 1등
-- 1등은 lotto_detail의 rank_no = 1
-- 1인당 당첨 금액 --> lotto_detail의 win_money
-- 해당 로또 번호는 lotto_master에서 join
--> 두 테이블을 조인하고, 1등을 구한 다음 당첨금액 순으로 내림차순 정렬


select a.seq_no
       ,a.draw_date -- 회차
       ,b.win_person_no 
       ,b.win_money -- 금액 
       ,a.num1, a.num2, a.num3, a.num4, a.num5, a.num6, a.bonus -- 번호 
from lotto_master a
     ,lotto_detail b
where a.seq_no = b.seq_no
and b.rank_no = 1
order by b.win_money DESC;







