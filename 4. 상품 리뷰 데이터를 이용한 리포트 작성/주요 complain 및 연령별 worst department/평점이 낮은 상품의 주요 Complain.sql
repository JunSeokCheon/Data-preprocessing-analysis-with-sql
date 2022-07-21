-- 평점이 낮은 상품의 주요 Complain
-- 먼저 Department별로 평점이 낮은 주요 10개 상품을 조회한 후, 해당 상품들의 리뷰를 살펴보겠습니다.
-- 1) Department Name, Clothing Name별 평균 평점 계산
SELECT `DEPARTMENT NAME`,
`CLOTHING ID`,
AVG(RATING) AVG_RATE
FROM MYDATA.DATASET2
GROUP BY 1, 2;

-- 2) Department별 순위 생성
-- Department, Clothing id의 평균 평점을 계산하고, Department 내에서 평균 평점을 기준으로 순위를 매기겠습니다.
SELECT *,
ROW_NUMBER() OVER( PARTITION BY `DEPARTMENT NAME` ORDER BY AVG_RATE) RNK
FROM
(SELECT `DEPARTMENT NAME`,
`CLOTHING ID`,
AVG(RATING) AVG_RATE
FROM MYDATA.DATASET2
GROUP BY 1, 2) A;

-- 쿼리 결과를 보면, 각 Department별로 평점이 가장 낮은 순서대로 평점이 매겨지고 있습니다.
-- RNK 값이 1~10위 사이의 데이터를 가져오면, 각 Department별로 평점이 좋지 않은 10개의 상품을 조회할 수 있습니다.

-- 3) 1~10위 데이터 조회
SELECT *
FROM
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY `DEPARTMENT NAME` ORDER BY AVG_RATE) RNK
FROM
(SELECT `DEPARTMENT NAME`,
`CLOTHING ID`,
AVG(RATING) AVG_RATE
FROM MYDATA.DATASET2
GROUP BY 1, 2) A) A
WHERE RNK <= 10;

-- 이제 해당 데이터를 테이블로 생성하겠습니다.
-- a) Department별 평균 평점이 낮은 10개 상품
CREATE TEMPORARY TABLE MYDATA.STAT AS
SELECT *
FROM
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY `DEPARTMENT NAME` ORDER BY AVG_RATE) RNK
FROM
(SELECT `DEPARTMENT NAME`,
`CLOTHING ID`,
AVG(RATING) AVG_RATE
FROM MYDATA.DATASET2
GROUP BY 1, 2) A) A
WHERE RNK <= 10;

-- 생성한 테이블을 이요하면, 각 Department별로 평점이 낮은 상품들의 Complain 내용을 확인할 수 있습니다.
-- 예를 들어, Bottoms의 평점이 낮은 10개 상품의 리뷰를 조회해보겠습니다.
SELECT `CLOTHING ID`
FROM MYDATA.STAT
WHERE `DEPARTMENT NAME` = 'Bottoms';

-- 쿼리 결과는 평점이 낮은 10개의 상품의 clothing id를 조회할 수 있습니다.
-- 조회한 clothing id를 가지고 리뷰 내용을 조회해보겠습니다.
SELECT *
FROM MYDATA.DATASET2
WHERE `CLOTHING ID` IN
(SELECT `CLOTHING ID`
FROM MYDATA.STAT
WHERE `DEPARTMENT NAME` = 'Bottoms')
ORDER BY `CLOTHING ID`;

-- 평점이 낮은 리뷰내용을 살펴보면 사이즈 및 소재에 대한 Complain이 다수 포착됩니다.

-- b) TF-IDF
-- 리뷰 데이터는 수많은 단어로 구성되어 있습니다. 문단에는 the, product와 같이 자주 사용되지만 가치가 없는 단어들도 있고, Size, Textured와 같이 평가 내용을 파악하는 데 도움이 되는 단어들도 있습니다.
-- 이를 판단하기 위해 NLP에서 TF-IDF라는 Score를 이용해서 단어별로 가치 수준을 매깁니다.
-- 자세한건 해당 링크를 참조하시기 바랍니다. https://ko.wikipedia.org/wiki/Tf-idf