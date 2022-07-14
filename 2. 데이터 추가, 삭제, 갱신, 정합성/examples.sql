-- Insert, 행 추가하기, 데이터 추가하기
INSERT INTO table_name (column1, column2, column3, ...) VALUES (value1, value2, value3, ...);
INSERT INTO PRODUCT (상품 번호, 카테고리, 색상, 성별, 사이즈, 원가) VALUES ('a003', '트레이닝', 'purple', 'f', 'xs', 80,000);

-- Multi Insert
INSERT INTO table_name (column1, column2, column3, ...) VALUES 
(value1, value2, value3, ...),
(value4, value5, value6, ...);

-- Delete, 행 삭제하기, 데이터 삭제하기
DELETE FROM table_name
WHERE some_column = some_value;

-- product 테이블에서 상품 번호 a003을 삭제하시오
DELETE FROM PRODUCT
WHERE 상품 번호 = 'a003';

-- Update, 데이터 갱신하기
UPDATE table_name
SET column_name = column_value
where condition;

-- 상품 번호 'a002'의 원가를 70,000으로 변경하고, 카테고리를 '피트니스'로 변경하세요
UPDATE PRODUCT
SET 원가 = 70,000, 카테고리 = '피트니스'
WHERE 상품 번호 = 'a002';

-- procedure, 프로시저 사용, 매크로처럼 반복되는 내용을 하나의 단위로 생성
DELIMITER //
CREATE PROCEDURE 프로시저 명()
BEGIN
쿼리;
END //
DELIMITER ;

-- 주문 취소 건이 발생했을 때 해당 매출을 마이너스 처리를 하세요. (일 배치이므로 매일 처리 요망)(프로시저 사용)
DELIMITER //
CREATE PROCEDURE sales_minus()
BEGIN
UPDATE product
SET 원가 = (-1)*원가
WHERE 취소 여부 = 'Y'
AND 판매 일자 = CURDATE()-1;
END //
DELIMITER ;

-- 프로시저 실행
CALL sales_minus();

-- View, 뷰, 테이블을 직접 생성하지 않고 SELETE 문의 출력 결과를 보여 준다.
CREATE VIEW DB.view_name
AS SELECT-STATEMENT;

-- SALES 테이블에서 취소 여부가 'Y'인 데이터만 조회하세요. (생성된 View는 테이블과 동일하게 사용 가능하다.)
CREATE VIEW DB.cancel_prodno
AS
SELECT 주문 번호
FROM DB.SALES
WHERE 취소 여부 = 'Y';

-- 데이터 정합성 : 데이터들의 값이 일치함을 의미한다. 
-- MECE : 각 항목들이 상호 배타적이면서 모였을 때는 완전하게 합쳐는 것을 말한다. -> 대부분의 분석은 전체에서 부분으로 나누어 살펴보는데 이때 부분의 합읍 전체와 일치해야 한다는 정합성을 지키면서 분석을 진행해야한다.