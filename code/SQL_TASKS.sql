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

/*Новая таблица может быть создана на основе данных из другой таблицы.
Для этого используется запрос SELECT, результирующая таблица которого
и будет новой таблицей базы данных. При этом имена столбцов 
запроса становятся именами столбцов новой таблицы. Запрос на создание новой таблицы имеет вид:*/
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


--Запросы на обновление, связанные таблицы

UPDATE book 
     INNER JOIN author ON author.author_id = book.author_id
     INNER JOIN supply ON book.title = supply.title 
                         and supply.author = author.name_author
SET book.amount = book.amount + supply.amount,
    supply.amount = 0   
WHERE book.price = supply.price;

SELECT * FROM book;

SELECT * FROM supply;

--

UPDATE book 
     INNER JOIN author ON author.author_id = book.author_id
     INNER JOIN supply ON book.title = supply.title 
                         and supply.author = author.name_author
SET book.amount = book.amount + supply.amount,
    book.price =  ((book.price * book.amount) + (supply.price * supply.amount))/(book.amount + supply.amount), -- не забываем запятые и скобки
    supply.amount = 0 
    
WHERE book.price <> supply.price;

SELECT * FROM book;

SELECT * FROM supply;


--Запросы на добавление, связанные таблицы (values не указываем")
INSERT INTO author(name_author)
SELECT supply.author 
    FROM author RIGHT JOIN supply ON author.name_author = supply.author
WHERE name_author IS Null;

SELECT * FROM author;

--
INSERT INTO book(title, author_id, price, amount)
SELECT title, author_id, price, amount
FROM 
    author 
    INNER JOIN supply ON author.name_author = supply.author
WHERE amount <> 0;

SELECT * FROM book;


/*Пример
Задать для книги Пастернака «Доктор Живаго»  жанр «Роман».
Если мы знаем код этой книги в таблице book (в нашем случае это 9)
 и код жанра «Роман» в таблице genre (это 1), запрос будет очень простым.*/

UPDATE book
SET genre_id = 1
WHERE book_id = 9;

SELECT * FROM book;


--Более сложным будет запрос, если известно только название жанра (результат будет точно таким же):
UPDATE book
SET genre_id = 
      (
       SELECT genre_id 
       FROM genre 
       WHERE name_genre = 'Роман'
      )
WHERE book_id = 9;

SELECT * FROM book;

/*Действия при удалении записи главной таблицы
С помощью выражения ON DELETE можно установить действия, которые выполняются для записей подчиненной таблицы при удалении связанной строки из главной таблицы. При удалении можно установить следующие опции:

CASCADE: автоматически удаляет строки из зависимой таблицы при удалении  связанных строк в главной таблице.
SET NULL: при удалении  связанной строки из главной таблицы устанавливает для столбца внешнего ключа значение NULL. (В этом случае столбец внешнего ключа должен поддерживать установку NULL).
SET DEFAULT похоже на SET NULL за тем исключением, что значение  внешнего ключа устанавливается не в NULL, а в значение по умолчанию для данного столбца.
RESTRICT: отклоняет удаление строк в главной таблице при наличии связанных строк в зависимой таблице.
Важно! Если для столбца установлена опция SET NULL, то при его описании нельзя задать ограничение на пустое значение.
*/

CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    author_id INT NOT NULL, 
    genre_id INT,
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id)  REFERENCES genre (genre_id) ON DELETE SET NULL
);



/*
При создании таблицы для внешних ключей с помощью ON DELETE устанавливаются опции,
которые определяют действия , выполняемые при удалении связанной строки из главной таблицы.
В частности, ON DELETE CASCADE автоматически удаляет строки из зависимой таблицы при удалении
связанных строк в главной таблице.

--В таблице book эта опция установлена для поля author_id.*/
DELETE FROM author
WHERE author_id IN
(
SELECT author_id
FROM 
    book 
GROUP BY author_id
HAVING sum(amount) < 20
);

SELECT * FROM author;
SELECT * FROM book;


/*Удалим из таблицы genre все  жанры, название которых заканчиваются на «я» , а в таблице book  -  для этих жанров установим значение Null.
Запрос:*/
DELETE FROM genre
WHERE name_genre LIKE "%я";

SELECT * FROM genre;

SELECT * FROM book;



/*Запросы на основе трех и более связанных таблиц
Пример
Вывести фамилии всех клиентов, которые заказали книгу Булгакова «Мастер и Маргарита»*/
SELECT buy.buy_id, title, price, buy_book.amount 
FROM 
    client 
    INNER JOIN buy ON client.client_id = buy.client_id
    INNER JOIN buy_book ON buy_book.buy_id = buy.buy_id
    INNER JOIN book ON buy_book.book_id=book.book_id
WHERE name_client = "Баранов Павел"
ORDER BY buy_id, title


/*Задание 
Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине.
Указать количество заказов в каждый город, этот столбец назвать Количество. 
Информацию вывести по убыванию количества заказов, 
а затем в алфавитном порядке по названию городов.*/
SELECT name_city, count(buy_id) AS Количество
FROM city         
    JOIN client USING (city_id)
    JOIN buy USING (client_id)
GROUP BY name_city
ORDER BY name_city

/*Задание
Вывести номера всех оплаченных заказов и даты, когда они были оплачены.*/
SELECT buy_id, date_step_end
FROM step 
    JOIN buy_step USING (step_id)
WHERE step_id = 1 AND date_step_end IS NOT NULL;

/*Задание
Вывести информацию о каждом заказе: его номер, кто его сформировал 
(фамилия пользователя) и его стоимость (сумма произведений количества заказанных книг и их цены), 
в отсортированном по номеру заказа виде. Последний столбец назвать Стоимость*/
SELECT buy_id, name_client, SUM(book.price * buy_book.amount) AS Стоимость
FROM book
     JOIN buy_book USING (book_id) 
     JOIN buy USING (buy_id)
     JOIN client USING (client_id)
GROUP BY buy_book.buy_id
ORDER BY buy_id

/*Задание
Вывести номера заказов (buy_id) и названия этапов,  на которых они в данный момент находятся.
Если заказ доставлен –  
информацию о нем не выводить. Информацию отсортировать по возрастанию buy_id.*/
SELECT buy_id, name_step
FROM step INNER JOIN buy_step ON step.step_id = buy_step.step_id
WHERE date_step_beg IS NOT NULL AND date_step_end IS NULL
ORDER BY buy_id;



/*Задание
В таблице city для каждого города указано количество дней, за которые заказ может быть доставлен в
этот город (рассматривается только этап Транспортировка). Для тех заказов, которые прошли этап 
транспортировки, вывести количество дней за которое заказ реально доставлен в город. А также, 
если заказ доставлен с опозданием, указать количество дней задержки, в противном случае вывести 0.
В результат включить номер заказа (buy_id), а также вычисляемые столбцы Количество_дней и Опоздание. 
Информацию вывести в отсортированном по номеру заказа виде.*/

SELECT buy_id, DATEDIFF(date_step_end, date_step_beg) AS Количество_дней,
IF(DATEDIFF(date_step_end, date_step_beg) > days_delivery, DATEDIFF(date_step_end, date_step_beg)-days_delivery, 0) AS Опоздание 
FROM city
     JOIN client USING (city_id)
     JOIN buy USING (client_id)
     JOIN buy_step USING (buy_id) 
     JOIN step USING (step_id)
WHERE name_step = "Транспортировка" AND DATEDIFF(date_step_end, date_step_beg) IS NOT NULL;



/*Задание
Вывести жанр (или жанры), в котором было заказано больше всего экземпляров книг,
указать это количество. Последний столбец назвать Количество*/
SELECT name_genre, SUM(buy_book.amount) AS Количество
    FROM genre
    JOIN book USING (genre_id)
    JOIN buy_book USING (book_id)
    GROUP BY genre_id
    HAVING sum(buy_book.amount) =  
                (SELECT MAX(sum_amount) AS max_amount /* вычисляем максимальное из общего количества книг каждого автора */
                FROM 
                (SELECT sum(buy_book.amount) AS sum_amount /* считаем количество книг каждого автора */
                FROM buy_book JOIN book USING (book_id)
                GROUP BY genre_id
                )query_in );


/*Пример UNION
Вывести всех клиентов, которые делали заказы или в этом, или в предыдущем году.
На этом примере рассмотрим разницу между UNION и UNION ALL.
С UNION клиенты будут выведены без повторений:*/

SELECT name_client
FROM 
    buy_archive
    INNER JOIN client USING(client_id)
UNION
SELECT name_client
FROM 
    buy 
    INNER JOIN client USING(client_id)
+-----------------+
| name_client     |
+-----------------+
| Баранов Павел   |
| Абрамова Катя   |
| Яковлева Галина |
| Семенонов Иван  |
+-----------------+
Affected rows: 4
C UNION ALL будут выведены клиенты с повторением (для тех, кто заказывал книги в обоих годах, а также несколько раз в одном году)

SELECT name_client
FROM 
    buy_archive
    INNER JOIN client USING(client_id)
UNION ALL
SELECT name_client
FROM 
    buy 
    INNER JOIN client USING(client_id)
+-----------------+
| name_client     |
+-----------------+
| Баранов Павел   |
| Баранов Павел   |
| Абрамова Катя   |
| Абрамова Катя   |
| Абрамова Катя   |
| Яковлева Галина |
| Яковлева Галина |
| Баранов Павел   |
| Абрамова Катя   |
| Абрамова Катя   |
| Баранов Павел   |
| Баранов Павел   |
| Абрамова Катя   |
| Семенонов Иван  |
+-----------------+
Affected rows: 14


/*Сравнить ежемесячную выручку от продажи книг за текущий и предыдущий годы. 
Для этого вывести год, месяц, сумму выручки в отсортированном сначала по возрастанию месяцев,
затем по возрастанию лет виде. Название столбцов: Год, Месяц, Сумма.
пример группировки с UNION!*/
SELECT YEAR(date_payment) AS Год, MONTHNAME(date_payment) AS Месяц, sum(amount * price) AS Сумма
FROM 
    buy_archive
GROUP BY 1, 2    
UNION ALL

SELECT YEAR(date_step_end), MONTHNAME(date_step_end) AS Месяц, sum(buy_book.amount * book.price)
FROM 
    book 
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy USING(buy_id) 
    INNER JOIN buy_step USING(buy_id)
    INNER JOIN step USING(step_id)    

WHERE  date_step_end IS NOT Null and name_step = "Оплата"
GROUP BY 1, 2
ORDER BY 2, 1 

Query result:
+------+----------+---------+
| Год  | Месяц    | Сумма   |
+------+----------+---------+
| 2019 | February | 5626.30 |
| 2020 | February | 3309.37 |
| 2019 | March    | 6857.50 |
| 2020 | March    | 2131.49 |
+------+----------+---------+
Affected rows: 4


/*!!Запросы с UNION можно использовать как вложенные, 
это позволяет обрабатывать данные из объединенных запросов совместно!!.

--
Для каждой отдельной книги необходимо вывести информацию о количестве проданных экземпляров 
и их стоимости за текущий и предыдущий год . 
Вычисляемые столбцы назвать Количество и Сумма. Информацию отсортировать по убыванию стоимости.*/
SELECT title, SUM(Количество) Количество, SUM(Сумма) Сумма
FROM
      (
SELECT book.title, SUM(buy_archive.amount) AS Количество, SUM(buy_archive.amount * buy_archive.price) AS Сумма
       FROM   
       buy_archive 
       INNER JOIN book USING(book_id)
       GROUP BY title     
UNION ALL
       SELECT book.title, buy_book.amount, buy_book.amount * book.price
        FROM 
        book 
        INNER JOIN buy_book USING(book_id)
        INNER JOIN buy USING(buy_id) 
        INNER JOIN buy_step USING(buy_id)
        INNER JOIN step USING(step_id)     
        WHERE buy_step.step_id = 1 AND buy_step.date_step_end IS NOT NULL
       ) query_in
       GROUP BY title
       ORDER BY Сумма DESC

/*
1. В запросах на добавление можно одновременно заносить и
константы, и данные из других таблиц. Для этого в той части запроса INSERT , 
где задается запрос на выборку, в качестве полей для вставки указываются
 не только поля других таблиц, но и  константы:*/
INSERT INTO client(name_client, city_id, email) 
SELECT 'Попов Илья', city.city_id, 'popov@test'
FROM city
WHERE name_city='Москва';
select * from client;

Affected rows: 1

Query result:
+-----------+-----------------+---------+----------------+
| client_id | name_client     | city_id | email          |
+-----------+-----------------+---------+----------------+
| 1         | Баранов Павел   | 3       | baranov@test   |
| 2         | Абрамова Катя   | 1       | abramova@test  |
| 3         | Семенонов Иван  | 2       | semenov@test   |
| 4         | Яковлева Галина | 1       | yakovleva@test |
| 5         | Попов Илья      | 1       | popov@test     |
+-----------+-----------------+---------+----------------+
Affected rows: 5


---
INSERT INTO buy_book (buy_id, book_id, amount)
SELECT 5, book_id, 2
FROM book
WHERE title = "Лирика";
INSERT INTO buy_book (buy_id, book_id, amount)
SELECT 5, book_id, 1
FROM book
WHERE title = "Белая гвардия";
SELECT * FROM buy_book;

INSERT INTO buy_book (buy_id, book_id, amount)
SELECT 5, book_id, 2
FROM book
WHERE title = "Лирика";
INSERT INTO buy_book (buy_id, book_id, amount)
SELECT 5, book_id, 1
FROM book
WHERE title = "Белая гвардия";
SELECT * FROM buy_book;


/*Создать счет (таблицу buy_pay) на оплату заказа с номером 5,
в который включить название книг, их автора, цену,
количество заказанных книг и  стоимость. 
Последний столбец назвать Стоимость.
Информацию в таблицу занести в отсортированном
 по названиям книг виде.*/

CREATE TABLE buy_pay AS 
SELECT title, name_author, price, buy_book.amount, buy_book.amount * price AS стоимость
FROM book JOIN author USING (author_id)
          JOIN buy_book USING (book_id)
WHERE buy_id = 5 
ORDER BY 1;
SELECT * FROM buy_pay;

--

CREATE TABLE buy_pay AS 
SELECT buy_id, SUM(buy_book.amount) AS Количество, SUM(book.price * buy_book.amount) AS Итого
FROM book JOIN buy_book USING (book_id)
WHERE buy_id = 5;
SELECT * FROM buy_pay;



В таблицу buy_step занести дату 12.04.2020 выставления счета на оплату заказа с номером 5.

/*Правильнее было бы занести не конкретную, а текущую дату. 
Это можно сделать с помощью функции Now(). Но при этом 
в разные дни будут вставляться разная дата, 
и задание нельзя будет проверить, поэтому  вставим дату 12.04.2020.*/
UPDATE buy_step 
        JOIN step USING(step_id) 
SET date_step_beg = "2020-04-12"
WHERE name_step="Оплата" AND buy_id = 5;

SELECT *
FROM buy_step
WHERE buy_id = 5
