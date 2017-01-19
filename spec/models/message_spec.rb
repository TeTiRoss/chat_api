require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should validate_presence_of(:content) }
  it { is_expected.to callback(:increment_user_messages_count).after(:create) }
  it { is_expected.to callback(:read_by_creator).after(:create) }
end
