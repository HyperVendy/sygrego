# NOTE: This process tends to hang in development whenever a 
#       production database is loaded in, because Active::Storage
#       hangs when trying to purge various attachments that it 
#       cannot find - runs by skipping the purge in environments 
#       that are not production

namespace :syg do
    namespace :end_of_year do
        desc 'Reset sport grade fields to pristine state'
        task update_sport_grades: ['db:migrate'] do |_t|
            puts 'Updating sport grades...'
            Grade.all.each do |g|
                g.entry_limit = g.starting_entry_limit
                g.status = 'Open'
                g.entries_to_be_allocated = 999
                g.over_limit = false
                g.one_entry_per_group = false
                g.waitlist_expires_at = nil
        
                g.save(validate: false)
            end
        end
    
        desc 'Reset sport section fields to pristine state'
        task update_sport_sections: ['db:migrate'] do |_t|
            puts 'Updating sport sections...'
            Section.all.each do |s|
                puts "--> #{s.name}"
                s.number_in_draw = nil
    
                s.save(validate: false)

                if s.draw_file.attached? && Rails.env.production?
                    s.draw_file.purge 
                    puts '--  draw file purged'
                end
            end
        end
    
        desc 'Delete old sport draws'
        task delete_sport_draws: ['db:migrate'] do |_t|
            puts 'Deleting sport draws...'
            Section.all.each do |s|
                puts "--> #{s.name}"
                if s.draw_file.attached? && Rails.env.production?
                    s.draw_file.purge 
                    puts '--  draw file purged'
                end
            end
        end
    
        desc 'Reset sport models to pristine state'
        task update_sport_models: %i[update_sport_grades
                                    update_sport_sections]
    
        desc 'Clear all participant extras'
        task destroy_participant_extras: ['db:migrate'] do |_t|
            puts "Deleting last year's participant extras..."
            ParticipantExtra.destroy_all
        end
    
        desc 'Clear all group extras'
        task destroy_group_extras: ['destroy_participant_extras'] do |_t|
            puts "Deleting last year's group extras..."
            GroupExtra.destroy_all
        end
    
        desc 'Reset group fields to pristine state'
        task update_groups: ['db:migrate'] do |_t|
            puts 'Updating groups...'
            Group.all.each do |g|
                puts "--> #{g.abbr}"
                g.last_year = g.coming
                g.coming = g.admin_use
                g.new_group = false
                g.late_fees = 0
                g.allocation_bonus = 0
                g.years_attended = 0
                g.status = 'Stale' unless g.admin_use
        
                g.save(validate: false)

                if g.booklet_file.attached? && Rails.env.production?
                    g.booklet_file.purge
                    puts '--  booklet purged'
                end
                if g.results_file.attached? && Rails.env.production?
                    g.results_file.purge 
                    puts '--  results purged'
                end
            end
        end
    
        desc 'Delete group attachments'
        task delete_group_attachments: ['db:migrate'] do |_t|
            puts 'Deleting group attachments...'
            Group.all.each do |g|
                puts "--> #{g.abbr}"
                if g.booklet_file.attached? && Rails.env.production?
                    g.booklet_file.purge
                    puts '--  booklet purged'
                end
                if g.results_file.attached? && Rails.env.production?
                    g.results_file.purge 
                    puts '--  results purged'
                end
            end
        end
    
        desc 'Reset group event detail fields to pristine state'
        task update_event_details: ['db:migrate'] do |_t|
            puts 'Updating group event details...'
            EventDetail.all.each do |g|
                puts "--> #{g.group.abbr}"
                g.estimated_numbers = g.group.participants.playing_sport.count
                g.fire_pit = false
                g.camping_rqmts = nil
                g.tents = nil
                g.caravans = nil
                g.marquees = nil
                g.marquee_sizes = nil
                g.marquee_co = nil
                g.number_of_vehicles = 0
                g.buddy_interest = 'Not interested'
                g.buddy_comments = nil
                g.service_pref_sat = 'No preference'
                g.service_pref_sun = 'No preference'
                g.warden_zone_id = nil
    
                g.save(validate: false)

                if g.food_cert.attached? && Rails.env.production?
                    g.food_cert.purge
                    puts '--  food cert purged'
                end
                if g.covid_plan.attached? && Rails.env.production?
                    g.covid_plan.purge 
                    puts '--  covid plan purged'
                end
                if g.insurance.attached? && Rails.env.production?
                    g.insurance.purge 
                    puts '--  insurance purged'
                end
            end
        end
    
        desc 'Delete group event detail attachments'
        task delete_event_detail_attachments: ['db:migrate'] do |_t|
            puts 'Deleting group event detail attachments...'
            EventDetail.all.each do |g|
                puts "--> #{g.group.abbr}"
                if g.food_cert.attached? && Rails.env.production?
                    g.food_cert.purge
                    puts '--  food cert purged'
                end
                if g.covid_plan.attached? && Rails.env.production?
                    g.covid_plan.purge 
                    puts '--  covid plan purged'
                end
                if g.insurance.attached? && Rails.env.production?
                    g.insurance.purge 
                    puts '--  insurance purged'
                end
            end
        end
    
        desc 'Reset group mysyg settings fields to pristine state'
        task update_mysyg_settings: ['db:migrate'] do |_t|
            puts 'Updating group mysyg settings...'
            MysygSetting.all.each do |g|
                g.mysyg_enabled = APP_CONFIG[:mysyg_default_enabled]
                g.mysyg_open = g.group.admin_use
                g.approve_option = "Normal"
                g.indiv_sport_view_strategy = "Show all"
                g.team_sport_view_strategy = "Show all"
                g.participant_instructions = nil
                g.extra_fee_total = 0.0
                g.extra_fee_per_day = 0.0
                g.show_finance_in_mysyg = true
                g.show_group_extras_in_mysyg = true
                g.show_sports_in_mysyg = true
                g.show_volunteers_in_mysyg = true
    
                g.save(validate: false)
            end
        end
    
        desc 'Reset group rego checklists fields to pristine state'
        task update_rego_checklists: ['db:migrate'] do |_t|
            puts 'Updating group rego_checklists...'
            RegoChecklist.all.each do |g|
                g.second_rep = nil
                g.registered = false
                g.rego_rep = nil
                g.admin_rep = nil
                g.driver_form = false
                g.driving_notes = nil
                g.finance_notes = nil
                g.sport_notes = nil
                g.disabled_notes = nil
                g.upload_notes = nil
                g.second_mobile = nil
                g.rego_mobile = nil
                g.disabled_participants = false
                g.food_cert_sighted = false
                g.insurance_sighted = false
                g.covid_plan_sighted = false
    
                g.save(validate: false)
            end
        end
    
        desc 'Refresh Groups for new year'
        task refresh_groups: [:destroy_group_extras,
                            :update_groups,
                            :update_event_details,
                            :update_mysyg_settings,
                            :update_rego_checklists]
    
        desc 'Clear all sport preferences'
        task destroy_sport_preferences: ['db:migrate'] do |_t|
            puts "Deleting last year's sport preferences..."
            SportPreference.destroy_all
        end
    
        # This routine rescues nil due to callbacks in deleting Participants having the
        # side effect of updating the Participant in the act of destroying it and therefore
        # causing a StaleObjectError.
        #
        # Not sure if this is a Rails error, but feel that rescue nil is acceptable in a rake
        # task that is executed only a couple of times a year
    
        desc 'Remove participants who did not come'
        task remove_non_attending_participants: ['destroy_sport_preferences'] do |_t|
            puts "Deleting last year's non-attending participants..."
            Participant.not_coming.each do |p|
                begin
                    p.destroy
                rescue ActiveRecord::StaleObjectError
                    nil
                end
            end
        end
    
        desc 'Reset participants to pristine state'
        task update_remaining_participants: ['db:migrate'] do |_t|
            puts "Updating last year's participants..."
            Participant.all.each do |p|
                if p.coming
                    p.years_attended += 1 unless p.years_attended.nil?
                end
        
                p.status = 'Accepted'
                p.coming = false
                p.age += 1
                p.coming_friday = true
                p.coming_saturday = true
                p.coming_sunday = true
                p.coming_monday = true
                p.spectator = false
                p.onsite = p.group.onsite
                p.helper = false
                p.group_coord = false
                p.sport_coord = false
                p.guest = false
                p.voucher = nil
                p.early_bird = false
                p.withdrawn = false
                p.fee_when_withdrawn = 0
                p.late_fee_charged = false
                p.driver = false
                p.number_plate = nil
                p.driver_signature = false
                p.driver_signature_date = nil
                p.amount_paid = 0
        
                p.save(validate: false)
            end
        end
    
        desc 'Clean up generated vouchers'
        task clean_up_vouchers: ['db:migrate'] do |_t|
            puts "Cleaning up generated vouchers..."
            Voucher.all.each do |v|
                if v.name.match('FREEHELPER')
                    v.destroy
                end
            end
        end
    
        desc 'Refresh Participants for new year'
        task refresh_participants: %i[destroy_volunteers 
                                    remove_non_attending_participants
                                    update_remaining_participants 
                                    clean_up_vouchers]
    
        desc 'Clear all payments'
        task destroy_payments: ['db:migrate'] do |_t|
            puts "Deleting last year's payments..."
            Payment.destroy_all
        end
    
        desc 'Clear all participant sport entries'
        task destroy_participants_sport_entries: ['environment'] do |_t|
            puts "Deleting last year's sport entry participants..."
                ParticipantsSportEntry.delete_all
    #            ActiveRecord::Base.connection.delete('DELETE FROM participants_sport_entries')
        end
    
        desc 'Clear all sport entries'
        task destroy_sport_entries: ['destroy_participants_sport_entries'] do |_t|
            puts "Deleting last year's sport entries..."
            SportEntry.destroy_all
        end
    
        desc 'Clear all volunteers'
        task destroy_volunteers: ['db:migrate'] do |_t|
            puts "Deleting last year's volunteers..."
            Volunteer.destroy_all
        end
    
        desc 'Clear all lost property'
        task destroy_lost_property: ['db:migrate'] do |_t|
            puts "Deleting last year's lost property..."
#            LostItem.delete_all
            LostItem.all.each do |i|
                puts "--> #{i.description}"

                if i.photo.attached? && Rails.env.production?
                    i.photo.purge
                    puts "-->  photo purged"
                end

                i.delete
            end
        end
    
        desc 'Clear all ballot results'
        task destroy_ballot_results: ['db:migrate'] do |_t|
            puts "Deleting last year's ballot results..."
            BallotResult.destroy_all
        end
    
        desc 'Clear all awards'
        task destroy_awards: ['db:migrate'] do |_t|
            puts "Deleting last year's award nominations..."
            Award.destroy_all
        end
    
        desc 'Clear all sports evaluations'
        task destroy_sports_evaluations: ['db:migrate'] do |_t|
            puts "Deleting last year's sports evaluations..."
            SportsEvaluation.destroy_all
        end
    
        desc 'Clear all incident reports'
        task destroy_incident_reports: ['db:migrate'] do |_t|
            puts "Deleting last year's incident reports..."
            IncidentReport.destroy_all
        end
    
        desc 'Clear all groups grades filters'
        task destroy_groups_grades_filters: ['db:migrate'] do |_t|
            puts "Deleting last year's group / grade filters..."
            GroupsGradesFilter.destroy_all
        end

        desc 'Destroy all models that are transient between SYG years'
        task destroy_transient_models: ['destroy_payments',
                                        'destroy_sport_entries',
                                        'destroy_lost_property',
                                        'destroy_ballot_results',
                                        'destroy_awards',
                                        'destroy_sports_evaluations',
                                        'destroy_incident_reports']

        desc 'Clear all audit trails'
        task destroy_audit_trails: ['db:migrate'] do |_t|
            puts 'Deleting old audit trails...'
            AuditTrail.destroy_all
        end
    
        desc 'Clean up logs'
        task clear_logs: [:destroy_audit_trails,
                        'log:clear']
    
        desc 'Reset settings to start of year state'
        task reset_settings: ['db:migrate'] do |_t|
            puts 'Resetting settings...'
            Setting.all.each do |s|
                s.group_registrations_closed = true
                s.participant_registrations_closed = true
                s.restricted_sports_allocated = false
                s.indiv_draws_complete = false
                s.team_draws_complete = false
                s.syg_is_happening = false
                s.syg_is_finished = false
                s.updates_restricted = false
                s.generate_stats = false
                s.sports_loaded = false
                s.volunteers_loaded = false
                s.evening_sessions_final = false
                s.early_bird = true
        
                s.save(validate: false)
            end
        end
    
        desc 'Clean up all non-admin users'
        task clean_up_users: ['db:migrate'] do |_t|
            puts "Cleaning up non-admin users..."
            User.all.each do |u|
                u.destroy unless u.role?(:admin)
            end
        end
    
        desc 'Roll State Youth Games models for a new year'
        task roll: [:clear_logs,
                    :clean_up_users,
                    :refresh_groups,
                    :refresh_participants,
                    :update_sport_models,
                    :destroy_transient_models,
                    :reset_settings]

        desc 'Clean up old attachments'
        task delete_attachments: [:delete_sport_draws,
                    :delete_group_attachments,
                    :delete_event_detail_attachments]
    end

    # TODO: Delete statistics more than x years old
end
  