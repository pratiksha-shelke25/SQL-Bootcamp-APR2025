Day 8
 
1.     Create view vw_updatable_products (use same query whatever I used in the training)
Try updating view with below query and see if the product table also gets updated.
Update query:
UPDATE updatable_products SET unit_price = unit_price * 1.1 WHERE units_in_stock < 10;

-- To create view
CREATE VIEW vw_updatable_products AS
SELECT product_id, product_name, unit_price, units_in_stock
FROM products
WHERE discontinued = 0;

SELECT * FROM products;

-- To update the view

UPDATE vw_updatable_products SET unit_price = unit_price * 1.1 WHERE units_in_stock < 10;

SELECT * FROM products;

---------------------------------------------------------------------------------------------------
 
2.     Transaction:
Update the product price for products by 10% in category id=1
Try COMMIT and ROLLBACK and observe what happens.

-- To check the current price

SELECT product_id,
       product_name,
       unit_price
FROM products
WHERE category_id = 1;

-- To Commit transaction and apply the 10% increase
BEGIN TRANSACTION;

-- To apply the 10% price increase
UPDATE products
SET unit_price = unit_price * 1.10
WHERE category_id = 1;

-- To verify uncommitted changes in your session
SELECT product_id,
       product_name,
       unit_price
FROM products
WHERE category_id = 1;

-- To commit the transaction to make changes permanent
COMMIT;



-- To Rollback the transaction
BEGIN TRANSACTION;

-- To apply the 10% price increase
UPDATE products
SET unit_price = unit_price * 1.10
WHERE category_id = 1;

-- To verify uncommitted changes in your session
SELECT product_id,
       product_name,
       unit_price
FROM products
WHERE category_id = 1;

-- To rollback the transaction to undo the update
ROLLBACK;

-- To confirm that prices are back to their original values
SELECT product_id,
       product_name,
       unit_price
FROM products
WHERE category_id = 1;
---------------------------------------------------------------------------------------------------
3.     Create a regular view which will have below details (Need to do joins):
Employee_id,
Employee_full_name,
Title,
Territory_id,
territory_description,
region_description

CREATE VIEW vw_employee_territory_details AS
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_full_name,
    e.title,
    t.territory_id,
    t.territory_description,
    r.region_description
FROM employees e
JOIN employee_territories et
  ON e.employee_id = et.employee_id
JOIN territories t
  ON et.territory_id = t.territory_id
JOIN region r
  ON t.region_id = r.region_id;


SELECT *
FROM vw_employee_territory_details;
---------------------------------------------------------------------------------------------------
4.     Create a recursive CTE based on Employee Hierarchy

WITH RECURSIVE employee_hierarchy AS (
  -- Anchor: top‐level employees (no manager)
  SELECT
    e.employee_id,
    e.first_name  || ' ' || e.last_name  AS employee_name,
    e.title,
    e.reports_to                            AS manager_id,
    NULL::text                              AS manager_name,
    1                                       AS level
  FROM employees e
  WHERE e.reports_to IS NULL

  UNION ALL

  -- Recursive step: find direct reports of everyone in the CTE so far
  SELECT
    e.employee_id,
    e.first_name  || ' ' || e.last_name,
    e.title,
    e.reports_to,
    eh.employee_name,
    eh.level + 1
  FROM employees e
  JOIN employee_hierarchy eh
    ON e.reports_to = eh.employee_id
)
SELECT
  employee_id,
  employee_name,
  title,
  manager_id,
  manager_name,
  level
FROM employee_hierarchy
ORDER BY level, manager_name NULLS FIRST, employee_name;

 
 

