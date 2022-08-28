/* создание отношенией(таблиц)  – это структура данных целиком,
     набор записей (в обычном понимании – таблица) */

CREATE TABLE book ( 
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8, 2), -- перед запятой количество цифр, после запятой количество.
    amount INT);
  

-- Добавление параметров в поля:
INSERT INTO book (title, author, price, amount)
VALUES ('Мастер и Маргарита', 'Булгаков М.А.', 670.99, 3);

-- Добавление множеств параметров в поля:
INSERT INTO book (title, author, price, amount)
VALUES 
('Белая гвардия', 'Булгаков М.А.', 540.50, 5),
('Идиот', 'Достоевский Ф.М.', 460.00, 10),
('Братья Карамазовы ', 'Достоевский Ф.М.', 799.01, 2);
SELECT * FROM book;

--

INSERT INTO author(name_author)
VALUES 
('Булгаков М.А.'),
('Достоевский Ф.М.'),
('Есенин С.А.'),
('Пастернак Б.Л.');
SELECT * FROM author;


-- Запрос вывода title AS Название, (alies) :
SELECT title AS Название, amount 
FROM book;

/*  ROUND(x, k)	округляет значение x до k знаков после запятой,
    Если k не указано – x округляется до целого*/
ROUND(4.361)=4
ROUND(5.86592,1)=5.9

-- a sample
SELECT author, SUM(price * amount) AS Стоимость, 
ROUND(SUM(price * amount) * (18/100) / (1 + 18/100),2) AS НДС,
ROUND(SUM(price * amount) / (1 + 18/100),2) AS Стоимость_без_НДС
FROM book
GROUP BY author;

/* Запрос Для упаковки каждой книги требуется один лист бумаги, 
цена которого 1 рубль 65 копеек. Посчитать стоимость упаковки
для каждой книги (сколько денег потребуется, чтобы упаковать все экземпляры книги).
В запросе вывести название книги, ее количество и стоимость упаковки, 
последний столбец назвать pack.*/
SELECT title, author, price, amount,  price * amount AS total 
FROM book;

--IF(логическое_выражение, выражение_1, else = выражение_2)
SELECT title, amount, price, IF(amount<4, price*0.5, price*0.7) AS sale
FROM book;

--Выборка данных по условию
SELECT title, price 
FROM book
WHERE price < 600;

--Выбор уникальных элементов столбца
SELECT DISTINCT author
FROM book;

-- или

SELECT author 
FROM book
GROUP BY author;

/*Посчитать, количество различных книг и количество экземпляров книг каждого автора ,
  хранящихся на складе */ 
SELECT author AS Автор, count(amount) AS Различных_книг, sum(amount) AS Количество_экземпляров
FROM book
GROUP by author;

/*К групповым функциям SQL относятся: MIN(), MAX() и AVG() min max avg являются групповыми функциями.
необходимо использовать group by, и эти групповые функции будут считать минимальное максимальное 
или среднее в пределах своей группы*/

SELECT author, 
MIN(price) AS Минимальная_цена, 
MAX(price) AS Максимальная_цена, 
AVG(price) AS Средняя_цена
FROM book
GROUP BY author;


--  В запросах с групповыми функциями вместо WHERE используется ключевое слово HAVING
'''Последовательность выполнения операций
    1 FROM
    2 WHERE
    3 GROUP BY
    4 HAVING
    5 SELECT
    6 ORDER BY
'''



SELECT author, SUM(price * amount) AS Стоимость
FROM book
WHERE title <> 'Идиот' AND title <> 'Белая гвардия'
GROUP BY author
HAVING SUM(price * amount) > 5000
ORDER BY author DESC;

/*Вывести информацию (автора, название и цену) о тех книгах, 
цены которых превышают минимальную цену книги на складе не 
более чем на 150 рублей в отсортированном по возрастанию цены виде*/
SELECT author, title, price
FROM book
WHERE price <= (SELECT MIN(price) FROM book) + 150
ORDER BY price ASC;

/*Вложенный запрос может возвращать несколько значений одного столбца.
Тогда его можно использовать в разделе WHERE совместно с оператором IN*/
SELECT title, author, amount, price
FROM book
WHERE author IN (
        SELECT author 
        FROM book 
        GROUP BY author 
        HAVING SUM(amount) >= 12
      );

---------
SELECT *
FROM Universities
WHERE Location IN ('Novosibirsk', 'Perm')

--Этот запрос аналогичен:
SELECT *
FROM Universities
WHERE Location = 'Novosibirsk' OR Location = 'Perm'

/*Операторы ANY и ALL используются с предложением WHERE или HAVING.
Оператор ANY возвращает true, если какое-либо из значений подзапроса соответствует 
условию. Оператор ALL возвращает true, если все значения подзапроса удовлетворяют условию*/



--Добавление записей из другой таблицы
INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply;

SELECT * FROM book;

--Добавление записей из другой таблицы
INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply
WHERE author not in ('Булгаков М.А.', 'Достоевский Ф.М.')

/*Изменение записей в таблице реализуется с 
  помощью запроса UPDATE. 
  Простейший запрос на обновление выглядит так: UPDATE таблица SET поле = выражение

где 
таблица     – имя таблицы, в которой будут проводиться изменения;
поле        – поле таблицы, в которое будет внесено изменение;
выражение   – выражение,  значение которого будет занесено в поле*/

UPDATE book 
SET price = 0.7 * price 
WHERE amount < 5;
SELECT * FROM book;

--
UPDATE book 
SET price = 0.9 * price 
WHERE amount BETWEEN 5 AND 10;
SELECT * FROM book;

--

UPDATE book 
SET buy   = IF(buy > amount,amount, buy ),
    price = IF(buy = 0, price * 0.9, price);
SELECT * FROM book;

--
UPDATE book, supply
SET book.amount = book.amount + supply.amount,
    book.price =  (book.price + supply.price) / 2
WHERE book.title = supply.title AND book.author = supply.author;
SELECT * FROM book;


/*Запросы на удаление -
Удалить из таблицы supply все книги, названия которых есть в таблице book
Запрос:                                                                     */

DELETE FROM supply 
WHERE title IN (
        SELECT title 
        FROM book
      );
SELECT * FROM supply;


---
CREATE TABLE ordering AS 
    SELECT author, title, 
   (SELECT ROUND(AVG(amount)) 
    FROM book) AS amount
FROM book
WHERE amount < (SELECT AVG(amount) 
    FROM book);
SELECT * FROM ordering;

--поиск по заданным параметрам LIKE
SELECT name, city, per_diem, date_first, date_last
FROM trip 
WHERE name LIKE "%а_____"
ORDER BY date_last DESC

--
SELECT name 
FROM trip
WHERE city = "Москва"
GROUP BY name
ORDER by name ASC;

-- или

SELECT DISTINCT name 
FROM trip
WHERE city = "Москва"
ORDER by name ASC;
--



-- Сколько раз в этих городах были сотрудники
SELECT city, count(city) as Количество
FROM trip
GROUP BY city
ORDER BY city ASC

--Оператор LIMIT
SELECT *
FROM trip
ORDER BY  date_first
LIMIT 1;

--
SELECT  city, count(city) AS Количество
FROM trip
GROUP by city
ORDER by count(city) DESC
LIMIT 2;

/*DATEDIFF(дата_1, дата_2), результатом которой является 
количество дней между дата_1 и дата_2. Например:    */

SELECT name, city, DATEDIFF(date_last, date_first) + 1 AS Длительность
FROM trip 
WHERE city NOT IN('Санкт-Петербург', 'Москва') 
ORDER BY Длительность DESC

--Вывести информацию о командировках сотрудника(ов), которые были самыми короткими по времени.
SELECT name, city, date_first, date_last
FROM trip
WHERE DATEDIFF(date_last, date_first) = (SELECT min(DATEDIFF(date_last, date_first))FROM trip);

--Вывести название месяца и количество командировок для каждого месяца.
SELECT MONTHNAME(date_first) AS Месяц, count(date_first) AS Количество
FROM trip
GROUP BY месяц
ORDER BY Количество DESC, Месяц 


-- февраль март, сумма суточных
SELECT name, city, date_first, per_diem * (DATEDIFF(date_last, date_first) + 1) AS Сумма
FROM trip
WHERE date_first LIKE '2020-02-__' OR date_first LIKE '2020-03-__'
ORDER BY name, per_diem * DATEDIFF(date_last, date_first) DESC

--OR

SELECT name,city,date_first, per_diem*(DATEDIFF(date_last,date_first)+1) AS Сумма 
FROM trip 
WHERE MONTH(date_first)=2 or MONTH(date_first)=3 and YEAR(date_first)=2020 
ORDER BY name ASC, Сумма DESC;


-- В SQL есть функции, которые позволяют выделить часть даты:
-- день(DAY()), месяц (MONTH()), год(YEAR()) . Например:

DAY('2020-02-01') = 1
MONTH('2020-02-01') = 2
YEAR('2020-02-01') = 2020

--сумма всех коммандировок отгруппированных по фимилии. 

SELECT name, sum((DATEDIFF(date_last, date_first) + 1) * per_diem) AS Сумма -- сумма всех поездок на одну фамилию
FROM trip 
GROUP by name
HAVING count(name) > 3 
ORDER BY sum((DATEDIFF(date_last, date_first) + 1) * per_diem) DESC

-- так отобразится колличество коммандировок
select name
,count((datediff(date_last,date_first) + 1) * per_diem) as Количество, 
sum((datediff(date_last,date_first) + 1) * per_diem) as Сумма
from trip
group by name
having count(name) > 3
order by 2 desc

--- Создание таблици с null значениями и датами в ''

INSERT INTO fine (name, number_plate, violation, sum_fine, date_violation, date_payment)
VALUES 
('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', NULL, '2020-02-14', NULL),
('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', NULL, '2020-02-23', NULL),
('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', NULL,'2020-03-03', NULL);

SELECT * FROM fine;


--Для присваивания псевдонима существует 2 варианта: 

--с использованием ключевого слова AS 
FROM fine AS f, traffic_violation AS tv
--а так же и без него
FROM fine f, traffic_violation tv

--

--при обновлении не нужен FROM, aliases указываем как например fine f или fine AS f. 

UPDATE fine f, traffic_violation tv
SET f.sum_fine = tv.sum_fine
WHERE f.sum_fine IS NULL AND f.violation = tv.violation;

SELECT * FROM fine;


-- группировка по трем полям, группы создаются с одинаковыми параметрами в 3х полях

SELECT name, number_plate, violation, count(violation) AS количество_нарушений
FROM fine
GROUP by name, number_plate, violation
HAVING count(violation) >= 2
ORDER by name, number_plate, violation


---

UPDATE fine, ( SELECT name, number_plate, violation FROM fine GROUP by name, number_plate, violation HAVING count(violation) >= 2) query_in
SET fine.sum_fine = sum_fine * 2 
WHERE date_payment IS NULL AND fine.name = query_in.name AND fine.number_plate = query_in.number_plate AND fine.violation = query_in.violation 


UPDATE fine, payment
SET fine.date_payment = payment.date_payment,
    fine.sum_fine = IF(DATEDIFF(payment.date_payment, fine.date_violation) <= 20, fine.sum_fine/2, fine.sum_fine)

---


WHERE fine.date_payment IS NULL 
AND fine.violation = payment.violation
AND fine.number_plate = payment.number_plate; -- без точки с запятой - ошибка.
SELECT * FROM fine;


CREATE TABLE back_payment AS
SELECT name, number_plate, violation, sum_fine, date_violation
FROM fine
WHERE date_payment IS NULL;
SELECT * FROM back_payment;


--Запросы на удаление


DELETE from supply
WHERE author IN 
(
SELECT author
FROM book
GROUP BY author
HAVING sum(amount) > 10
);

SELECT * FROM supply;



--По умолчанию любой столбец, кроме ключевого, может содержать значение NULL. 
--При создании таблицы это можно переопределить, 
--используя  ограничение NOT NULL для этого столбца:

CREATE TABLE таблица (
    столбец_1 INT NOT NULL, 
    столбец_2 VARCHAR(10) 
);

-- создание внешнего ключа

CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    author_id INT NOT NULL, 
    genre_id INT, 
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id),
    FOREIGN KEY (genre_id)  REFERENCES genre (genre_id)
    );


--

CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    author_id INT NOT NULL, 
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id) ON DELETE CASCADE
);

ON DELETE CASCADE -- удоляет и в зависимой таблице




--- Добавление значений 

INSERT INTO book (title, author_id, genre_id, price, amount)
VALUES 
    ('Стихотворения и поэмы', 3, 2, 650.00, 15),
    ('Черный человек',	3,	2,	570.20,	6),
    ('Лирика',	4,	2,	518.99,	2);
  

SELECT * FROM book;



--my First JOIN 

SELECT title, name_genre, price 
FROM
    book INNER JOIN genre
    ON book.genre_id = genre.genre_id
WHERE book.amount > 8
ORDER BY price DESC;

--

SELECT name_genre
FROM 
    book RIGHT JOIN genre
    ON book.genre_id = genre.genre_id
WHERE title IS NULL;


--Cros join и генерация даты

SELECT name_city, name_author, (DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * 365) DAY)) AS Дата
FROM author, city
ORDER BY name_city, Дата


-- Join и группировка 

SELECT name_author, SUM(amount) AS Количество
FROM 
    author 
    LEFT JOIN book ON author.author_id = book.author_id
GROUP BY name_author
HAVING SUM(amount) < 10 OR SUM(amount) IS NULL
ORDER BY  SUM(amount);    



-- подсчитывает уникальное количество строк в поле. 

SELECT name_author
FROM book
JOIN genre ON genre.genre_id = book.genre_id
JOIN author ON book.author_id = author.author_id
GROUP BY name_author
HAVING COUNT(distinct book.genre_id) = 1  -- уникальное количество записей повторяющихся( допустим Пастернак несколько раз пишет в одном жанре, жанр уникальный и он 1.)


--


SELECT query_in_1.genre_id, query_in_1.sum_amount
FROM 
    (/* выбираем id жанра и сумму произведений, относящихся к нему */
      SELECT genre_id, SUM(amount) AS sum_amount                                    
      FROM book
      GROUP BY genre_id                                                     --  "Это таблица"
    )query_in_1
    INNER JOIN
    (/* выбираем запись, в которой указан id жанр с максимальным количеством книг */ --получим 31 
      SELECT genre_id, SUM(amount) AS sum_amount
      FROM book
      GROUP BY genre_id
      ORDER BY sum_amount DESC                                              --  "и это таблица"
      LIMIT 1
     ) query_in_2
     ON query_in_1.sum_amount= query_in_2.sum_amount 


-- потом это все склеивается по JOIN где есть совпадения строк
    Query result:
    +----------+------------+
    | genre_id | sum_amount |
    +----------+------------+
    | 1        | 31         |
    | 2        | 31         |
    +----------+------------+
    Affected rows: 2

    --- еще одна вариация без группировки


    SELECT title ,name_author, name_genre, price, amount
FROM 
    author 
    INNER JOIN book ON author.author_id = book.author_id
    INNER JOIN genre ON  book.genre_id = genre.genre_id

WHERE genre.genre_id IN
         (/* выбираем автора, если он пишет книги в самых популярных жанрах*/
          SELECT query_in_1.genre_id
          FROM 
              ( /* выбираем код жанра и количество произведений, относящихся к нему */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
               )query_in_1
          INNER JOIN 
              ( /* выбираем запись, в которой указан код жанр с максимальным количеством книг */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
                ORDER BY sum_amount DESC
                LIMIT 1
               ) query_in_2
          ON query_in_1.sum_amount= query_in_2.sum_amount
         )
ORDER BY title;



SELECT title, name_author, author.author_id /* явно указать таблицу - обязательно */
FROM 
    author INNER JOIN book
    ON author.author_id = book.author_id;

--Вариант с USING
SELECT title, name_author, author_id /* имя таблицы, из которой берется author_id, указывать не обязательно*/
FROM 
    author INNER JOIN book
    USING(author_id);



SELECT book.title AS Название, author.name_author AS Автор, supply.amount + book.amount AS Количество
FROM book JOIN author USING (author_id)
          JOIN supply ON book.title = supply.title
                     AND supply.price = book.price
/* WHERE supply.price = book.price */