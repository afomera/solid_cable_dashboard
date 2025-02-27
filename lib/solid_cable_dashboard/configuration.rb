# frozen_string_literal: true

module SolidCableDashboard
  class Configuration
    attr_accessor :title

    def initialize
      @title = "Solid Cable Dashboard"
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
