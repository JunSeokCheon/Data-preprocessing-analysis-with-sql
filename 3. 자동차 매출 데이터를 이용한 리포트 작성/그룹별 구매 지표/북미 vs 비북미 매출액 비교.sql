-- 북미(USA, Canada) vs 비북미 매출액 비교
-- CASE WHEN은 조건에 따라 원하는 결과를 출력하는 구문인데, 이것을 이용해 북미와 비북미 지역으로 구분합니다.
SELECT CASE WHEN COUNTRY IN ('USA', 'Canada') THEN "North America" ELSE "Others" END AS COUNTRY_GAP
FROM CLASSICMODELS.CUSTOMERS;

-- 우리가 구해야 할 것은 북미와 비북미 지역의 매출을 구하는 것으로, 위에서 구한 매출을 구하는 쿼리를 조금만 수정하면 됩니다.
-- 여기서 COUNTRY와 CITY를 CASE WHEN 구문으로 변경하면 북미, 비북미의 매출을 구분회 조회하면 됩니다.
SELECT CASE WHEN C.COUNTRY IN ("USA", "Canada") THEN "North America" ELSE "Others" END AS COUNTRY_GAP,
SUM(B.PRICEEACH * B.QUANTITYORDERED) AS SALES
FROM CLASSICMODELS.ORDERS A
LEFT JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP BY 1
ORDER BY 2 DESC;