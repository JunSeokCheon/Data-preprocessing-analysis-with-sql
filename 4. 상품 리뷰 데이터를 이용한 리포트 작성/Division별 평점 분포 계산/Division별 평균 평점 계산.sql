SELECT * FROM MYDATA.DATASET2;
-- 1) Division별 평균 평점 계산
-- 먼저 Division별로 평점을 계산해 보고, 어떤 Division의 상품이 좋은 평가를 받는지 또는 좋지 않은 평가를 받는지 살펴보겠습니다.
-- 해당 데이터 세트의 칼럼 구조를 살펴보겠습니다.
-- Clothing ID : 상품 번호 (Unique Value)
-- Age : 나이
-- Title : 리뷰 제목
-- Review Text : 리뷰 내용
-- Rating : 리뷰 작성자가 제출한 평점
-- Recommended IND : 리뷰어에 대한 상품 추천 여부
-- Positive Feedback Counter : 긍정적 피드백 수
-- Division Name : 상품이 속한 Division
-- Department Name : 상품이 속한 Department
-- Class Name : 상품의 타입

-- a) DIVISION NAME별 평균 평점
-- Division별 평균 Rating을 계산하려면 먼저 Division Name으로 그룹핑한 뒤, 점수를 평균하는 작업을 실행하겠습니다.
SELECT `DIVISION NAME`,
AVG(RATING) AVG_RATE
FROM MYDATA.DATASET2
GROUP BY 1
ORDER BY 2 DESC;

-- 3개의 DIVISION 모두 유사한 평점을 갖는 것으로 확인되었습니다. DIVISION NAME의 공란은 데이터가 없는 것으로 판단하겠습니다.

-- b) DEPARTMENT별 평균 평점
SELECT `DEPARTMENT NAME`,
AVG(RATING) AVG_RATE
FROM MYDATA.DATASET2
GROUP BY 1
ORDER BY 2 DESC;

-- Bottoms부터 상위 5개의 Department는 유사한 평점이 가진 것으로 보입니다. 하지만 Trend는 3.85점으로 상위 대비 평점이 낮게 나옵니다.
-- Trend에 어떤 문제가 있는지 파악하겠습니다.
-- 먼저 Trend의 좋지 않은 리뷰(평점 3점 이하)의 연령별 분포를 살펴보겠습니다.
-- 쿼리를 작성하기 위해서 DEPARTMENT NAME을 TREND로 한정하고 RATING은 3점 이하의 조건을 추가하면 됩니다.
SELECT *
FROM MYDATA.DATASET2
WHERE `DEPARTMENT NAME` = 'Trend' AND RATING <= 3;

-- 쿼리를 실행하면, RATING이 3점 이하이고 DEPARTMENT NAME은 TREND인 데이터가 모두 조회됩니다.
-- 따라서 위의 데이터 세트에서 연령으로 데이터를 그룹핑하고 카운트로 집계하면, 우리가 원하는 결과를 얻을 수 있습니다.
-- 구간을 그룹으로 나누어 집계하는 방법에는 크게 2가지가 있습니다. (CASE WHEN, FLOOR)