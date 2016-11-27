class Product < ApplicationRecord
  has_many :deliveries
  belongs_to :category
  has_one :availability

  validates :name, :category_id, presence: true

  class << self
    def connection
      ActiveRecord::Base.connection
    end

    def _all
      res = connection.execute("SELECT products.* FROM products")
      make_hash(res.fields, res.values)
    end

    def _find(id)
      res = connection.execute("SELECT products.* FROM products WHERE products.id = #{id} LIMIT 1")
      make_hash(res.fields, res.values)
    end

    def _create(params)
      res = connection.execute("INSERT INTO products (name, category_id) VALUES ('#{params[:name]}', '#{params[:category_id]}') RETURNING *")
      make_hash(res.fields, res.values)
    end

    def _update(params, id)
      str = ''
      params.keys.each { |k| str << "#{k} = '#{params[k]}'," if params[k].present? }
      str.chop!
      connection.execute("UPDATE products SET #{str} WHERE products.id = #{id}")
    end

    def _destroy(id)
      connection.execute("DELETE FROM products WHERE products.id = #{id}")
    end

    def category_name(category_id)
      name = connection.execute("SELECT name FROM categories WHERE categories.id = #{category_id}").values
      name[0][0]
    end

    def make_hash(fields, values)
      values.map do |v|
        {
          id: v[0],
          name: v[1],
          category_id: v[2]
        }
      end
    end
  end

end
