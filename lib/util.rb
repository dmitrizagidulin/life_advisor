class Util
  def self.hash_list_by(list, hash_key)
    if not list or list.empty?
      return {}
    end
    hash = {}
    list.each do |ea|
      key_value = ea.send(hash_key) 
      unless hash.include? key_value
        hash[key_value] = []
      end
      hash[key_value] << ea
    end
    hash
  end
end