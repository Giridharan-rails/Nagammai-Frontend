class CfasController < ApplicationController

 add_breadcrumb "Cfa Titles", :cfas_path

## to display all the cfatitles in index page
  def index
  Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in cfa titles index page"
  begin
  cfas=RestClient::Request.execute(method: :get, url: $api_service+'/cfa_titles',timeout: 10)#RestClient.get $api_service+'/cfa_titles'
  @cfas=(JSON.parse cfas)

   user_id = session[:user_id]
  user = RestClient.get $api_service+"/users/#{user_id}"
  @user=JSON.parse user

   if @cfas.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Cfa titles successfully displayed"
  else
    Rails.logger.debug_log.debug { "#{"cfas titles may be not available otherwise check backend"}"}
  end
  
  rescue =>e
   Rails.logger.custom_log.error { "#{e} Cfa controller index method" }
  end
 

  end
# to create the new cfatitle


  def new
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in cfa titles new method"
      @cfa="new cfa"
        add_breadcrumb "New", :new_cfa_path
  end
# to delete the cfatitles
  def cfa_delete
   Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in cfa titles cfa_delete method"
    begin
    id=params["format"]    
    cfa=RestClient.delete $api_service+'/cfa_titles/'+id
    rescue =>e
    Rails.logger.custom_log.error { "#{e} Cfa controller delete method" }
    end
    redirect_to action: "index"
  end 


   # to update the selected cfa's
  def cfa_update
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in cfa titles cfa_update method"
 
    begin
     params.permit!
     data=params["cfas"]
     cfa={:cfa_title=>{"job_name": params[:job_name]}}
     cfa=RestClient.put $api_service+'/cfa_titles/'+data[:id],cfa 
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : cfa_updated successfully"
     rescue =>e
     Rails.logger.custom_log.error { "#{e}cfas_controller cfa_update method" }
     end
     redirect_to  :action => "index"
   # redirect_to  :action => "show" ,:id=>data[:id]
  end
# post th newly created cfatitles
  def create
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in cfa titles create method"
    begin
           params.permit!
     data=params["new cfa"]
     cfa={:cfa_title=>{"job_name": params[:job_name]}}
     @cfa=RestClient.post $api_service+'/cfa_titles',cfa
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : cfa titles created successfully"
    rescue => e
      Rails.logger.custom_log.error { "#{e} Cfa controller create method" }
    end
     redirect_to  :action => "index"
   end  
# to edit the selected cfa titles
  def edit
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in cfa titles edit method"
    
begin
    id=params[:id]
    cfa=RestClient.get $api_service+'/cfa_titles/'+id
     @cfa=JSON.parse cfa

if @cfa.present?
Rails.logger.debug_log.debug { "#{"cfas titles may be not available otherwise check backend"}"}

end
    rescue =>e
     Rails.logger.custom_log.error { "#{e} Cfa controller edit method " }
    end
    #@cfa=cfa_json["results"][0]
    add_breadcrumb "Edit", :edit_cfa_path
  end



# to display the selected cfa's
  def show
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in cfa titles show method"
    
     begin
      id=params[:id]
      cfa=RestClient.get $api_service+'/cfa_titles/'+id 
      @cfa=JSON.parse cfa

     if @cfa.present?
      Rails.logger.debug_log.debug { "#{"cfas titles may be not available otherwise check backend"}"}
     end
     rescue =>e
      
     Rails.logger.custom_log.error { "#{e} Cfa controller show method" }
     end 
  end


end
