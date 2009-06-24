class RemoteController < ApplicationController
  # 6916db5b-fb62-4f47-bdce-516152dede6c
  def _get_service_types
    logger.debug("Grabbing Service Types")
    service_types = DCGOV::Open311.get_service_types()
    service_type_ret = service_types.collect { |service_type|
      {"type"=>service_type.service_type,"code"=>service_type.service_code}
    }
    render :json =>service_type_ret.to_json
  end


  def _get_service_fields
    service_code = params["service_code"]
    service_fields = DCGOV::Open311.get_request_fields(service_code)
    service_fields_ret = service_fields.collect{|service_field|
      {"service_type"=>service_field.service_type.strip,"service_code"=>service_field.service_code.strip,
        "field_name"=>service_field.field_name.strip,"field_label"=>service_field.field_label.strip,
        "field_required"=>service_field.field_required.strip,"field_type"=>service_field.field_type.strip,
        "field_width"=>service_field.field_width.strip,"item_list"=>service_field.item_list.strip}
    }
    render :json=>service_fields_ret.to_json
  end

  def _lookup_address
    partial = params["partial"]
    address_options = DCGOV::GeoCoder.find_by_address(partial)
    address_options_ret = address_options.collect { |address|
      {"address"=>address.fulladdress,"aid"=>address.aid,"longitude"=>address.longitude,"latitude"=>address.latitude}
    }
    render :json=>address_options_ret.to_json
  end

  def _lookup_point
    lat = params["lat"]
    lon = params["lon"]
    results = DCGOV::GeoCoder.find_by_lat_lon(lat,lon)

    logger.debug(results.inspect)
    
    address_options_ret = results.collect { |address|
      res = DCGOV::Util::fix_hash(address["address"])
      ind_address = DCGOV::Address.new_from_hash(res)
      {"address"=>ind_address.fulladdress,"aid"=>ind_address.aid,"longitude"=>ind_address.longitude,"latitude"=>ind_address.latitude}
    }
    render :json=>address_options_ret

  end

end
