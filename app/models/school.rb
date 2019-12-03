class School < ActiveRecord::Base
  validates :name, :city, :state, :website, presence: true
  before_save :grab_lat_lng

  has_many :teachers

  def self.validated
    School.all
  end

  private
    def grab_lat_lng
      # Getting the long and lat of the city they put
      puts "succ"

      google_key = "AIzaSyC7jyOFHSorVb256ZEwvvyprp2KPjxKTPw"
      location = self.city + " " + self.state
      location.sub! " ", "+"
      url = "https://maps.googleapis.com/maps/api/geocode/json?address=%s&key=%s" % [location, google_key]
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE # You should use VERIFY_PEER in production
      req = Net::HTTP::Get.new(uri.request_uri)
      res = http.request(req)
      puts "req"
      data = JSON.parse(res.body)
      puts "data"
      self.lat = data["results"][0]["geometry"]["location"]["lat"]
      self.lng = data["results"][0]["geometry"]["location"]["lng"]
      puts "params"
    end
end
