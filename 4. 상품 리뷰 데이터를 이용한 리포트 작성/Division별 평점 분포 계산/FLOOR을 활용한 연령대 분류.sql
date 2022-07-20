-- 3) FLOOR
-- 연령을 10으로 나눈 값을 버림 하면 어떤 값을 얻을 수 있을까요?
-- 예를 들어 23을 10으로 나누면 2.3이라는 값을 얻고 여기서 버림하면 2가 나오고 10을 곱하면 해당 연령대인 20을 구할 수 있습니다.
-- 이것을 이용해 연령대를 구해보도록 하겠습니다.
SELECT FLOOR(AGE/10)*10 AGEBAND,
AGE
FROM MYDATA.DATASET2
WHERE `DEPARTMENT NAME` = 'Trend' AND RATING <=3;

-- CASE WHEN을 사용하는 것보다 훨씬 간단한 방법으로 10단위로 연령을 나눌 수 있게 되었습니다.
-- 그렇다면 이 값으로 데이터를 그룹핑하고 COUNT로 집계한다면, 연령별 리뷰 수를 구할 수 있겠습니다.

-- a) Trend의 평점 3점 이하 리뷰의 연령 분포
SELECT FLOOR(AGE/10)*10 AGEBAND,
COUNT(*) CNT
FROM MYDATA.DATASET2
WHERE `DEPARTMENT NAME` = 'Trend' AND RATING <= 3
GROUP BY 1
ORDER BY 2 DESC;

-- 50개에서 3점 이하의 평점 수가 많은 것으로 확인됩니다. 하지만 50대가 Trend라는 Department에 가장 많은 불만이 있다고 할 수 있을까요?
-- 만약 Trend의 리뷰 중 50대 리뷰가 압도적으로 많다면, 위 결과는 당연한 결과일 겁니다.
-- 그렇기 때문에 Trend의 전체 연령별 리뷰 수를 구해보아야 합니다.
-- b) Department별 연령별 라뷰 수
SELECT FLOOR(AGE/10)*10 AGEBAND,
COUNT(*) CNT
FROM MYDATA.DATASET2
WHERE `DEPARTMENT NAME` = 'Trend'
GROUP BY 1
ORDER BY 2 DESC;

-- 위 결과를 보면 50대의 Trend에 대한 평점이 다소 좋지 않은 것으로 생각할 수 있습니다.
-- 더 명확하게 결과를 확인하기 위하여 50대 3점 이하 Trend 리뷰를 살펴보겠습니다.
-- c) 50대 3점 이하 Trend 리뷰
SELECT *
FROM MYDATA.DATASET2
WHERE `DEPARTMENT NAME` = 'Trend' AND RATING <=3 AND AGE BETWEEN 50 AND 59 LIMIT 10;

-- Review Text를 몇 가지 살펴보면 사이즈에 관한 complain이 존재함을 알 수 있습니다. 추후 사이즈와 관련된 리뷰를 좀 더 깊게 살펴보겠습니다.