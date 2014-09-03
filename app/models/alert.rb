class Alert

  require 'open-uri'
  require 'nokogiri'

  url = "http://www.transitchicago.com/api/1.0/alerts.aspx"
  data = Nokogiri::HTML(open(url))

  alerts = data.xpath("//alert").each do |alert|
      %w[shortdescription].each do |description|
      if alert.text.include?('elevator')
         puts alert.at(description).text
        else
          alert.delete(alert)
      end
    end
  end
end
