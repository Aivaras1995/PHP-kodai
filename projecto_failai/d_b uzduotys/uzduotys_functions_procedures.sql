CREATE FUNCTION sukurti(iname varchar(255), isurname varchar(255), uname varchar(255), personalCode bigint)
    RETURNS int DETERMINISTIC
BEGIN
    DECLARE personId int;
INSERT INTO `persons` (`first_name`, `last_name`, `code`) VALUES (iname, isurname, personalCode);
SET personId = LAST_INSERT_ID();
INSERT INTO users (name, person_id) VALUES (uname, personId);
return personId;
END;

drop function if exists sukurti;

SELECT sukurti('Tautvydas', 'Dulskis', 'emailas@pastas.lt', null);
SELECT sukurti('TOMAS', 'TOMUTIS', 'emaiasl@gmail.com', 98765432198);


use akademija;

CREATE FUNCTION skaiciuoti_adresus (country_iso varchar(255))
    RETURNS int deterministic
BEGIN
SELECT addresses.country_iso, COUNT(country_iso)
FROM addresses
group by addresses.country_iso;
SELECT skaiciuoti_adresus()

END;

    use eshop;
#FUNCTIONS
#1 Sukurkite skaičiuojamąją funkciją,
# kuri suskaičiuoja kiek įrašų yra lentelėje `customers` ir grąžina rezultatą.
CREATE FUNCTION skaiciuoti(customers varchar(255))
RETURNS INT DETERMINISTIC
BEGIN
SELECT `customers.id`, COUNT(`customers.id`)
FROM `customers`;
SELECT skaiciuoti()
END;

#PROCEDURES
#1 Sukurkite procedūrą, kuri ištrina visus įrašus iš lentelės `customers`
# esančius senesnius nei tam tikra data.

CREATE PROCEDURE istrinti(customers varchar(255))
BEGIN
    DELETE * from orders WHERE order_date > ;
end;

#2 Sukurkite procedūrą, kuri atnaujina visų lentelės `employees` darbuotojų algas.
# (pvz. padidina 10%)

CREATE PROCEDURE raises(employees varchar(255))
BEGIN
UPDATE employees SET alga = alga * 10 % '' WHERE employees.id = *;
end;
CALL raises();

#3 Sukurkite procedūrą, kuri sujungia lenteles `orders` ir `products`
# pagal `products`.`id` ir įrašo susijusios prekės pavadinimą
# į `order_products` lentelės `product_name` stulpelį.

CREATE PROCEDURE order_products(orders varchar(255), products varchar(255))
BEGIN
SELECT products.id, orders.products
FROM `Products`
         LEFT JOIN orders
END;