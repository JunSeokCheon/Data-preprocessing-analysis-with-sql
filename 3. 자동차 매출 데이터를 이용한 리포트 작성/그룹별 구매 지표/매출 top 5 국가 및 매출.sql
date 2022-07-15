-- 매출 Top 5 국가 및 매출
-- 먼저 국가별 매출을 모두 출력 후 매출이 높은 순위부터 등수를 매겨 상위 5개의 국가만 출력하면 됩니다. 그렇게 하기 위해 데이터의 값에 따라 등수를 매기는 함수가 필요합니다.
-- RANK, DENSE_RANK, ROW_NUMBER 함수가 있는데, 이들을 구분하는 점은 동률을 처리하는 방법이 다르다는 것입니다.
-- RANK는 동률을 모두 같은 등수로 처리한 후, 그 다음 등수를 동률의 수만큼 제외하고 메깁니다.
-- DENSE_RANK는 RANK와 동일하게 동률을 같은 등수로 처리하지만, 그 다음 등수를 동률의 수만큼 제외하지 않고 바로 다음 등수로 매깁니다.
-- ROW_NUMBER는 동률을 반영하지 않고, 동일한 등수는 존재하지 않고 모든 행은 다른 등수를 가집니다.
-- 우리는 앞에서 국가별 매출액을 구했는데, 이를 다른 이름의 테이블로 생성 후 매출에 따라 RANK를 매기면 우리가 원하는 TOP 5 국가를 산출할 수 있습니다.
CREATE TABLE CLASSICMODELS.STAT AS
SELECT C.COUNTRY,
SUM(PRICEEACH * QUANTITYORDERED) SALES
FROM CLASSICMODELS.ORDERS A
LEFT JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP BY 1
ORDER BY 2 DESC;

-- 위에서 생성한 테이블을 조회합니다.
SELECT * FROM CLASSICMODELS.STAT;

-- 생성된 테이블에서 DENSE_RANK를 이용해 매출액 등수를 매겨보겠습니다.
SELECT COUNTRY, SALES, DENSE_RANK() OVER(ORDER BY SALES DESC) RNK
FROM CLASSICMODELS.STAT;

-- 출력 결과를 테이블로 생성한 후 상위 5개의 국가를 추출하겠습니다.
CREATE TABLE CLASSICMODELS.STAT_RNK AS
SELECT COUNTRY, SALES, DENSE_RANK() OVER(ORDER BY SALES DESC) RNK
FROM CLASSICMODELS.STAT;

SELECT * FROM CLASSICMODELS.STAT_RNK
WHERE RNK BETWEEN 1 AND 5;

-- 우리가 원하는 결과가 출력하기 위해 2개의 테이블을 생성해 원하는 결과를 출력했습니다. 
-- 하지만 데이터를 조회할 때마다 이렇게 테이블을 생성한다면, DB에 금방 임시로 생성된 테이블로 가득해지고 데이터 관리가 힘들수가 있습니다.
-- SUBQUERY를 이용하면 위 과정을 하나의 쿼리로 처리가 가능합니다.
SELECT * FROM 
(SELECT COUNTRY, SALES, DENSE_RANK() OVER(ORDER BY SALES DESC) RNK
FROM
(SELECT C.COUNTRY, SUM(PRICEEACH*QUANTITYORDERED) SALES
FROM CLASSICMODELS.ORDERS A
LEFT JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP BY 1) A) A
WHERE RNK <= 5;