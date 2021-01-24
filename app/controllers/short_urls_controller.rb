class ShortUrlsController < ApplicationController
  def new
    @short_url = ShortUrl.new
  end

  def create
    @short_urls = ShortUrlGenerator.new(short_url_params).perform
  end

  def update
    @short_url = ShortUrl.find(params[:id])
    @short_url.update(short_url_update_params)

    redirect_to short_url_generator_url(
      random_hex: ShortUrl.find_by(child_short_url_id: @short_url.id).random_hex
    )
  end

  def search
    @short_url = ShortUrl.find_by(random_hex: params[:random_hex])

    redirect_to root_path and return if @short_url.nil?

    if @short_url.child_short_url.nil?
      if @short_url.disabled?
        render file: 'public/404.html', status: :not_found, layout: false
        return
      end

      redirect_to @short_url.original_url

      ShortUrl.transaction do
        @short_url.lock!
        @short_url.update(
          number_of_times_accessed: @short_url.number_of_times_accessed + 1
        )
        @short_url.save!
      end

      return
    end

    @child_url = @short_url.child_short_url
  end

  private

  def short_url_params
    params.require(:short_url).permit(:original_url)
  end

  def short_url_update_params
    params.require(:short_url).permit(:disabled)
  end
end
