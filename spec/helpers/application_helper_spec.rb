require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the HomeHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe ApplicationHelper do
  describe "#markdown" do
    it "returns text with markdown" do
      expect(helper.markdown("text")).to eq("<p>text</p>\n")
    end
  end

  describe "#markup2html" do
    it ""
  end

  describe "#show_afisha" do
    it ""
  end
end
