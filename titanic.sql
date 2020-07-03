-- Titanic Data Visualization
-----------------------------

-- titanic 데이터 생성
-- titanic.csv file import 

SELECT *
FROM titanic;

-- 좀 더 파악하기 쉽게 titanic2 생성하기

DROP TABLE titanic2;

CREATE TABLE titanic2 AS
SELECT passengerid
    ,CASE WHEN survived = 0 THEN '사망' ELSE '생존' END survived
    ,TO_CHAR(pclass)||'등급' pclass, name
    ,DECODE(sex, 'male', '남성', 'female', '여성', '없음') gender
    ,age, sibsp, parch, ticket, fare, cabin
    ,CASE embarked WHEN 'C' THEN '프랑스-셰르부르'
                   WHEN 'Q' THEN '아일랜드-퀸즈타운'
                   WHEN 'S' THEN '영국-사우샘프턴'
                   ELSE ''
     END embarked
FROM titanic
ORDER BY 1;


SELECT *
FROM titanic2;


--1) 성별, 생존/사망자 수 조회

SELECT gender, survived, COUNT(*) cnt
FROM titanic2
GROUP BY gender, survived
ORDER BY 1, 2;


-- 2) 성별, 생존/사망자 수와 비율

SELECT gender, survived, cnt,
       ROUND(cnt / SUM(cnt) OVER
       (PARTITION BY gender
       ORDER BY gender), 2) 비율
FROM (SELECT gender, survived, COUNT(*) cnt
      FROM titanic2
      GROUP BY gender, survived
      ) t;
      
      
-- 3) 등급별 생존/사망자 수


SELECT pclass, survived, COUNT(*) cnt
FROM titanic2
GROUP BY pclass, survived
ORDER BY 1, 2;


-- 4) 등급별 생존/사망자 수와 비율

SELECT pclass, survived, cnt,
       ROUND(cnt / SUM(cnt) OVER
       (PARTITION BY pclass
       ORDER BY pclass), 2) 비율
FROM (SELECT pclass, survived, COUNT(*) cnt
      FROM titanic2
      GROUP BY pclass, survived
      );
      
-- 5) 연령대별 생존/사망자 수

SELECT CASE WHEN age BETWEEN 1 AND 9 THEN '(1) 10대 이하'
            WHEN age BETWEEN 10 AND 19 THEN '(2) 10대'
            WHEN age BETWEEN 20 AND 29 THEN '(3) 20대'
            WHEN age BETWEEN 30 AND 39 THEN '(4) 30대'
            WHEN age BETWEEN 40 AND 49 THEN '(5) 40대'
            WHEN age BETWEEN 50 AND 59 THEN '(6) 50대'
            WHEN age BETWEEN 60 AND 69 THEN '(7) 60대'
            ELSE '(8) 70대 이상' END ages
       ,survived, COUNT(*)
FROM titanic2
GROUP BY
   CASE WHEN age BETWEEN 1 AND 9 THEN '(1) 10대 이하'
        WHEN age BETWEEN 10 AND 19 THEN '(2) 10대'
        WHEN age BETWEEN 20 AND 29 THEN '(3) 20대'
        WHEN age BETWEEN 30 AND 39 THEN '(4) 30대'
        WHEN age BETWEEN 40 AND 49 THEN '(5) 40대'
        WHEN age BETWEEN 50 AND 59 THEN '(6) 50대'
        WHEN age BETWEEN 60 AND 69 THEN '(7) 60대'
        ELSE '(8) 70대 이상' END
        ,survived
ORDER BY 1, 2;

-- 70대 이상 인원이 너무 많다...?

SELECT age
FROM titanic2
ORDER BY 1 DESC; -- NULL 값 제거 필요

SELECT age
FROM titanic2
ORDER BY 1; -- 나이가 1 이하인 것도 존재함!


-- NULL 값을 '알수없음' 으로 분류 

SELECT CASE WHEN age BETWEEN 0 AND 9 THEN '(1) 10대 이하'
            WHEN age BETWEEN 10 AND 19 THEN '(2) 10대'
            WHEN age BETWEEN 20 AND 29 THEN '(3) 20대'
            WHEN age BETWEEN 30 AND 39 THEN '(4) 30대'
            WHEN age BETWEEN 40 AND 49 THEN '(5) 40대'
            WHEN age BETWEEN 50 AND 59 THEN '(6) 50대'
            WHEN age BETWEEN 60 AND 69 THEN '(7) 60대'
            WHEN age >= 70             THEN '(8) 70대 이상'
            ELSE '(9) 알수없음'
        END ages
       ,survived, COUNT(*)
FROM titanic2
GROUP BY
   CASE WHEN age BETWEEN 0 AND 9 THEN '(1) 10대 이하'
        WHEN age BETWEEN 10 AND 19 THEN '(2) 10대'
        WHEN age BETWEEN 20 AND 29 THEN '(3) 20대'
        WHEN age BETWEEN 30 AND 39 THEN '(4) 30대'
        WHEN age BETWEEN 40 AND 49 THEN '(5) 40대'
        WHEN age BETWEEN 50 AND 59 THEN '(6) 50대'
        WHEN age BETWEEN 60 AND 69 THEN '(7) 60대'
        WHEN age >= 70             THEN '(8) 70대 이상'
        ELSE '(9) 알수없음'
    END
    ,survived
ORDER BY 1, 2;


-- 6) 연령대, 성별, 생존/사망자 수 조회


SELECT CASE WHEN age BETWEEN 0 AND 9 THEN '(1) 10대 이하'
            WHEN age BETWEEN 10 AND 19 THEN '(2) 10대'
            WHEN age BETWEEN 20 AND 29 THEN '(3) 20대'
            WHEN age BETWEEN 30 AND 39 THEN '(4) 30대'
            WHEN age BETWEEN 40 AND 49 THEN '(5) 40대'
            WHEN age BETWEEN 50 AND 59 THEN '(6) 50대'
            WHEN age BETWEEN 60 AND 69 THEN '(7) 60대'
            WHEN age >= 70             THEN '(8) 70대 이상'
            ELSE '(9) 알수없음'
        END ages
       ,gender, survived, COUNT(*)
FROM titanic2
GROUP BY
   CASE WHEN age BETWEEN 0 AND 9 THEN '(1) 10대 이하'
        WHEN age BETWEEN 10 AND 19 THEN '(2) 10대'
        WHEN age BETWEEN 20 AND 29 THEN '(3) 20대'
        WHEN age BETWEEN 30 AND 39 THEN '(4) 30대'
        WHEN age BETWEEN 40 AND 49 THEN '(5) 40대'
        WHEN age BETWEEN 50 AND 59 THEN '(6) 50대'
        WHEN age BETWEEN 60 AND 69 THEN '(7) 60대'
        WHEN age >= 70             THEN '(8) 70대 이상'
        ELSE '(9) 알수없음'
    END
    ,gender, survived
ORDER BY 1, 3, 2;


-- 6) 형제, 배우자 수별, 부모자식수별 생존/사망자수 조회 

SELECT sibsp, parch, survived, COUNT(*)
FROM titanic2
GROUP BY sibsp, parch, survived
ORDER BY 1, 2, 3;



