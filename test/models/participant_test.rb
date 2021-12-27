# == Schema Information
#
# Table name: participants
#
#  id                     :bigint           not null, primary key
#  address                :string(200)
#  age                    :integer          default(30), not null
#  amount_paid            :decimal(8, 2)    default(0.0)
#  coming                 :boolean          default(TRUE)
#  database_rowid         :integer
#  days                   :integer          default(3), not null
#  dietary_requirements   :string(255)
#  driver                 :boolean          default(FALSE)
#  driver_signature       :boolean          default(FALSE)
#  driver_signature_date  :datetime
#  early_bird             :boolean          default(FALSE)
#  email                  :string(100)
#  emergency_contact      :string(40)
#  emergency_phone_number :string(20)
#  emergency_relationship :string(20)
#  fee_when_withdrawn     :decimal(8, 2)    default(0.0)
#  first_name             :string(20)       not null
#  gender                 :string(1)        default("M"), not null
#  group_coord            :boolean          default(FALSE)
#  guest                  :boolean          default(FALSE)
#  helper                 :boolean          default(FALSE)
#  late_fee_charged       :boolean          default(FALSE)
#  lock_version           :integer          default(0)
#  medical_info           :string(255)
#  medicare_number        :string
#  medications            :string(255)
#  mobile_phone_number    :string(20)
#  number_plate           :string(10)
#  onsite                 :boolean          default(TRUE)
#  phone_number           :string(20)
#  postcode               :integer
#  spectator              :boolean          default(FALSE)
#  sport_coord            :boolean          default(FALSE)
#  status                 :string(20)       default("Accepted")
#  suburb                 :string(40)
#  surname                :string(20)       not null
#  updated_by             :bigint
#  withdrawn              :boolean          default(FALSE)
#  wwcc_number            :string
#  years_attended         :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  group_id               :bigint           default(0), not null
#
# Indexes
#
#  index_participants_on_coming                               (coming)
#  index_participants_on_group_id_and_surname_and_first_name  (group_id,surname,first_name) UNIQUE
#  index_participants_on_surname_and_first_name               (surname,first_name)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#
require "test_helper"

class ParticipantTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  def setup
    @user = FactoryBot.create(:user, :admin)
    @setting = FactoryBot.create(:setting)
    @participant = FactoryBot.create(:participant)
  end

  test "should display driver fields" do
    assert_equal '', @participant.driver_sign
    assert_equal '', @participant.date_driver_signed

    @participant.driver_signature = true
    @participant.driver_signature_date = '1/2/2020'

    assert_equal '[electronic]', @participant.driver_sign
    assert_equal '01/02/2020', @participant.date_driver_signed
  end

  def test_participant_fee_values
    full_participant = FactoryBot.create(:participant)
    early_participant = FactoryBot.create(:participant, early_bird: true)
    eleven_year_old_playing_sport = FactoryBot.create(:participant, age: 11)
    spectator = FactoryBot.create(:participant, spectator: true)
    primary_aged = FactoryBot.create(:participant, age: 11, spectator: true)
    pre_schooler = FactoryBot.create(:participant, age: 5)
    day_visitor_not_playing_sport = FactoryBot.create(:participant, spectator: true, onsite: false, days: 2)
    early_day_visitor_not_playing_sport = FactoryBot.create(:participant, spectator: true, onsite: false, days: 2, early_bird: true)
    day_visitor_playing_sport = FactoryBot.create(:participant, onsite: false, days: 1)
    early_day_visitor_playing_sport = FactoryBot.create(:participant, onsite: false, days: 1, early_bird: true)
    group_coordinator_playing_sport = FactoryBot.create(:participant, group_coord: true)
    group_coordinator_not_playing_sport = FactoryBot.create(:participant, group_coord: true, spectator: true)
    sport_coordinator_playing_sport = FactoryBot.create(:participant, sport_coord: true)
    sport_coordinator_not_playing_sport = FactoryBot.create(:participant, sport_coord: true, spectator: true)
    guest_playing_sport = FactoryBot.create(:participant, guest: true)
    guest_not_playing_sport = FactoryBot.create(:participant, guest: true, spectator: true)

    assert_equal @setting.full_fee, full_participant.fee
    assert_equal @setting.full_fee, eleven_year_old_playing_sport.fee
    assert_equal 75, early_participant.fee
    assert_equal 50, spectator.fee
    assert_equal 20, primary_aged.fee
    assert_equal 0, pre_schooler.fee
    assert_equal 25, day_visitor_playing_sport.fee
    assert_equal 25, early_day_visitor_playing_sport.fee
    assert_equal 30, day_visitor_not_playing_sport.fee
    assert_equal 30, early_day_visitor_not_playing_sport.fee
    assert_equal 60, group_coordinator_playing_sport.fee
    assert_equal 40, group_coordinator_not_playing_sport.fee
    assert_equal 80, sport_coordinator_playing_sport.fee
    assert_equal 50, sport_coordinator_not_playing_sport.fee
    assert_equal 0, guest_playing_sport.fee
    assert_equal 0, guest_not_playing_sport.fee
  end

  def test_participant_category_values
    full_participant = FactoryBot.create(:participant)
    early_participant = FactoryBot.create(:participant, early_bird: true)
    spectator = FactoryBot.create(:participant, spectator: true)
    early_spectator = FactoryBot.create(:participant, spectator: true, early_bird: true)
    primary_aged = FactoryBot.create(:participant, age: 11, spectator: true)
    pre_schooler = FactoryBot.create(:participant, age: 5)
    day_visitor_not_playing_sport = FactoryBot.create(:participant, spectator: true, onsite: false)
    day_visitor_playing_sport = FactoryBot.create(:participant, onsite: false)
    early_day_visitor_playing_sport = FactoryBot.create(:participant, onsite: false, early_bird: true)
    group_coordinator_playing_sport = FactoryBot.create(:participant, group_coord: true)
    group_coordinator_not_playing_sport = FactoryBot.create(:participant, group_coord: true, spectator: true)
    sport_coordinator_playing_sport = FactoryBot.create(:participant, sport_coord: true)
    sport_coordinator_not_playing_sport = FactoryBot.create(:participant, sport_coord: true, spectator: true)
    guest_playing_sport = FactoryBot.create(:participant, guest: true)
    guest_not_playing_sport = FactoryBot.create(:participant, guest: true, spectator: true)
    10.times do
      FactoryBot.create(:participant, group: full_participant.group)      
    end
    full_participant.group.reload
    team_helper = FactoryBot.create(:participant, spectator: true, helper: true, group: full_participant.group)
    offsite_team_helper = FactoryBot.create(:participant, spectator: true, helper: true, onsite: false, group: full_participant.group)

    assert_equal "Child", primary_aged.category
    assert_equal "Sport Participant", full_participant.category
    assert_equal "Sport Participant (early bird)", early_participant.category
    assert_equal "SYG Sport Coordinator - Not playing sport", sport_coordinator_not_playing_sport.category
    assert_equal "Spectator", spectator.category
    assert_equal "Spectator (early bird)", early_spectator.category
    assert_equal "Ages 0-5", pre_schooler.category
    assert_equal "Sport Participant", day_visitor_playing_sport.category
    assert_equal "Sport Participant (early bird)", early_day_visitor_playing_sport.category
    assert_equal "Day Visitor", day_visitor_not_playing_sport.category
    assert_equal "Group Coordinator - Playing sport", group_coordinator_playing_sport.category
    assert_equal "Group Coordinator - Not playing sport", group_coordinator_not_playing_sport.category
    assert_equal "SYG Sport Coordinator - Playing sport", sport_coordinator_playing_sport.category
    assert_equal "SYG Guest - Playing sport", guest_playing_sport.category
    assert_equal "SYG Guest - Not playing sport", guest_not_playing_sport.category
    assert_equal "Team Helper", team_helper.category
    assert_equal "Team Helper - Not staying onsite", offsite_team_helper.category
  end

  test "should import participants from file" do
    FactoryBot.create(:group, abbr: "CAF")
    file = fixture_file_upload('participant.csv','application/csv')
    
    assert_difference('Participant.count') do
      @result = Participant.import(file, @user)
    end

    assert_equal 1, @result[:creates]
    assert_equal 0, @result[:updates]
    assert_equal 0, @result[:errors]
  end

  test "should assign participants to default group if group not found" do
    group = FactoryBot.create(:group, abbr: "DFLT")
    file = fixture_file_upload('participant.csv','application/csv')
    
    assert_difference('Participant.count') do
      @result = Participant.import(file, @user)
    end

    assert_equal 1, @result[:creates]
    assert_equal 0, @result[:updates]
    assert_equal 0, @result[:errors]

    group.reload
    assert_equal 1, group.participants.size
  end

  test "should update exiting participants from file" do
    group = FactoryBot.create(:group, abbr: "CAF")
    participant = FactoryBot.create(:participant, 
      group: group,
      first_name: "Amos",
      surname: "Burton")
    file = fixture_file_upload('participant.csv','application/csv')
    
    assert_no_difference('Participant.count') do
      @result = Participant.import(file, @user)
    end

    assert_equal 0, @result[:creates]
    assert_equal 1, @result[:updates]
    assert_equal 0, @result[:errors]

    participant.reload
    assert_equal 35, participant.age
  end

  test "should not import participants with errors from file" do
    FactoryBot.create(:group, abbr: "CAF")
    file = fixture_file_upload('invalid_participant.csv','application/csv')
    
    assert_no_difference('Participant.count') do
      @result = Participant.import(file, @user)
    end

    assert_equal 0, @result[:creates]
    assert_equal 0, @result[:updates]
    assert_equal 1, @result[:errors]
  end

  test "should not update participants with errors from file" do
    group = FactoryBot.create(:group, abbr: "CAF")
    participant = FactoryBot.create(:participant, 
      group: group,
      first_name: "Amos",
      surname: "Burton")
    file = fixture_file_upload('invalid_participant.csv','application/csv')
    
    assert_no_difference('Participant.count') do
      @result = Participant.import(file, @user)
    end

    assert_equal 0, @result[:creates]
    assert_equal 0, @result[:updates]
    assert_equal 1, @result[:errors]

    participant.reload
    assert_not_equal "X", participant.gender
  end

  test "should import GC participants from file" do
    group = FactoryBot.create(:group)
    file = fixture_file_upload('participant_gc.csv','application/csv')
    
    assert_difference('Participant.count') do
      @result = Participant.import_gc(file, group, @user)
    end

    assert_equal 1, @result[:creates]
    assert_equal 0, @result[:updates]
    assert_equal 0, @result[:errors]
  end

  test "should update exiting GC participants from file" do
    group = FactoryBot.create(:group)
    participant = FactoryBot.create(:participant, 
      group: group,
      first_name: "Amos",
      surname: "Burton")
    file = fixture_file_upload('participant_gc.csv','application/csv')
    
    assert_no_difference('Participant.count') do
      @result = Participant.import_gc(file, group, @user)
    end

    assert_equal 0, @result[:creates]
    assert_equal 1, @result[:updates]
    assert_equal 0, @result[:errors]

    participant.reload
    assert_equal 35, participant.age
  end

  test "should not import GC participants with errors from file" do
    group = FactoryBot.create(:group)
    file = fixture_file_upload('invalid_participant_gc.csv','application/csv')
    
    assert_no_difference('Participant.count') do
      @result = Participant.import_gc(file, group, @user)
    end

    assert_equal 0, @result[:creates]
    assert_equal 0, @result[:updates]
    assert_equal 1, @result[:errors]
  end

  test "should not update GC participants with errors from file" do
    group = FactoryBot.create(:group)
    participant = FactoryBot.create(:participant, 
      group: group,
      first_name: "Amos",
      surname: "Burton")
    file = fixture_file_upload('invalid_participant_gc.csv','application/csv')
    
    assert_no_difference('Participant.count') do
      @result = Participant.import_gc(file, group, @user)
    end

    assert_equal 0, @result[:creates]
    assert_equal 0, @result[:updates]
    assert_equal 1, @result[:errors]

    participant.reload
    assert_not_equal "X", participant.gender
  end

  def test_should_normalize_phone_number
    #local number
    assert_equal "(0#{APP_CONFIG[:state_area_code]}) 9555-1122", Participant.normalize_phone_number("95551122")
    assert_equal "(0#{APP_CONFIG[:state_area_code]}) 9555-1122", Participant.normalize_phone_number("9555-1122")
    assert_equal "(03) 9555-1122", Participant.normalize_phone_number("03-9555-1122")
    assert_equal "(03) 9555-1122", Participant.normalize_phone_number("(03) 9555-1122")
    #mobile number
    assert_equal "(0444) 555-666", Participant.normalize_phone_number("0444555666")
    assert_equal "(0444) 555-666", Participant.normalize_phone_number("(0444) 555666")
    assert_equal "(0444) 555-666", Participant.normalize_phone_number("0444-555-666")
    assert_equal "(0444) 555-666", Participant.normalize_phone_number("(0444) 555-666")
    #not recognised
    assert_equal "private", Participant.normalize_phone_number("private")
    assert_equal "04445556667", Participant.normalize_phone_number("04445556667")
    #empty
    assert_equal "", Participant.normalize_phone_number("")
  end

  def test_should_normalize_medical_info
    #normal
    assert_equal "brain damage", Participant.normalize_medical_info("brain damage")
    #nil
    assert_nil Participant.normalize_medical_info("none")
    assert_nil Participant.normalize_medical_info("None")
    assert_nil Participant.normalize_medical_info("N/A")
    assert_nil Participant.normalize_medical_info("n/a")
    assert_nil Participant.normalize_medical_info("-")
    assert_nil Participant.normalize_medical_info("nil")
    assert_nil Participant.normalize_medical_info("")
  end

  def test_should_normalize_suburb
    #normal case
    assert_equal "Cheltenham", Participant.normalize_suburb("cheltenham")
    #variations on North
    assert_equal "Moe North", Participant.normalize_suburb("moe n")
    assert_equal "Moe North", Participant.normalize_suburb("moe nth")
    assert_equal "Moe North", Participant.normalize_suburb("moe n.")
    assert_equal "Moe North", Participant.normalize_suburb("moe nth.")
    assert_equal "North Moe", Participant.normalize_suburb("n moe")
    assert_equal "North", Participant.normalize_suburb("n")
    #variations on South
    assert_equal "Moe South", Participant.normalize_suburb("moe s")
    assert_equal "Moe South", Participant.normalize_suburb("moe sth")
    assert_equal "Moe South", Participant.normalize_suburb("moe s.")
    assert_equal "Moe South", Participant.normalize_suburb("moe sth.")
    assert_equal "South Moe", Participant.normalize_suburb("s moe")
    assert_equal "South", Participant.normalize_suburb("s")
    #variations on East
    assert_equal "Moe East", Participant.normalize_suburb("moe e")
    assert_equal "Moe East", Participant.normalize_suburb("moe e.")
    assert_equal "East Moe", Participant.normalize_suburb("e moe")
    assert_equal "East", Participant.normalize_suburb("e")
    #variations on West
    assert_equal "Moe West", Participant.normalize_suburb("moe w")
    assert_equal "Moe West", Participant.normalize_suburb("moe w.")
    assert_equal "West Moe", Participant.normalize_suburb("w moe")
    assert_equal "West", Participant.normalize_suburb("w")
    #empty input
    assert_equal "", Participant.normalize_suburb("")
  end

  def test_should_normalize_surname
    #normal case
    assert_equal "Smith", Participant.normalize_surname("smith")
    #a Macca
    assert_equal "McDonald", Participant.normalize_surname("mcdonald")
    #someone Irish
    assert_equal "O'Smythe", Participant.normalize_surname("o'smythe")
    #hyphenated name
    assert_equal "Bleedington-Smythe", Participant.normalize_surname("Bleedington-smythe")
    #two names
    assert_equal "Ablett Jnr", Participant.normalize_surname("Ablett jnr")
    #a little bit of everything
    assert_equal "O'McDonald-Smythe Jnr", Participant.normalize_surname("o'mcdonald-smythe jnr")
    #empty input
    assert_equal "", Participant.normalize_surname("")
  end

  def test_should_normalize_address
    #normal case
    assert_equal "33 Elliot St", Participant.normalize_address("33 elliot street")
    assert_equal "33 Elliot St", Participant.normalize_address("33 Elliot St")
    #road
    assert_equal "33 Elliot Rd", Participant.normalize_address("33 elliot road")
    #avenue
    assert_equal "33 Elliot Ave", Participant.normalize_address("33 elliot av")
    assert_equal "33 Elliot Ave", Participant.normalize_address("33 elliot avenue")
    #close
    assert_equal "33 Elliot Cl", Participant.normalize_address("33 elliot close")
    #boulevard
    assert_equal "33 Elliot Blvd", Participant.normalize_address("33 elliot Boulevard")
    #lane
    assert_equal "33 Elliot Ln", Participant.normalize_address("33 elliot Lane")
    #court
    assert_equal "33 Elliot Crt", Participant.normalize_address("33 elliot court")
    #grove
    assert_equal "33 Elliot Gve", Participant.normalize_address("33 elliot grove")
    assert_equal "33 Elliot Gve", Participant.normalize_address("33 elliot gr")
    #crescent
    assert_equal "33 Elliot Cres", Participant.normalize_address("33 elliot cresent")
    assert_equal "33 Elliot Cres", Participant.normalize_address("33 elliot crescent")
    #place
    assert_equal "33 Elliot Pl", Participant.normalize_address("33 elliot Place")
    #parade
    assert_equal "33 Elliot Pde", Participant.normalize_address("33 elliot parade")
    #drive
    assert_equal "33 Elliot Dve", Participant.normalize_address("33 elliot drive")
    assert_equal "33 Elliot Dve", Participant.normalize_address("33 elliot dr")
    assert_equal "33 Elliot Dve", Participant.normalize_address("33 elliot drv")
    #parade
    assert_equal "33 Elliot Tce", Participant.normalize_address("33 elliot terrace")
    #highway
    assert_equal "33 Elliot Hwy", Participant.normalize_address("33 elliot Highway")
    #square
    assert_equal "33 Elliot Sq", Participant.normalize_address("33 elliot square")
    #track
    assert_equal "33 Elliot Tk", Participant.normalize_address("33 elliot track")
    #p.o. box
    assert_equal "P.O. Box 33", Participant.normalize_address("po box 33")
    assert_equal "P.O. Box 33", Participant.normalize_address("p.o box 33")
    assert_equal "P.O. Box 33", Participant.normalize_address("p.o. box 33")
    #r.m.b. 
    assert_equal "R.M.B. 33", Participant.normalize_address("rmb 33")
    assert_equal "R.M.B. 33", Participant.normalize_address("r.m.b 33")
    assert_equal "R.M.B. 33", Participant.normalize_address("r.m.b. 33")
    #r.s.d. 
    assert_equal "R.S.D. 33", Participant.normalize_address("rsd 33")
    assert_equal "R.S.D. 33", Participant.normalize_address("r.s.d 33")
    assert_equal "R.S.D. 33", Participant.normalize_address("r.s.d. 33")
    #slash-hyphen-quote
    assert_equal "3/3 Elliot St", Participant.normalize_address('3/3 elliot street')
    assert_equal "'The Swamp Emmerson-Windchester Corner M/A/S/H", Participant.normalize_address("'the swamp' emmerson-windchester corner m/a/s/h")
    #empty input
    assert_equal "", Participant.normalize_address("")
  end
end
