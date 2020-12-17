class ApplicationController < ActionController::Base
require 'will_paginate/array'

  before_action :check_session,:current_user, :except => ["login","login_create","new"]

  #protect_from_forgery with: :exception

 #$api_service = 'http://192.168.0.203:4003'
#http://182.72.104.66:4202/
#$api_service = 'http://182.72.104.66:4202/'   #backend ip
#$api_service = 'http://183.82.250.137:4202/'   #backend ip
$api_service = 'http://192.168.0.156:81/'   #backend ip

#$api_service = 'http://192.168.1.106:5200'
#$api_service = 'http://192.168.1.106:4202'
  def check_session               #this method is for check the session
    if session[:user_id].blank?
      redirect_to root_path
    end
  end
# this method is used to maintain the current user
  def current_user
    if session[:user_id]
      unless  session[:user_id].nil?
        @current_user ||= session[:user_id]
      else
        @current_user = nil
      end
    end
  end
#to display the claim issues which has cut off date today
  def issue_alert
    JSON.parse RestClient.get $api_service+'/appointments/issue_for_alert'
  end
  helper_method :issue_alert
#to display the today's appointments
  def appointment_alert
    JSON.parse RestClient.get $api_service+'/appointments/appointment_for_alert'
  end
  helper_method :appointment_alert
# not used any where
  def contacts_for_appoinment(params)

    #JSON.parse RestClient.get $api_service+'/appointments/contacts_for_alert?contact_ids='+params
  end 
  helper_method :contacts_for_appoinment
# this is to display the pending notification
   def issue_alerts
    JSON.parse RestClient.get $api_service+'/send_mails/email_notification'
  end
  helper_method :issue_alerts

private
  
  def record_not_found
    render errors_path, status: 500
  end

  def record_invalid
    render errors_path, status: 422
  end


end
