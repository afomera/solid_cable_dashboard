require 'pagy'

module SolidCableDashboard
  class Engine < ::Rails::Engine
    isolate_namespace SolidCableDashboard

    initializer "solid_cable_dashboard.assets.precompile" do |app|
      app.config.assets.precompile += %w[
        solid_cable_dashboard/alpine.js
        solid_cable_dashboard/application.js
        solid_cable_dashboard/application.css
      ]
    end

    initializer "solid_cable_dashboard.instrumentation" do
      config.after_initialize do
        SolidCableDashboard::Instrumentation.install
      end
    end

    initializer "solid_cable_dashboard.pagy" do
      # Include Pagy modules in application controller and views
      ActiveSupport.on_load(:action_controller) do
        include Pagy::Backend
      end

      ActiveSupport.on_load(:action_view) do
        include Pagy::Frontend
      end
    end
  end
end
