-- 1. customers
CREATE TABLE customers (
  customerID    VARCHAR(5)     PRIMARY KEY,
  companyName   VARCHAR(100)   NOT NULL,
  contactName   VARCHAR(50),
  contactTitle  VARCHAR(50),
  city           VARCHAR(50),
  country        VARCHAR(50)
);

-- 2. employees
CREATE TABLE employees (
  employeeID    SERIAL         PRIMARY KEY,
  employeeName  VARCHAR(50)   NOT NULL,
  title          VARCHAR(50),
  city           VARCHAR(50),
  country        VARCHAR(50),
  reports_to     INTEGER
);

-- 3. shippers
CREATE TABLE shippers (
  shipperID     SERIAL         PRIMARY KEY,
  companyName   VARCHAR(50)   NOT NULL
);

-- 4. categories
CREATE TABLE categories (
  categoryID    SERIAL         PRIMARY KEY,
  categoryName  VARCHAR(50)    NOT NULL,
  description    VARCHAR(100)
);

-- 5. products
CREATE TABLE products (
  product_id        SERIAL         PRIMARY KEY,
  productName      VARCHAR(100)   NOT NULL,
  quantity_per_unit VARCHAR(50),
  unit_price        INTEGER,
  discontinued      INTEGER,
  categoryID INTEGER NOT NULL,
  CONSTRAINT fk_products_categories
    FOREIGN KEY (categoryID)
    REFERENCES categories(categoryID)
);

-- 6. orders
CREATE TABLE orders (
  orderID      SERIAL       PRIMARY KEY,
  customerID   VARCHAR(5)   NOT NULL,
  employeeID  INTEGER      NOT NULL,
  orderDate    DATE         NOT NULL,
  requiredDate DATE         NOT NULL,
  shippedDate  DATE,
  shipperID    INTEGER,
  freight       REAL,
  CONSTRAINT fk_orders_customers
    FOREIGN KEY (customerID)
    REFERENCES customers(customerID),
  CONSTRAINT fk_orders_employees
    FOREIGN KEY (employeeID)
    REFERENCES employees(employeeID),
  CONSTRAINT fk_orders_shippers
    FOREIGN KEY (shipperID)
    REFERENCES shippers(shipperID)
);

-- 7. order_details
CREATE TABLE order_details (
  orderID    INTEGER     NOT NULL,
  productID  INTEGER     NOT NULL,
  unit_price  REAL NOT NULL,
  quantity    INTEGER     NOT NULL,
  discount    REAL        NOT NULL DEFAULT 0,
 
  CONSTRAINT fk_od_orders
    FOREIGN KEY (orderID)
    REFERENCES orders(orderID)
  CONSTRAINT fk_od_products
    FOREIGN KEY (productID)
    REFERENCES products(productID)
);