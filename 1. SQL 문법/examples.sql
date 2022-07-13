-- 예제 데이터 셋 : https://www.mysqltutorial.org/mysql-sample-database.aspx

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

