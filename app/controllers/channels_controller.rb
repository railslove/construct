class ChannelsController < ApplicationController
  def index
    @channels = Channel.all
  end
  
  def show
    @channel = Channel.find_by_name(params[:id])
    @subheader = Date.today.strftime("%B %d %Y")
    @messages = @channel.messages.today.paginate(:per_page => 250, :page => params[:page])
  end
end
