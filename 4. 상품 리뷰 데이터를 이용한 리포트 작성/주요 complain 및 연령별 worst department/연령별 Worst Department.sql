-- 연령별 Worst Department
-- 리뷰 데이터를 기반으로 프로모션을 진행한다고 가정해보겠습니다. 먼저 연령대별로 가장 낮은 점수를 준 Department를 구하고, 해당 Department의 할인 쿠폰을 발송하기로 합니다.
-- 연령별로 가장 낮은 점수를 준 Department가 구해지면, 연령별로 가장 낮은 점수를 준 Department에 해택을 줍니다.
-- 이를 구할려면 아래와 같은 과정을 진행하면 됩니다.
-- 연령, Department별 가장 낮은 점수 계산
-- 생성한 점수를 기반으로 Rank 생성
-- Rank 값이 1인 데이터를 조회
-- 우선 연령, Department별 가장 낮은 점수를 구합니다. 
-- Department Name과 연령으로 그룹핑한 뒤, 평점을 평균하면 됩니다. 이때 연령은 앞에서 구한 것처럼 FLOOR를 사용해 10세 단위로 나눕니다.
SELECT `DEPARTMENT NAME`,
FLOOR(AGE/10)*10 AGEBAND,
AVG(RATING) AVG_RATE
FROM MYDATA.DATASET2
GROUP BY 1, 2;

-- 다음으로 연령별로 생성한 점수를 기준으로 Rank를 계산합니다. Rank를 생성할 때는 가장 낮은 점수가 1위가 되도록 오름차순으로 정렬합니다.
SELECT *,
ROW_NUMBER() OVER(PARTITION BY AGEBAND ORDER BY AVG_RATE) RNK
FROM
(SELECT `DEPARTMENT NAME`,
FLOOR(AGE/10)*10 AGEBAND,
AVG(RATING) AVG_RATE
FROM MYDATA.DATASET2
GROUP BY 1, 2) A;

-- 연령별로 평균 평점 점수가 가장 낮은 Department의 Rank 값이 1을 가집니다.
-- 위 쿼리 결과에서 10대의 가장 낮은 평균 평점을 받은 Department는 Intimate이고 20대는 Trend가 됩니다.

-- 이제 Rank 값이 1인 값을 조회하면, 연령대별로 가장 낮은 평점을 준 Department를 찾을 수 있습니다.
SELECT *
FROM
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY AGEBAND ORDER BY AVG_RATE) RNK
FROM 
(SELECT `DEPARTMENT NAME`,
FLOOR(AGE/10)*10 AGEBAND,
AVG(RATING) AVG_RATE
FROM MYDATA.DATASET2
GROUP BY 1, 2) A) A
WHERE RNK = 1;