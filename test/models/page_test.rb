# == Schema Information
#
# Table name: pages
#
#  id         :bigint           not null, primary key
#  admin      :boolean
#  name       :string(50)
#  permalink  :string(20)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class PageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
