module DCGOV
  class ServiceRequestField
    include EasyClassMaker
    #{"servicetype"=>[{"servicetype"=>"Abandoned Bicycles"}, {"servicecode"=>"S0021"},
    #{"name"=>"ABDBIC-HOWLONG"}, {"prompt"=>"How long has the bicycle been abandoned?"},
    # {"required"=>"Y"}, {"type"=>"TextBox           "}, {"width"=>"200"}, {"itemlist"=>"\r"}]}

    attributes  :service_type,:service_code,:field_name,:field_label,:field_required,:field_type,:field_width,:item_list

    # Creates a new user from a piece of xml
    def self.new_from_hash(hsh)
      u = new
      u.service_type = hsh[0]['servicetype']
      u.service_code = hsh[1]['servicecode']
      u.field_name = hsh[2]['name']
      u.field_label = hsh[3]['prompt']
      u.field_required = hsh[4]['required']
      u.field_type = hsh[5]['type']
      u.field_width = hsh[6]['width']
      u.item_list = hsh[7]['itemlist']
      u
    end


  end
end