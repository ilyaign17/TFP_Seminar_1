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
#+
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
        main_menu(@store)
      else
        break
      end
    end
  end

#+
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

#+
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
  def main_menu(store)
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
      item_view_store(store)
    when 'Добавить/удалить товар'
      add_delete_menu(store)
    when 'Вывод книг по жанру'
      item_view_books_jenre(store)
    when 'Вывод книг по названию'
      item_view_books_name(store)
    when 'Работа со списками покупок...'
      work_list_menu(store)
    when 'Статистика по жанрам'
      statistics(store)
      main_menu(store)
    end
  end

  def item_view_store(store)
    puts 'Книги:'
    puts store.books_list
    puts 'Канцелярия:'
    puts store.stationery_list
    main_menu(store)
  end

  def item_view_books_jenre(store)
    puts 'Введите жанр'
    genre = gets.chomp
    puts store.select_by_genre(genre, store.books_list)
    main_menu(store)
  end

  def item_view_books_name(store)
    puts 'Введите название'
      name = gets.chomp
      puts store.select_by_name(name, store.books_list)
      main_menu(store)
  end

#+
  def statistics(store)
    statistics = store.statistics(store)
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
  def add_delete_menu(store)
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
      item_add_book_store(store)
    when 'Добавить канцелярию'
      item_add_stationery_store(store)
    when 'Удалить книгу'
      item_delete_book_store(store)
    when 'Удалить канцелярию'
      item_delete_stationery_store(store)
    else
      main_menu(store)
    end
  end

  def item_add_book_store(store)
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
    store.books_list = store.add_book(Book.new(author, name,
                              genre, price, count),
                              store.books_list)
    add_delete_menu(store)
  end

  def item_add_stationery_store(store)
    puts 'Введите название'
      name = gets.chomp
      puts 'Введите цену'
      price = gets.chomp.to_i
      puts 'Введите кол-во'
      count = gets.chomp.to_i
      store.stationery_list = store.add_stationery(Stationery.new(name, price, count),
                               store.stationery_list)
      add_delete_menu(store)
  end

  def item_delete_book_store(store)
    puts 'Введите название'
    name = gets.chomp
    store.delete_thing(name.capitalize,
                        store.books_list)
    add_delete_menu(store)
  end

  def item_delete_stationery_store(store)
    puts 'Введите название'
    name = gets.chomp
    store.delete_thing(name.capitalize,
                        store.stationery_list)
    add_delete_menu(store)
  end

  # ПОЯСНЕНИЕ ОШИБКИ RUBOCOP:
  # МЕТОД, РАСПОЛОЖЕННЫЙ НИЖЕ, ИМЕЕТ РАЗМЕР
  # БОЛЬШЕ ДОПУСТИМОГО ПО ПРИЧИНЕ
  # МАССИВНОЙ ЗАПИСИ СМЫСЛОВОЙ НАГРУЗКИ КЛАССА,
  # ЛОГИЧЕСКОЙ ДЕКОМПОЗИЦИИ КЛАССА,
  # А ТАКЖЕ НЕКОТОРЫХ ИСПРАВЛЕНИЙ RUBOCOP'А.
  def work_list_menu(store)
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
      item_create_list(store)
    when 'Работа со списком'
      item_work_with_list(store)
    when 'Удалить список'
      item_delete_list(store)
    when 'Отобразить списки'
      item_view_lists(store)
    else
      main_menu(store)
    end
  end

  def item_create_list(store)
    store.shopping_lists = store.create_shop_list(store.shopping_lists)
    work_list_menu(store)
  end

  def item_work_with_list(store)
    puts 'Введите id'
    id = gets.chomp
    edit_list_menu(store, id)
  end

  def item_delete_list(store)
    puts store.shopping_lists.map(&:id)
    puts 'Введите id'
    id = gets.chomp
    store.shopping_lists = store.delete_shop_list(id.to_i, store.shopping_lists)
    work_list_menu(store)
  end

  def item_view_lists(store)
    store.shopping_lists.each do |el|
      puts el
    end
    work_list_menu(store)
  end

  # ПОЯСНЕНИЕ ОШИБКИ RUBOCOP:
  # МЕТОД, РАСПОЛОЖЕННЫЙ НИЖЕ, ИМЕЕТ РАЗМЕР
  # БОЛЬШЕ ДОПУСТИМОГО ПО ПРИЧИНЕ
  # МАССИВНОЙ ЗАПИСИ СМЫСЛОВОЙ НАГРУЗКИ КЛАССА,
  # ЛОГИЧЕСКОЙ ДЕКОМПОЗИЦИИ КЛАССА,
  # А ТАКЖЕ НЕКОТОРЫХ ИСПРАВЛЕНИЙ RUBOCOP'А.
#+  
  def edit_list_menu(store, id)
    prompt = TTY::Prompt.new
    choices = ['Добавить книгу',
               'Добавить канцелярию',
               'Удалить книгу/канцелярию',
               'Вывести список с суммой',
               'Оплатить',
               'В главное меню']

    # puts 'Введите id'
    # id = gets.chomp
    check_id(id, store)

    enter = prompt.enum_select('Выберите пункт меню',
                               choices)
    case enter
    when 'Добавить книгу'
      puts 'Здесь id' 
      puts id
      item_add_book(store, id)
    when 'Добавить канцелярию'
      puts 'Здесь id' 
      puts id
      item_add_stationery(store, id)
    when 'Удалить книгу/канцелярию'
      puts 'Здесь id' 
      puts id
      item_delete_thing(store, id)
    when 'Вывести список с суммой'
      puts 'Здесь id' 
      puts id
      item_list_summa(store, id)
    when 'Оплатить'
      puts 'Здесь id' 
      puts id
      item_buy(store, id)
    else
      main_menu(store)
    end
  end

  def check_id(id, store)
    if store.check_id(store.shopping_lists)
      id
    else
      puts 'Такого ID нет'
      main_menu
    end
  end
#+
  def item_add_book(store, id)
    puts 'Введите название'
    name = gets.chomp
    puts 'Здесь до входа в блок' 
    puts id
    store.shopping_lists = store.add_in_bag(id.to_i, 
      store.shopping_lists, store.books_list, name)
    edit_list_menu(store, id)
  end
#+
  def item_add_stationery(store, id)
    puts 'Введите название'
    name = gets.chomp
    store.add_in_bag(id, store.stationery_list, name)
    edit_list_menu(store, id)
  end
#+
  def item_delete_thing(store, id)
    puts 'Введите название'
    name = gets.chomp
    store.delete_from_bag(id, store.shopping_lists, name)
    edit_list_menu(store, id)
  end
#+
  def item_list_summa(store, id)
    answer = store.list_with_summa(id, store.shopping_lists)
    puts("#{answer[0]}\nИТОГО: #{answer[1]}")
    edit_list_menu(store, id)
  end
#+
  def item_buy(store, id)
    puts('Введите название файла (на английском)')
    name_file = gets.chomp
    path = "../lib/#{name_file}.txt"
    puts path
    store = store.buy(id, path, store)
    store.books_list
    work_list_menu(store)
  end
end
