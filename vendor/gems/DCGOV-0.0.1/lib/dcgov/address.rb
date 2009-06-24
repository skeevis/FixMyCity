module DCGOV
  class Address
    include EasyClassMaker

    #    just a sample of what dc returns, for reference purposes. 
    #    [{"aid"=>"285552"}, {"status"=>"ACTIVE"}, {"fulladdress"=>"441 4TH STREET NW"}, {"addrnum"=>"441"}, {"stname"=>"4TH"}, {"street_type"=>"STREET"},
    #      {"quadrant"=>"NW"}, {"city"=>"WASHINGTON"}, {"state"=>"DC"}, {"xcoord"=>"398642.18"}, {"ycoord"=>"136399.84"},
    #      {"ssl"=>"0532    0020"}, {"anc"=>"ANC 6C"}, {"psa"=>"Police Service Area 101"}, {"ward"=>"Ward 6"}, {"nbhd_action"=>" "},
    #      {"cluster"=>"Cluster 8"}, {"poldist"=>"Police District - First District"}, {"roc"=>"-"}, {"census_tract"=>"59"},
    #      {"vote_prcnct"=>"Precinct 143"}, {"smd"=>"SMD02 6C09"}, {"zipcode"=>"20001"}, {"latitude"=>"38.89544591"},
    #      {"longitude"=>"-77.01565221"}, {"distance"=>"0"}]

    attributes  :aid,:status,:fulladdress,:addrnum,:stname,:street_type,:quadrant,:city,:state,:xoord,:ycoord,:ssl,:anc,:psa,:ward,:nbhd,:clust,:poldist,:roc,:census_tract,
      :vote_prcnct,:smd,:zipcode,:latitude,:longitude,:distance

    # Creates a new user from a piece of xml
    def self.new_from_hash(hsh)
      u = new
      u.aid = hsh['aid']
      u.status = hsh['status']
      u.fulladdress = hsh['fulladdress']
      u.addrnum = hsh['addrnum']
      u.stname = hsh['stname']
      u.street_type = hsh['street_type']
      u.quadrant = hsh['quadrant']
      u.city = hsh['city']
      u.state = hsh['state']
      u.xoord = hsh['xoord']
      u.ycoord = hsh['ycoord']
      u.ssl = hsh['ssl']
      u.anc = hsh['anc']
      u.psa = hsh['psa']
      u.ward = hsh['ward']
      u.nbhd = hsh['nbhd']
      u.clust = hsh['clust']
      u.poldist = hsh['poldist']
      u.roc = hsh['roc']
      u.census_tract = hsh['census_tract']
      u.vote_prcnct = hsh['vote_prcnct']
      u.smd = hsh['smd']
      u.zipcode = hsh['zipcode']
      u.latitude = hsh['latitude']
      u.longitude = hsh['longitude']
      u.distance = hsh['distance']
      u
    end
  end
end