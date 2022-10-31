# frozen_string_literal: true

require 'tty-prompt'
require_relative 'store'
require_relative 'book'
require_relative 'stationery'

# Realize menu for application
class Menu
  # ПОЯСНЕНИЕ ОШИБКИ RUBOCOP:
  # ДАННЫЙ КЛАСС ИМЕЕТ РАЗМЕР
  # БОЛЬШЕ ДОПУСТИМОГО ПО ПРИЧИНЕ
  # МАССИВНОЙ ЗАПИСИ СМЫСЛОВОЙ НАГРУЗКИ КЛАССА,
  # ЛОГИЧЕСКОЙ ДЕКОМПОЗИЦИИ КЛАССА,
  # А ТАКЖЕ НЕКОТОРЫХ ИСПРАВЛЕНИЙ RUBOCOP'А.
  def initialize(path_books, path_stationery)
    @store = Store.new(load_books(path_books),
                       load_stationery(path_stationery))
    menu
  end

  def menu
    prompt = TTY::Prompt.new
    choices = ['Меню',
               'Завершить работу']
    loop do
      puts ''
      enter = prompt.enum_select('Выберите пункт',
                                 choices)
      case enter
      when 'Меню'
        main_menu
      else
        break
      end
    end
  end

  def load_books(path)

    books_list = []
    CSV.foreach(path, headers: true) do |row|
      book_array = row[0].split(';')
      books_list.append(Book.new(book_array[0], book_array[1],
                                 book_array[2], book_array[3],
                                 book_array[4]))
    end
    books_list
  end

  def load_stationery(path)
    stationery_list = []
    CSV.foreach(path, headers: true) do |row|
      stationery_array = row[0].split(';')
      stationery_list.append(Stationery.new(stationery_array[0],
                                            stationery_array[1],
                                            stationery_array[2]))
    end
    stationery_list
  end

  # ПОЯСНЕНИЕ ОШИБКИ RUBOCOP:
  # МЕТОД, РАСПОЛОЖЕННЫЙ НИЖЕ, ИМЕЕТ РАЗМЕР
  # БОЛЬШЕ ДОПУСТИМОГО ПО ПРИЧИНЕ
  # МАССИВНОЙ ЗАПИСИ СМЫСЛОВОЙ НАГРУЗКИ КЛАССА,
  # ЛОГИЧЕСКОЙ ДЕКОМПОЗИЦИИ КЛАССА,
  # А ТАКЖЕ НЕКОТОРЫХ ИСПРАВЛЕНИЙ RUBOCOP'А.
  def main_menu
    prompt = TTY::Prompt.new
    choices = ['Вывести ассортимент',
               'Добавить/удалить товар',
               'Вывод книг по жанру',
               'Вывод книг по названию',
               'Работа со списками покупок...',
               'Статистика по жанрам',
               'Завершить работу']

    puts ''
    enter = prompt.enum_select('Выберите пункт меню',
                               choices)
    case enter
    when 'Вывести ассортимент'
      puts 'Книги:'
      puts @store.books_list
      puts 'Канцелярия:'
      puts @store.stationery_list
      main_menu
    when 'Добавить/удалить товар'
      add_delete_menu
    when 'Вывод книг по жанру'
      puts 'Введите жанр'
      genre = gets.chomp
      puts @store.select_by_genre(genre)
      main_menu
    when 'Вывод книг по названию'
      puts 'Введите название'
      name = gets.chomp
      puts @store.select_by_name(name)
      main_menu
    when 'Работа со списками покупок...'
      work_list_menu
    when 'Статистика по жанрам'
      statistics
      main_menu
    end
  end

  def statistics
    statistics = @store.statistics
    i = 0
    while i < statistics.count
      puts "Жанр: #{statistics[i][0]}(#{statistics[i][1]} шт.)\n" \
           "Средняя стоимость: #{statistics[i][2]}\n" \
           "Всего экземпляров по жанру: #{statistics[i][3]}\n" \
           "Процент: #{statistics[i][4]}%\n"
      i += 1
    end
  end

  # ПОЯСНЕНИЕ ОШИБКИ RUBOCOP:
  # МЕТОД, РАСПОЛОЖЕННЫЙ НИЖЕ, ИМЕЕТ РАЗМЕР
  # БОЛЬШЕ ДОПУСТИМОГО ПО ПРИЧИНЕ
  # МАССИВНОЙ ЗАПИСИ СМЫСЛОВОЙ НАГРУЗКИ КЛАССА,
  # ЛОГИЧЕСКОЙ ДЕКОМПОЗИЦИИ КЛАССА,
  # А ТАКЖЕ НЕКОТОРЫХ ИСПРАВЛЕНИЙ RUBOCOP'А.
  def add_delete_menu
    prompt = TTY::Prompt.new
    choices = ['Добавить книгу',
               'Добавить канцелярию',
               'Удалить книгу',
               'Удалить канцелярию',
               'В главное меню']

    puts ''
    enter = prompt.enum_select('Выберите пункт меню',
                               choices)
    case enter
    when 'Добавить книгу'
      puts 'Введите автора'
      author = gets.chomp
      puts 'Введите название'
      name = gets.chomp
      puts 'Введите жанр'
      genre = gets.chomp
      puts 'Введите цену'
      price = gets.chomp.to_i
      puts 'Введите кол-во'
      count = gets.chomp.to_i
      @store.add_book(Book.new(author, name,
                               genre, price, count))
      add_delete_menu
    when 'Добавить канцелярию'
      puts 'Введите название'
      name = gets.chomp
      puts 'Введите цену'
      price = gets.chomp.to_i
      puts 'Введите кол-во'
      count = gets.chomp.to_i
      @store.add_stationery(Stationery.new(name, price, count))
      add_delete_menu
    when 'Удалить книгу'
      puts 'Введите название'
      name = gets.chomp
      @store.delete_thing(name.capitalize,
                          @store.books_list)
      add_delete_menu
    when 'Удалить канцелярию'
      puts 'Введите название'
      name = gets.chomp
      @store.delete_thing(name.capitalize,
                          @store.stationery_list)
      add_delete_menu
    else
      main_menu_ex
    end
  end

  # ПОЯСНЕНИЕ ОШИБКИ RUBOCOP:
  # МЕТОД, РАСПОЛОЖЕННЫЙ НИЖЕ, ИМЕЕТ РАЗМЕР
  # БОЛЬШЕ ДОПУСТИМОГО ПО ПРИЧИНЕ
  # МАССИВНОЙ ЗАПИСИ СМЫСЛОВОЙ НАГРУЗКИ КЛАССА,
  # ЛОГИЧЕСКОЙ ДЕКОМПОЗИЦИИ КЛАССА,
  # А ТАКЖЕ НЕКОТОРЫХ ИСПРАВЛЕНИЙ RUBOCOP'А.
  def work_list_menu
    prompt = TTY::Prompt.new
    choices = ['Создать список',
               'Работа со списком',
               'Удалить список',
               'Отобразить списки',
               'В главное меню']

    puts ''
    enter = prompt.enum_select('Выберите пункт меню',
                               choices)
    case enter
    when 'Создать список'
      @store.create_shop_list
      work_list_menu
    when 'Работа со списком'
      edit_list_menu
    when 'Удалить список'
      puts @store.shopping_lists.map(&:id)
      puts 'Введите id'
      id = gets.chomp
      @store.delete_shop_list(id.to_i)
      work_list_menu
    when 'Отобразить списки'
      @store.shopping_lists.each do |el|
        puts el
      end
      work_list_menu
    else
      main_menu_ex
    end
  end

  # ПОЯСНЕНИЕ ОШИБКИ RUBOCOP:
  # МЕТОД, РАСПОЛОЖЕННЫЙ НИЖЕ, ИМЕЕТ РАЗМЕР
  # БОЛЬШЕ ДОПУСТИМОГО ПО ПРИЧИНЕ
  # МАССИВНОЙ ЗАПИСИ СМЫСЛОВОЙ НАГРУЗКИ КЛАССА,
  # ЛОГИЧЕСКОЙ ДЕКОМПОЗИЦИИ КЛАССА,
  # А ТАКЖЕ НЕКОТОРЫХ ИСПРАВЛЕНИЙ RUBOCOP'А.
  def edit_list_menu
    prompt = TTY::Prompt.new
    choices = ['Добавить книгу',
               'Добавить канцелярию',
               'Удалить книгу/канцелярию',
               'Вывести список с суммой',
               'Оплатить',
               'В главное меню']

    puts 'Введите id'
    id = gets.chomp
    check_id(id)

    enter = prompt.enum_select('Выберите пункт меню',
                               choices)
    case enter
    when 'Добавить книгу'
      item_add_book(id)
    when 'Добавить канцелярию'
      item_add_stationery(id)
    when 'Удалить книгу/канцелярию'
      item_delete_thing(id)
    when 'Вывести список с суммой'
      item_list_summa(id)
    when 'Оплатить'
      item_buy(id)
    else
      main_menu_ex
    end
  end

  def check_id(id)
    if @store.shopping_lists.map(&:id).include? id.to_i
      id
    else
      puts 'Такого ID нет'
      main_menu_ex
    end
  end

  def item_add_book(id)
    puts 'Введите название'
    name = gets.chomp
    @store.add_in_bag(id, @store.books_list, name)
    edit_list_menu
  end

  def item_add_stationery(id)
    puts 'Введите название'
    name = gets.chomp
    @store.add_in_bag(id, @store.stationery_list, name)
    edit_list_menu
  end

  def item_delete_thing(id)
    puts 'Введите название'
    name = gets.chomp
    @store.delete_from_bag(id, name)
    edit_list_menu
  end

  def item_list_summa(id)
    answer = @store.list_with_summa(id)
    puts("#{answer[0]}\nИТОГО: #{answer[1]}")
    edit_list_menu
  end

  def item_buy(id)
    puts('Введите название файла (на английском)')
    name_file = gets.chomp
    path = "../lib/#{name_file}.txt"
    puts path
    @store.buy(id, path)
    work_list_menu
  end
end
