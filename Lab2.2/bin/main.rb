# frozen_string_literal: true

require_relative '../lib/menu'

def main
  Menu.new('../lib/books.csv',
           '../lib/stationery.csv')
end

main if __FILE__ == $PROGRAM_NAME
