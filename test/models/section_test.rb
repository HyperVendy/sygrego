# == Schema Information
#
# Table name: sections
#
#  id               :integer          not null, primary key
#  grade_id         :integer          default("0"), not null
#  name             :string(50)       not null
#  active           :boolean
#  venue_id         :integer          default("0"), not null
#  session_id       :integer          default("0"), not null
#  database_rowid   :integer
#  number_in_draw   :integer
#  year_introduced  :integer
#  number_of_courts :integer          default("1")
#  updated_by       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_sections_on_name  (name) UNIQUE
#

require "test_helper"

class SectionTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  def setup
    FactoryBot.create(:role, name: 'admin')
    @user = FactoryBot.create(:user)
    @section = FactoryBot.create(:section, name: "Order1")
  end

  test "should compare sport sections" do
    #comparison against self
    assert_equal 0, @section <=> @section 
    #different name
    other_section = FactoryBot.create(:section, name: "Order2")
    assert_equal -1, @section <=> other_section
  end

  test "should inherit sport name from grade" do
    assert_equal @section.grade.sport_name, @section.sport_name
  end

  test "should inherit venue name from venue" do
    assert_equal @section.venue.name, @section.venue_name
  end

  test "should inherit session name from session" do
    assert_equal @section.session.name, @section.session_name
  end

  test "should provide section session and venuw" do
    assert_equal @section.session.name + ' - ' + @section.venue.name, @section.session_and_venue
  end

  test "should import sections from file" do
    FactoryBot.create(:grade, name: "Hockey Open B")
    FactoryBot.create(:venue, database_code: "HOCK")
    FactoryBot.create(:session, database_rowid: 1)
    file = fixture_file_upload('section.csv','application/csv')
    
    assert_difference('Section.count') do
      @result = Section.import(file, @user)
    end

    assert_equal 1, @result[:creates]
    assert_equal 0, @result[:updates]
    assert_equal 0, @result[:errors]
  end

  test "should update exiting sections from file" do
    grade = FactoryBot.create(:grade, name: "Hockey Open B")
    venue = FactoryBot.create(:venue, database_code: "HOCK")
    session = FactoryBot.create(:session, database_rowid: 1)
    section = FactoryBot.create(:section, name: 'Hockey Open B1', grade: grade, venue: venue, session: session)
    file = fixture_file_upload('section.csv','application/csv')
    
    assert_no_difference('Section.count') do
      @result = Section.import(file, @user)
    end

    assert_equal 0, @result[:creates]
    assert_equal 1, @result[:updates]
    assert_equal 0, @result[:errors]

    section.reload
    assert_equal 2005, section.year_introduced
  end

  test "should not import sections with errors from file" do
    FactoryBot.create(:grade, name: "Hockey Open B")
    FactoryBot.create(:venue, database_code: "HOCK")
    FactoryBot.create(:session, database_rowid: 1)
    file = fixture_file_upload('invalid_section.csv','application/csv')
    
    assert_no_difference('Section.count') do
      @result = Section.import(file, @user)
    end

    assert_equal 0, @result[:creates]
    assert_equal 0, @result[:updates]
    assert_equal 1, @result[:errors]
  end

  test "should not update sections with errors from file" do
    grade = FactoryBot.create(:grade, name: "Hockey Open B")
    venue = FactoryBot.create(:venue, database_code: "HOCK")
    session = FactoryBot.create(:session, database_rowid: 1)
    section = FactoryBot.create(:section, name: 'Hockey Open B1', grade: grade, venue: venue, session: session)
    file = fixture_file_upload('invalid_section.csv','application/csv')
    
    assert_no_difference('Section.count') do
      @result = Section.import(file, @user)
    end

    assert_equal 0, @result[:creates]
    assert_equal 0, @result[:updates]
    assert_equal 1, @result[:errors]

    section.reload
    assert_equal session, section.session
  end
end
