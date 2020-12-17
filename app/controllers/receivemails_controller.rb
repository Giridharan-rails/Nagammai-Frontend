class ReceivemailsController < ApplicationController
  add_breadcrumb "Dashboard", :users_dashboard_path 
  
# not in use
  def index
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Receivemails Index"
   begin
    receive_mail=RestClient.get $api_service+'/receive_mails'
    @receive_mails=JSON.parse receive_mail

    if @receive_mails.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Receive Mails details displayed successfully"
   else
      Rails.logger.debug_log.debug { "#{"receivemail may be not available otherwise check backend"}"}
   end

    rescue => e
      Rails.logger.custom_log.error { "#{e} receivemails_controller index method" }
     end
  end

  def _form
  end
# new received mail creation page
  def new
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Receivemails Creation"
    @receive_mail="new mail"
  end
# create or update the received mails becz it has only one record
  def create
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the Receivemails create button"
    begin
     params.permit!
    if params["week_data"].present?
      receive_mail={receive_mail: {"job_name":params[:email_address],"schedule":params[:cars],"schedule_period":params[:week_data]}}
     elsif params["month_data"].present?
      receive_mail={receive_mail: {"job_name":params[:email_address],"schedule":params[:cars],"schedule_period":params[:month_data]}}
     else
      receive_mail={receive_mail: {"job_name":params[:email_address],"schedule":params[:cars]}}
     end 
     sop=RestClient.post $api_service+'/receive_mails',receive_mail
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Receivemails created successfully"
     rescue => e
    Rails.logger.custom_log.error { "#{e} receivemails_controller create method" }
   end
     redirect_to  :action => "index"
   
  end

  def edit
  end
# to update the received mail.but not in use
  def receivemail_update
    
    
  Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the Receivemails update button"
  begin   
  if params["cars"] == "Weekly"
     sync = { "sync_setting": { "job_name": params["job_name"],"schedule": params["cars"],"schedule_time": params["schedule_time"].join(","),"schedule_period": params["week_data"]},id: params["id"],email1:params["email1"],password1:params["password1"],email2:params["email2"],password2:params["password2"]}
   elsif params["cars"] == "Monthly"
    sync = { "sync_setting": { "job_name": params["job_name"],"schedule": params["cars"],"schedule_time": params["schedule_time"].join(","),"schedule_period": params["month_data"]},id: params["id"],email1:params["email1"],password1:params["password1"],email2:params["email2"],password2:params["password2"]}
    elsif params["cars"] == "Manual"
    
    sync = { "sync_setting": { "job_name": params["job_name"],"schedule": params["cars"],id: params["id"],email1:params["email1"],password1:params["password1"],email2:params["email2"],password2:params["password2"]}}
   
   else 
   
    sync = { "sync_setting": { "job_name": params["job_name"],"schedule": params["cars"],"schedule_time": params["schedule_time"].join(",")},id: params["id"],email1:params["email1"],password1:params["password1"],email2:params["email2"],password2:params["password2"]}
   end 
   
    sop=RestClient.post $api_service+'/receive_mails/receivemails_update',sync
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Receivemails Updated successfully"
    rescue => e
    Rails.logger.custom_log.error { "#{e} receivemails_controller receivemails_update method" }
    end
    redirect_to  :action => "receive_setting_page"

  end
#not in use
  
  def receive_setting_page
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in Receivemails receive_setting_page page"
    begin
    @receive_setting="receive_setting update"
    sync_set=RestClient.get $api_service+'/receive_mails'
    @data_json = JSON.parse sync_set 

      if @data_json["schedule_time"].present?
      @schedule_time=@data_json["schedule_time"].split(",")
    else
      @schedule_time=[]
    end
    rescue => e
    Rails.logger.custom_log.error { "#{e} receivemails_controller receive_setting_page method" }
    end
    add_breadcrumb "Receive Mail Settings", :receivemails_receive_setting_page_path 
  end
# not in use
  def show
  end


end


