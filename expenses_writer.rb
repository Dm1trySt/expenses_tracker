require 'rexml/document' #подключаем парсре
require 'date' #будем использовать операции с данными

puts "На что потратили деньги?"
expense_text = STDIN.gets.chomp

puts "Сколько потратили?"
expense_amount = STDIN.gets.chomp.to_i

puts "Укажите дату траты в формате ДД.ММ.ГГГГ, например 15.12.2012 (пустое поле - сегодня)"
date_input = STDIN.gets.chomp

expense_date = nil
# Если пользователь не ввел дату, то устанавливаем сегодняшнее число
if date_input == ''
  expense_date = Date.today
else
  expense_date = Date.parse(date_input)
end

puts "В какую категорию занести трату?"
expense_category = STDIN.gets.chomp

# Путь до папки с программой
current_path = File.dirname(__FILE__)

# путь до файла
file_name = current_path + "/my_expenses.xml"

# Открываем файл
file = File.new(file_name, "r:UTF-8")

# Если файл не открылся !
begin
  doc = REXML::Document.new(file)
    # Ошибка при неудачной попытке открыть файл - ParseException
rescue REXML::ParseException => e
  puts "XML файл похоже битый =("
  abort e.message
end

# Закрываем файл
file.close

# .find('имя тега') - выводит все найденные теги
# .first - первый эллемент
expenses = doc.elements.find('expenses').first

# XML_element.add_element(имя тега, аттрибуты) - добавит в наш тег (XML_element)
# новые теги с элементами
# В данном случае аттрибуты представлены хэш массивом
expense = expenses.add_element 'expense', {
    'amount' => expense_amount,
    'category' => expense_category,
    'date' => expense_date.to_s
}

# .text - содержимое тега
expense.text = expense_text

# Запись файла
file = File.new(file_name, "w:UTF-8")

# .write(файл куда записать, количество отступов)
# в файле при добавлении информации в файл перед тегом будет поставлено
# то кол-во пробелов, которое мы укажем
doc.write(file, 2)

file.close

puts "Записть успешно сохранена"

