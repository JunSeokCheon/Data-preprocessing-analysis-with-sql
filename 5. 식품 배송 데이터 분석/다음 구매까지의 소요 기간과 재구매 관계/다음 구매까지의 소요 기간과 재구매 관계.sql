-- 다음 구매까지의 소요 기간과 재구매 관계
-- 우리는 "고객이 자주 재구매하는 상품은 그렇지 않은 상품보다 일정한 주기를 가질 것이다"라는 가정을 세우고 수치를 살펴보겠습니다. 
-- 재구매율이 높은 순서대로 상품을 10가지 그룹으로 구분하고, 각 그룹에서의 구매 소요 기간의 분산을 구해보겠습니다.
-- 분산은 그 확률 변수가 기댓값에서 얼마나 떨어진 곳에 분포하는지를 나타내는 값입니다. 즉, 분산이 낮을수록 데이터가 평균에 모이게 되고, 분산이 클수록 관측치는 평균에서 멀리 분포합니다.
-- 먼저 다음과 같은 방법으로 상품별 재구매율을 계산하고, 가장 높은 순서대로 순위를 매깁니다.
SELECT *
FROM
(SELECT *,
ROW_NUMBER() OVER(ORDER BY RET_RATIO DESC) RNK
FROM
(SELECT PRODUCT_ID,
SUM(CASE WHEN REORDERED = 1 THEN 1 ELSE 0 END)/COUNT(*) RET_RATIO
FROM INSTACART.ORDER_PRODUCTS__PRIOR
GROUP BY 1) A) BASE;

SELECT COUNT(DISTINCT PRODUCT_ID)
FROM INSTACART.ORDER_PRODUCTS__PRIOR;

-- 고객 분석에서 했던 10분위 분석과 동일한 방법으로 각 상품을 10개의 그룹으로 나누겠습니다.
-- 그림
CREATE TEMPORARY TABLE INSTACART.PRODUCT_REPURCHASE_QUANTILE AS
SELECT A.PRODUCT_ID,
CASE WHEN RNK <= 929 THEN 'Q_1'
WHEN RNK <= 1858 THEN 'Q_2'
WHEN RNK <= 2786 THEN 'Q_3'
WHEN RNK <= 3715 THEN 'Q_4'
WHEN RNK <= 4644 THEN 'Q_5'
WHEN RNK <= 5573 THEN 'Q_6'
WHEN RNK <= 6502 THEN 'Q_7'
WHEN RNK <= 7430 THEN 'Q_8'
WHEN RNK <= 8359 THEN 'Q_9'
WHEN RNK <= 9288 THEN 'Q_10' END RNK_GRP
FROM
(SELECT *,
ROW_NUMBER() OVER(ORDER BY RET_RATIO DESC) RNK
FROM
(SELECT PRODUCT_ID,
SUM(CASE WHEN REORDERED = 1 THEN 1 ELSE 0 END)/COUNT(*) RET_RATIO
FROM INSTACART.ORDER_PRODUCTS__PRIOR
GROUP BY 1) A) A
GROUP BY 1, 2;

-- 위의 쿼리로 PRODUCT_ID별 분위 수를 계산할 수 있습니다. 계산된 상품별 분위 수는 PRODUCT_REPURCHASE_QUANTILE 테이블에 생성됩니다. 
-- 이제 각 분위 수별로 재구매 소요 시간의 분산을 구해보겠습니다.
-- 먼저 INSTACART.ORDER_PRODUCTS__PRIOR에 ORDERS 테이블을 결합해 PRODUCT_ID의 DAYS_SINCE_PRIOR_ORDER를 구해야 합니다.
CREATE TEMPORARY TABLE INSTACART.ORDER_PRODUCTS__PIOR2 AS
SELECT PRODUCT_ID,
DAYS_SINCE_PRIOR_ORDER
FROM INSTACART.ORDER_PRODUCTS__PRIOR A
INNER JOIN INSTACART.ORDERS B
ON A.ORDER_ID = B.ORDER_ID;

-- 다음으로 결합한 테이블에서 분위수, 상품별 구매 소요 기간의 분산을 계산합니다.
SELECT A.RNK_GRP,
A.PRODUCT_ID,
VARIANCE(DAYS_SINCE_PRIOR_ORDER) VAR_DAYS
FROM INSTACART.PRODUCT_REPURCHASE_QUANTILE A
LEFT JOIN INSTACART.ORDER_PRODUCTS__PIOR2 B
ON A.PRODUCT_ID = B.PRODUCT_ID
GROUP BY 1, 2
ORDER BY 1;

-- 각 분위 수, 상품의 소요 기간의 분산을 계산했습니다. 우리의 가정은 "재구매율이 높은 상품군은 구매 주기가 일정할 것이다"인데 이를 확인하기 위해서 다음과 가정을 수행했습니다.
-- 결과를 보면 분위 수에 따라 재구매 주기의 분산에 차이가 없는 것으로 확인됩니다. 즉, 재구매율이 높은 상품이라도 구매 주기가 집중되지 않는다는 것을 확인할 수 있었습니다.