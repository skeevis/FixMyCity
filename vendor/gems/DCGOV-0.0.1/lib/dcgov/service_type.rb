module DCGOV
  class ServiceType
    include EasyClassMaker
    attributes  :service_type,:service_code

    # Creates a new user from a piece of xml
    def self.new_from_hash(hsh)
      hash_to_proc = hsh.to_a
      u = new
      u.service_type = hash_to_proc[0]['servicetype']
      u.service_code = hash_to_proc[1]['servicecode']
      u
    end

  end
end