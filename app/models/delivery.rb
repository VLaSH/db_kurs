class Delivery < ApplicationRecord
  belongs_to :provider
  belongs_to :product
  validates :provider_id, presence: { message: 'Додайте постачальника щоб створити поставку' }
  validates :product_id, presence: { message: 'Додайте товар щоб створити поставку' }
  validates :amount, presence: { message: 'Додайте кількість товару щоб створити поставку' }
  validates :delivery_date, presence: { message: 'Додайте дату поставки щоб створити поставку' }

  class << self
    def connection
      ActiveRecord::Base.connection
    end

    def _all
      res = connection.execute("SELECT deliveries.* FROM deliveries")
      make_hash(res.fields, res.values)
    end

    def _find(id)
      res = connection.execute("SELECT deliveries.* FROM deliveries WHERE deliveries.id = #{id} LIMIT 1")
      make_hash(res.fields, res.values).first
    end

    def _create(params)
      params = params.symbolize_keys
      calculate_price(params)
      res = connection.execute("INSERT INTO deliveries (provider_id, product_id, price, amount, delivery_date) VALUES
                                                       ('#{params[:provider_id]}', '#{params[:product_id]}', '#{params[:price]}', '#{params[:amount]}', '#{params[:delivery_date]}') RETURNING *")
      make_hash(res.fields, res.values)
    end

    def _update(params, id)
      str = ''
      params.keys.each { |k| str << "#{k} = '#{params[k]}'," if params[k].present? }
      str.chop!
      connection.execute("UPDATE deliveries SET #{str} WHERE deliveries.id = #{id}")
    end

    def _destroy(id)
      connection.execute("DELETE FROM deliveries WHERE deliveries.id = #{id}")
    end

    def product_name(product_id)
      name = connection.execute("SELECT name FROM products WHERE products.id = #{product_id}").values
      name&.first&.first
    end

    def provider_address(provider_id)
      address = connection.execute("SELECT address FROM providers WHERE providers.id = #{provider_id}").values
      address&.first&.first
    end

    def make_hash(fields, values)
      values.map do |v|
        {
          id: v[0],
          provider_id: v[1],
          product_id: v[2],
          price: v[3],
          amount: v[4],
          delivery_date: v[5]
        }
      end
    end

    def calculate_price(params)
      params[:price] = Product._find(params[:product_id])[:price].to_f * params[:amount].to_i
    end
  end
end
