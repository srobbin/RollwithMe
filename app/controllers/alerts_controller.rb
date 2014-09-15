class AlertsController < ApplicationController
  require 'open-uri'
  require 'nokogiri'

  url = "http://www.transitchicago.com/api/1.0/alerts.aspx"
  data = Nokogiri::HTML(open(url))
  @alert = []
  data.css("shortdescription").each do |alert|
    if alert.text.include?('elevator')
       @alert << alert.text
      else
      alert.delete(alert)
    end
  end
end
