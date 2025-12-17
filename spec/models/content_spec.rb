# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Content, type: :model do
  describe '#associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe '#validations' do
    before { create(:content, user: create(:user)) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_uniqueness_of(:title).case_insensitive.scoped_to(:user_id).with_message('already exists for this user') }
  end
end
