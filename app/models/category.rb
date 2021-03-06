class Category < ApplicationRecord
  has_many :products
  validates :name, presence: { message: 'Додайте назву щоб створити категорію' }

  class << self
    def connection
      ActiveRecord::Base.connection
    end

    def _all
      res = connection.execute("SELECT categories.* FROM categories")
      make_hash(res.fields, res.values)
    end

    def _find(id)
      res = connection.execute("SELECT categories.* FROM categories WHERE categories.id = #{id} LIMIT 1")
      make_hash(res.fields, res.values).first
    end

    def _create(params)
      res = connection.execute("INSERT INTO categories (name) VALUES ('#{params[:name]}') RETURNING *")
      make_hash(res.fields, res.values)
    end

    def _update(params, id)
      str = ''
      params.keys.each { |k| str << "#{k} = '#{params[k]}'," if params[k].present? }
      str.chop!
      connection.execute("UPDATE categories SET #{str} WHERE categories.id = #{id}")
    end

    def _destroy(id)
      res = connection.execute("DELETE FROM categories WHERE categories.id = #{id}
        AND (SELECT count(*) FROM products WHERE products.category_id = #{id}) = 0
      ")
      return res.cmd_tuples == 0 ? 'Цей запис має діючі асоціації, спочатку видаліть їх' : false
    end

    def make_hash(fields, values)
      values.map do |v|
        {
          id: v[0],
          name: v[1]
        }
      end
    end
  end
end
