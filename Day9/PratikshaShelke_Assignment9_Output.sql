1.      Create AFTER UPDATE trigger to track product price changes
 
·       Create product_price_audit table with below columns:
	audit_id SERIAL PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(40),
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_name VARCHAR(50) DEFAULT CURRENT_USER
 
·       Create a trigger function with the below logic:
 
  INSERT INTO product_price_audit (
        product_id,
        product_name,
        old_price,
        new_price
    )
    VALUES (
        OLD.product_id,
        OLD.product_name,
        OLD.unit_price,
        NEW.unit_price
    );
·       Create a row level trigger for below event:
          	AFTER UPDATE OF unit_price ON products
 
·        Test the trigger by updating the product price by 10% to any one product_id.
 


--1. To create product_price_audit table

CREATE TABLE product_price_audit (
    audit_id SERIAL PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(40),
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_name VARCHAR(50) DEFAULT CURRENT_USER
);

SELECT * FROM product_price_audit;

--2. To create the trigger function

CREATE OR REPLACE FUNCTION track_price_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.unit_price <> NEW.unit_price THEN
        INSERT INTO product_price_audit (
            product_id,
            product_name,
            old_price,
            new_price
        )
        VALUES (
            OLD.product_id,
            OLD.product_name,
            OLD.unit_price,
            NEW.unit_price
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- 3. Create the AFTER UPDATE trigger

CREATE TRIGGER trg_track_price_changes
AFTER UPDATE OF unit_price ON products
FOR EACH ROW
EXECUTE FUNCTION track_price_changes();

--4. To test the trigger: Update a product price by 10%
--To update product_id = 1:

UPDATE products
SET unit_price = unit_price * 1.10
WHERE product_id = 1;

-- 5. To check if audit was recorded

SELECT * FROM product_price_audit
ORDER BY change_date DESC;
---------------------------------------------------------------------------------------------------
2.      Create stored procedure  using IN and INOUT parameters to assign tasks to employees
 
·       Parameters:
IN p_employee_id INT,
IN p_task_name VARCHAR(50),
 INOUT p_task_count INT DEFAULT 0
 
·       Inside Logic: Create table employee_tasks:
 CREATE TABLE IF NOT EXISTS employee_tasks (
        task_id SERIAL PRIMARY KEY,
        employee_id INT,
        task_name VARCHAR(50),
        assigned_date DATE DEFAULT CURRENT_DATE
    );
 
·       Insert employee_id, task_name  into employee_tasks
·       Count total tasks for employee and put the total count into p_task_count .
·       Raise NOTICE message:
 RAISE NOTICE 'Task "%" assigned to employee %. Total tasks: %',
        p_task_name, p_employee_id, p_task_count;
 
 
After creating stored procedure test by calling  it:
 CALL assign_task(1, 'Review Reports');
 
You should see the entry in employee_tasks table.
 

-- To create stored Procedure: assign_task

CREATE OR REPLACE PROCEDURE assign_task(
    IN p_employee_id INT,
    IN p_task_name VARCHAR(50),
    INOUT p_task_count INT DEFAULT 0
)
LANGUAGE plpgsql
AS $$
BEGIN

--To create the table if it doesn't exist
    CREATE TABLE IF NOT EXISTS employee_tasks (
        task_id SERIAL PRIMARY KEY,
        employee_id INT,
        task_name VARCHAR(50),
        assigned_date DATE DEFAULT CURRENT_DATE
    );

-- To insert the task for the employee
    INSERT INTO employee_tasks (employee_id, task_name)
    VALUES (p_employee_id, p_task_name);

-- To count total tasks assigned to the employee
    SELECT COUNT(*) INTO p_task_count
    FROM employee_tasks
    WHERE employee_id = p_employee_id;

-- To show a notice with task details
    RAISE NOTICE 'Task "%" assigned to employee %. Total tasks: %',
        p_task_name, p_employee_id, p_task_count;
END;
$$;

-- To Test the Procedure

DO $$
DECLARE
    v_task_count INT := 0;
BEGIN
    CALL assign_task(1, 'Review Reports', v_task_count);
    RAISE NOTICE 'Returned task count: %', v_task_count;
END;
$$;

--To check if the Task Was Inserted

SELECT * FROM employee_tasks
WHERE employee_id = 1;


