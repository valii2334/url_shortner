require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
  let(:short_url) { build(:short_url) }
  subject { short_url }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :random_hex }
  it { should have_attribute :original_url }
  it { should have_attribute :child_short_url_id }
  it { should have_attribute :number_of_times_accessed }
  it { should have_attribute :disabled }
end
