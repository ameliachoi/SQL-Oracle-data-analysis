-- fine_dust data analysis
--------------------------

-- create 'fine_dust' table

CREATE TABLE fine_dust (
gu_name VARCHAR2(50) NOT NULL, -- 구 이름
mea_station VARCHAR2(30) NOT NULL, -- 측정소
mea_date DATE NOT NULL, -- 측정일자
pm10 NUMBER, -- 미세먼지 농도
pm25 NUMBER -- 초미세먼지 농도
);

ALTER TABLE fine_dust
ADD CONSTRAINTS fine_dust_pk PRIMARY KEY (gu_name, mea_station, mea_date);

-- create 'fine_dust_standard' table


CREATE TABLE fine_dust_standard (
org_name VARCHAR2(50) NOT NULL, -- 기관 명
std_name VARCHAR2(30) NOT NULL, -- 미세먼지 기준
pm10_start NUMBER,
pm10_end NUMBER,
pm25_start NUMBER,
pm25_end NUMBER
);

ALTER TABLE fine_dust_standard
ADD CONSTRAINTS fine_dust_standard_pk PRIMARY KEY (org_name, std_name);


-- 데이터 입력
-- fine_dust_insert.sql


-- 1) 월간 미세먼지와 초미세먼지의 최소, 최대, 평균값 구하기
-- 월간 : fine_dust의 mea_date를 월로 변환 --> TO_CHAR(mea_date, 'yyyy-mm')
-- 집계 함수 사용

SELECT TO_CHAR(a.mea_date, 'YYYY-MM') months
    ,ROUND(MIN(a.pm10), 0) pm10_min
    ,ROUND(MAX(a.pm10), 0) pm10_max
    ,ROUND(AVG(a.pm10), 0) pm10_avg
    ,ROUND(MIN(a.pm25), 0) pm25_min
    ,ROUND(MAX(a.pm25), 0) pm25_max
    ,ROUND(AVG(a.pm25), 0) pm25_avg
FROM fine_dust a
GROUP BY TO_CHAR(a.mea_date, 'YYYY-MM')
ORDER BY 1;


-- 0값 제외하고 보기

SELECT TO_CHAR(a.mea_date, 'YYYY-MM') months
    ,ROUND(MIN(a.pm10), 0) pm10_min
    ,ROUND(MAX(a.pm10), 0) pm10_max
    ,ROUND(AVG(a.pm10), 0) pm10_avg
    ,ROUND(MIN(a.pm25), 0) pm25_min
    ,ROUND(MAX(a.pm25), 0) pm25_max
    ,ROUND(AVG(a.pm25), 0) pm25_avg
FROM fine_dust a
WHERE pm10 > 0 AND pm25 > 0
GROUP BY TO_CHAR(a.mea_date, 'YYYY-MM')
ORDER BY 1;


-- 2) 월 평균 미세먼지 현황
-- 상태 값 fine_dust_standard table에서 확인


SELECT *
FROM fine_dust_standard;


SELECT TO_CHAR(a.mea_date, 'YYYY-MM') months
    ,ROUND(AVG(a.pm10), 0) pm10_avg
    ,ROUND(AVG(a.pm25), 0) pm25_avg
FROM fine_dust a
WHERE pm10 > 0 AND pm25 > 0
GROUP BY TO_CHAR(a.mea_date, 'YYYY-MM')
ORDER BY 1;

-- 월별 평균 값을 미세먼지 기준 테이블의 start와 end 값 사이에 있는 지 비교 
-- 해당 쿼리를 서브쿼리 (inline view) 로 사용 


SELECT a.months
    ,a.pm10_avg
    ,(SELECT b.std_name
      FROM fine_dust_standard b
      WHERE b.org_name = 'WHO'
      AND a.pm10_avg BETWEEN b.pm10_start AND b.pm10_end
      ) "미세먼지 상태"
    ,a.pm25_avg
    ,(SELECT b.std_name
      FROM fine_dust_standard b
      WHERE b.org_name = 'WHO'
      AND a.pm25_avg BETWEEN b.pm25_start AND b.pm25_end
      ) "초미세먼지 상태"
FROM (
    SELECT TO_CHAR(a.mea_date, 'YYYY-MM') months
    ,ROUND(AVG(a.pm10), 0) pm10_avg
    ,ROUND(AVG(a.pm25), 0) pm25_avg
    FROM fine_dust a
    WHERE pm10 > 0 AND pm25 > 0
    GROUP BY TO_CHAR(a.mea_date, 'YYYY-MM')
    ) a
ORDER BY 1;