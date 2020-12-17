class SyncsettingsController < ApplicationController
 #
 
 def _form
  end
# to display all the sync configurations
  def index
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in SyncsettingsController  index method"
   begin
    sync_set=RestClient.get $api_service+'/sync_settings'
    @sync_data=JSON.parse sync_set

    if @sync_data.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Syncsettings details displayed successfully"
    else
      Rails.logger.debug_log.debug { "#{"Users may be not available otherwise check backend"}"}
    end

    rescue => e
       Rails.logger.custom_log.error { "#{e} SyncsettingsController index method" }
    end
    add_breadcrumb "Sync", :syncsettings_path   
  end
# to create the new configuration but we are not allowing them to create new configuration.becz configuration name is manually configured in sync exe 
  def new
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in SyncsettingsController  new method"
    @sync="new sync"
    add_breadcrumb "Sync", :syncsettings_path   
    add_breadcrumb "New", :new_syncsetting_path   
  end
  # not in use
  def create
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in SyncsettingsController  create method"
     begin
     params.permit!
    if params["week_data"].present?
      sync={sync_setting: {"job_name":params[:job_name],"schedule":params[:cars],"schedule_period":params[:week_data]}}
     elsif params["month_data"].present?
      sync={sync_setting: {"job_name":params[:job_name],"schedule":params[:cars],"schedule_period":params[:month_data]}}
     elsif params["manual"].present?
      sync={sync_setting: {"job_name":params[:job_name],"schedule":params[:cars]}}
    else
      sync={sync_setting: {"job_name":params[:job_name],"schedule":params[:cars]}}
     end 
     sop=RestClient.post $api_service+'/sync_settings',sync

     rescue => e
       Rails.logger.custom_log.error { "#{e} SyncsettingsController create method" }       
     end

     redirect_to  :action => "index"
   
  end

  def edit
  end

  def show
  end
# this to edit the selected sync configuration
  def sync_setting_update
      

    if params["schedule_time"].present?
   if params["schedule_time"][0].include?('?') 
    params["schedule_time"]=["No Data"]
  end
end
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in SyncsettingsController  sync_setting_update method"
    begin
      if params["cars"] == "Weekly"
      sync = { "sync_setting": { "job_name": params["job_name"],"schedule": params["cars"],"schedule_time": params["schedule_time"].join(","),"schedule_period": params["week_data"]},id: params["id"],"last_sync":params["last_sync"]}
      elsif params["cars"] == "Monthly"
      sync = { "sync_setting": { "job_name": params["job_name"],"schedule": params["cars"],"schedule_time": params["schedule_time"].join(","),"schedule_period": params["month_data"]},id: params["id"],"last_sync":params["last_sync"]}
      elsif params["cars"] == "Manual"

      sync = { "sync_setting": { "job_name": params["job_name"],"schedule": params["cars"],id: params["id"],"last_sync":params["last_sync"]}}
      
      else

      sync = { "sync_setting": { "job_name": params["job_name"],"schedule": params["cars"],"schedule_time": params["schedule_time"].join(",")},id: params["id"],"last_sync":params["last_sync"]}

      end 
      sop=RestClient.post $api_service+'/sync_settings/sync_setting_update',sync
    rescue => e
      Rails.logger.custom_log.error { "#{e} SyncsettingsController sync_setting_update method" }       
    end
      redirect_to  :action => "index"
  end  

# to show the selected sync configuration for edit
  def sync_setting_page
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in SyncsettingsController  sync_setting_page method"
    begin
      @sync_setting="syn_setting update"
      sync_set=RestClient.get $api_service+'/sync_settings/'+params[:id]
      @data_json = JSON.parse sync_set 
      if @data_json["schedule_time"].present?
        @schedule_time=@data_json["schedule_time"].split(",")
      else
        @schedule_time=@data_json["schedule_time"].to_a
      end
    rescue => e
      Rails.logger.custom_log.error { "#{e} SyncsettingsController sync_setting_page method" }       
    end
    add_breadcrumb "Sync", :syncsettings_path   
    add_breadcrumb "Sync Setting", :syncsettings_sync_setting_page_path
  end
# this is to wondersoft database connection details
  def wondersoft
      begin
        wonder=RestClient.get $api_service+'/sync_settings/wondersoft_connection_data'
        @wondersoft_data =JSON.parse(wonder)
      rescue =>e
        Rails.logger.custom_log.error { "#{e} SyncsettingsController wondersoft method" }       
      end
      add_breadcrumb "Dashboard", :users_dashboard_path
      add_breadcrumb "Wodersoft Connection", :syncsettings_wondersoft_path
  end
# this is to create the new wonder soft connection details
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
# this to edit the wonder soft database connection details
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






def nagammai
      begin
        nagammai=RestClient.get $api_service+'/sync_settings/nagammai_connection_data'
        @nagammai_data =JSON.parse(nagammai)
      rescue =>e
        Rails.logger.custom_log.error { "#{e} SyncsettingsController nagammai method" }       
      end
      add_breadcrumb "Dashboard", :users_dashboard_path
      add_breadcrumb "Nagammai Connection", :syncsettings_nagammai_path
  end

  def nagammai_create
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in SyncsettingsController  wondersoft_create method"
    begin
      params.permit!
      data={wonder_soft:{user_name:params[:username],password:params[:password],database_name:params[:databasename],server_name:params[:servername],manual_sync_time:params[:manual_sync_time]}}
      @wondersoft=RestClient.post $api_service+'/sync_settings/nagammai_connection',data
      flash[:success] = "Nagammai Connection successfully created"
    rescue => e
     Rails.logger.custom_log.error { "#{e} SyncsettingsController nagammai_create method" }       
    end
 end

 def nagammai_edit
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in SyncsettingsController  wondersoft_edit method"
    begin
 
      params.permit!
      data={wonder_soft:{user_name:params[:username],password:params[:password],database_name:params[:databasename],server_name:params[:servername],manual_sync_time:params[:manual_sync_time]}}
      @wondersoft=RestClient.put $api_service+'/sync_settings/nagammai_connection_update?idd='+params["wondersoft"][:id],data
      flash[:success] = "Nagammai Connection successfully created"
    rescue => e
     Rails.logger.custom_log.error { "#{e} SyncsettingsController nagammai_edit method" }       
    end
 end








end
