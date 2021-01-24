class ShortUrlsController < ApplicationController
  def new
    @short_url = ShortUrl.new
  end

  def create
    @short_url = ShortUrlGenerator.new(short_url_params).perform
  end

  private

  def short_url_params
    params.require(:short_url).permit(:original_url)
  end
end
