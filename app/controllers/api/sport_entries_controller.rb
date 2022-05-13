class Api::SportEntriesController < ApplicationController
    before_action :authorize_xml
    before_action :authenticate_user!
    
    # GET /api/sport_entries/1.xml
    def show
      @sport_entry = SportEntry.find(params[:id])
      
      respond_to do |format|
        format.xml  { render xml: @sport_entry }
      end
      
    rescue ActiveRecord::RecordNotFound 
      respond_to do |format|
        format.xml { render xml: "<sport-entry></sport-entry>", status: :not_found }
      end
    end
end
