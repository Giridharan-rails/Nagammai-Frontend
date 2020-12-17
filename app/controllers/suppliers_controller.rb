class SuppliersController < ApplicationController
  add_breadcrumb "Suppliers", :suppliers_path  

# to display all the suppliers
  def index  

    if params["enable"].present?
   supplier = {:supplier => {"id": params["enable"],"active_status": 1}}
   supplier = RestClient.put $api_service+'/suppliers/'+params["enable"],supplier
   elsif params["disable"].present?
    supplier = {:supplier => {"id": params["disable"],"active_status": nil}}
   supplier = RestClient.put $api_service+'/suppliers/'+params["disable"],supplier
   end

  
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : supplier index display"
 
   begin
   @suppliers = (JSON.parse RestClient.get $api_service+'/suppliers')
   if @suppliers.present?
   Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : supplier display successfully"
   else
   Rails.logger.debug_log.debug { "#{"Suppliers may be not available otherwise check backend"}"}
   end
   rescue => e
   Rails.logger.custom_log.error { "#{e} supplier_controller supplier index method" }
   end

  #@suppliers=suppliers_json["results"]
  end
# to create new supplier form
  def new
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : supplier Creation"
  	@supplier = "new supplier"
     add_breadcrumb "New", :new_supplier_path  
  end
# to delete selected supplier if it is deleted from wonder soft
  def supplier_delete
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in supplier Delete"
    begin
  	id = params["format"]    
    user = RestClient.delete $api_service+'/suppliers/'+id
    rescue => e
      Rails.logger.custom_log.error { "#{e} supplier_controller supplier_delete method" }
    end
    redirect_to action: "index"
  end	
   # to update the supplier details except supplier name and supplier code
  def supplier_update
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the supplier update button"
    begin
  	params.permit!
    
    #supplier = {"id": data[:id], "name": data[:name], "email": data[:email], "phone_number": data[:phone_number], "address": data[:address]}
    supplier = {:supplier => {"id": params["suppliers"][:id], "supplier_name": params[:supplier_name],"expiry_broken": params[:suppliers]["expiry_broken"], "supplier_abb": params[:supplier_abb], "address_one": params[:address_one],"addrsss_two": params[:addrsss_two], "addrsss_three": params[:addrsss_three], "gst_no": params[:gst_no], "order_copy_format": params["order_copy_format"], "phone_number": params[:phone_number], "city": params[:city], "state": params[:state], "country": params[:country], supplier_code: params["code"], batch:params["batch"]}}
    
    supplier = RestClient.put $api_service+'/suppliers/'+params["suppliers"][:id],supplier
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : supplier Updated successfully"
    rescue => e
    Rails.logger.custom_log.error { "#{e} supplier_controller supplier_update method" }
    end
    redirect_to :action => "index"#, :id => data[:id]
  end
# to post the new supplier details to create but we are not using this.only sync process is in use
  def create
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the supplier create button"
    begin
     params.permit!
    
     supplier = {:supplier => {"supplier_name": params[:supplier_name], "supplier_abb": params[:supplier_abb], "address_one": params[:address_one],"addrsss_two": params[:addrsss_two], "addrsss_three": params[:addrsss_three], "gst_no": params[:gst_no], "order_copy_format": params["order_copy_format"], "phone_number": params[:phone_number], "city": params[:city], "state": params[:state], supplier_code: params["code"]}}
     supplier = RestClient.post $api_service+'/suppliers',supplier
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : supplier created successfully"
     rescue => e
    Rails.logger.custom_log.error { "#{e} supplier_controller create method" }
    end
     redirect_to :action => "index"
   end	
# to edit the selected supplier in the edit form
  def edit
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in supplier edit page"
    begin
  	id = params[:id]
    @supplier = JSON.parse RestClient.get $api_service+'/suppliers/'+id
    rescue => e
    Rails.logger.custom_log.error { "#{e} supplier_controller edit method" }
    end
    #supplier_json=JSON.parse supplier
    #@supplier=supplier_json["results"][0]
     add_breadcrumb "Edit", :edit_supplier_path  
  end
# to show the selected supplier details
  def show
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in supplier show page"
  begin
  	id = params[:id]
    @supplier = JSON.parse RestClient.get $api_service+'/suppliers/'+id 
    rescue => e
 Rails.logger.custom_log.error { "#{e} supplier_controller show method" }
  end
    #supplier_json=JSON.parse supplier
	  #@supplier=supplier_json["results"]
  end

end