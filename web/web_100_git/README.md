# Александрийская библиотека
### Сложность: (50)100
### Категория: web + recon 

### Описание:
Прежде всего необходимо взяться за себя.
Формат флага: 16 символов начинается с решетки (#) Все заглавными буквами

### Решение:
Неправильно настроенный веб сервер с возможностью просмотра директорий
На нем найти папку .git, файл config в котором найти remote host
~~~~
[remote "origin"]
	url = git@github.com:Mnimiy2009/egypt_xydeu.git
~~~~
Зайти на него и найти часть флага в файлах, благодаря подсказке о формате флага.

Вторая часть флага в GitHub heatmap
* https://github.com/ben174/git-draw
* https://habrahabr.ru/post/319298/
