CREATE DATABASE sales;

USE sales;

CREATE TABLE sales_data (
    product_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    price REAL NOT NULL,
    quantity INTEGER NOT NULL,
    timestamp TIMESTAMP NOT NULL

);
