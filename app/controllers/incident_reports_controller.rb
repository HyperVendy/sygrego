class IncidentReportsController < ApplicationController

  load_and_authorize_resource
  layout 'users'
  
  # GET /incident_reports/new
  # GET /incident
  def new
    @incident_report = IncidentReport.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /incident_reports
  def create
    @incident_report = IncidentReport.new(incident_report_params)

    respond_to do |format|
      if @incident_report.save
          flash[:notice] = 'Thanks for reporting. Another?'
          format.html do
            redirect_to incident_url
          end
      else
          format.html { render action: "new" }
      end
    end
  end

  private

  def incident_report_params
    params.require(:incident_report).permit(
      :section, 
      :session,
      :venue,
      :description,
      :name,
      :action_taken,
      :other_info
    )
  end
end  