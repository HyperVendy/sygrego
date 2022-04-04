class Gc::EventDetailsController < ApplicationController
    load_and_authorize_resource except: [:show]
    before_action :authenticate_user!
    before_action :find_group
    
    layout "gc"
  
    # GET /gc/event_details/1/edit
    def edit
      render layout: @current_role.name
    end
  
    # GET /gc/event_details/1/new_food_certificate
    def new_food_certificate
      render layout: @current_role.name
    end
  
    # PATCH /gc/event_details/1
    def update
      @event_detail.updated_by = current_user.id

      respond_to do |format|
        if @event_detail.update(event_detail_params)
          flash[:notice] = 'Details were successfully updated.'
          format.html { redirect_to home_gc_info_path }
        else
          format.html { render action: "edit", layout: @current_role.name }
        end
      end
    end
  
    # PATCH /gc/event_details/1
    def update_food_certificate
      @event_detail.updated_by = current_user.id

      respond_to do |format|
        if @event_detail.update(event_detail_food_cert_params)
          flash[:notice] = 'Details were successfully updated.'
          format.html { redirect_to home_gc_info_path }
        else
          format.html { render action: "new_food_certificate", layout: @current_role.name }
        end
      end
    end
  
    # PATCH /gc/event_details/1/purge_food_certificate
    def purge_food_certificate
      @event_detail.updated_by = current_user.id

      @event_detail.food_cert.purge

      respond_to do |format|
          format.html { render action: "new_food_certificate", layout: @current_role.name }
      end
    end

    private
  
    def event_detail_params
      params.require(:event_detail).permit(:onsite, 
                                    :fire_pit,
                                    :camping_rqmts,
                                    :tents,
                                    :caravans,
                                    :marquees,
                                    :marquee_sizes,
                                    :marquee_co,
                                    :buddy_interest,
                                    :buddy_comments,
                                    :service_pref_sat,
                                    :service_pref_sun,
                                    :estimated_numbers,
                                    :number_of_vehicles
                                )
    end
  
    def event_detail_food_cert_params
      params.require(:event_detail).permit( 
                                    :food_cert
                                )
    end
end
