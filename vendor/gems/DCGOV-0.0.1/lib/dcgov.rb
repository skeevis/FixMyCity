require 'uri'
require 'cgi'
require 'net/http'
require 'rubygems'
require 'json'

$:.unshift(File.dirname(__FILE__))
require 'dcgov/easy_class_maker'
require 'dcgov/geocoder'
require 'dcgov/open311'
require 'dcgov/service_request_field'
require 'dcgov/service_type'
require 'dcgov/address'
require 'dcgov/util'

module DCGOV
   #Not too much in here...

end