# frozen_string_literal: true

require 'csv'
require_relative 'book'
require_relative 'stationery'
require_relative 'shopping_list'

# This class describes the operation of the store.
# The store sells books and stationery.
class Store
  # ПОЯСНЕНИЕ ОШИБКИ RUBOCOP:
  # КЛАСС ИМЕЕТ РАЗМЕР БОЛЬШЕ ДОПУСТИМОГО ПО
  # ПРИЧИНЕ РЕАЛИЗАЦИИ БОЛЬШОГО КОЛИЧЕСТВА
  # ФУНКЦИЙ
  attr_accessor :books_list, :stationery_list, :shopping_lists

  def initialize(book_list = [], stationery_list = [])
    @books_list = book_list
    @stationery_list = stationery_list
    @shopping_lists = []
  end
#+
  def add_book(book, books_list2)#
    names_books_list = books_list2.map(&:name)
    if names_books_list.include? book.name
      names_books_list.each do |el|
        unless books_list2[names_books_list.index(el)].author == book.author
          next
        end

        books_list2[names_books_list.index(el)].count_things +=
          book.count_things
        break
      end
    else
      books_list2.append(book)
    end
    return books_list2
  end
#+?
  def delete_thing(name, list)
    list.each do |el|
      next unless el.name == name
      el.count_things -= 1
      list.delete(el) if el.count_things.zero?
      break
    end
  end
#+
  def add_stationery(stationery, stationery_list2)#
    names_stationery_list = stationery_list2.map(&:name)
    if names_stationery_list.include? stationery.name
      stationery_list2[names_stationery_list.index(stationery.name)]
        .count_things += stationery.count_things
    else
      stationery_list2.append(stationery)
    end
    return stationery_list2
  end
#+
  def select_by_name(name, books_list2)
    books_list2.select do |el|
      el if el.name.include? name.capitalize
    end
  end
#+
  def select_by_genre(genre, books_list2)
    books_list2.select do |el|
      el if el.genre.include? genre.capitalize
    end
  end
#+
  def create_shop_list(shopping_lists2)
    return shopping_lists2.append(ShoppingList.new(shopping_lists2.size + 1))
  end
#+?
  def delete_shop_list(id, shopping_lists2)
    shopping_lists2.each do |el|
      shopping_lists2.delete(el) if el.id == id
    end
  end
#+
  def add_in_bag(id, shopping_lists2, list, name)
    list_name = list.map(&:name)
    return if !(list_name.include? name)
    index_id = shopping_lists2.map(&:id).index(id)
    index_thing = list_name.index(name)
    thing = list[index_thing]
    #puts thing
    shopping_lists2[index_id.to_i].list.append(thing)
    return shopping_lists2
  end

  def delete_from_bag(id, shopping_lists2, name)
    index_id = shopping_lists2.map(&:id).index(id)
    list_name = shopping_lists2[index_id.to_i].list.map(&:name)
    return if !(list_name.include? name)
    index_thing = list_name.index(name)
    thing = shopping_lists2[index_id.to_i].list[index_thing.to_i]
    shopping_lists2[index_id.to_i].list.delete(thing)
  end
#+
  def buy(id, path, store)
    index_id = store.shopping_lists.map(&:id).index(id.to_i)
    list_things_id = store.shopping_lists[index_id.to_i].list
    save_to_file(path, store.shopping_lists[index_id.to_i])
    delete_shop_list(id.to_i, store.shopping_lists)
    store = delete_from_lists(list_things_id, store)
    return store
  end

  def statistics(store)
    genres = store.books_list.map(&:genre).uniq
    all_stat = []
    i = 0
    while i < genres.count
      all_stat.append(statistic_for_genre(genres[i], store))
      i += 1
    end
    all_stat
  end
#+
  def list_with_summa(id, shopping_lists2)
    index_id = shopping_lists2.map(&:id).index(id.to_i)
    list = shopping_lists2[index_id.to_i]
    summa = array_summa(shopping_lists2[index_id.to_i].list.map(&:price))
    return [list, summa]
  end

  private
#+
  def delete_from_lists(list_things_id, store)
    list_things_id.each do |el|
      store = delete_from_lists_stationery(store, el)
      next unless store.books_list.include? el
      store = delete_from_lists_book(store, el)
    end
    return store
  end
#+
  def delete_from_lists_stationery(store, el)
    if store.stationery_list.include? el
      index_stationery = store.stationery_list.index(el)
      store.stationery_list[index_stationery].count_things -= 1
      if store.stationery_list[index_stationery].count_things.zero?
        store.stationery_list.delete_at(index_stationery)
      end
    end
    store
  end
 #+ 
  def delete_from_lists_book(store, el)
    index_book = store.books_list.index(el)
      store.books_list[index_book].count_things = 
        store.books_list[index_book].count_things.to_i - 1
      if store.books_list[index_book].count_things.zero?
        store.books_list.delete_at(index_book)
      end
    store
  end
#+
  def save_to_file(path, list)
    f = File.open(path, 'a')
    f.puts("ID: #{list.id}")
    f.puts(list.list)
  end
#+
  def count_all(store)
    array_count_things = store.books_list.map(&:count_things) |
                         store.stationery_list.map(&:count_things)
    array_summa(array_count_things)
  end
#+
  def statistic_for_genre(genre, store)
    genres_list = store.books_list.select do |el|
      el if el.genre == genre
    end
    stat_two = array_summa(genres_list.map(&:price)) / genres_list.count
    stat_three = array_summa(genres_list.map(&:count_things))
    stat_four = stat_three.to_f / count_all(store) * 100
    [genre, genres_list.count, stat_two, stat_three, stat_four]
  end
#+
  def array_summa(array)
    summa = 0
    array.each do |el|
      summa += el.to_i
    end
    summa
  end

  def check_id(shopping_lists2)
    return shopping_lists2.map(&:id).include? id.to_i
  end
end
