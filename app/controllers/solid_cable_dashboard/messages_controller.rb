module SolidCableDashboard
  class MessagesController < ApplicationController
    def index
      @messages = SolidCable::Message.order(created_at: :desc)
      @pagy, @messages = pagy(@messages)
      @messages = SolidCableDashboard.decorate(@messages)
    end

    def show
      @message = SolidCable::Message.find(params[:id])
      @message = SolidCableDashboard.decorate(@message)
    end

    def clear_all
      SolidCable::Message.delete_all
      redirect_to messages_path, notice: "All messages have been cleared"
    end

    def delete
      @message = SolidCable::Message.find(params[:id])
      @message.destroy
      redirect_to messages_path, notice: "Message was successfully deleted"
    end
  end
end
