# == Schema Information
#
# Table name: participants
#
#  id                     :bigint           not null, primary key
#  address                :string(200)
#  age                    :integer          default(30), not null
#  allergies              :string(255)
#  amount_paid            :decimal(8, 2)    default(0.0)
#  booking_nbr            :string(10)
#  camping_preferences    :string(100)
#  coming                 :boolean          default(TRUE)
#  coming_friday          :boolean          default(TRUE)
#  coming_monday          :boolean          default(TRUE)
#  coming_saturday        :boolean          default(TRUE)
#  coming_sunday          :boolean          default(TRUE)
#  database_rowid         :integer
#  dietary_requirements   :string(255)
#  dirty                  :boolean          default(FALSE)
#  driver                 :boolean          default(FALSE)
#  driver_signature       :boolean          default(FALSE)
#  driver_signature_date  :datetime
#  driving_to_syg         :boolean          default(FALSE)
#  early_bird             :boolean          default(FALSE)
#  email                  :string(100)
#  emergency_contact      :string(40)
#  emergency_email        :string(100)
#  emergency_phone_number :string(20)
#  emergency_relationship :string(20)
#  exported               :boolean          default(FALSE)
#  fee_when_withdrawn     :decimal(8, 2)    default(0.0)
#  first_name             :string(20)       not null
#  gender                 :string(1)        default("M"), not null
#  group_coord            :boolean          default(FALSE)
#  guest                  :boolean          default(FALSE)
#  helper                 :boolean          default(FALSE)
#  late_fee_charged       :boolean          default(FALSE)
#  licence_type           :string(15)
#  lock_version           :integer          default(0)
#  medical_info           :string(255)
#  medicare_number        :string
#  medications            :string(255)
#  mobile_phone_number    :string(20)
#  number_plate           :string(10)
#  onsite                 :boolean          default(TRUE)
#  paid                   :boolean          default(FALSE)
#  phone_number           :string(20)
#  postcode               :integer
#  registration_nbr       :string(24)
#  rego_type              :string(10)       default("Full Time")
#  spectator              :boolean          default(FALSE)
#  sport_coord            :boolean          default(FALSE)
#  sport_notes            :string
#  status                 :string(20)       default("Accepted")
#  suburb                 :string(40)
#  surname                :string(20)       not null
#  updated_by             :bigint
#  vaccinated             :boolean          default(FALSE)
#  vaccination_document   :string(40)
#  vaccination_sighted_by :string(20)
#  withdrawn              :boolean          default(FALSE)
#  wwcc_number            :string
#  years_attended         :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  group_id               :bigint           default(0), not null
#  voucher_id             :bigint
#
# Indexes
#
#  index_participants_on_coming                               (coming)
#  index_participants_on_group_id_and_surname_and_first_name  (group_id,surname,first_name) UNIQUE
#  index_participants_on_surname_and_first_name               (surname,first_name)
#  index_participants_on_voucher_id                           (voucher_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#

FactoryBot.define do
  factory :participant do
    group

    sequence(:first_name) { |n| "Johnny#{n}"}
    sequence(:surname)    { |n| "Smith#{n}"}
    age                   {"18"}
    gender                {"M"}
    rego_type             {"Full Time"}
    coming_friday         {true}
    coming_saturday       {true}
    coming_sunday         {true}
    coming_monday         {true}
    coming                {true}
    address               {"123 Main St"}
    suburb                {"Disneyland"}
    postcode              {"3333"}
    email                 {"blah@blah.com"}
    phone_number          {"9555-5555"}
    dietary_requirements  {"None"}
    allergies             {"None"}

    trait :under18 do
      age                 {"17"}
      emergency_contact   {"Mother Theresa"}
      emergency_relationship {"Mother"}
      emergency_phone_number {"9777-7777"}
      emergency_email     {"mother@theresa.com"}
    end
  end
end
