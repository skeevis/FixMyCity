class Notification < ActionMailer::Base
  

  def welcome(sr_id, sent_at = Time.now)
    @sr = ServiceRequest.find(sr_id)
    subject    'FixMyCityDC.com - Welcome and Thanks!'
    recipients @sr.email
    from       'fixmycitydc@skeevisarts.com'
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def in_system(sr_id, sent_at = Time.now)
    @sr = ServiceRequest.find(sr_id)

    subject    'FixMyCityDC.com - Request Sent to DC311'
    recipients @sr.email
    from       'fixmycitydc@skeevisarts.com'
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def update(sr_id, update = nil, sent_at = Time.now)
    @sr = ServiceRequest.find(sr_id)
    subject    'FixMyCityDC.com - We have an update for you!'
    recipients @sr.email
    from       'fixmycitydc@skeevisarts.com'
    sent_on    sent_at
    
    body       :update => update
  end

end
