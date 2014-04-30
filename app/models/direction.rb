class Direction
  require 'open-uri'
  require 'json'
  attr_accessor :start, :destination

  def directions?(departure)
    url = URI.encode("http://maps.googleapis.com/maps/api/geocode/json?address=#{self.start}&sensor=false")
    url_string_data = open(url).read
    url_json_data = JSON.parse(url_string_data)

    latitude = url_json_data['results'].first['geometry']['location']['lat']
    longitude = url_json_data['results'].first['geometry']['location']['lng']

    # latitude = nil
    # longitude = nil

    # if url_json_data['results'].present?
    #   first_result = url_string_data['results'].first

    #   if first_result.present?
    #     geometry = first_result['geometry']

    #     if geometry.present?
    #       location = geometry['location']

    #       if location.present?
    #         latitude = location['lat']
    #         longitude = location['lng']
    #       end
    #     end
    #   end
    # end


    start_coordinates = [latitude, longitude]

    url = URI.encode("http://maps.googleapis.com/maps/api/geocode/json?address=#{self.destination}&sensor=false")
    url_string_data = open(url).read
    url_json_data = JSON.parse(url_string_data)

    latitude = url_json_data['results'].first['geometry']['location']['lat']
    longitude = url_json_data['results'].first['geometry']['location']['lng']

    destination_coordinates = [latitude, longitude]


    if departure.to_i == 15
      @departure_time = (Time.now + 15.minutes).to_i
    elsif departure.to_i == 30
      @departure_time = (Time.now + 30.minutes).to_i
    elsif departure.to_i == 60
      @departure_time = (Time.now + 1.hour).to_i
    else
      @departure_time = Time.now.to_i
    end

    url = URI.encode("http://maps.googleapis.com/maps/api/directions/json?origin=#{start_coordinates.first},#{start_coordinates.last}&destination=#{destination_coordinates.first},#{destination_coordinates.last}&sensor=false&mode=transit&departure_time=#{@departure_time}&alternatives=true")
    url_string_data = open(url).read
    url_json_data = JSON.parse(url_string_data)

    routes_info_hash = Array.new
    url_json_data['routes'].each do |route|
      route_info_hash = Hash.new
      route_info_hash['start_address'] = route['legs'].first['start_address']
      route_info_hash['distance'] = route['legs'].first['distance']['text']
      route_info_hash['duration'] = route['legs'].first['duration']['text']
      route_info_hash['end_address'] = route['legs'].first['end_address']
      route_info_hash['route'] = Array.new
      route['legs'].first['steps'].each do |step|
        if step['travel_mode'] == 'WALKING'
          step_info = Hash.new
          step_info['travel_mode'] = step['travel_mode']
          step_info['distance'] = step['distance']['text']
          step_info['duration'] = step['duration']['text']
          step_info['instruction'] = step['html_instructions']
          route_info_hash['route'] << step_info
        elsif step['travel_mode'] == 'DRIVING'
          step_info = Hash.new
          step_info['travel_mode'] = step['travel_mode']
          step_info['distance'] = step['distance']['text']
          step_info['duration'] = step['duration']['text']
          step_info['instruction'] = step['html_instructions']
          route_info_hash['route'] << step_info
        elsif step['travel_mode'] == 'TRANSIT'
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
      routes_info_hash << route_info_hash
    end
    return routes_info_hash
  end

  def accessible?(departure_time)
    accessible_stations_array = %w[Kimball, Kedzie, Francisco, Rockwell, Western, Damen, Montrose, Irving Park, Addison, Paulina, Southport, Belmont, Wellington, Diversey, Fullerton, Armitage, Sedgwick, Chicago, Merchandise Mart, Washington/Wells, Harold Washington Library-State/Van Buren, Clark/Lake, O’Hare, Rosemont, Cumberland, Harlem (O'Hare), Jefferson Park, Logan Square, Western (O’Hare), Clark/Lake, Jackson, UIC-Halsted, Illinois Medical District (Damen Entrance), Kedzie-Homan, Forest Park, Ashland/63rd, Cottage Grove, King Drive, Garfield, 51st, 47th, 43rd, Indiana, 35th-Bronzeville-IIT, Roosevelt, Clinton, Morgan, Ashland, California, Conservatory-Central Park Drive, Pulaski, Cicero, Laramie, Harlem/Lake (via Marion entrance), Midway, Pulaski, Kedzie, Western, 35/Archer, Ashland, Halsted, Roosevelt, Harold Washington Library-State/Van Buren, Washington/Wells, Clark/Lake, 54th/Cermak, Cicero, Kostner, Pulaski, Central Park, Kedzie, California, Western, Damen, 18th, Polk, Ashland, Morgan, Clinton, Clark/Lake, Harold Washington Library-State/Van Buren, Washington/Wells, Belmont, Wellington, Diversey, Fullerton, Armitage, Sedgwick, Chicago, Merchandise Mart, Clark/Lake, Harold Washington Library-State/Van Buren, and Washington/Wells, Howard, Loyola, Granville, Addison, Belmont, Fullerton, Chicago, Lake, Jackson, Roosevelt, Cermak-Chinatown, Sox-35th, 47th, Garfield, 63rd, 69th, 79th, 87th, 95th/Dan Ryan, Howard, Oakton-Skokie, Dempster-Skokie]



    routes = self.directions?(departure_time)


      routes.each_with_index do |route, index|
        subway_routes = route['route'].select {|r| r ["vehicle_type"] == "SUBWAY"}
        if subway_routes.any?
          unless(accessible_stations_array.include?(route['arrival_stop_name']))
            routes.delete(route)
           end
        end
      end
    return routes.uniq
  end
end
