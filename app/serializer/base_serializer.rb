class BaseSerializer
  def self.collection(records)
    records.map { |r| new(r).as_json }
  end
end
