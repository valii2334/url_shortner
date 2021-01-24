class ShortUrlsController < ApplicationController
  def new
    @short_url = ShortUrl.new
  end

  def create
    uri = URI.parse(short_url_params[:original_url])
    raise URI::BadURIError unless uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
    
    @short_urls = ShortUrlGenerator.new(short_url_params).perform
  rescue URI::BadURIError
    render file: 'public/500.html', status: :not_found, layout: false
  end

  def update
    @short_url = ShortUrl.find(params[:id])
    @short_url.update(short_url_update_params)

    redirect_to short_url_generator_url(
      random_hex: @short_url.parent_short_url.random_hex
    )
  end

  def search
    @short_url = ShortUrl.find_by(random_hex: params[:random_hex])

    if @short_url.nil?
      render file: 'public/404.html', status: :not_found, layout: false
      return
    end

    unless @short_url.admin_url?
      if @short_url.disabled?
        render file: 'public/404.html', status: :not_found, layout: false
        return
      else
        @short_url.increase_number_of_times_accessed!
        redirect_to @short_url.original_url
        return
      end
    end
  end

  private

  def short_url_params
    params.require(:short_url).permit(:original_url)
  end

  def short_url_update_params
    params.require(:short_url).permit(:disabled)
  end
end
