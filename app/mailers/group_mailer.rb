class GroupMailer < ActionMailer::Base
    default from: 'registrations@stateyouthgames.com'
    layout 'mailer'
    before_action :get_settings
  
    def new_group_signup(group, church_rep, gc)
        @group = group
        @church_rep = church_rep
        @gc = gc
        
        mail(to:      [@settings.rego_email, 
                       @settings.admin_email, 
                       @settings.info_email,
                       @settings.comms_email],
             subject: "#{APP_CONFIG[:email_subject]} New group signup details: #{group.name}",) do |format|
          format.html { render layout: 'mailer' }
          format.text
        end
    end

    def get_settings
        @settings ||= Setting.first
    end
  end
  