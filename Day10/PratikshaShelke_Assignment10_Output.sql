--1.Write  a function to Calculate the total stock value for a given category:
(Stock value=ROUND(SUM(unit_price * units_in_stock)::DECIMAL, 2)
Return data type is DECIMAL(10,2)


CREATE OR REPLACE FUNCTION get_total_stock_value(
    p_category_name VARCHAR
)
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock_value DECIMAL(10,2);
BEGIN
    SELECT ROUND(SUM(p.unit_price * p.units_in_stock)::DECIMAL, 2)
    INTO v_stock_value
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    WHERE c.category_name = p_category_name;

    RETURN v_stock_value;
END;
$$;

SELECT * FROM products;

----------------------------------------------------------------------------------------------------
--2. Try writing a   cursor query which I executed in the training.

CREATE OR REPLACE FUNCTION get_total_stock_value_cursor(
    p_category_name VARCHAR
)
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_product_id INT;
    v_unit_price DECIMAL(10,2);
    v_units_in_stock INT;
    v_stock_value DECIMAL(10,2) := 0;
    v_partial_value DECIMAL(10,2);
    
    product_cursor CURSOR FOR
        SELECT p.product_id, p.unit_price, p.units_in_stock
        FROM products p
        JOIN categories c ON p.category_id = c.category_id
        WHERE c.category_name = p_category_name;
BEGIN
    OPEN product_cursor;
    
    LOOP
        FETCH product_cursor INTO v_product_id, v_unit_price, v_units_in_stock;
        EXIT WHEN NOT FOUND;

        v_partial_value := ROUND(v_unit_price * v_units_in_stock, 2);
        v_stock_value := v_stock_value + v_partial_value;
    END LOOP;
    
    CLOSE product_cursor;
    
    RETURN ROUND(v_stock_value, 2);
END;
$$;

SELECT * FROM products;