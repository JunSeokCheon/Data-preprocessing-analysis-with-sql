-- clothing ID별 Size review
-- 연령, Department별로 사이즈와 관련된 리뷰를 살펴보았습니다. 이제 좀 더 세부적으로 어떤 상품이 Size와 관련된 리뷰 내용이 많은지 확인하겠습니다.
-- 먼저 상품 ID별로 사이즈와 관련된 리뷰 수를 계산하고, 사이즈 타입별로 리뷰 수를 다시 집계해보겠습니다.
SELECT `CLOTHING ID`,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) N_SIZE
FROM MYDATA.DATASET2
GROUP BY 1;

-- 다음으로 사이즈 타입을 추가로 집계하겠습니다.
SELECT `CLOTHING ID`,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) N_SIZE_T,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END)/SUM(1) N_SIZE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END)/SUM(1) N_LARGE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END)/SUM(1) N_LOOSE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END)/SUM(1) N_SMALL,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END)/SUM(1) N_TIGHT
FROM MYDATA.DATASET2
GROUP BY 1;

-- 이제 어떤 옷이 사이즈와 관련된 Complain이 많고, 어떤 타입의 Complain이 많은 지 알게 되었습니다. 상품 개발팀이나 디자인팀에서 이 정보를 알고 있다면, 다음 상품을 개발할 때 큰 도움이 될 것입니다.
-- 타 부서와 관련 내용을 공유하도록 새로운 테이블로 생성해보겠습니다.
CREATE TABLE MYDATA.SIZE_STAT_AS
SELECT `CLOTHING ID`,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) N_SIZE_T,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END)/SUM(1) N_SIZE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END)/SUM(1) N_LARGE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END)/SUM(1) N_LOOSE,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END)/SUM(1) N_SMALL,
SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END)/SUM(1) N_TIGHT
FROM MYDATA.DATASET2
GROUP BY 1;

-- 상품 리뷰 데이터를 이용해서 텍스트 데이터를 다루어 보았습니다. 실제로 대부분의 상품명, 상품 카테고리, 회원 주소와 같은 정보는 텍스트로 되어있습니다.
-- 내용을 잘 학습한다면, 텍스트 데이터도 SQL에서 어렵지 않게 다룰 수 있을 겁니다. 
-- 다음 포스팅부터는 식품 배송 데이터분석에 대해서 학습하겠습니다.
-- 감사합니다.