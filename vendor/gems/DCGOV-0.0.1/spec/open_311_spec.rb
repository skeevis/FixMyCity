require File.dirname(__FILE__) + '/spec_helper.rb'

describe "DCGOV::Open311" do

  it "should return a list of service types" do
    service_types = DCGOV::Open311.get_service_types()
    service_types.length.should > 0
    service_types[0].class.to_s.should == "DCGOV::ServiceType"
    service_types[0].service_type.should =="Abandoned Bicycles"
    service_types[0].service_code.should =="S0021"
  end

  it "should return a list of fields for a service type" do
    service_code="S0021"
    request_fields = DCGOV::Open311.get_request_fields(service_code)
    request_fields.length.should > 0
    request_fields[0].service_type.should == "Abandoned Bicycles"
    request_fields[0].field_name.should == "ABDBIC-HOWLONG"
    request_fields[0].field_label.should == "How long has the bicycle been abandoned?"

  end

  it "should return a request based on a service ID" do
    request_id="123456"
    request = DCGOV::Open311.get(request_id)
    request.class.to_s.should == "Hash"
  end

  it "should convert a token into a service request id" do
    token_id = "123456"
    service_request_id = DCGOV::Open311.resolve_token(token_id)
    service_request_id.should_not == nil
  end

  it "should post a service request" do
    values = Hash.new
    token_id = DCGOV::Open311.submit(values)
    token_id.should_not == nil
  end
  
end