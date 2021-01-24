class ShortUrlsController < ApplicationController
  def new
    @short_url = ShortUrl.new
  end
end
