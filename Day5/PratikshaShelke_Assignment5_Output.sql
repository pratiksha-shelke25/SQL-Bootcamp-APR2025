1.  GROUP BY with WHERE - Orders by Year and Quarter
Display, order year, quarter, order count, avg freight cost only for those orders where freight cost > 100
    
SELECT 
    EXTRACT(YEAR FROM Order_date) AS OrderYear,
    EXTRACT(QUARTER FROM Order_date) AS OrderQuarter,
    COUNT(*) AS OrderCount,
    AVG(Freight) AS AvgFreight
FROM 
    orders
WHERE 
    Freight > 100
GROUP BY 
     OrderYear,OrderQuarter
ORDER BY 
    OrderYear,OrderQuarter;


---------------------------------------------------------------------------------------
2.      GROUP BY with HAVING - High Volume Ship Regions
Display, ship region, no of orders in each region, min and max freight cost
 Filter regions where no of orders >= 5

SELECT 
    ship_region,
    COUNT(*) AS OrderCount,
    MIN(Freight) AS MinFreight,
    MAX(Freight) AS MaxFreight
FROM 
    Orders
WHERE 
     ship_region IS NOT NULL
GROUP BY 
    ship_region
HAVING 
    COUNT(*) >= 5
ORDER BY 
    OrderCount DESC;
	
	

---------------------------------------------------------------------------------------
3.      Get all title designations across employees and customers ( Try UNION & UNION ALL)
 Using UNION

SELECT title
FROM employees
UNION
SELECT contact_title
FROM customers;

Using UNION ALL

SELECT title
FROM employees
UNION ALL
SELECT contact_title
FROM customers;
---------------------------------------------------------------------------------------
4.      Find categories that have both discontinued and in-stock products
(Display category_id, instock means units_in_stock > 0, Intersect)

-- Categories with discontinued products
SELECT category_id
FROM products
WHERE discontinued = 1

INTERSECT

-- Categories with in-stock products
SELECT category_id
FROM products
WHERE units_in_stock > 0;
---------------------------------------------------------------------------------------
5.Find orders that have no discounted items (Display the  order_id, EXCEPT)

SELECT order_id
FROM order_details

EXCEPT

-- Orders that have at least one discounted item
SELECT DISTINCT order_id
FROM order_details
WHERE Discount > 0;

---------------------------------------------------------------------------------------