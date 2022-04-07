# == Schema Information
#
# Table name: sport_preferences
#
#  id             :bigint           not null, primary key
#  preference     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  grade_id       :bigint           not null
#  participant_id :bigint           not null
#
# Indexes
#
#  index_sport_preferences_on_grade_id        (grade_id)
#  index_sport_preferences_on_participant_id  (participant_id)
#
# Foreign Keys
#
#  fk_rails_...  (grade_id => grades.id)
#  fk_rails_...  (participant_id => participants.id)
#
class SportPreference < ApplicationRecord
  belongs_to :grade
  belongs_to :participant

  scope :entered, -> { where('preference is not null') }

  delegate :session, to: :grade

  validates :preference, 
    numericality: { only_integer: true },
    allow_blank: true

  def <=>(other)
    if cached_session.id == other.cached_session.id
      cached_grade.name <=> other.cached_grade.name
    else
      cached_session.id <=> other.cached_session.id
    end
  end

  def self.locate_for_participant(participant)
    SportPreference
      .joins(:grade, :participant)
      .entered
      .where(participant_id: participant.id)
      .sort
  end

#  def self.prepare_for_participant_and_session(participant, session_id = 2)
#    session = SportSession.where(id: session_id).first

#    grades = if participant && session
#               (participant.available_sport_grades +
#                         participant.group_sport_grades_i_can_join +
#                         participant.sport_grades)
#                 .uniq
#                 .sort &
#                 session.sport_grades.to_a &
#                 participant.group.filtered_sport_grades
#             else
#               []
#             end

#    prefs = []
#    prefs = grades.collect do |g|
#      SportPreference.find_or_create_by(participant_id: participant.id, sport_grade_id: g.id) do |sp|
        # SportPreference.find_or_create_by_participant_id_and_sport_grade_id(participant.id, g.id) do |sp|
#        sp.participant_id = participant.id
#        sp.sport_grade_id = g.id
#      end
#    end
#    prefs
#  end

  def self.store(participant_id, grade_id, preference)
    pref = SportPreference.find_by_participant_id_and_grade_id(participant_id, grade_id) || SportPreference.new(participant_id: participant_id, grade_id: grade_id)

    pref.preference = preference
    pref.save
  end

  def self.locate_for_group(group, options = {})
    prefs = SportPreference
            .joins([:grade, { participant: :group }])
            .entered
            .where(participants: { group_id: group.id })
            .where(participants: { coming: true })
            .includes({ participant: %i[group sport_entries] }, grade: %i[session sport sport_entries]).
            #              order('sport_sessions.id, sport_grades.name')
            sort

    prefs = prefs.reject { |p| (options[:entered].nil? || !options[:entered]) && p.is_entered? }
    prefs = prefs.reject { |p| (options[:in_sport].nil? || !options[:in_sport]) && !p.is_entered? && p.is_entered_this_sport? }
    prefs = prefs.reject { |p| (options[:in_session].nil? || !options[:in_session]) && !p.is_entered? && !p.is_entered_this_sport? && p.is_entered_this_session? }
  end

  def cached_participant
    @participant ||= participant
  end

  def cached_grade
    @grade ||= grade
  end

  def cached_session
    @session ||= session
  end

  def group
    @group ||= cached_participant.group
  end

  def sport_entry
    @sport_entry ||= cached_participant.first_entry_in_grade(cached_grade)
  end

  def available_sport_entry
    @available_sport_entry ||= group.first_entry_in_grade(cached_grade)
  end

  def is_entered?
    @is_entered ||= cached_participant.is_entered_in?(cached_grade)
  end

  def is_entered_this_session?
    @is_entered_this_session ||= cached_participant.is_entered_in_session?(cached_grade.session)
  end

  def is_entered_this_sport?
    @is_entered_this_sport ||= cached_participant.is_entered_in_sport?(cached_grade.sport)
  end

  def is_sport_entry_available?
    @is_sport_entry_available ||= !available_sport_entry.nil?
  end

  def is_sport_entry_allowed?
    @is_sport_entry_allowed ||= cached_participant.can_play_grade(cached_grade) &&
                                group.can_enter_grade(cached_grade)
  end

  def entry_comment
    if is_entered_this_sport?
      'Sport clash (not allowed)'
    elsif is_entered_this_session?
      'Session clash'
    else
      ''
    end
  end
end
