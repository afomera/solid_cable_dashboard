# frozen_string_literal: true

module SolidCableDashboard
  class Message
    attr_reader :solid_cable_message

    def initialize(solid_cable_message)
      @solid_cable_message = solid_cable_message
    end

    def id
      solid_cable_message.id
    end

    def channel
      solid_cable_message.channel
    end

    def channel_hash
      solid_cable_message.channel_hash
    end

    def payload
      solid_cable_message.payload
    end

    def created_at
      solid_cable_message.created_at
    end

    def channel_string
      channel
    rescue
      "Binary channel (#{channel.bytesize} bytes)"
    end

    def payload_string
      JSON.parse(payload)
    rescue
      "Binary payload (#{payload.bytesize} bytes)"
    end

    def payload_size
      payload.bytesize
    end

    def human_payload_size
      ActiveSupport::NumberHelper.number_to_human_size(payload_size)
    end
  end
end
