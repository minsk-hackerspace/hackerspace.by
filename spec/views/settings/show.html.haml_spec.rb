require 'rails_helper'

RSpec.describe "settings/show", type: :view do
  before(:each) do
    @setting = assign(:setting, Setting.create!(key: 'key1', value: 'val1'))
  end

  it "renders attributes in <p>" do
    render
  end
end
