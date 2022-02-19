class Api::VolunteersController < ApplicationController
    before_action :authorize_xml
    before_action :authenticate_user!

    # GET /api/volunteers/1.xml
    def show
      @volunteer = Volunteer.find(params[:id])
      
      respond_to do |format|
        format.xml  { render xml: @volunteer }
      end
      
    rescue ActiveRecord::RecordNotFound 
      respond_to do |format|
        format.xml { render xml: "<volunteer></volunteer>", status: :not_found }
      end
    end
end
