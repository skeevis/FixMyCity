class HelloController < ApplicationController
  layout "default"

  protect_from_forgery :only => [:update, :destroy]

  
  def index

  end

  def new

  end

  def check
    
  end

  def service_request
    id = params[:id]
    @req = ServiceRequest.find(id)
  end

  def post
    answers = params['answer']
    result =     DCGOV::Open311.submit(answers)
    logger.debug(result.inspect)
    service_request = ServiceRequest.new
    service_request.aid = answers['aid']
    service_request.description = answers['description']
    phone_or_email = answers['phone_or_email']
    unless phone_or_email.empty?
      if phone_or_email.include? "@"
        service_request.email = phone_or_email
      else
        service_request.phone_number = phone_or_email.sub(/[^0-9]/, '')
      end
    end
    service_request.fields = answers.to_yaml
    service_request.token = result
    service_request.service_code = answers['service_code']
    service_request.save
    begin
      service_request.notify_welcome
    rescue
      logger.warn("Something went wrong when notifying new req: #{$!}")

    end

    flash['message']='Your service request has been submitted. You can bookmark this page to keep track of the results. Come back at any time, and enter in your email address or phone number (whatever you entered on the last page) to pull up your requests.'
    redirect_to :action=>:service_request,:id=>service_request.id
  end


  def check
    if request.post?
      phone_or_email = params['phone_or_email']
      if phone_or_email.include? "@"
        @results = ServiceRequest.find_all_by_email phone_or_email
      else
        @results = ServiceRequest.find_all_by_phone_number phone_or_email.sub(/[^0-9]/, '')
      end
    end
  end


  def update
    #first find all service requests.
    @nil_requests = ServiceRequest.find_all_by_service_id nil
    @nil_requests.each { |i|
      i.get_service_id
      unless i.service_id.nil?
        begin
          i.notify_in_system
        rescue
          logger.warn("Something went wrong when updating new reqs: #{$!}")
        end

      end
    }

    @reqs = ServiceRequest.find(:all,:conditions=>['service_id IS NOT NULL'])
    @reqs.each{ |i|
      old_status = i.status
      i.get_status
      if(old_status != i.status)
        begin
          i.notify_update
        rescue
          logger.warn("Something went wrong when updating all reqs: #{$!}")
        end

      end
    }
    render :nothing => true
  end

  def shush
    sr_id = params[:id]
    ServiceRequest.update(sr_id, {:is_silenced=>true})
    flash['message'] = "You won't receive any more email or phone notifications about this request. You can still check the status of your request by visiting this page."
    redirect_to :action=>:service_request,:id=>sr_id
  end

end
