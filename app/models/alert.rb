class Alert

  def get_elevator_alerts
    require 'open-uri'
    require 'nokogiri'

    url = "http://www.transitchicago.com/api/1.0/alerts.aspx"
    data = Nokogiri::HTML(open(url))
    elevator_alerts = []
      data.xpath("//alert").each do |alert|
        %w[shortdescription].each do |description|
        if alert.text.include?('elevator')
         elevator_alert = alert.at(description).text.strip
         elevator_alerts << elevator_alert
        else
         alert.delete(alert)
        end
      end
    end
    return elevator_alerts
  end
end

#   ALERT SCRAPE TEST

#   url = "http://www.transitchicago.com/api/1.0/alerts.aspx"
#   data = Nokogiri::HTML(open(url))
#    data.xpath("//alert").each do |alert|
#     %w[shortdescription].each do |description|
#     if alert.text.include?('elevator')
#      puts alert.at(description).text.strip
#     else
#     alert.delete(alert)
#     end
#   end
# end
