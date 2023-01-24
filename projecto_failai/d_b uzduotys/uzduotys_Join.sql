USE akademija;
create table students
(
    id          INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50),
    age        VARCHAR(50),
    ClassId      VARCHAR(50),
    postcode    VARCHAR(50),
    PRIMARY KEY (id)
);

#1 Kiek 'useriu' kurių 'state' yra 'Active'  būsenoje.
Select Count(*)
from users
JOIN states ON users.state = states.id
WHERE states.title = 'Active';

SELECT distinct state from users;

#2 Kiek 'gruops' kuriu 'state' yra 'Active' būsenoje.

SELECT Count(*)
from `groups`
JOIN states on `groups`.state = `groups`.id
WHERE `groups`.title = 'Active';

#3 paSELECTinti iš 'persons' lentelės įrašus kurie turi 'address_id',
# ekrane rodyti tik 'persons.first_name' , 'persons.last_name',
# address.city' ir 'countries.title' pilną šalies pavadinimą kur jis gyvena.

SELECT persons.first_name, persons.last_name, addresses.city, countries.title
FROM persons
LEFT JOIN addresses ON persons.address_id = addresses.id
LEFT JOIN countries ON persons.address_id = countries.title
WHERE persons.address_id is not null;

#4 Suskaičiuoti kiek yra studentų tik aktyviose "Active" grupėse.
# Pavaizduoti Grupės pavadinimą ir studentų skaičių tose grupese.

ALTER TABLE `groups`
MODIFY state VARCHAR(50);

SELECT COUNT(state)
FROM `groups`
WHERE groups.state = 'Active';

#5 Atvaizduoti tik dieninių (Kai grupės pavadinimas baigiasi 'D' raide) studijų studentų:
#a) Sąrašą
SELECT title
FROM `groups`
WHERE title LIKE '%D';
#b) Bendrą skaičių
SELECT COUNT(title)
FROM `groups`
WHERE title LIKE '%D';

#6 Pavaizduoti pasirinktos grupės studentus ir pilną adresą viename stulpelyje.
# (Užklausos salygoje ieskoti pagal grupės pavadinimą ne ID).
SELECT addresses.id, addresses.country_iso, addresses.city, addresses.street, addresses.postcode,
`groups`.title
FROM addresses
LEFT JOIN `groups` ON addresses.id = `groups`.address_id
WHERE title LIKE '%V';

#7 Surasti visus asmenis (‘persons’) kurie neturi vardo (`first_name’) arba pavardės (‘last_name’)
# ir turi neaktyvų (‘Inactive’) vartotoją (‘users’)
# (Jei tokių duomenų nėra prieš atliekant užduotį reikia pakoreguoti persons lentos  duomenis
# ir pašalinti keleta vardu ir pavardziu).

SELECT users.id AS user_id,person_id AS person_id,first_name,last_name
FROM persons
LEFT JOIN users AS users ON persons.id = users.person_id
WHERE users.state = 'Inactive' OR persons.first_name IS NULL OR persons.last_name IS NULL;

#8 Suskaičiuoti kiek grupių naudojasi tais pačiais adresais.
# Atvaizduoti kiekio stulpelį ir pilna adresą kaip vieną stulpelį. (viso 2 stulpeliai)

SELECT count(*) as kiek, concat(a.city, ' ', a.street) as pilnas_adresas

FROM `groups` g
         JOIN addresses a ON a.id = g.address_id
group by g.address_id
HAVING kiek > 1;