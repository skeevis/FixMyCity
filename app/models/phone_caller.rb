require "twilio.rb"

class PhoneCaller < ActiveRecord::Base

  # Twilio REST API version
  API_VERSION = '2008-08-01'

  # Twilio AccountSid and AuthToken
  ACCOUNT_SID = 'AC65c55314d8c8f1f27048e5d68b5ba1e9'
  ACCOUNT_TOKEN = '749061d882e91dbbcd4cdc5b6ebcb53e'

  # Outgoing Caller ID previously validated with Twilio
  CALLER_ID = '(202) 683-7803';

  def self.welcome(phone_number)
    account = TwilioRest::Account.new(ACCOUNT_SID, ACCOUNT_TOKEN)

    d = {
      'Caller' => CALLER_ID,
      'Called' => phone_number,
      'Url' => 'http://projects.skeevisarts.com/fixmycity/twilio-welcome.php'
    }
    resp = account.request("/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/Calls",
      'POST', d)
    resp.error! unless resp.kind_of? Net::HTTPSuccess
    logger.debug "code: %s\nbody: %s" % [resp.code, resp.body]

  end

  def self.in_system(phone_number)
    account = TwilioRest::Account.new(ACCOUNT_SID, ACCOUNT_TOKEN)

    d = {
      'Caller' => CALLER_ID,
      'Called' => phone_number,
      'Url' => 'http://projects.skeevisarts.com/fixmycity/twilio-insystem.php'
    }
    resp = account.request("/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/Calls",
      'POST', d)
    resp.error! unless resp.kind_of? Net::HTTPSuccess
    logger.debug "code: %s\nbody: %s" % [resp.code, resp.body]

  end

  def self.update(phone_number)
    account = TwilioRest::Account.new(ACCOUNT_SID, ACCOUNT_TOKEN)

    d = {
      'Caller' => CALLER_ID,
      'Called' => phone_number,
      'Url' => 'http://projects.skeevisarts.com/fixmycity/twilio-update.php'
    }
    resp = account.request("/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/Calls",
      'POST', d)
    resp.error! unless resp.kind_of? Net::HTTPSuccess
    logger.debug "code: %s\nbody: %s" % [resp.code, resp.body]

  end

end
