class DivisionsController < ApplicationController
   add_breadcrumb "Divisions", :divisions_display_path  
 
# this method to display the divsion by manufacturer and normal
  def display
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in Divsion index page"
    unless params[:manufacturer_id].present?
     begin
      divisions=RestClient.get $api_service+'/divisions'
      @divisions=(JSON.parse divisions)
      if  @divisions.present?
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : divisions successfully displayed"
      else
      Rails.logger.debug_log.debug { "#{"division may be not available otherwise check backend"}"}
      end  

    rescue => e
      Rails.logger.custom_log.error { "#{e} division_controller index method" }
    end
     
    else
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in Divsion index page"  
    begin
      
      @divisions = (JSON.parse RestClient.get $api_service+'/manufacturers/manufacturer_division?manufacturer_id='+params[:manufacturer_id]).paginate(page: params[:page], per_page: 15)
      #divisions_json=JSON.parse divisions
      #@divisions=divisions_json["results"]
       if @divisions.present?
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : divisions successfully displayed"
      else
      Rails.logger.debug_log.debug { "#{"division may be not available otherwise check backend"}"}
      end  
     rescue => e
     Rails.logger.custom_log.error { "#{e} division_controller index method" }
    end
    end

  end

  def _from
    
  end  
# this to create new division but we are not using this method
  def new
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in DivIsion new page"
    begin
    @division="new division"
    manufacturers=RestClient.get $api_service+'/manufacturers'
    @manufacturers=JSON.parse manufacturers
      if @manufacturers.present?
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Manufacturer successfully displayed in dropdown"
      else
      Rails.logger.debug_log.debug { "#{"Manufacturer may be not available otherwise check backend"}"}
      end  
    rescue => e
    Rails.logger.custom_log.error { "#{e} division_controller new method" }
    end  
    add_breadcrumb "New", :new_division_path  
  
  end


# delete the selected division
  def division_delete
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in division_delete method"
   begin
    id=params["format"]    
    user=RestClient.delete $api_service+'/divisions/'+id
   rescue => e
  Rails.logger.custom_log.error { "#{e} division_controller division_delete method" }
   end
    redirect_to action: "display"
  end 
   
# this method is to put the changes of selected divisions
  def division_update
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in division_update method" 
    begin
    params.permit!
    data=params["divisions"]
    id=data[:id]
    division=  {division:{div_name:params["name"], div_code:params["div_code"], mfr_code:"", div_abb: params["div_abb"], address_one:params["address_one"], address_two:params["address_two"], address_three:params["address_three"], city:params["city"], state: params["state"], country:params["country"]}}
    division=RestClient.put $api_service+'/divisions/'+id,division
    rescue => e
    Rails.logger.custom_log.error { "#{e} division_controller division_update method" }
    end

    redirect_to  :action => "display" ,:id=>data[:id]
  end
# to create the division but we are not using it
  def create
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in create method" 
    begin
      params.permit!
      division= {division:{div_name:params["name"], div_code:params["div_code"], mfr_code:"", div_abb: params["div_abb"], address_one:params["address_one"], address_two:params["address_two"], address_three:params["address_three"], city:params["city"], state: params["state"], country:params["country"], manufacturer_id:params["new division"]["manufacturer_id"]}}
      division=RestClient.post $api_service+'/divisions',division
    rescue => e
       Rails.logger.custom_log.error { "#{e} division_controller create method" }
    end  

      redirect_to  :action => "display"
   end  
# to update the selected division for view page
  def edit
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in edit method" 
  
begin
    id=params[:id]
    division=RestClient.get $api_service+'/divisions/'+id
    @division=JSON.parse division
    if @division.present?
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Manufacturer successfully displayed in dropdown"
      else
      Rails.logger.debug_log.debug { "#{"Manufacturer may be not available otherwise check backend"}"}
      end  

   manufacturers=RestClient.get $api_service+'/manufacturers'
   @manufacturers=JSON.parse manufacturers
     if @manufacturers.present?
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Manufacturer successfully displayed in dropdown"
      else
      Rails.logger.debug_log.debug { "#{"Manufacturer may be not available otherwise check backend"}"}
      end  
  rescue => e
    Rails.logger.custom_log.error { "#{e} division_controller edit method" }

 end 
add_breadcrumb "Edit", :edit_division_path  
  end

# to display the selected division
  def show
 Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in show method" 
   begin
     id=params[:id]
    division=RestClient.get $api_service+'/divisions/'+id 
    @division=JSON.parse division
    if @division.present?
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Division successfully displayed in dropdown"
      else
      Rails.logger.debug_log.debug { "#{"Manufacturer may be not available otherwise check backend"}"}
      end  

   rescue => e
    Rails.logger.custom_log.error { "#{e} division_controller edit method" }
     
   end
    
   
  end
# to get the manufacturer by selected supplier using products
  def dynamic_manufacturer
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in dynamic_manufacturer method" 
    begin
   
    manufacturers=RestClient.get $api_service+'/suppliers/supplier_manufacturer?supplier_id='+params["format"]
    @manufacturer_dropdown=JSON.parse manufacturers
    if @manufacturer_dropdown.present?
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Manufacturer successfully displayed in dropdown"
      else
      Rails.logger.debug_log.debug { "#{"Manufacturer may be not available otherwise check backend"}"}
      end  
    rescue => e
    Rails.logger.custom_log.error { "#{e} division_controller dynamic_manufacturer method" }
    end
  end  

end

