class Provider < ApplicationRecord
  has_many :deliveries
  validates :address, :phone, presence: true


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
      make_hash(res.fields, res.values).first
    end

    def _create(params)
      res = connection.execute("INSERT INTO providers (address, phone) VALUES ('#{params[:address]}', '#{params[:phone]}') RETURNING *")
      make_hash(res.fields, res.values)
    end

    def _update(params, id)
      str = ''
      params.keys.each { |k| str << "#{k} = '#{params[k]}'," if params[k].present? }
      str.chop!
      connection.execute("UPDATE providers SET #{str} WHERE providers.id = #{id}")
    end

    def _destroy(id)
      res = connection.execute("DELETE FROM providers WHERE providers.id = #{id}
        AND (SELECT count(*) FROM deliveries WHERE deliveries.product_id = #{id}) = 0
      ")
      return res.cmd_tuples == 0 ? 'Цей запис має діючі асоціації, спочатку видаліть їх' : false
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
