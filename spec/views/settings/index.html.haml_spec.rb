require 'rails_helper'

RSpec.describe "settings/index", type: :view do
  before(:each) do
    assign(:settings, [
      Setting.create!(key: 'key1', value: 'val1'),
      Setting.create!(key: 'key2', value: 'val2')
    ])
  end

  it "renders a list of settings" do
    render
  end
end
