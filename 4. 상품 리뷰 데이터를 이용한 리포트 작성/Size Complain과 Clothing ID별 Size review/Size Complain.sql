-- size complain
-- 이전 포스팅에서 살펴본 내용에 따르면, Complain 내용의 다수가 Size에 관련한 문제였습니다.
-- 먼저 전체 리뷰 내용 중 Size와 관련된 리뷰가 얼마나 되는지 확인하기 위해서 Review Text의 내용 중 size라는 단어가 언급된 Reivew가 몇 개인지 계산해보겠습니다.
SELECT `REVIEW TEXT`,
CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END SIZE_YN
FROM MYDATA.DATASET2;

-- SIZE_YN은 리뷰의 내용 중 size가 포함되어 있으면 1, 그렇지 않으면 0인 값으로 출력됩니다. 
-- 전체의 리뷰 수에서 size가 포함된 리뷰의 수를 구해봅시다.
SELECT SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) N_SIZE,
COUNT(*) N_TOTAL
FROM MYDATA.DATASET2;

-- 전체 리뷰 중 약 30%가량이 size와 관련된 리뷰였습니다. 다음으로 사이즈를 Large, Loose, Small, Tight로 상세히 나누어 살펴보겠습니다.
SELECT SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) N_SIZE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) N_LARGE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) N_LOOSE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) N_SMALL,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) N_TIGHT,
SUM(1) N_TOTAL
FROM MYDATA.DATASET2;

-- Large, Loose에 비해 Small, Tight와 관련된 리뷰가 더 많은 것으로 확인됩니다. 이것들을 카테고리별로 확인해보겠습니다.
SELECT `DEPARTMENT NAME`,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) N_SIZE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) N_LARGE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) N_LOOSE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) N_SMALL,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) N_TIGHT,
SUM(1) N_TOTAL
FROM MYDATA.DATASET2
GROUP BY 1;

-- Dresses, Bottoms, Tops에서 사이즈와 관련된 리뷰가 많은 것으로 확인되었고, Dresses와 Bottoms는 Tops에 비해 small, tight와 관련된 리뷰가 많았습니다.
-- 다음으로 이를 연령별로 나누어 보겠습니다.
SELECT FLOOR(AGE/10)*10 AGEBAND,
`DEPARTMENT NAME`,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) N_SIZE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) N_LARGE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) N_LOOSE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) N_SMALL,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) N_TIGHT,
SUM(1) N_TOTAL
FROM MYDATA.DATASET2
GROUP BY 1, 2
ORDER BY 1, 2;

-- 단순히 리뷰의 수를 계산하게 되면 Department에서 Size와 관련된 주된 Complain 내용이 무엇인지 파악하기가 어렵습니다.
-- 그래서 절대 수가 아닌 비중을 구하겠습니다. 총 리뷰 수로 각 칼럼들을 나누면, 각 그룹에서 size 세부 그룹의 비중을 구할 수 있습니다.
SELECT FLOOR(AGE/10)*10 AGEBAND,
`DEPARTMENT NAME`,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END)/SUM(1) N_SIZE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END)/SUM(1) N_LARGE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END)/SUM(1) N_LOOSE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END)/SUM(1) N_SMALL,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END)/SUM(1) N_TIGHT,
SUM(1) N_TOTAL
FROM MYDATA.DATASET2
GROUP BY 1, 2
ORDER BY 1, 2;

-- 총 리뷰 수를 SUM(1)과 같은 방법으로 계산했는데, 이는 COUNT(*)과 동일한 결과를 출력합니다.
-- 결론적으로 연령대별, Department별 size Complain 원인을 파악할 수 있었습니다.