class MarketingsController < ApplicationController
   add_breadcrumb "Marketting Titles", :marketings_path

# to display all marketting title in index page
  def index
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Marketing Index"
   begin
     marketings=RestClient.get $api_service+'/marketing_titles'
     @marketings=(JSON.parse marketings)

    user_id = session[:user_id]
  user = RestClient.get $api_service+"/users/#{user_id}"
  @user=JSON.parse user

   if @marketings.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Marketing successfully displayed"
  else
    Rails.logger.debug_log.debug { "#{"Marketting titles may be not available otherwise check backend"}"}
  end
 
   rescue => e
    Rails.logger.custom_log.error { "#{e} marketing_controller index method" }
   end
  end
# create new marketting title for new form
  def new
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Marketing Creation"
     @marketing="new marketing"
     add_breadcrumb "New", :new_marketing_path
  end
# to delete the selected marketting title
  def marketing_delete
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in Marketing Delete"
    begin
    id=params["format"]    
    marketing=RestClient.delete $api_service+'/marketing_titles/'+id
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Marketing Deleted Successfully"
    rescue => e
    Rails.logger.custom_log.error { "#{e} marketing_controller marketing_delete method" }
    end
    redirect_to action: "index"
  end 
   # to put the selected marketting title changes
  def marketing_update
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the marketing update button"
    begin
    params.permit!
    data=params["marketings"]
    marketing={:marketing_title=>{"job_name":params[:job_name]}}
    marketing=RestClient.put $api_service+'/marketing_titles/'+data[:id],marketing
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Marketing Updated successfully"
    rescue => e
    Rails.logger.custom_log.error { "#{e} marketing_controller marketing_update method" }
    end

    redirect_to  :action => "index"
  end
# to post for creating new marketting title
  def create
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the marketing create button"
    begin
     params.permit!
     marketing= {:marketing_title=>{"job_name":params[:job_name]}}
     marketing=RestClient.post $api_service+'/marketing_titles',marketing
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Marketing created successfully"
     rescue => e
    Rails.logger.custom_log.error { "#{e} marketing_controller create method" }
   end
       redirect_to  :action => "index"
   end  
# to edit selected marketting tile for view edit form 
  def edit
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in marketing edit page"
    begin
    id=params[:id]
    marketing=RestClient.get $api_service+'/marketing_titles/'+id
    @marketing=JSON.parse marketing
    rescue => e
    Rails.logger.custom_log.error { "#{e} marketing_controller edit method" }
    end
    add_breadcrumb "Edit", :edit_marketing_path
  end
# to display selected marketting title
  def show
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in marketing show page"
    begin
    id=params[:id]
    marketing=RestClient.get $api_service+'/marketing_titles/'+id 
    @marketing=JSON.parse marketing
    if @marketing.present?
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Marketing successfully displayed"
    else
      Rails.logger.debug_log.debug { "#{"marketing may be not available otherwise check backend"}"}
    end  
   rescue => e
   Rails.logger.custom_log.error { "#{e} marketing_controller show method" }
  end
    
  end


end
