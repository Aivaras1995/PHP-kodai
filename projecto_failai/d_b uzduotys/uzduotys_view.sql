use eshop;

CREATE TABLE `Departments`(
                              id     INT NOT NULL AUTO_INCREMENT,
                              Name   VARCHAR(50),
                              PRIMARY KEY (id)
);
INSERT INTO `Departments` (Name)
    VALUE ('Training'),
    ('Marketing'),
    ('Human Resources'),
    ('Sales'),
    ('Support'),
    ('Research and Development');

ALTER TABLE employees
    ADD Departments varchar(50);

ALTER TABLE employees
    RENAME COLUMN Departments TO Department;

INSERT INTO employees (Department)
VALUES ('Support'),
       ('Research and Development'),
       ('Marketing');

TRUNCATE employees;

INSERT INTO employees (first_name, last_name, alga, Department)
VALUES ('Rosalinde','Chambers', 1100, 'Support'),
       ('Tomas','Tomaitis', 1200 , 'Marketing'),
       ('Dalia','Dalytė', 1300 , 'Research and Development'),
       ('Modestas','Modestaitis', 1000 , 'Human Resources'),
       ('Reg','Mockler', 1500, 'Marketing'),
       ('Bev','Moreing', 1160, 'Training');

# 1. Sukurkite view lentelę, kuri susieja lenteles `employees` ir
# `departments` pagal `departments`.`id` ir atvaizduoja visus `employees` vardus,
# pavardes ir susijusias `departments` pavadinimus.


CREATE VIEW `Job` AS
SELECT first_name,last_name, Department
FROM employees;

SELECT * FROM `job`;

ALTER
ALGORITHM=MERGE
VIEW Job AS
SELECT
    e.first_name,
    e.last_name,
    e.Department,
    d.Name
FROM employees e
         LEFT JOIN Departments d ON d.id=e.id;


INSERT INTO customers (first_name, last_name, email)
VALUES ('Modestas', 'Modestaitis', 'modestukas@gmail.com'),
       ('Rasa', 'Rasickaitė', 'rasyte@gmail.com'),
       ('Liudas', 'Mikalauskas', 'liudukas@gmail.com'),
       ('Kate', 'Jennings', 'Katty@gmail.com');
INSERT INTO orders (id, order_date, address, state, type, person, products, Qantity, Price)
VALUES (3, '2018-01-06', 'Salomėjos Neries g. 25', 'Active','Paid', 'Liudas Mikalauskas', 'Engine',1 , 2500),
       (4, '2010-11-26', 'Vytauto g. 15', 'Inactive','Paid', 'Kate Jennigs', 'TV', 1, 2100),
       (5, '2023-01-15', 'Sausio 13-osios g. 75', 'Active','Not Paid', 'Jude Law', 'Washing Machine', 1, 700),
       (6, '2005-03-08', 'Vokiečių g. 21', 'Inactive','Paid', 'Kate Winslet', 'Computer', 1, 1600),
       (7, '2000-07-10', 'Jakšto g. 95', 'Inactive','Paid', 'Ryan Gosling', 'Monitor', 1, 200);

ALTER TABLE orders

DROP COLUMN type;

#2 Sukurkite view lentelę, kuri susieja lenteles `customers` ir `orders`
# pagal `customers`.`id` ir atvaizduoja visus `customers` vardus, pavardes ir
# susijusias `orders` sumas, tik tada kai suma yra didesnė nei 1000.


CREATE VIEW `Customer_Orders` AS
SELECT id,first_name,last_name
FROM customers;

SELECT * FROM customer_orders;

ALTER
ALGORITHM=MERGE
VIEW customer_orders AS
SELECT
    c.id,
    c.first_name,
    c.last_name,
    orders.Price
FROM customers c
         LEFT JOIN orders o ON o.id=c.id
SELECT * FROM orders WHERE orders.Price>1000;

# 3)Sukurkite view lentelę, kuri susieja lenteles `products` ir `inventory` pagal `products`.`id`
# ir atvaizduoja visus `products` pavadinimus, susijusias `inventory` kiekius ir
# `reorder_level` reikšmes, tik tada kai `quantity` yra mažesnė nei `reorder_level`.

INSERT INTO Products (productid, name, description, price)
VALUES (1,'Engine', 'Automobilio variklis', 2500),
       (2,'Monitor', 'Kompiuterio monitorius', 200),
       (3,'Computer', 'Asmeninis kompiuteris', 1100),
       (4,'Washing Machine', 'Skalbimo mašina', 700),
       (5,'Eggs', 'Kiaušiniai', 3),
       (6,'TV', 'Televizorius', 900);