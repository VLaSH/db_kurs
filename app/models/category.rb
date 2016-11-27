class Category < ApplicationRecord
  has_many :products
  validates :name, presence: true

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
      make_hash(res.fields, res.values)
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
      connection.execute("DELETE FROM categories WHERE categories.id = #{id}")
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
