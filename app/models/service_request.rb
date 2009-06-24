class ServiceRequest < ActiveRecord::Base

  def update_request
    if service_id.nil?
      #retrieve token
      get_service_id
    else
      get_status
    end
  end

  def get_service_id
    token_res =  DCGOV::Open311.resolve_token(token)
    update_attribute("service_id", token_res)
  end

  def get_status
    service_results =   DCGOV::Open311.get(service_id)
    logger.debug(service_results.inspect)
    update_attribute("status", service_results["serviceorderstatus"])
    service_results
  end

  def notify_welcome
    unless is_silenced
      unless phone_number.nil?
        PhoneCaller.welcome(phone_number)
      end
      unless email.nil?
        Notification.deliver_welcome(id)
      end
    end
  end

  def notify_in_system
    unless is_silenced

      unless phone_number.nil?
        PhoneCaller.in_system(phone_number)
      end
      unless email.nil?
        Notification.deliver_in_system(id)
      end
    end
  end

  def notify_update
    unless is_silenced

      unless phone_number.nil?
        PhoneCaller.update(phone_number)
      end
      unless email.nil?
        message = "Your request is now marked as #{status}"
        Notification.deliver_update(id,message)
      end
    end
  end

end
