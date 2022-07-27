-- 상품 분석
-- 서비스의 지표와 분위 수에 따른 주문 건수의 비중을 계산해보았습니다. 이제 재구매를 많이 하는 상품을 알아보고, 각 상품의 판매 특성에 대해 알아보겠습니다.
-- 먼저 재구매 비중이 높은 상품을 찾아 보고, 상품별 재구매 비중과 주문 건수를 계산하겠습니다.
SELECT PRODUCT_ID,
SUM(REORDERED)/SUM(1) REORDER_RATE,
COUNT(DISTINCT ORDER_ID) ORDER_COUNT
FROM INSTACART.ORDER_PRODUCTS__PRIOR
GROUP BY 1
ORDER BY 2 DESC;

-- 주문 건수가 10건 이하인 상품을 제외하고 확인해보겠습니다.
SELECT A.PRODUCT_ID,
SUM(REORDERED)/SUM(1) REORDER_RATE,
COUNT(DISTINCT ORDER_ID) ORDER_COUNT
FROM INSTACART.ORDER_PRODUCTS__PRIOR A
LEFT JOIN INSTACART.PRODUCTS B
ON A.PRODUCT_ID = B.PRODUCT_ID
GROUP BY 1
HAVING ORDER_COUNT > 10
ORDER BY ORDER_COUNT DESC;

-- 여기서 HAVING을 사용했는데, HAVING과 WHERE의 차이점에 대해 설명해보겠습니다. 
-- WHERE 절은 FROM에 위치한 테이블에만 조건을 걸 수있습니다. SELECT 문제서 새롭게 생성한 칼럼에 조건을 걸어야 하는 경우가 많은데, 이때 초급자분들은 SELECT에 WHERE 절로 조건을 거는 실수를 많이 합니다.
-- 이때 HAVING을 사용해서 그룹핑한 데이터에 조건을 생성하여 사용합니다.
-- 마지막으로 어떤 상품들이 재구매율이 높은지 보기 위해 PRODUCTS 테이블과 JOIN하여 상품명을 보면서 확인해보겠습니다.
SELECT A.PRODUCT_ID,
B.PRODUCT_NAME,
SUM(REORDERED)/SUM(1) REORDER_RATE,
COUNT(DISTINCT ORDER_ID) ORDER_COUNT
FROM INSTACART.ORDER_PRODUCTS__PRIOR A
LEFT JOIN INSTACART.PRODUCTS B
ON A.PRODUCT_ID = B.PRODUCT_ID
GROUP BY 1, 2
HAVING ORDER_COUNT > 10;