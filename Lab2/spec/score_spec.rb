# frozen_string_literal: true

require 'store'
require 'book'
require 'stationery'

RSpec.describe Store do
  let(:book_one) do
    Book.new('Пушкин', 'Евгений Онегин', 'Роман',
             250, 5)
  end
  let(:book_two) do
    Book.new('Островский', 'Бесприданница', 'Пьеса',
             200, 2)
  end
  let(:book_three) do
    Book.new('Чехов', 'Палата №6', 'Рассказ',
             50, 12)
  end

  let(:book_four) do
    Book.new('Чехов', 'Палата №6 Изд.2', 'Рассказ',
             55, 12)
  end

  let(:stationery_one) do
    Stationery.new('Тетрадь 12', 3, 45)
  end
  let(:stationery_two) do
    Stationery.new('Ручка шариковая(синяя)', 2, 143)
  end
  let(:stationery_three) do
    Stationery.new('Карандаш простой', 1, 234)
  end
  let(:stationery_four) do
    Stationery.new('Карандаш', 1, 2)
  end

  let(:store) do
    Store.new([book_one, book_two, book_three],
              [stationery_one, stationery_two,
               stationery_three])
  end

  it 'should create the store' do
    expect(store).to be_a(Store)
  end

  it 'should added book in the store with
    when book is not in the shop and
    after when book already added' do
    store.add_book(Book.new('Грибоедов', 'Горе от ума', 'Комедия',
                            340, 7))
    store.add_book(Book.new('Грибоедов', 'Горе от ума', 'Комедия',
                            340, 7))
    expect(store.books_list[3].count_things).to eq(14)
  end

  it 'should deleted thing (for example, book) in the store
    if count books is not 0' do
    store.delete_thing('Евгений Онегин', store.books_list)
    the_book_list = store.books_list.select { |el| el.name == 'Евгений Онегин' }
    expect(the_book_list[0].count_things).to eq(4)
  end

  it 'should deleted thing(for example, stationary) in the store
    if count books is 0' do
    count_the_thing = store.stationery_list.select do |el|
      el.name == 'Тетрадь 12'
    end[0].count_things
    while count_the_thing > 0
      store.delete_thing('Тетрадь 12', store.stationery_list)
      count_the_thing -= 1
    end
    expect(store.stationery_list.count).to eq(2)
  end

  it 'should added stationery in the store with
    when book is not in the shop and
    after when book already added' do
    store.add_stationery(Stationery.new('Тетрадь 24', 12, 7))
    store.add_stationery(Stationery.new('Тетрадь 24', 12, 7))
    store.add_stationery(Stationery.new('Тетрадь 24', 12, 7))
    expect(store.stationery_list[3].count_things).to eq(21)
  end

  it 'should select books by name' do
    store.add_book(book_four)
    expect(store.select_by_name('ПАЛАТА')).to match_array([book_four,
                                                           book_three])
  end

  it 'should select books by genre' do
    store.add_book(book_four)
    expect(store.select_by_genre('Рассказ')).to match_array([book_three,
                                                             book_four])
  end

  it 'should create shopping list' do
    store.create_shop_list
    expect(store.shopping_lists.count).to eq(1)
  end

  it 'should delete shopping list' do
    store.create_shop_list
    id = store.shopping_lists[0].id
    store.delete_shop_list(id)
    expect(store.shopping_lists.count).to eq(0)
  end

  it 'should added things in shopping list
    for different list and dont exist name' do
    store.create_shop_list
    id = store.shopping_lists[0].id
    store.add_in_bag(id, store.books_list, 'Бесприданница')
    store.add_in_bag(id, store.stationery_list, 'Тетрадь 12')
    store.add_in_bag(id, store.stationery_list, 'Тетрадь 12sdvsvsef')
    expect(store.shopping_lists[0].list.count).to eq(2)
  end

  it 'should delete things from shopping list' do
    store.create_shop_list
    id = store.shopping_lists[0].id
    store.add_in_bag(id, store.books_list, 'Бесприданница')
    store.add_in_bag(id, store.stationery_list, 'Тетрадь 12')

    store.delete_from_bag(id, 'Бесприданница')
    store.delete_from_bag(id, 'Бесприданsefsegница')
    expect(store.shopping_lists[0].list.count).to eq(1) and
      expect(store.shopping_lists[0].list[0].name).to eq('Тетрадь 12')
  end

  it 'should buy all things and recalculated count things' do
    store.create_shop_list
    id = store.shopping_lists[0].id
    store.add_in_bag(id, store.books_list, 'Бесприданница')
    store.add_in_bag(id, store.stationery_list, 'Тетрадь 12')
    store.buy(id, 'text.txt')
    expect(store.books_list[1].count_things).to eq(1) and
      expect(store.stationery_list[0].count_things).to eq(44) and
      expect(store.shopping_lists.empty?).to be true
  end

  it 'should clear list books and stationery' do
    mini_store = Store.new([book_two],
                           [stationery_four])
    mini_store.create_shop_list
    id = mini_store.shopping_lists[0].id
    mini_store.add_in_bag(id, mini_store.books_list, 'Бесприданница')
    mini_store.add_in_bag(id, mini_store.books_list, 'Бесприданница')
    mini_store.add_in_bag(id, mini_store.stationery_list, 'Карандаш')
    mini_store.add_in_bag(id, mini_store.stationery_list, 'Карандаш')
    mini_store.buy(id, 'test.txt')
    expect(mini_store.books_list.count).to eq(0) and
      expect(mini_store.stationery_list.count).to eq(0)
  end

  it 'should calculated statistic for all genres' do
    store.add_book(book_four)
    expect(store.statistics.count).to eq(3)
  end

  it 'should get list with calculate summa' do
    store.create_shop_list
    id = store.shopping_lists[0].id
    store.add_in_bag(id, store.books_list, 'Бесприданница')
    store.add_in_bag(id, store.stationery_list, 'Тетрадь 12')

    expect(store.list_with_summa(id)[0]).to be_a(ShoppingList) and
      expect(store.list_with_summa(id)[1]).to eq(203)
  end
end
