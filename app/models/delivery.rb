class Delivery < ApplicationRecord
  belongs_to :provider
  belongs_to :product
  validates :provider_id, :product_id, :price, :amount, :delivery_date, :end_date, presence: true
  validates :product_id, uniqueness: true

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
      make_hash(res.fields, res.values)
    end

    def _create(params)
      params.symbolize_keys!
      res = connection.execute("INSERT INTO deliveries (provider_id, product_id, price, amount, delivery_date, end_date) VALUES
                                                       ('#{params[:provider_id]}', '#{params[:product_id]}', '#{params[:price]}', '#{params[:amount]}', '#{params[:delivery_date]}', '#{params[:end_date]}') RETURNING *")
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
      name[0][0]
    end

    def provider_address(provider_id)
      address = connection.execute("SELECT address FROM providers WHERE providers.id = #{provider_id}").values
      address[0][0]
    end

    def make_hash(fields, values)
      values.map do |v|
        {
          id: v[0],
          provider_id: v[1],
          product_id: v[2],
          price: v[3],
          amount: v[4],
          delivery_date: v[5],
          end_date: v[6]
        }
      end
    end
  end
end
