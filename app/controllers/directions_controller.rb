
class DirectionsController < ApplicationController
  def landing_page
  end

  def route
    @direction = Direction.new
    @direction.start = params[:start]
    @direction.destination = params[:destination]
    @departure_time = params[:departure]

    @alert = Alert.new

    if @direction.start.present? && @direction.destination.present?
      begin
        @elevator_alerts = @alert.get_elevator_alerts
        @routes = @direction.accessible?(@departure_time)
      rescue
        # redirect_to root_url, notice: "Sorry, something went wrong. Please try again in a moment."
      end
    else
      redirect_to root_url, notice: 'Please make sure both fields are properly completed.'
    end
  end
end
