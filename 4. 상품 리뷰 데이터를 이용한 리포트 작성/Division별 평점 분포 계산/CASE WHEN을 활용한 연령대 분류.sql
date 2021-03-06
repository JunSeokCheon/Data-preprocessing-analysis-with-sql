-- 2) CASE WHEN
-- case when 구문을 사용해 우리가 원하는 그룹을 생성할 수 있습니다. 예를 들어 연령을 10세 단위로 그룹핑을 진행해보겠습니다.
SELECT CASE WHEN AGE BETWEEN 0 AND 9 THEN '0009'
WHEN AGE BETWEEN 10 AND 19 THEN '1019'
WHEN AGE BETWEEN 20 AND 29 THEN '2029'
WHEN AGE BETWEEN 30 AND 39 THEN '3039'
WHEN AGE BETWEEN 40 AND 49 THEN '4049'
WHEN AGE BETWEEN 50 AND 59 THEN '5059'
WHEN AGE BETWEEN 60 AND 69 THEN '6069'
WHEN AGE BETWEEN 70 AND 79 THEN '7079'
WHEN AGE BETWEEN 80 AND 89 THEN '8089'
WHEN AGE BETWEEN 90 AND 99 THEN '9099' END AGEBAND,
AGE
FROM MYDATA.DATASET2
WHERE `DEPARTMENT NAME` = 'Trend' AND RATING <= 3;

-- AGE와 AGEBAND를 살펴보면, 우리가 의도한 대로 연령대가 생성된 것을 확인할 수 있습니다.
-- 위의 방법은 하나씩 연령 구간을 설정해야 한다는 점에서 번거러움이 있을 수 있습니다.
-- FLOOR를 사용하면 10세 단위로 연령을 쉽게 나눌 수 있습니다.