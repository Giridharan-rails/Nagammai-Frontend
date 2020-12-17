require "zlib"
#require 'win32ole'
require 'rest-client'
require 'json'
class UsersController < ApplicationController
 # to display all the users
  def index
   Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in user index page"
   begin

    users=RestClient.get $api_service+'/users'
    @users=JSON.parse users
    if @users.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User details displayed successfully"
  else
      Rails.logger.debug_log.debug { "#{"Users may be not available otherwise check backend"}"}
  end
  rescue => e
    Rails.logger.custom_log.error { "#{e} user_controller show" }
  end
  
   add_breadcrumb "Users", :users_path  
  end
# to create new use page
  def new
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in user creation page"
   @user="new user"
    add_breadcrumb "Users", :users_path  
   add_breadcrumb "New", :new_user_path  
  end
# to post the newly created user details
  def create
       Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click create button"
   begin
     params.permit!
     user= {:user=>{"user_name":params[:username],"password":params[:password],"role":params[:user],"email":params[:email]}}
     user=RestClient.post $api_service+'/users',user
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User successfully created"
   rescue => e
     Rails.logger.custom_log.error { "#{e} user_controller create method" }
   end
     redirect_to  :action => "index"
  end

  # to display the selected user details
  def show
   Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in user show page"
  begin
   id=params[:id]
   user=RestClient.get $api_service+'/users/'+id
   @user=JSON.parse user
  if @user.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User details displayed successfully"
  else
      Rails.logger.debug_log.debug { "#{"Users may be not available otherwise check backend"}"}
  end
  rescue => e
    Rails.logger.custom_log.error { "#{e} user_controller show" }
  end
  end

# to login page

  def login
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in login method"
    user="login user"
    render :layout => false

  end
# to validate the login details and login the user
  def login_create
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the login button"
    
      params.permit!
      data={user:{"email":params[:email],"password":params[:password]}}
      user=RestClient.post $api_service +'/users/login',data      


    if user != "null"
      user_data=JSON.parse user
      session[:user_id]=user_data["id"]
       Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Login success"
     flash[:notice] = " user successfully login"
      redirect_to  pages_dashboard_path
    else
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Login failed"
      flash[:notice] = "UserName or password Invalid"
      redirect_to root_path
    end
  end
# to display the dashboard but not in use
  def dashboard
 #add_breadcrumb "Dasboard", :users_users_dashboard_path  
  end
# to display selecteed used details in edit form
  def edit
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User entered in edit page"
    begin
    id=params[:id]
    user=RestClient.get $api_service+'/users/'+id
    @user=JSON.parse user

    if @user.present?
     Rails.logger.debug_log.debug { "#{"Users may be not available otherwise check backend"}"}
    end

    rescue => e
    Rails.logger.custom_log.error { "#{e} user_controller edit" }
    end
     add_breadcrumb "Users", :users_path  
      add_breadcrumb "Edit", :edit_user_path  
  end
# post the updated details in put method
  def user_update
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click update button"
     begin
     params.permit!
     id=params["users"][:id]
     user= {:user=>{"user_name":params[:username],"password":params[:password], "role":params[:user],"email":params[:email]}}
     user=RestClient.put $api_service+'/users/'+id,user
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User updated Successfully"
     rescue => e
     Rails.logger.custom_log.error { "#{e} user_controller user_update method"}
     end
     redirect_to  :action => "index"
  end

# assign the user to supplier for handling the appointmnets
  def user_assign

      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in user assign method"
    begin
       @supplier="supplier assign"
      supplier=RestClient.get $api_service+'/suppliers'
      @suppliers=JSON.parse supplier
      user=RestClient.get $api_service+'/users/'+params[:format]
      @user=JSON.parse user
      if  @user["supplier_id"].present?
         @supplier_id=@user["supplier_id"].split(",")
      else
         @supplier_id=@user["supplier_id"].to_a
      end
    rescue => e
         Rails.logger.custom_log.error { "#{e} user_controller user_assign method" }
    end
      add_breadcrumb "Users", :users_path  
       add_breadcrumb "User Assign" 
  end
# to delete ths supplier

  def delete
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the delete button"    
    begin
    id=params[:format]    
    user=RestClient.delete $api_service+'/users/'+id
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User deleted successfully"    
    rescue => e
       Rails.logger.custom_log.error { "#{e}  user_controller delete method" }
    end
    
    redirect_to action: "index"


  end
# to display the user assigned wise details
 def user_supplier
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User entered in user_supplier"    
     begin
     params.permit!
     data={:user=>{"id":params[:user_id],"supplier_id":params[:supplier_ids].join(",")}}
     user_supplier=RestClient.post $api_service+'/users/supplier_update',data
     rescue => e
     Rails.logger.custom_log.error { "#{e} user_controller user_supplier method" }   
     end
     redirect_to  :action => "index"

  end
  # to logout
  def logout
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Logout successfully"    
    session[:user_id]=nil
    redirect_to :action => "login"
  end
# to change the password
  def change_password

end  
# to update the change password
  def change_password_update
  user=JSON.parse RestClient.get $api_service+"/users/change_password?id=#{session["user_id"]}&old_password=#{params["change password"]["old_password"]}&new_password=#{params["change password"]["password"]}"
  flash[:notice]=user["message"]
  redirect_to root_url

  end  
# to check the old password
  def old_password_check
    @user=JSON.parse RestClient.get $api_service+"/users/#{session["user_id"]}"
    if @user["password"]==params["password"]
       @data="1"
    else
       @data="0"    
    end  
end


end



