class StaticPagesController < ApplicationController
  require 'flickr'

  def index
    begin
      flickr = Flickr.new
      unless params[:user_id].blank?
        @photos = flickr.photos.search(user_id: params[:user_id], per_page: 10)
      else
        @photos = flickr.photos.getRecent(per_page: 10)
      end
      @hasher = {}
      @infohash = {}
      @photos.each do |pic|
        picinfo = flickr.photos.getInfo(photo_id: pic.id)
        @infohash[pic.id] = picinfo
        @hasher[pic.id] = flickr.photos.comments.getList(photo_id: pic.id)
      end
    rescue StandardError => e
      flash[:alert] = "#{e.class}: #{e.message}. Please try again..."
      redirect_to root_path
    end
  end


end
