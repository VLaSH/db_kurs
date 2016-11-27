class Provider < ApplicationRecord
  has_many :deliveries

  class << self
    def connection
      ActiveRecord::Base.connection
    end

    def _all
      res = connection.execute("SELECT providers.* FROM providers")
      make_hash(res.fields, res.values)
    end

    def _find(id)
      res = connection.execute("SELECT providers.* FROM providers WHERE providers.id = #{id} LIMIT 1")
      make_hash(res.fields, res.values)
    end

    def _create(params)
      res = connection.execute("INSERT INTO providers (address, phone) VALUES ('#{params[:address]}', '#{params[:phone]}') RETURNING *")
      make_hash(res.fields, res.values)
    end

    def make_hash(fields, values)
      values.map do |v|
        {
          id: v[0],
          address: v[1],
          phone: v[2]
        }
      end
    end
  end

end
