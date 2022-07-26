-- 데이터 탐색
-- 처음 접하는 데이터가 있다면 항상 각 테이블이 무엇을 의미하는지, 어떤 칼럼이 있는지 확인하고 테이블 간의 관계를 파악해야 합니다.
-- aisles, departments, order_products_prior, orders, products 총 5개의 테이블이 존재합니다.
-- aisles, departments는 상품의 카테고리를 의미하고, order_products_prior는 각 주무 번호의 상세 구매 내역, orders는 주문 대표 정보, products 상품 정보를 의미합니다.
SELECT * FROM INSTACART.AISLES;
SELECT * FROM INSTACART.DEPARTMENTS;
SELECT * FROM INSTACART.ORDER_PRODUCTS__PRIOR;
SELECT * FROM INSTACART.ORDERS;
SELECT * FROM INSTACART.PRODUCTS;