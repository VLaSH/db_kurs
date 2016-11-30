class Product < ApplicationRecord
  has_many :deliveries
  belongs_to :category
  has_one :availability

  validates :name, presence: { message: 'Додайте назву щоб створити продукт' }
  validates :category_id, presence: { message: 'Виберіть категорію щоб створити постачальника' }
  validates :made, presence: { message: 'Додайте дату виготовлення щоб створити продукт' }
  validates :expiration, presence: { message: 'Виберіть термін придатності щоб створити постачальника' }


  class << self
    def connection
      ActiveRecord::Base.connection
    end

    def _all(order)
      res = connection.execute("SELECT products.* FROM products ORDER BY products.price #{order.to_s}")
      make_hash(res.fields, res.values)
    end

    def _find(id)
      res = connection.execute("SELECT products.* FROM products WHERE products.id = #{id} LIMIT 1")
      make_hash(res.fields, res.values).first
    end

    def _create(params)
      res = connection.execute("
        INSERT INTO products (name, category_id, made, expiration, price)
        VALUES (
          '#{params[:name]}', '#{params[:category_id]}', '#{params[:made]}',
          '#{params[:expiration]}', '#{params[:price]}'
        ) RETURNING *
      ")
      make_hash(res.fields, res.values)
    end

    def _update(params, id)
      str = ''
      params.keys.each { |k| str << "#{k} = '#{params[k]}'," if params[k].present? }
      str.chop!
      connection.execute("UPDATE products SET #{str} WHERE products.id = #{id}")
    end

    def _destroy(id)
      res = connection.execute("DELETE FROM products WHERE products.id = #{id}
        AND (SELECT count(*) FROM deliveries WHERE deliveries.product_id = #{id}) = 0
        AND (SELECT count(*) FROM availabilities WHERE availabilities.product_id = #{id}) = 0
      ")
       return res.cmd_tuples == 0 ? 'Цей запис має діючі асоціації, спочатку видаліть їх' : false
    end

    def _search(name)
      res = connection.execute("SELECT searchProductByName('#{name}')")
      make_hash(res.fields, parse_res(res)) if res.values.any?
    end

    def category_name(category_id)
      name = connection.execute("SELECT name FROM categories WHERE categories.id = #{category_id}").values
      name&.first&.first
    end

    def make_hash(fields, values)
      values.map do |v|
        {
          id: v[0],
          category_id: v[1],
          made: v[2],
          expiration: v[3],
          name: v[4],
          price: v[5]
        }
      end
    end

    def parse_res(res)
      new_res = [[]]
      new_res[0] = res.values[0][0].gsub(/\(|\)/, '').split(',')
      new_res
    end
  end

end
