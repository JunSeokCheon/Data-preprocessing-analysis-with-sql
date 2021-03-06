-- 구매자 수, 구매 건수
-- ERD를 보면 ORDERS 테이블에 판매일(ORDERDATE), 구매 고객 번호(CUSTOMERNUMBER)가 존재합니다. 그래서 판매일로 그룹핑한 후 고객 번호를 COUNT 해주면 됩니다.
-- 주의할 점은 구매자 수, 구매 건수를 산출할 때는 보통 UNIQUE하게 필드를 COUNT 해줘야 합니다.
SELECT ORDERDATE,
COUNT(DISTINCT CUSTOMERNUMBER) N_PURCHASE,
COUNT(ORDERNUMBER) N_ORDER
FROM CLASSICMODELS.ORDERS
GROUP BY 1
ORDER BY 1;

-- 월별 구매자 수, 구매 건수
SELECT SUBSTR(ORDERDATE,1,7),
COUNT(DISTINCT CUSTOMERNUMBER) N_PURCHASE,
COUNT(ORDERNUMBER) N_ORDER
FROM CLASSICMODELS.ORDERS
GROUP BY 1
ORDER BY 1;

-- 년별 구매자 수, 구매 건수
SELECT SUBSTR(ORDERDATE,1,4),
COUNT(DISTINCT CUSTOMERNUMBER) N_PURCHASE,
COUNT(ORDERNUMBER) N_ORDER
FROM CLASSICMODELS.ORDERS
GROUP BY 1
ORDER BY 1;


