module DCGOV
  class Open311
    def self.get_service_types()
      request_url = "/open311/v1/meta_getTypesList.json"
      result_json = DCGOV::Util.pull_from_json(request_url)
      return result_json["servicetypeslist"].collect { |st| DCGOV::ServiceType.new_from_hash(st["servicetype"])  }
    end

    def self.get_request_fields(sr_id)
      request_url = "/open311/v1/meta_getTypeDefinition.json?servicecode=#{CGI::escape(sr_id)}"
      result_json = DCGOV::Util.pull_from_json(request_url)
      print result_json.inspect
      return result_json["servicetypedefinition"].collect { |st| DCGOV::ServiceRequestField.new_from_hash(st["servicetype"])  }
    end

    def self.get(request_id)
      request_url = "/open311/v1/get.json?servicerequestid=#{CGI::escape(request_id)}"
      result_json = DCGOV::Util.pull_from_json(request_url)
      results_fixed =  DCGOV::Util::fix_hash(result_json["servicerequest"])
      return results_fixed
    end

    def self.resolve_token(token_id)
      request_url = "/open311/v1/getFromToken.json?token=#{token_id}"
      result_json = DCGOV::Util.pull_from_json(request_url)
      result_json["servicerequestid"]
    end

    def self.submit(values)
      request_url = "/open311/v1/submit.json"
      result_json = DCGOV::Util.post_to_json(values,request_url)
      result_json["token"]
    end

  end
end