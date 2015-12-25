require 'rails_helper'

describe User do
  describe "relations and validations" do

    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(255) }

  end
end
