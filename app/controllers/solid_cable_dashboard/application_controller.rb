module SolidCableDashboard
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    
    # Set dark mode preference
    before_action :set_appearance
    
    private
    
    def set_appearance
      @appearance = cookies[:solid_cable_dashboard_appearance] || "light"
    end
  end
end
