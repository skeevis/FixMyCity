module DCGOV
  class ServiceRequest

 include EasyClassMaker
 
    attributes  :anc,:lattitude,:serviceorderdate,:resolution,:servicerequestid,:siteaddress,:serviceorderstatus,:district,:zipcode,:servicenotes,:servicetypecodedescription,:servicecodedescription,:servicecode,:neighborhoodcluster,:servicepriority,:aid,:serviceduedate,:resolutiondate,:psa,:longitude,:smd,:ward,:agencyabbreviation,:servicetypeocde
    
    # Creates a new user from a piece of xml
    def self.new_from_hash(hsh)
      u = new
      u.anc = hsh['anc']
      u.lattitude = hsh['lattitude']
      u.serviceorderdate = hsh['serviceorderdate']
      u.resolution = hsh['resolution']
      u.servicerequestid = hsh['servicerequestid']
      u.siteaddress = hsh['siteaddress']
      u.serviceorderstatus = hsh['serviceorderstatus']
      u.district = hsh['district']
      u.zipcode = hsh['zipcode']
      u.servicenotes = hsh['servicenotes']
      u.servicetypecodedescription = hsh['servicetypecodedescription']
      u.servicecodedescription = hsh['servicecodedescription']
      u.servicecode = hsh['servicecode']
      u.neighborhoodcluster = hsh['neighborhoodcluster']
      u.servicepriority = hsh['servicepriority']
      u.aid = hsh['aid']
      u.serviceduedate = hsh['serviceduedate']
      u.resolutiondate = hsh['resolutiondate']
      u.psa = hsh['psa']
      u.longitude = hsh['longitude']
      u.smd = hsh['smd']
      u.ward = hsh['ward']
      u.agencyabbreviation = hsh['agencyabbreviation']
      u.servicetypeocde = hsh['servicetypeocde']


      u
    end
  end
end