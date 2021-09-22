class ApplicationMailer < ActionMailer::Base
  default from: 'registrations@stateyouthgames.com'
  layout 'mailer'
  before_action :get_settings

  def get_settings
      @settings ||= Setting.first
  end

end
