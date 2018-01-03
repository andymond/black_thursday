require 'CSV'
require_relative 'item'
require 'pry'

class ItemRepository
# shared behaviors between item & merchant repos can be pulled to module?
  attr_reader :all

  def initialize(file_path)
    contents = CSV.open(file_path, headers: true, header_converters: :symbol)
    @all = contents.map do |row|
      Item.new({:id          => row[:id],
                :name        => row[:name],
                :description => row[:description],
                :merchant_id => row[:merchant_id],
                :unit_price  => row[:unit_price],
                :created_at  => row[:created_at],
                :updated_at  => row[:updated_at]
                })
    end
  end

  def find_by_id(id)
    all.find do |item|
      item.id == id
    end
  end

  def find_by_name(name)
    all.find do |item|
      item.name.downcase == name.downcase
    end
  end

  def find_all_with_description(description)
    all.select do |item|
      item.description.downcase.include?(description.downcase)
    end
  end

  def find_all_by_price(price)
    all.select do |item|
      item.unit_price == price
    end
  end

  def find_all_by_price_in_range(range)
    all.select do |item|
      (range).include?(item.unit_price.to_i)
    end
  end

  def find_all_by_merchant_id(merchant_id)
    all.select do |item|
      item.merchant_id == merchant_id
    end
  end

end