class ChatroomsController < ApplicationController
  before_action :require_chef
  def show
    @message = Message.new
    @messages = Message.most_recent
  end
end