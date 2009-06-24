module DCGOV
  class Util

    # just about all there is.
    def self.pull_from_json(params)

      #why am I wrapping the entire deal in a rescue block? Well, the API has no error handling at all
      # so if you enter in something bad, it just craps on you.
      begin
        @resp
        Net::HTTP.start('api.dc.gov') {|http|
          req = Net::HTTP::Get.new(params)
          response = http.request(req)
          @resp = response.body

        }
        JSON.parse @resp
      rescue
        #so the caller can catch a "better" error than some JSON parsing or HTTP bs.
        raise "An error occurred while attempting to grab and parse the results: #{$!}"
      end
    end

    def self.post_to_json(params,url)
      @resp
      Net::HTTP.start('api.dc.gov') {|http|
        req = Net::HTTP::Post.new(url)
        req.set_form_data(params)
        response = http.request(req)
        @resp = response.body
      }
      JSON.parse @resp
    end

    def self.fix_hash(hsh)
      results = Hash.new
      hsh.each { |i|
        results.merge!(i)
      }
      return results
    end
  end
end