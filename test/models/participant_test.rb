# == Schema Information
#
# Table name: participants
#
#  id                           :bigint           not null, primary key
#  address                      :string(200)
#  age                          :integer          default(30), not null
#  amount_paid                  :decimal(8, 2)    default(0.0)
#  coming                       :boolean          default(TRUE)
#  database_rowid               :integer
#  days                         :integer          default(3), not null
#  dietary_requirements         :string(255)
#  driver                       :boolean          default(FALSE)
#  driver_signature             :boolean          default(FALSE)
#  driver_signature_date        :datetime
#  early_bird                   :boolean          default(FALSE)
#  email                        :string(100)
#  emergency_contact            :string(40)
#  emergency_phone_number       :string(20)
#  emergency_relationship       :string(20)
#  encrypted_medicare_number    :string
#  encrypted_medicare_number_iv :string
#  encrypted_wwcc_number        :string
#  encrypted_wwcc_number_iv     :string
#  fee_when_withdrawn           :decimal(8, 2)    default(0.0)
#  first_name                   :string(20)       not null
#  gender                       :string(1)        default("M"), not null
#  group_coord                  :boolean          default(FALSE)
#  guest                        :boolean          default(FALSE)
#  helper                       :boolean          default(FALSE)
#  late_fee_charged             :boolean          default(FALSE)
#  lock_version                 :integer          default(0)
#  medical_info                 :string(255)
#  medications                  :string(255)
#  mobile_phone_number          :string(20)
#  number_plate                 :string(10)
#  onsite                       :boolean          default(TRUE)
#  phone_number                 :string(20)
#  postcode                     :integer
#  spectator                    :boolean          default(FALSE)
#  sport_coord                  :boolean          default(FALSE)
#  status                       :string(20)       default("Accepted")
#  suburb                       :string(40)
#  surname                      :string(20)       not null
#  updated_by                   :bigint
#  withdrawn                    :boolean          default(FALSE)
#  years_attended               :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  group_id                     :bigint           default(0), not null
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
end
