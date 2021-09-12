# == Schema Information
#
# Table name: venues
#
#  id            :bigint           not null, primary key
#  address       :string
#  database_code :string(4)
#  lat           :float
#  lng           :float
#  name          :string(50)       default(""), not null
#  updated_by    :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "test_helper"

class VenueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
