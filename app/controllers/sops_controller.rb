class SopsController < ApplicationController
 # to display all the sop in index page
  def index
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : sops Index"
   begin
    if params["division_id"].present?
      sops=RestClient.get $api_service+'/sops?division_id='+params["division_id"]
      else
      sops=RestClient.get $api_service+'/sops'
    end
    @sops=(JSON.parse sops)
  if @sops.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Sop details displayed successfully"
  else
      Rails.logger.debug_log.debug { "#{"sop may be not available otherwise check backend"}"}
  end

  rescue => e
    Rails.logger.custom_log.error { "#{e} sops_controller index method" }
  end
      add_breadcrumb "SOPs", :sops_path  
  end
# to create form details for sop
  def new
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : sops Creation"
    @sop="new sop"
    
    
    @supplier=JSON.parse RestClient.get $api_service+'/suppliers'

    if @supplier.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : supplier details displayed successfully"
    else
    Rails.logger.debug_log.debug { "#{"supplier may be not available otherwise check backend"}"}
    end

    @manufacturer=[]
    @division=[]
    user_id = session[:user_id]
    user = RestClient.get $api_service+"/users/#{user_id}"
    @user=JSON.parse user

    if @user.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : user details displayed successfully"
    else
    Rails.logger.debug_log.debug { "#{"user may be not available otherwise check backend"}"}
    end

    add_breadcrumb "SOPs", :sops_path  
    add_breadcrumb "New SOP", :new_sop_path  
    
  end

  def destroy
    response = RestClient.delete $api_service+"/sops/"+params['id']
    redirect_to :action => "index"
  end
# to delete the selected sop
  def sop_delete
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in sops Delete"
    begin
    id=params["format"]    
    user=RestClient.delete $api_service+'/sops'+id
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : sops Deleted Successfully"
      rescue => e
      Rails.logger.custom_log.error { "#{e} sops_controller sop_delete method" }
    end
    redirect_to action: "index"
  end 
   # to update the selected sop changes
  def sop_update

    params.permit!


    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the sops update button"
   # begin
    params.permit!
    id=params["sops"]["id"]
if params["new division"].present?
params["division_id"]=params["new division"]["division_id"]
end

    appoint1= params["appoint_time1"].values.last(2)
    appoint_time1 = appoint1.first+":"+appoint1.last
    appoint2= params["appoint_time2"].values.last(2)
    appoint_time2 = appoint2.first+":"+appoint2.last
    appoint3= params["appoint_time3"].values.last(2)
    appoint_time3 = appoint3.first+":"+appoint3.last



    unless params["delivery_order_schedule"].nil?
     params["delivery_order_schedule"]=params["delivery_order_schedule"].join(",")
    end
     params["monthly_appointment1"]=params["monthly_appointment1"]+"-"+Date.today.strftime("%m-%Y")
     params["monthly_appointment2"]=params["monthly_appointment2"]+"-"+Date.today.strftime("%m-%Y")
     params["monthly_appointment3"]=params["monthly_appointment3"]+"-"+Date.today.strftime("%m-%Y")
    
    
    sop={sop: {"order_type":params[:order_type],"payment_term":params[:payment_term],"special_offer":params[:special_offer],"claims_offer":params[:claims_offer],"expiry_broken_settlement":params[:expiry],"delivery_order_schedule":params["delivery_order_schedule"],"monthly_appoinment1":params[:monthly_appointment1],"monthly_appoinment2":params[:monthly_appointment2],"monthly_appoinment3":params[:monthly_appointment3],"dispatch_mode":params[:dispatch_mode],"current_ns":params[:current_ns],"current_ms":params[:current_ms],"division_id":params["division_id"],supplier_id:params["supplier_id"],appoint_time1:appoint_time1,appoint_time2:appoint_time2,appoint_time3:appoint_time3}}
    sop=RestClient.put $api_service+'/sops/'+id,sop
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : sops Updated successfully"
    #rescue => e
   # Rails.logger.custom_log.error { "#{e.class} #{sops_controller sop_update method}" }
    #end


    if  params["sops"]["appoint_id"].present?
    redirect_to  :action => "show" ,:id=>id,:division_id=>params["division_id"],:appoint_id=>params["sops"]["appoint_id"]
    else
      redirect_to  :action => "show" ,:id=>id,:division_id=>params["division_id"]
    end
  end
# post the date for creating new sop
  def create


    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the sops create button"
    begin
     params.permit!

     data=params["new sop"]
     #image = File.open(params["image_path"].tempfile) {|img| img.read}
     params["monthly_appointment1"]=params["monthly_appointment1"]+"-"+Date.today.strftime("%m-%Y")
     params["monthly_appointment2"]=params["monthly_appointment2"]+"-"+Date.today.strftime("%m-%Y")
     params["monthly_appointment3"]=params["monthly_appointment3"]+"-"+Date.today.strftime("%m-%Y")
     #encoded_image = Base64.encode64 image

unless params["schedule"].nil?
  params["schedule"]=params["schedule"].join(",")
end

appoint_time1=params["new sop"]["appoint_time1(4i)"]+":"+params["new sop"]["appoint_time1(5i)"]
appoint_time2=params["new sop"]["appoint_time2(4i)"]+":"+params["new sop"]["appoint_time2(5i)"]
appoint_time3=params["new sop"]["appoint_time3(4i)"]+":"+params["new sop"]["appoint_time3(5i)"]


      sop={sop: {"order_type":params[:order_type],"payment_term":params[:payment_term],"special_offer":params[:special_offer],"claims_offer":params[:claims_offer],"expiry_broken_settlement":params[:expiry],"delivery_order_schedule":params[:schedule],"monthly_appoinment1":params[:monthly_appointment1],"monthly_appoinment2":params[:monthly_appointment2],"monthly_appoinment3":params[:monthly_appointment3],"dispatch_mode":params[:dispatch_mode],"current_ns":params[:current_ns],"current_ms":params[:current_ms],"division_id":params["new division"]["division_id"],supplier_id:params["supplier_id"],appoint_time1:appoint_time1,appoint_time2:appoint_time2,appoint_time3:appoint_time3}}


      sop=RestClient.post $api_service+'/sops',sop
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : sops created successfully"
     rescue => e
    Rails.logger.custom_log.error { "#{e} sops_controller create method" }
   end

   if   params["appoint_id"].present?
     redirect_to  appointment_path(params["appoint_id"])
   else
     redirect_to  :action => "index"
    end
 end  
# to edit selected sop form
  def edit

 
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in sops edit page"
   # begin
    id=params[:id]
    sop=RestClient.get $api_service+'/sops/'+id
    @sop=JSON.parse sop

         @supplier=JSON.parse RestClient.get $api_service+'/suppliers'
         division=JSON.parse RestClient.get $api_service+"/divisions/#{@sop["division_id"]}"
         manufacturer_id=division["manufacturer_id"]
         @manufacturer = JSON.parse RestClient.get $api_service+"/manufacturers/manufacturer_base_manufacturers?manufacturer_id=#{manufacturer_id}"
         @manufacturer=[] if @manufacturer[0]["response"].present?
         @division=JSON.parse RestClient.get $api_service+"/manufacturers/manufacturer_division?manufacturer_id=#{manufacturer_id}"
         @division=[] if @division[0]["response"].present?
    if @supplier.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : supplier details displayed successfully"
    else
    Rails.logger.debug_log.debug { "#{"supplier may be not available otherwise check backend"}"}
    end

    supplier=RestClient.get $api_service+'/divisions/division_manufacturer_supplier?supplier_id='+@sop["supplier_id"].to_s

if supplier.present?
    @supplier_name=JSON.parse supplier
end
    if @supplier_name.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : supplier details displayed successfully"
    else
    Rails.logger.debug_log.debug { "#{"supplier may be not available otherwise check backend"}"}
    end


    
    user_id = session[:user_id]
    
    user = RestClient.get $api_service+"/users/#{user_id}"
    @user=JSON.parse user

    if @user.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : user details displayed successfully"
    else
    Rails.logger.debug_log.debug { "#{"user may be not available otherwise check backend"}"}
    end

   add_breadcrumb "SOPs", :sops_path  
   add_breadcrumb "Edit SOP", :edit_sop_path  
    #rescue => e
    #Rails.logger.custom_log.error { "#{e.class} #{sops_controller edit method}" }
    #end
  end
# to show the selected sop details
  def show

    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in sops show page"
 begin

    id=params[:id]
    sop=RestClient.get $api_service+'/sops/'+id 
    @sop=JSON.parse sop 

    user_id = session[:user_id]
    
    user = RestClient.get $api_service+"/users/#{user_id}"
    @user=JSON.parse user

     if @user.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : user details displayed successfully"
    else
    Rails.logger.debug_log.debug { "#{"user may be not available otherwise check backend"}"}
    end


    supplier=RestClient.get $api_service+'/divisions/division_manufacturer_supplier?supplier_id='+@sop["supplier_id"].to_s
    
    
    @supplier_name=JSON.parse supplier

    if @supplier_name.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : supplier details displayed successfully"
    else
    Rails.logger.debug_log.debug { "#{"supplier may be not available otherwise check backend"}"}
    end

   rescue => e
    Rails.logger.custom_log.error { "#{e} sops_controller show method" }
   end  
    add_breadcrumb "SOPs", :sops_path  
   add_breadcrumb "View SOP", :sop_path  

  end
# to display the products by division or all producrs
def products_view
  Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in sops products_view page"
  begin
  if params[:division_id] == nil
    products=RestClient.get ($api_service+'/products' )
    @product=(JSON.parse products).paginate(page: params[:page], per_page: 10)
  else
   products=RestClient.get ($api_service+'/products/division_product_view?division_id='+params[:division_id])
    @product=(JSON.parse products).paginate(page: params[:page], per_page: 10)
   end 

   
  
    rescue => e
    Rails.logger.custom_log.error { "#{e} sops_controller products_view method" }
   end 
   add_breadcrumb "SOPs", :sops_path  
   add_breadcrumb "Products", :sops_products_view_path  

  end 
# to select the manufacturer by using supplier
  def div_supplier_manufacture
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in sops div_supplier_manufacture page"
    begin
    if params["supplier_id"].present?
    @supplier_id=params[:supplier_id]
    supplier=RestClient.get $api_service+'/suppliers/supplier_manufacturer?supplier_id='+@supplier_id
    @supplier=JSON.parse supplier

    if @supplier.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : supplier details displayed successfully"
    else
    Rails.logger.debug_log.debug { "#{"supplier may be not available otherwise check backend"}"}
    end


    else

       @manufacturer_id=params[:manufacturer_id]
       manufacturer=RestClient.get $api_service+'/manufacturers/manufacturer_division?manufacturer_id='+@manufacturer_id
       @manufacturer=JSON.parse manufacturer
      if @manufacturer.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : manufacturer details displayed successfully"
    else
    Rails.logger.debug_log.debug { "#{"manufacturer may be not available otherwise check backend"}"}
    end

      end    
        rescue => e
        Rails.logger.custom_log.error { "#{e} sops_controller div_supplier_manufacture method" }
        end
          
    
     end 
# to display the closed claim issues
 def issue_closed_reopened

  Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in sops issue_closed_reopened page"
    begin
    issues=RestClient.get $api_service+'/appointments/claim_issues'
    @issues=JSON.parse issues
    rescue => e
    Rails.logger.custom_log.error { "#{e} sops_controller issue_closed_reopened method" }
    end
    add_breadcrumb "Dashboard", :users_dashboard_path  
    add_breadcrumb "Issue Audit Reports", :sops_issue_closed_reopened_path  
  end
# to display the free and discount claims report by sop
  def offers_claims_report
  Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in offers_claims_report page"
    begin 
   sops=RestClient.get $api_service+'/sops'
   @sops=JSON.parse sops
   @divisions = JSON.parse RestClient.get $api_service+'/divisions'
      respond_to do |format|
       format.html #{ render :layout => false }
       format.pdf do
       render :pdf => "sop_offers_report.pdf", :template => "sops/offers_claims_report.html.erb"
       end
     end
   rescue => e
    Rails.logger.custom_log.error { "#{e} sops_controller offers_claims_report method" }
    end
     add_breadcrumb "SOPs", :sops_path  
   add_breadcrumb "SOP Reports", :sops_offers_claims_report_path  

  end
# to download te free and discount claims by sop

def offers_claims_report_pdf
   Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in offers_claims_report page"
   begin 
   sops=RestClient.get $api_service+'/sops'
   @sops=JSON.parse sops
   @divisions = JSON.parse RestClient.get $api_service+'/divisions'


  
   rescue => e
   Rails.logger.custom_log.error { "#{e} sops_controller offers_claims_report method" }
   end
    
  end



# update the status and approval for selected ckaim issues

  def issue_update

    
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in issue_update page"
    #begin 
    ids=params["ids"]
  
    status=params["status"]
  
    approval=params["approval"]
    
    issue={"ids"=>ids,"status"=>status,"approval"=>approval }
    data=RestClient.post $api_service+'/sops/issues_update',issue
    #rescue => e
   # Rails.logger.custom_log.error { "#{e.class} #{sops_controller issue_update method}" }
    #end
    #JSON.parse data
    redirect_to :action=>"issue_closed_reopened"
    
  end 
  # select the sop by its divisions
  def dynamic_sop
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in dynamic_sop page"
    begin 
      if params["format"].present?
          sop=RestClient.get $api_service+'/sops/dynamic_sop?division_id='+params["format"]
          @sops=JSON.parse sop
      elsif params["division_id"].present?
   
         data=RestClient.get $api_service+'/sops/dynamic_sop?division_id='+params["division_id"]
          @data=JSON.parse data
          if @data.present?
            
            redirect_to sop_path(@data[0]["id"],"division_id":@data[0]["division_id"],"appoint_id":params["appoint_id"])
          else
            redirect_to new_sop_path(appoint_id:params["appoint_id"])
          end
      end
   rescue => e
    Rails.logger.custom_log.error { "#{e} sops_controller dynamic_sop method" }
    end
  end  





end
