-- 구매자 분석
-- 10분위 분석
-- 이전까지는 매출과 관련된 지표들을 주로 살펴보았다면, 이제는 구매자에 집중해 데이터를 살펴보고자 합니다.
-- 먼저 10분위 분석을 통해 서비스의 주문 수가 VIP 고객에게 얼마나 집중되어 있는지 알아보겠습니다.
-- 10분위 분석을 진행하려면 먼저 각 구매자의 분위 수를 구해야 합니다. 우리는 고객들을 주문 건수를 기준으로 분위 수를 나누겠습니다.
SELECT *,
ROW_NUMBER() OVER(ORDER BY ORDER_COUNT DESC) RNK
FROM
(SELECT USER_ID,
COUNT(DISTINCT ORDER_ID) ORDER_COUNT
FROM INSTACART.ORDERS
GROUP BY 1) BASE;

-- 고객별 주문 건수에 따라 순위가 매겨집니다. 고객별로 분위 수를 매기려면 전체 고객이 몇 명인지 알아야 합니다.
SELECT COUNT(DISTINCT USER_ID)
FROM
(SELECT USER_ID,
COUNT(DISTINCT ORDER_ID) ORDER_COUNT
FROM INSTACART.ORDERS
GROUP BY 1) BASE;

-- 전체 고객 수는 3,159명으로 등수별 분위 수는 아래 그림과 같이 계산됩니다.
-- 그림
-- 각 등수에 따른 분위 수는 CASE WHEN 구문을 이용해 다음과 같은 방법으로 설정할 수 있습니다.
SELECT *,
CASE WHEN RNK BETWEEN 1 AND 316 THEN 'Quantile_1'
WHEN RNK BETWEEN 317 AND 632 THEN 'Quantile_2'
WHEN RNK BETWEEN 633 AND 948 THEN 'Quantile_3'
WHEN RNK BETWEEN 949 AND 1264 THEN 'Quantile_4'
WHEN RNK BETWEEN 1265 AND 1580 THEN 'Quantile_5'
WHEN RNK BETWEEN 1581 AND 1895 THEN 'Quantile_6'
WHEN RNK BETWEEN 1896 AND 2211 THEN 'Quantile_7'
WHEN RNK BETWEEN 2212 AND 2527 THEN 'Quantile_8'
WHEN RNK BETWEEN 2528 AND 2843 THEN 'Quantile_9'
WHEN RNK BETWEEN 2844 AND 3159 THEN 'Quantile_10' END quantile
FROM
(SELECT *,
ROW_NUMBER() OVER(ORDER BY ORDER_COUNT DESC) RNK
FROM
(SELECT USER_ID,
COUNT(DISTINCT ORDER_ID) ORDER_COUNT
FROM INSTACART.ORDERS
GROUP BY 1) A) BASE;

-- 이제 각 분위 수별 특성을 파악해보겠습니다. 각 분위 수별로 평균 Recency를 파악합니다. 먼저 위의 조회 결과를 하나의 테이블로 생성해 user_id별 분위 수 정보를 생성합니다.
CREATE TEMPORARY TABLE INSTACART.USER_QUANTILE AS
SELECT *,
CASE WHEN RNK BETWEEN 1 AND 316 THEN 'Quantile_1'
WHEN RNK BETWEEN 317 AND 632 THEN 'Quantile_2'
WHEN RNK BETWEEN 633 AND 948 THEN 'Quantile_3'
WHEN RNK BETWEEN 949 AND 1264 THEN 'Quantile_4'
WHEN RNK BETWEEN 1265 AND 1580 THEN 'Quantile_5'
WHEN RNK BETWEEN 1581 AND 1895 THEN 'Quantile_6'
WHEN RNK BETWEEN 1896 AND 2211 THEN 'Quantile_7'
WHEN RNK BETWEEN 2212 AND 2527 THEN 'Quantile_8'
WHEN RNK BETWEEN 2528 AND 2843 THEN 'Quantile_9'
WHEN RNK BETWEEN 2844 AND 3159 THEN 'Quantile_10' END quantile
FROM
(SELECT *,
ROW_NUMBER() OVER(ORDER BY ORDER_COUNT DESC) RNK
FROM
(SELECT USER_ID,
COUNT(DISTINCT ORDER_ID) ORDER_COUNT
FROM INSTACART.ORDERS
GROUP BY 1) A) BASE;

-- 이제 다음과 같은 방법으로 각 분위 수별 전체 주문 건수의 합을 구할 수 있습니다.
SELECT QUANTILE,
SUM(ORDER_COUNT) ORDER_COUNT
FROM INSTACART.USER_QUANTILE
GROUP BY 1;

-- 전체 주문 건수를 계산하고, 각 분위 수의 주문 건수를 전체 주문 건수로 나눈다면 각 분위 수별 주문 건수의 비율을 볼 수 있습니다.
SELECT SUM(ORDER_COUNT) FROM INSTACART.USER_QUANTILE;

SELECT QUANTILE,
SUM(ORDER_COUNT)/3220 RATIO
FROM INSTACART.USER_QUANTILE
GROUP BY 1;

-- 결과를 보면 각 분위 수별로 주문 건수가 거의 균등하게 분포되어 있습니다. 즉 해당 서비스는 매출이 VIP에게 집중되지 않고, 전체 고객에 고르게 분포되어 있음을 알 수 있습니다.
-- 하지만, 고객의 최대 주문 수와 최소 주문 수의 차이가 별로 나지 않는 점으로 봤을 때 기본 데이터의 다양성이 부족한다는 것을 알 수 있습니다.