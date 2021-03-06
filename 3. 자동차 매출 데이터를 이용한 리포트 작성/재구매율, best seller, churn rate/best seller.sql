-- Best Seller
-- 다른 나라에 비해 클라이언트 시장이 가장 큰 것으로 파악되었습니다. 큰 시장에 집중하기 위해 좀 더 디테일한 내용을 추출하고자 합니다.
-- 미국의 TOP 5 제품명을 추출하기 위해서 필요한 테이블은 총 4개 입니다.
-- 결합해야 할 테이블이 많은 뿐 로직이 복잡하진 않아 ERD를 보고 충분히 쉽게 결합할 수 있습니다.
-- 쿼리가 너무 길어진다면 아래와 같이 테이블로 데이터를 생성 후, 한번 더 쿼리를 작성해 추출하는 것이 좋습니다.
CREATE TABLE CLASSICMODELS.PRODUCT_SALES AS
SELECT D.PRODUCTNAME,
SUM(C.QUANTITYORDERED * C.PRICEEACH) SALES
FROM CLASSICMODELS.ORDERS A
LEFT JOIN CLASSICMODELS.CUSTOMERS B
ON A.CUSTOMERNUMBER = B.CUSTOMERNUMBER
LEFT JOIN CLASSICMODELS.ORDERDETAILS C
ON A.ORDERNUMBER = C.ORDERNUMBER
LEFT JOIN CLASSICMODELS.PRODUCTS D
ON C.PRODUCTCODE = D.PRODUCTCODE
WHERE B.COUNTRY = 'USA'
GROUP BY 1;

SELECT *
FROM
(SELECT *,
ROW_NUMBER() OVER(ORDER BY SALES DESC) RNK
FROM CLASSICMODELS.PRODUCT_SALES) A
WHERE RNK <= 5
ORDER BY RNK;