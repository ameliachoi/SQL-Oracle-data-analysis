-- traffic accident data analysis
----------------------------------
-- create 'traffic_accident' table

CREATE TABLE traffic_accident (
year NUMBER NOT NULL,
trans_type VARCHAR2(30) NOT NULL, -- 교통수단
total_acct_num NUMBER, -- 사고 발생 건수 
death_person_num NUMBER
);

ALTER TABLE traffic_accident
ADD CONSTRAINTS traffic_accident_pk PRIMARY KEY (year, trans_type);


-- traffice_accident 데이터 입력
-- traffic_accident_insert.sql

SELECT *
FROM traffic_accident;


-- 1) 연도, 교통수단별 총 사고건수 조회 
-- 집계 쿼리 사용함 

SELECT year
       ,trans_type
       ,SUM(total_acct_num)
       ,SUM(death_person_num)
FROM traffic_accident
WHERE 1=1
GROUP BY year, trans_type
ORDER BY 1,2;

-- 원하는 결과를 얻었지만 결과 row가 너무 많아 파악하기가 어려움  
-- 개별년도별이 아닌 년대 별로 다시 집계 

SELECT CASE WHEN year BETWEEN 1980 AND 1989 THEN '1980년대'
            WHEN year BETWEEN 1990 AND 1999 THEN '1990년대'
            WHEN year BETWEEN 2000 AND 2009 THEN '2000년대'
            WHEN year BETWEEN 2010 AND 2019 THEN '2010년대'
       END AS years
    ,trans_type
    ,SUM(total_acct_num) 사고건수
FROM traffic_accident
WHERE 1=1
GROUP BY CASE WHEN year BETWEEN 1980 AND 1989 THEN '1980년대'
              WHEN year BETWEEN 1990 AND 1999 THEN '1990년대'
              WHEN year BETWEEN 2000 AND 2009 THEN '2000년대'
              WHEN year BETWEEN 2010 AND 2019 THEN '2010년대'
         END, trans_type
ORDER BY 1,2;


-- 2) 연대별 교통사고 추이 분석
-- 교통사고 유형을 row로, 연대를 column으로 두고 교통사고 건수 조회
-- 1980년대 발생한 교통사고 총 건수를 컬럼으로 만드려면?

-- case when year between 1980 and 1989 then total_acct_num else 0 end

SELECT trans_type
    ,CASE WHEN year BETWEEN 1980 AND 1989 THEN total_acct_num ELSE 0 END "1980년대"
    ,CASE WHEN year BETWEEN 1990 AND 1999 THEN total_acct_num ELSE 0 END "1990년대"
    ,CASE WHEN year BETWEEN 2000 AND 2009 THEN total_acct_num ELSE 0 END "2000년대"
    ,CASE WHEN year BETWEEN 2010 AND 2019 THEN total_acct_num ELSE 0 END "2010년대"
FROM traffic_accident
WHERE 1=1
ORDER BY trans_type;

-- row에 0을 지우고 합치는 방법 

SELECT trans_type
    ,sum(CASE WHEN year BETWEEN 1980 AND 1989 THEN total_acct_num ELSE 0 END) "1980년대"
    ,sum(CASE WHEN year BETWEEN 1990 AND 1999 THEN total_acct_num ELSE 0 END) "1990년대"
    ,sum(CASE WHEN year BETWEEN 2000 AND 2009 THEN total_acct_num ELSE 0 END) "2000년대"
    ,sum(CASE WHEN year BETWEEN 2010 AND 2019 THEN total_acct_num ELSE 0 END) "2010년대"
FROM traffic_accident
WHERE 1=1
GROUP BY trans_type
ORDER BY trans_type;


-- 3) 교통수단별 가장 많은 사망자 수가 발생한 연도 구하기
-- 사망자 수 -> death_person_num 
-- 교통수단별 가장 많은 사망자 수 trans_type을 group by, max(death_person_num)

SELECT trans_type
       ,MAX(death_person_num) death_per
FROM traffic_accident
GROUP BY trans_type;

-- 여기서 확장하여, 연도를 구하기
-- 교통수단 별 가장 많은 사망자 수를 교통수단별 사망자 수가 같은 건을 구하면?
-- 가장 많은 사망자 수가 발생한 연도를 구할 수 잇음 
-- traffic_accident join --> 서브 쿼리 사용 

SELECT a.*
FROM traffic_accident a
    ,(SELECT trans_type
             ,MAX(death_person_num) death_per
      FROM traffic_accident
      GROUP BY trans_type
      ) b
WHERE a.trans_type = b.trans_type
AND a.death_person_num = b.death_per;
      

