class Availability < ApplicationRecord
  belongs_to :product
  validates :amount, :end_date, :price, presence: true

  class << self
    def connection
      ActiveRecord::Base.connection
    end

    def _all
      res = connection.execute("SELECT availabilities.* FROM availabilities")
      make_hash(res.fields, res.values)
    end

    def _find(id)
      res = connection.execute("SELECT availabilities.* FROM availabilities WHERE availabilities.id = #{id} LIMIT 1")
      make_hash(res.fields, res.values).first
    end

    def _create(params)
      res = connection.execute("INSERT INTO availabilities (product_id, amount) VALUES ('#{params[:product_id]}', '#{params[:amount]}') RETURNING *")
      make_hash(res.fields, res.values)
    end

    def _update(params, id)
      str = ''
      params.keys.each { |k| str << "#{k} = '#{params[k]}'," if params[k].present? }
      str.chop!
      connection.execute("UPDATE availabilities SET #{str} WHERE availabilities.id = #{id}")
    end

    def _destroy(id)
      connection.execute("DELETE FROM availabilities WHERE availabilities.id = #{id}")
    end

    def product_name(product_id)
      name = connection.execute("SELECT name FROM products WHERE products.id = #{product_id}").values
      name&.first&.first
    end

    def make_hash(fields, values)
      values.map do |v|
        {
          id: v[0],
          product_id: v[1],
          amount: v[2]
        }
      end
    end
  end
end
