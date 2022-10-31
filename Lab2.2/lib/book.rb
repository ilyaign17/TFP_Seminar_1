# frozen_string_literal: true

# Description of book
class Book
  attr_accessor :author, :name, :genre, :price, :count_things

  def initialize(author, name, genre, price, count_things)
    @author = author
    @name = name
    @genre = genre
    @price = price
    @count_things = count_things
  end

  def to_s
    "#{author} - '#{name}', жанр: #{genre}, цена: #{price}р. #{count_things}"
  end
end
