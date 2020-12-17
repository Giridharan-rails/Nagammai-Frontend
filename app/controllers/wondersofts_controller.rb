class WondersoftsController < ApplicationController
	

# to display the wonder soft details
   def wondersoft
      begin
        wonder=RestClient.get $api_service+'/sync_settings/wondersoft_connection_data'
        @wondersoft_data =JSON.parse(wonder)
      rescue =>e
        Rails.logger.custom_log.error { "#{e} SyncsettingsController wondersoft method" }       
      end
      add_breadcrumb "Dashboard", :pages_dashboard_path
      add_breadcrumb "Wodersoft Connection", :wondersofts_wondersoft_path
  end
# to create the new connection we can create only one connection
  def wondersoft_create
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in SyncsettingsController  wondersoft_create method"
    begin
      params.permit!
      data={wonder_soft:{user_name:params[:username],password:params[:password],database_name:params[:databasename],server_name:params[:servername],manual_sync_time:params[:manual_sync_time]}}
      @wondersoft=RestClient.post $api_service+'/sync_settings/wondersoft_connection',data
      flash[:notice] = "WonderSoft Connection successfully created"
    rescue => e
     Rails.logger.custom_log.error { "#{e} SyncsettingsController wondersoft_create method" }       
    end
 end
#to edit the created wondersoft connection
 def wondersoft_edit
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in SyncsettingsController  wondersoft_edit method"
    begin
 
      params.permit!
      data={wonder_soft:{user_name:params[:username],password:params[:password],database_name:params[:databasename],server_name:params[:servername],manual_sync_time:params[:manual_sync_time]}}
      @wondersoft=RestClient.put $api_service+'/sync_settings/wondersoft_connection_update?idd='+params["wondersoft"][:id],data
      flash[:notice] = "WonderSoft Connection successfully created"
    rescue => e
     Rails.logger.custom_log.error { "#{e} SyncsettingsController wondersoft_edit method" }       
    end
 end




end
