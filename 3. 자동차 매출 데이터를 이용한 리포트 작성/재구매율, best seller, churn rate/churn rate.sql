-- churn rate(%)
-- churn rate란 고객 중 얼마나 많은 고객이 비활동 고객으로 전환되었는지를 의미하는 지표입니다. 고객 1명을 획득하는 비용을 Acquisition Cost라고 부릅니다.
-- 기업들은 신규 고객을 유치하는데 생각보다 큰 비용을 사용하기 때문에 한 번 획득한 고객을 Active로 유지하는 것은 굉장히 중요한 일입니다.
-- chrun rate를 구하기 전에 chrun에 대한 정의가 필요한데, 일반적으로 churn은 다음과 같이 정의합니다.
-- churn : max(구매일, 접속일) 이후 일정 기간(ex. 3개월) 구매, 접속하지 않는 상태


-- 1) Churn Rate(%) 구하기
-- classicmodels를 이용한 churn rate를 구해보겠습니다. 먼저 orders 테이블에서 마지막 구매일을 확인합니다.
SELECT MAX(ORDERDATE) MX_ORDER
FROM CLASSICMODELS.ORDERS;

-- 2005-06-01일을 기준으로 각 고객의 마지막 구매일이 며칠 소요되었는지를 구해보겠습니다. 
-- 먼저 각 고객의 마지막 구매일을 구합니다.
SELECT CUSTOMERNUMBER,
MAX(ORDERDATE) MX_ORDER
FROM CLASSICMODELS.ORDERS
GROUP BY 1;

-- 다음으로 2005-06-01 기준으로 며칠이 소요되었는지 계산합니다. 계산에는 DATEDIFF() 함수를 사용합니다.
SELECT CUSTOMERNUMBER,
MX_ORDER, '2005-06-01',
DATEDIFF('2005-06-01', MX_ORDER) DIFF
FROM
(SELECT CUSTOMERNUMBER, 
MAX(ORDERDATE) MX_ORDER
FROM CLASSICMODELS.ORDERS
GROUP BY 1) BASE;

-- DIFF는 MX_ORDER와 END_POINT의 차이를 나타냅니다. 우리는 DIFF가 90일 이상인 경우를 Churn이라고 가정하겠습니다.
SELECT *,
CASE WHEN DIFF >= 90 THEN 'CHURN' ELSE 'NON-CHURN' END CHURN_TYPE
FROM
(SELECT CUSTOMERNUMBER, 
MX_ORDER, "2005-06-01",
DATEDIFF("2005-06-01", MX_ORDER) DIFF
FROM
(SELECT CUSTOMERNUMBER,
MAX(ORDERDATE) MX_ORDER
FROM CLASSICMODELS.ORDERS
GROUP BY 1) BASE) BASE;

-- DIFF가 90이상이면 CHURN, 그렇지 않은 경우 NON-CHURN으로 구분했습니다. 이제 CHRUN RATE(%)를 구해봅니다.
SELECT CASE WHEN DIFF >= 90 THEN "CHURN" ELSE "NON-CHRUN" END CHURN_TYPE,
COUNT(DISTINCT CUSTOMERNUMBER) N_CUS
FROM
(SELECT CUSTOMERNUMBER, 
MX_ORDER, "2005-06-01" END_POINT,
DATEDIFF("2005-06-01", MX_ORDER) DIFF
FROM
(SELECT CUSTOMERNUMBER, 
MAX(ORDERDATE) MX_ORDER
FROM CLASSICMODELS.ORDERS
GROUP BY 1) BASE) BASE
GROUP BY 1;
-- CHRUN RATE는 69/(69+29) = 0.70으로, 약 70%로 높은 수치로 나타납니다.

-- 2) Churn 고객이 가장 많이 구매한 Productline
-- 앞에서 Churn rate와 Churn 고객을 구해보았습니다. 
-- 이제 Churn 고객의 특성을 파악해보려고 하는데, 먼저 churn 고객은 어떤 카테고리의 상품을 많이 구매했는지 파악해보겠습니다.
-- 고객별 Churn Table을 생성하겠습니다.
CREATE TABLE CLASSICMODELS.CHRUN_LIST AS
SELECT CASE WHEN DIFF >= 90 THEN "CHURN" ELSE "NON-CHURN" END CHURN_TYPE,
CUSTOMERNUMBER
FROM
(SELECT CUSTOMERNUMBER,
MX_ORDER, "2005-06-01" END_POINT,
DATEDIFF("2005-06-01", MX_ORDER) DIFF
FROM
(SELECT CUSTOMERNUMBER,
MAX(ORDERDATE) MX_ORDER
FROM CLASSICMODELS.ORDERS
GROUP BY 1) BASE) BASE;

-- 다음으로 ORDERDETAILS - ORDERS - PRODUCTS를 결합해 PRODUCTLINE별 구매주 수를 구해보도록 하겠습니다.
SELECT C.PRODUCTLINE,
COUNT(DISTINCT B.CUSTOMERNUMBER) CLI
FROM CLASSICMODELS.ORDERDETAILS A
LEFT JOIN CLASSICMODELS.ORDERS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT JOIN CLASSICMODELS.PRODUCTS C
ON A.PRODUCTCODE = C.PRODUCTCODE
GROUP BY 1;

-- 우리가 구하고 싶은 것은 CHURN TYPE, PRODUCT LINE별 구매자 수입니다.
-- 앞에서 생성한 CLASSICMODELS.CHURN_LIST를 결합해 CHURN TYPE으로 데이터를 한번 더 나눠줘야 합니다.
SELECT D.CHURN_TYPE,
C.PRODUCTLINE,
COUNT(DISTINCT B.CUSTOMERNUMBER) CLI
FROM CLASSICMODELS.ORDERDETAILS A
LEFT JOIN CLASSICMODELS.ORDERS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT JOIN CLASSICMODELS.PRODUCTS C
ON A.PRODUCTCODE = C.PRODUCTCODE
LEFT JOIN CLASSICMODELS.CHURN_LIST D
ON B.CUSTOMERNUMBER = D.CUSTOMERNUMBER
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

-- CHURN TYPE과 PRODUCTLINE과 큰 연관이 없는 것처럼 보입니다.