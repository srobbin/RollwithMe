class Direction
  require 'open-uri'
  require 'json'
  attr_accessor :start, :destination



def directions?(departure)

  # Get Start Address Lat Long
     url = URI.encode("http://maps.googleapis.com/maps/api/geocode/json?address=#{self.start}&sensor=false")
     url_string_data = open(url).read
     url_json_data = JSON.parse(url_string_data)

     latitude = url_json_data['results'].first['geometry']['location']['lat']
     longitude = url_json_data['results'].first['geometry']['location']['lng']

     start_coordinates = [latitude, longitude]

  # Get Destination Lat Long
     url = URI.encode("http://maps.googleapis.com/maps/api/geocode/json?address=#{self.destination}&sensor=false")
     url_string_data = open(url).read
     url_json_data = JSON.parse(url_string_data)

     latitude = url_json_data['results'].first['geometry']['location']['lat']
     longitude = url_json_data['results'].first['geometry']['location']['lng']

     destination_coordinates = [latitude, longitude]

  # Setting Departure Time
     if departure.to_i == 15
       @departure_time = (Time.now + 15.minutes).to_i
     elsif departure.to_i == 30
       @departure_time = (Time.now + 30.minutes).to_i
     elsif departure.to_i == 60
       @departure_time = (Time.now + 1.hour).to_i
     else
       @departure_time = Time.now.to_i
     end

  # Start Direction Logic

  # Hard Coded URL (json)
     # url = URI.encode("http://maps.googleapis.com/maps/api/directions/json?origin=Merchandise+Mart+Chicago,IL&destination=210+S+Canal+St+Chicago,IL&departure_time=134759800&mode=transit&sensor=true&alternatives=true")
     # url = URI.encode("http://maps.googleapis.com/maps/api/directions/json?origin=Chicago+Ohare+Int+Chicago,IL&destination=1032+West+Lake+St+Chicago,IL&departure_time=134759800&mode=transit&sensor=true&alternatives=true")
  # Dynamic Directions URL (json)
     url = URI.encode("http://maps.googleapis.com/maps/api/directions/json?origin=#{start_coordinates.first},#{start_coordinates.last}&destination=#{destination_coordinates.first},#{destination_coordinates.last}&departure_time=#{@departure_time}&mode=transit&sensor=true&alternatives=true")
     url_string_data = open(url).read
     url_json_data = JSON.parse(url_string_data)

  # Creating a routes array to push all individual routes to
     routes_info_hash = Array.new
     url_json_data['routes'].each do |route|
       route_info_hash = Hash.new
       route_info_hash['start_address'] = route['legs'].first['start_address']
        route_info_hash['distance'] = route['legs'].first['distance']['text']
       route_info_hash['duration'] = route['legs'].first['duration']['text']
       route_info_hash['end_address'] = route['legs'].first['end_address']

  # Create an individual array for each route
       route_info_hash['route'] = Array.new
       route['legs'].first['steps'].each do |step|

  # Walking directions
         if step['travel_mode'] == 'WALKING'
           step_info = Hash.new
           step_info['travel_mode'] = step['travel_mode']
           step_info['distance'] = step['distance']['text']
           step_info['duration'] = step['duration']['text']
           step_info['general_instruction'] = step['html_instructions']
           step_info['detail'] =  step['steps'].each do |direct|
            direct['html_instructions']
           end
           route_info_hash['route'] << step_info

  # Driving directions
         elsif step['travel_mode'] == 'DRIVING'
           step_info = Hash.new
           step_info['travel_mode'] = step['travel_mode']
           step_info['distance'] = step['distance']['text']
           step_info['duration'] = step['duration']['text']
           step_info['instruction'] = step['html_instructions']
           route_info_hash['route'] << step_info

  # Start Transit Directions
         elsif step['travel_mode'] == 'TRANSIT'

  # All Bus logic
           if step['transit_details']['line']['vehicle']['type'] == 'BUS'
             step_info = Hash.new
             step_info['travel_mode'] = step['travel_mode']
             step_info['distance'] = step['distance']['text']
             step_info['duration'] = step['duration']['text']
             step_info['instruction'] = step['html_instructions']
             step_info['departure_stop_name'] = step['transit_details']['departure_stop']['name']
             step_info['departure_time'] = step['transit_details']['departure_time']['text']
             step_info['arrival_stop_name'] = step['transit_details']['arrival_stop']['name']
             step_info['arrival_time'] = step['transit_details']['arrival_time']['text']
             step_info['vehicle_type'] = step['transit_details']['line']['vehicle']['type']
             step_info['service_provider'] = step['transit_details']['line']['agencies'].first['name']
             step_info['bus_line'] = step['transit_details']['line']['name']
             step_info['vehicle_short_name'] = step['transit_details']['line']['short_name']
             step_info['bus_line_info'] = step['transit_details']['line']['url']
             route_info_hash['route'] << step_info

  # CTA Train Logic
           elsif step['transit_details']['line']['vehicle']['type'] == 'SUBWAY'
            step_info = Hash.new
            step_info['travel_mode'] = step['travel_mode']
            step_info['distance'] = step['distance']['text']
            step_info['duration'] = step['duration']['text']
            step_info['instruction'] = step['html_instructions']
            step_info['departure_stop_name'] = step['transit_details']['departure_stop']['name']
            step_info['departure_time'] = step['transit_details']['departure_time']['text']
            step_info['arrival_stop_name'] = step['transit_details']['arrival_stop']['name']
            step_info['arrival_time'] = step['transit_details']['arrival_time']['text']
            step_info['vehicle_type'] = step['transit_details']['line']['vehicle']['type']
            step_info['service_provider'] = step['transit_details']['line']['agencies'].first['name']
            step_info['train_line'] = step['transit_details']['line']['name']
            step_info['train_line_color'] = step['transit_details']['line']['color']
            step_info['train_line_info'] = step['transit_details']['line']['url']
            route_info_hash['route'] << step_info

  # Metra Train Logic
          elsif step['transit_details']['line']['vehicle']['type'] == 'HEAVY_RAIL'
            step_info = Hash.new
            step_info['travel_mode'] = step['travel_mode']
            step_info['distance'] = step['distance']['text']
            step_info['duration'] = step['duration']['text']
            step_info['instruction'] = step['html_instructions']
            step_info['departure_stop_name'] = step['transit_details']['departure_stop']['name']
            step_info['departure_time'] = step['transit_details']['departure_time']['text']
            step_info['arrival_stop_name'] = step['transit_details']['arrival_stop']['name']
            step_info['arrival_time'] = step['transit_details']['arrival_time']['text']
            step_info['vehicle_type'] = step['transit_details']['line']['vehicle']['type']
            step_info['service_provider'] = step['transit_details']['line']['agencies'].first['name']
            step_info['train_line'] = step['transit_details']['line']['name']
            step_info['train_line_short_name'] = step['transit_details']['line']['short_name']
            step_info['train_line_color'] = step['transit_details']['line']['color']
            step_info['train_line_info'] = step['transit_details']['line']['url']
            route_info_hash['route'] << step_info
          end
        end
      end

  # Push all route arrays into one big routes array
      routes_info_hash << route_info_hash
    end
    return routes_info_hash
  end

  # Array of all accessible CTA Stations
    def accessible?(departure_time)
      accessible_stations_array = [

        # CTA BROWN LINE
        "Kimball", "Kedzie-Brown", "Francisco", "Rockwell", "Western-Brown", "Damen-Brown",
        "Montrose", "Irving Park", "Addison-Brown", "Paulina", "Southport", "Belmont",
        "Wellington", "Diversey", "Fullerton", "Armitage", "Sedgwick", "Chicago-Brown",
        "Merchandise Mart", "Washington/Wells", "Harold Washington Library-State/Van Buren",
        "Clark/Lake",

        # CTA BLUE LINE
        "O’Hare", "Rosemont", "Cumberland", "Harlem (O'Hare)", "Jefferson Park", "Logan Square",
        "Western (O’Hare)", "Clark/Lake", "Jackson-Blue", "UIC-Halsted",
        "Illinois Medical District (Damen Entrance)", "Kedzie-Homan", "Forest Park",

        # CTA GREEN LINE
        "Ashland/63rd", "Halsted", "Cottage Grove", "King Drive", "Garfield", "51st", "47th",
        "43rd", "Indiana", "35th-Bronzeville-IIT", "Roosevelt", "Clark/Lake", "Clinton",
        "Morgan-Lake", "Ashland", "California", "Kedzie-Green", "Conservatory-Central Park Drive",
        "Pulaski", "Cicero", "Laramie", "Central","Harlem/Lake (via Marion entrance)",

        # CTA ORANGE LINE
        "Midway", "Pulaski", "Kedzie-Orange", "Western-Orange", "35/Archer", "Ashland", "Halsted", "Roosevelt", "Harold Washington Library-State/Van Buren",
        "Harold Washington Library-State/Van Buren", "Washington/Wells", "Clark/Lake",

        # CTA PINK LINE
        "54th/Cermak", "Cicero", "Kostner", "Pulaski", "Central Park", "Kedzie-Pink", "California",
        "Western-Pink", "Damen-Pink", "18th", "Polk", "Ashland", "Morgan-Lake", "Clinton", "Clark/Lake",
        "Harold Washington Library-State/Van Buren", "Washington/Wells",

        # CTA PURPLE LINE
        "Belmont", "Wellington", "Diversey", "Fullerton", "Armitage", "Sedgwick", "Chicago-Purple",
        "Merchandise Mart", "Clark/Lake", "Harold Washington Library-State/Van Buren",
        "Washington/Wells",

        # CTA RED LINE
        "Howard", "Loyola", "Graville", "Addison-Red", "Belmont", "Fullerton", "Chicago-Red", "Grand", "Lake",
        "Jackson-Red", "Roosevelt", "Cermak-Chinatown", "Sox-35th", "47th", "Garfield", "63rd",
        "69th", "79th", "87th", "95th/Dan Ryan",

        # CTA YELLOW LINE
        "Howard", "Oakton-Skokie", "Dempster-Skokie"
      ]


  # Logic to filter out any unaccessible routes
    routes = self.directions?(departure_time)


      routes.each do |route|
        subway_routes = route['route'].select {|r| r ["vehicle_type"] == "SUBWAY"}
          results_stations_array = subway_routes.each.map  do |subway|
           subway['arrival_stop_name']
          unless(accessible_stations_array.include?(results_stations_array))
            routes.delete(route)
          end
        end
      end
    return routes
  end
end
