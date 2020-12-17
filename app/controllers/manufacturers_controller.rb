class ManufacturersController < ApplicationController
 add_breadcrumb "Manufacturers", :manufacturers_path  
  


# this is to display all the manufacturers
  def index
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Manufacturer Index"
   begin

    if params["supplier_id"].present?
    
    @manufacturers=(JSON.parse RestClient.get $api_service+'/manufacturers/supplier_manufacturer?supplier_id='+params["supplier_id"]).paginate(page: params[:page], per_page: 15)
   else
    @manufacturers = (JSON.parse RestClient.get $api_service+'/manufacturers')
      end
    if @manufacturers.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : manufacturers details displayed successfully"
   else
      Rails.logger.debug_log.debug { "#{"manufacturers may be not available otherwise check backend"}"}
   end
    



     rescue => e
      Rails.logger.custom_log.error { "#{e} manufacturer_controller index method" }
     end

  end
# not in use
  def _from
    
  end   
# this is to create new manufacturer but not in use
  def new
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Manufacturer Creation"
    @manufacturer = "new manufacturer"
    @suppliers = (JSON.parse RestClient.get $api_service+'/suppliers')
     add_breadcrumb "New", :new_manufacturer_path  
  end
# this is to delete selected manufacturer
  def manufacturer_delete
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in Manufacturer Delete"
    begin
    id = params["format"]    
    manufacturer = RestClient.delete $api_service+'/manufacturers/'+id
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Manufacturer Deleted Successfully"
      rescue => e
      Rails.logger.custom_log.error { "#{e} manufacturer_controller manufacturer_delete method" }
    end

    redirect_to action: "index"
  end 
   # this is to put the changes of selected manufacturer
  def manufacturer_update
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the manufacturer update button"
    begin

    id=params["manufacturers"]["id"]
    params.permit!
    manufacturer = {manufacturer:{manufacturer_name: params["name"], manufacturer_code: params["mfr_code"], manufacturer_abb:params["mfr_abb"], address_one: params["address_one"], addrsss_two: params["address_two"], addrsss_three: params["address_three"], city: params["city"], state: params["state"], country: params["country"]}}
    manufacturer = RestClient.put $api_service+'/manufacturers/'+id,manufacturer
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Manufacturer Updated successfully"
    rescue => e
    Rails.logger.custom_log.error { "#{e} manufacturer_controller manufacturer_update method" }
    end
    redirect_to  :action => "index"
  end
# this to create new manufacturer but not in use
  def create
        Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the manufacturer create button"
    begin
    params.permit!
    
    manufacturer = {manufacturer:{manufacturer_name: params["name"], manufacturer_code: params["mfr_code"], manufacturer_abb:params["mfr_abb"], address_one: params["address_one"], addrsss_two: params["address_two"], addrsss_three: params["address_three"], city: params["city"], state: params["state"], country: params["country"], supplier_id: params["new division"][:supplier_id]}}
    manufacturer = RestClient.post $api_service+'/manufacturers',manufacturer
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Manufacturer created successfully"
     rescue => e
    Rails.logger.custom_log.error { "#{e} manufacturer_controller create method" }
   end
    redirect_to  :action => "index"

  end  
# this is to update selected manufacturer in view page
  def edit
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in manufacturer edit page"
    begin
    id = params[:id]
    @manufacturer = JSON.parse RestClient.get $api_service+'/manufacturers/'+id
    @suppliers = JSON.parse RestClient.get $api_service+'/suppliers'
    rescue => e
    Rails.logger.custom_log.error { "#{e} manufacturer_controller edit method" }
    end
   add_breadcrumb "Edit", :edit_manufacturer_path  
  end
# to dispplay the selected manufacturer
  def show
  Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in manufacturer show page"
  begin
    id = params[:id]
    @manufacturer = JSON.parse RestClient.get $api_service+'/manufacturers/'+id 

    if @manufacturer.present?
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Manufacturer successfully displayed"
    else
      Rails.logger.debug_log.debug { "#{"manufacturer may be not available otherwise check backend"}"}
    end  
   rescue => e
 Rails.logger.custom_log.error { "#{e} manufacturer_controller show method" }
  end

   
  end


#this is to display the manufacturer list under selected  supplier
  def manufacturer_list

  Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in manufacturer list"
  begin
    manufacturers=RestClient.get $api_service+'/suppliers/supplier_manufacturer?supplier_id='+params["id"]
    @manufacturers=JSON.parse manufacturers
 unless @manufacturers.nil?
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Manufacturer list successfully displayed"
    else
      Rails.logger.debug_log.debug { "#{"manufacturer may be not available otherwise check backend"}"}
    end  
  rescue => e
       Rails.logger.custom_log.error { "#{e} manufacturer_controller manufacturer_list method" }
  end

end

end
