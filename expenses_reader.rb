require "rexml/document" #Подключаем парсер
require "date" #будем работать с датами

# Путь до папки программы
current_path = File.dirname(__FILE__ )

# Путь до файла
file_name = current_path + "/my_expenses.xml"

# Ошибка, если файла не суещствует
abort "Извиняемся, хозяин, файлик my_expenses.xml не найден." unless  File.exist?(file_name)

# Открытие файла
file = File.new(file_name)

# REXML::Document.new(file) - создает новый XML объект из файла (file)
doc = REXML::Document.new(file)

# Траты за день
amount_by_day = Hash.new

# XML.elements.each(путь к тэгам) - цикл по всем элементам дерева
doc.elements.each("expenses/expense") do |item|

  # .atributes - возвращает хэш из всех атрибутов
  # в нашем случае эллемента item
  loss_sum = item.attributes["amount"].to_i
  # Date.parse - обрабатывает строчку и переводит в форматы даты
  loss_date = Date.parse(item.attributes["date"])

  # Конструкция выражение ||= значени -
  # если в этот день нет записей то присвоить 0
  amount_by_day[loss_date] ||= 0

  # Добавляем к дате сумму трат в этот день
  amount_by_day[loss_date] += loss_sum
end

# Закрытие файла
file.close

# Траты за месяц
sum_by_month = Hash.new

# Сортировка по ключам
# установим указатель на самой первой дате (sort[0])
current_month = amount_by_day.keys.sort[0].strftime("%B %Y")

# Отсортируем и переберем все значения amount_by_day
amount_by_day.keys.sort.each do |key|

  # .strftime("%B %Y") - форматирование времени по тпу месяц.год
  # Если даты еще нет, то присваиваем 0
  sum_by_month[key.strftime("%B %Y")] ||= 0
  # Добавление суммы затраты на текущий день
  sum_by_month[key.strftime("%B %Y")] += amount_by_day[key]
end

# Вывод заголовка
puts"-------[#{current_month}, всего птрачено: #{sum_by_month[current_month]} р. ]-------"

# Сортировка времени по
amount_by_day.keys.sort.each do |key|

  # Если месяц не совпадает с текущим
  if key.strftime("%B %Y") != current_month
    # присвоим новый месяц
    current_month = key.strftime("%B %Y")

    # Повтор заголовка
    puts"-------[#{current_month}, всего птрачено: #{sum_by_month[current_month]} р. ]-------"
  end

  puts"\t #{key.day}: #{amount_by_day[key]}р."
end