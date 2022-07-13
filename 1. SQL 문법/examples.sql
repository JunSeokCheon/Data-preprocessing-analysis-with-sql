-- 예제 데이터 셋 : https://www.mysqltutorial.org/mysql-sample-database.aspx
-- SQL로 맛보는 데이터 전처리 분석

-- classicmodels.customers의 customerNumber를 조회하세요.
SELECT CUSTOMERNUMBER FROM CLASSICMODELS.CUSTOMERS;

-- classicmodels.payments의 amount의 총합과 checknumber의 개수를 구하세요.
SELECT sum(amount), count(checknumber) from classicmodels.payments;

-- classicmodels.products의 productName, productLine을 조회하세요.
select productname, productline from classicmodels.products;

-- classicmodels.products의 productCode의 개수를 구하고, 칼럼 명을 n_products로 변경하세요.
select count(productcode) as n_products from classicmodels.products;

-- classicmodels.orderdetails의 ordernumber의 중복을 제거하고 조회하세요.
select distinct ordernumber from classicmodels.orderdetails;

-- classicmodels.orderdetails의 priceeach가 30에서 50사이인 데이터를 조회하세요.
select * from classicmodels.orderdetails where priceEach between 30 and 50;

-- classicmodels.orderdeatils의 priceeach가 30 이상인 데이터를 조회하세요.
select * from classicmodels.orderdetails where priceEach >= 30;

-- classicmodels.customers의 country가 USA 또는 Canada인 customernumber를 조회하세요.
select * from classicmodels.customers where country in ('USA', 'Canada');

-- classicmodels.customers의 country가 USA, Canada가 아닌 customernumber를 조회하세요.
select customernumber from classicmodels.customers where country not in ('USA', 'Canada');

-- classicmodels.employees의 reportsTo의 값이 NULL인 employeenumber를 조회하세요.
select employeenumber from classicmodels.employees where reportsTo IS NULL;

-- classicmodels.customers의 addressline1에 ST가 포함된 addressline1을 출력하세요.
select addressline1 from classicmodels.customers where addressLine1 like '%ST%';

-- classicmodels.customers 테이블을 이용해 국가, 도시별 고객 수를 구하세요.
select country, city, count(customernumber) as N_customers from classicmodels.customers group by country, city;

-- classicmodels.customers 테이블을 이용해 USA 거주자의 수를 계산하고, 그 비중을 구하세요.
select sum(case when country = 'USA' then 1 else 0 end) as N_usa, sum(case when country = 'USA' then 1 else 0 end)/count(*) as usa_portion from classicmodels.customers;

-- classicmodels.customers, classicmodels.orders 테이블을 결합하고 ORDERNUMBER와 COUNTRY를 출력하세요. (LEFT JOIN)
SELECT A.ORDERNUMBER, B.COUNTRY
FROM CLASSICMODELS.ORDERS A
LEFT JOIN CLASSICMODELS.CUSTOMERS B
ON A.CUSTOMERNUMBER = B.CUSTOMERNUMBER;

-- classicmodels.customers, classicmodels.orders 테이블을 이용해 USA 거주자의 주문 번호(orderNumber), 국가(Country)를 출력하세요.
select A.orderNumber, B.country
from classicmodels.orders as A
left join classicmodels.customers as B
on A.customernumber = B.customernumber
where B.country = 'USA';

-- classicmodels.customers, classicmodels.orders 테이블을 이용해 USA 거주자의 주문 번호, 국가를 출력하세요. (INNER JOIN)
SELECT A.ORDERNUMBER, B.COUNTRY
FROM CLASSICMODELS.ORDERS A
INNER JOIN CLASSICMODELS.CUSTOMERS B
ON A.CUSTOMERNUMBER = B.CUSTOMERNUMBER
WHERE B.COUNTRY = 'USA';

-- classicmodels.customers의 country 칼럼을 이용해 북미(Canada, USA), 비북비를 출력하는 칼럼을 생성하세요.
SELECT COUNTRY, CASE WHEN COUNTRY IN ('Canada', 'USA') THEN "North America" ELSE "OTHERS" END as region
FROM CLASSICMODELS.CUSTOMERS;

-- classicmodels.customers의 country 칼럼을 이용해 북미(Canada, USA), 비북미를 출력하는 칼럼을 생성하고, 북미, 비북미 거주 고객의 수를 계산하세요.
SELECT CASE WHEN COUNTRY IN ('Canada', 'USA') THEN "North America" ELSE "Others" END AS REGION, COUNT(CUSTOMERNUMBER) N_CUSTOMER
FROM CLASSICMODELS.CUSTOMERS
GROUP BY CASE WHEN COUNTRY IN ('Canada', 'USA') THEN "North America" ELSE "Others" END;

-- 위와 같은 결과를 나타낸다. 1은 Select의 첫 번째 칼럼을 의미하고, 2는 두 번째 칼럼을 의미한다. GROUP BY 1 - 첫 번째 칼럼으로 그룹핑하겠다는 의미이다.
SELECT CASE WHEN COUNTRY IN ('Canada', 'USA') THEN "North America" ELSE "Others" END AS REGION, COUNT(CUSTOMERNUMBER) N_CUSTOMER
FROM CLASSICMODELS.CUSTOMERS
GROUP BY 1;

-- classicmodels.products 테이블에서 buyprice 칼럼으로 순위를 매겨 주세요. (오름차순)(row_number, rank, dense rank 사용)
SELECT BUYPRICE,
ROW_NUMBER() OVER(ORDER BY BUYPRICE) ROWNUMBER,
RANK() OVER(ORDER BY BUYPRICE) RNK,
DENSE_RANK() OVER(ORDER BY BUYPRICE) DENSERANK
FROM CLASSICMODELS.PRODUCTS;

-- classicmodels.products 테이블의 productline 별로 순위를 매겨주세요. (buyprice 칼럼 기준, 오름차순)(row_number, rank, dense rank 사용)
SELECT BUYPRICE,
ROW_NUMBER() OVER(PARTITION BY PRODUCTLINE ORDER BY BUYPRICE) ROWNUMBER,
RANK() OVER(PARTITION BY PRODUCTLINE ORDER BY BUYPRICE) RNK,
DENSE_RANK() OVER(PARTITION BY PRODUCTLINE ORDER BY BUYPRICE) DENSERANK
FROM CLASSICMODELS.PRODUCTS;

-- classicmodels.customers와 classicmodels.orders를 이용해 USA 거주자의 주문 번호를 출력하세요.
SELECT ORDERNUMBER
FROM CLASSICMODELS.ORDERS
WHERE CUSTOMERNUMBER IN (SELECT CUSTOMERNUMBER FROM CLASSICMODELS.CUSTOMERS WHERE COUNTRY = "USA");