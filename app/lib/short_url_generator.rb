class ShortUrlGenerator
  def initialize(short_url_params)
    @short_url_params = short_url_params.to_h
  end

  def perform
    short_url = generate_url(@short_url_params)
    admin_url = generate_url({}.merge({ child_short_url_id: short_url.id }))

    { short_url: short_url, admin_url: admin_url }
  end

  def generate_url(params = {})
    url = new_short_url(params)

    while !url.valid?
      url = new_short_url(params)
    end

    url
  end

  def new_short_url(params)
    ShortUrl.create(params.merge({ random_hex: SecureRandom.hex(4) }))
  end
end
