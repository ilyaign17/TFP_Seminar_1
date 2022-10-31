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

  def add_book(book)#
    names_books_list = @books_list.map(&:name)
    if names_books_list.include? book.name
      names_books_list.each do |el|
        unless @books_list[names_books_list.index(el)].author == book.author
          next
        end

        @books_list[names_books_list.index(el)].count_things +=
          book.count_things
        break
      end
    else
      @books_list.append(book)
    end
  end

  def delete_thing(name, list)
    list.each do |el|
      next unless el.name == name

      el.count_things -= 1
      list.delete(el) if el.count_things.zero?
      break
    end
  end

  def add_stationery(stationery)#
    names_stationery_list = @stationery_list.map(&:name)
    if names_stationery_list.include? stationery.name
      @stationery_list[names_stationery_list.index(stationery.name)]
        .count_things += stationery.count_things
    else
      @stationery_list.append(stationery)
    end
  end

  def select_by_name(name)
    @books_list.select do |el|
      el if el.name.include? name.capitalize
    end
  end

  def select_by_genre(genre)
    @books_list.select do |el|
      el if el.genre.include? genre.capitalize
    end
  end

  def create_shop_list
    @shopping_lists.append(ShoppingList.new(create_id))
  end

  def delete_shop_list(id)
    @shopping_lists.each do |el|
      @shopping_lists.delete(el) if el.id == id
    end
  end

  def add_in_bag(id, list, name)
    list_name = list.map(&:name)
    return if !(list_name.include? name)

    index_id = @shopping_lists.map(&:id).index(id)

    index_thing = list_name.index(name)
    thing = list[index_thing]
    puts thing
    @shopping_lists[index_id.to_i].list.append(thing)
  end

  def delete_from_bag(id, name)
    index_id = @shopping_lists.map(&:id).index(id)
    list_name = @shopping_lists[index_id.to_i].list.map(&:name)

    return if !(list_name.include? name)

    index_thing = list_name.index(name)
    thing = @shopping_lists[index_id].list[index_thing]

    @shopping_lists[index_id].list.delete(thing)
  end

  def buy(id, path)
    index_id = @shopping_lists.map(&:id).index(id)
    list_things_id = @shopping_lists[index_id.to_i].list

    delete_from_lists(list_things_id)
    save_to_file(path, @shopping_lists[index_id.to_i])
    delete_shop_list(id.to_i)
  end

  def statistics
    genres = @books_list.map(&:genre).uniq
    all_stat = []
    i = 0
    while i < genres.count
      all_stat.append(statistic_for_genre(genres[i]))
      i += 1
    end
    all_stat
  end

  def list_with_summa(id)
    index_id = @shopping_lists.map(&:id).index(id)
    list = @shopping_lists[index_id.to_i]
    summa = array_summa(@shopping_lists[index_id.to_i].list.map(&:price))
    [list, summa]
  end

  private

  def delete_from_lists(list_things_id)
    list_things_id.each do |el|
      if @stationery_list.include? el
        index_stationery = @stationery_list.index(el)
        @stationery_list[index_stationery].count_things -= 1
        if @stationery_list[index_stationery].count_things.zero?
          @stationery_list.delete_at(index_stationery)
        end
      end
      next unless @books_list.include? el

      index_book = @books_list.index(el)
      @books_list[index_book].count_things -= 1
      if @books_list[index_book].count_things.zero?
        @books_list.delete_at(index_book)
      end
    end
  end

  def save_to_file(path, list)
    f = File.open(path, 'a')
    f.puts("ID: #{list.id}")
    f.puts(list.list)
  end

  def count_all
    array_count_things = @books_list.map(&:count_things) |
                         @stationery_list.map(&:count_things)
    array_summa(array_count_things)
  end

  def statistic_for_genre(genre)
    genres_list = @books_list.select do |el|
      el if el.genre == genre
    end
    stat_two = array_summa(genres_list.map(&:price)) / genres_list.count
    stat_three = array_summa(genres_list.map(&:count_things))
    stat_four = stat_three.to_f / count_all * 100
    [genre, genres_list.count, stat_two, stat_three, stat_four]
  end

  def array_summa(array)
    summa = 0
    array.each do |el|
      summa += el.to_i
    end
    summa
  end

  def create_id
    @shopping_lists.count + 1
  end
end
