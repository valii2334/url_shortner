require 'rails_helper'

RSpec.describe ShortUrlsController, type: :controller do
  context '#create' do
    it 'does not create short urls if invalid original_url' do
      expect do
        post :create, params: {
          short_url: {
            original_url: '123'
          }
        }
      end.to_not change { ShortUrl.count }
    end

    it 'returns 500 if invalid original_url' do
      post :create, params: {
        short_url: {
          original_url: '123'
        }
      }

      expect(response.status).to eql(500)
    end

    it 'creates two short_urls if valid original_url' do
      expect do
        post :create, params: {
          short_url: {
            original_url: 'https://www.google.com'
          }
        }
      end.to change { ShortUrl.count }.by(2)

      short_url = ShortUrl.find_by(original_url: 'https://www.google.com')

      expect(short_url).to be_present
      expect(short_url.admin_url).to be_present
    end
  end

  context '#search' do
    it 'returns 404 if no url if found' do
      get :search, params: {
          random_hex: '123'
      }

      expect(response.status).to eql(404)
    end

    it 'redirects to original_url if short_url is found and increases number_of_times_accessed with 1' do
      short_url = create(:short_url)

      expect do
        get :search, params: {
          random_hex: short_url.random_hex
        }
      end.to change { short_url.reload.number_of_times_accessed }.by(1)

      response.should redirect_to short_url.original_url
    end

    it 'should not redirect if admin_url is found' do
      short_url = ShortUrlGenerator.new({ original_url: FFaker::Internet.uri('https') }).perform

      get :search, params: {
        random_hex: short_url.parent_short_url.random_hex
      }

      expect(response.status).to eq(200)
    end

    it 'renders 404 if short_url is disabled' do
      short_url = create(:short_url, disabled: true)

      get :search, params: {
          random_hex: short_url.random_hex
      }

      expect(response.status).to eql(404)
    end
  end

  context '#update' do
    it 'updates disabled and redirects to search for admin_url' do
      short_url = ShortUrlGenerator.new({ original_url: FFaker::Internet.uri('https') }).perform

      expect do
        patch :update, params: {
          id: short_url.id,
          short_url: {
            disabled: true
          }
        }
      end.to change { short_url.reload.disabled }

      response.should redirect_to short_url_generator_url(
        random_hex: short_url.parent_short_url.random_hex
      )
    end
  end
end
