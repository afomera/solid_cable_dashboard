module SolidCableDashboard
  class AppearanceController < ApplicationController
    def toggle
      appearance = cookies[:solid_cable_dashboard_appearance] == "dark" ? "light" : "dark"
      cookies[:solid_cable_dashboard_appearance] = { value: appearance, expires: 1.year.from_now }
      redirect_back(fallback_location: root_path)
    end
  end
end
