# frozen_string_literal: true

# Description of shopping
class ShoppingList
  attr_accessor :id, :list

  def initialize(id)
    @id = id
    @list = []
  end

  def to_s
    "ID: #{@id}\n" \
      "Список\n#{@list}\n"
  end
end
