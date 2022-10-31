# frozen_string_literal: true

# Description of stationery
class Stationery
  attr_accessor :name, :price, :count_things

  def initialize(name, price, count_things)
    @name = name
    @price = price
    @count_things = count_things
  end

  def to_s
    "#{name}, цена: #{price}р."
  end
end
