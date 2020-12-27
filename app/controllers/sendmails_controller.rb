class SendmailsController < ApplicationController
  before_action :supplier, only: [:pending_claims_report, :free_discount_claims, :overall_claims_report, :sendmails_excess_stock,:sendmails_claims_broken_damage,:purchase_order_report, :sendmail_purchase_order_page, :expiry_damage_claims,:purchase_return_claims,:rate_change_claims,:today_adjustment_report,:excess_stock_report,:sendmails_claims_discount,:sendmails_claims_purchase_return,:sendmails_claims_rate_change, :non_findable_claims]
  
  add_breadcrumb "SendMails", :sendmails_path 

  # def initialize
  #   @supplier=JSON.parse RestClient.get $api_service+'/suppliers'
  # end
  
  def _form
  end
# this method is to display all the sendmail configuration items
  def index
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : sendmail Index"
   begin
    sendmail_set=RestClient.get $api_service+'/send_mails'
    @sendmail_data=JSON.parse sendmail_set
   if @sendmail.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : SendMails details displayed successfully"
   else
      Rails.logger.debug_log.debug { "#{"sendmail may be not available otherwise check backend"}"}
   end

    rescue => e
      Rails.logger.custom_log.error { "#{e} sendmail_controller index method" }
     end

  end
# create new send mail configuration page
  def new
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : sendmail Creation"
    @sendmail="newsendmail"
    add_breadcrumb "New", :new_sendmail_path 
  end
# post the data for new sendmail configuration creation
  def create
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the sendmail create button"
    begin
     params.permit!
    if params["week_data"].present?
      sendmail={:send_mail=> {"job_name":params[:job_name],"schedule":params[:cars],"schedule_period":params[:week_data]}}
     elsif params["month_data"].present?
     sendmail={:send_mail=> {"job_name":params[:job_name],"schedule":params[:cars],"schedule_period":params[:month_data]}}
     elsif params["manual"].present?
      sendmail={:send_mail=> {"job_name":params[:job_name],"schedule":params[:cars]}}
    else
     sendmail={:send_mail=> {"job_name":params[:job_name],"schedule":params[:cars]}}
     end 
     sop=RestClient.post $api_service+'/send_mails',sendmail
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : sendmail created successfully"
     rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller create method" }
   end
     redirect_to  :action => "index"
   
  end
# not in use
  def edit
    
  end
#not in use
  def show
  end
# to configure the email schedule time for mail sending
  def sendmail_setting_page
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the sendmail_setting_page"
    begin
    @data="edit sendmail" 
    sendmail_set=RestClient.get $api_service+'/send_mails/'+params[:id]
    @data_json = JSON.parse sendmail_set  
    if @data_json["schedule_time"].present?
    @schedule_time=@data_json["schedule_time"].split(",")
    else
      @schedule_time=@data_json["schedule_time"].to_a
    end
    rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller sendmail_setting_page method" }
    end
   add_breadcrumb "SendMails Setting", :sendmails_sendmail_setting_page_path 
  end
# to update the configuration
  def sendmail_update
    
    if params["schedule_time"].present?
   if params["schedule_time"][0].include?('?') 
    params["schedule_time"]=["No Data"]
  end
end


unless params["send-items"].nil?
  send_items=params["send-items"].join(",")
  
end
  Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the sendmail_update"
    begin
  if params["cars"] == "Weekly"
     sync = { "sync_setting": { "job_name": params["job_name"],"schedule": params["cars"],"schedule_time": params["schedule_time"].join(","),"schedule_period": params["week_data"]},id: params["id"],send_items:send_items}
   elsif params["cars"] == "Monthly"
    sync = { "sync_setting": { "job_name": params["job_name"],"schedule": params["cars"],"schedule_time": params["schedule_time"].join(","),"schedule_period": params["month_data"]},id: params["id"],send_items:send_items}
   
   elsif params["cars"] == "Manual"
    

    sync = { "sync_setting": { "job_name": params["job_name"],"schedule": params["cars"],id: params["id"],send_items:send_items}}
    else     

    sync = { "sync_setting": { "job_name": params["job_name"],"schedule": params["cars"],"schedule_time": params["schedule_time"].join(",")},id: params["id"],send_items:send_items}
   end 
   
    sop=RestClient.post $api_service+'/send_mails/sendmails_update',sync
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : sendmail Updated successfully"
    rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller sendmail_update method" }
    end
    redirect_to  :action => "index"

  end
# this to redirect the user to specic mailing page
  def sendmail_redirect_page
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the sendmail_redirect_page"
    begin
      if params[:id] == "Purchase Order"
        redirect_to  :action => "sendmail_purchase_order_page"
      elsif  params[:id] == "Excess Stock"
        redirect_to  :action => "sendmails_excess_stock"
      elsif  params[:id] == "Claims(Rate Change)"
        redirect_to  :action => "sendmails_claims_rate_change"
      elsif  params[:id] == "Claims(Free and Discounts)"
        redirect_to  :action => "sendmails_claims_discount"
      elsif  params[:id] == "Claims (Expiry / Broken)"
        redirect_to  :action => "sendmails_claims_broken_damage"
      elsif  params[:id] == "Claims (Purchase Return)"
       
        redirect_to  :action => "sendmails_claims_purchase_return"
        
        elsif params[:id] =="PO-GR Mismatch"
          redirect_to sendmails_pogr_mismatch_path
      end
      rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller sendmail_redirect_page method" }
    end
  end
# this method to display the purchase order for manual mailing after the verification it is only for testing currently no in use
  def sendmail_purchase_order_page
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the sendmail_purchase_order_page"
    begin
    order_id=[]
    @purchase_orders ="Send Purchase Orders"

    if params["from_date"].present? and params["to_date"].present?
      sendmail_set = RestClient.get $api_service+"/send_mails/send_mail_purchase_order_report?from_date=#{params["from_date"]}&to_date=#{params["to_date"]}&supplier_id=#{params["supplier_id"]}"
    else  
      sendmail_set = RestClient.get $api_service+'/send_mails/get_purchase_order'
    end

    @purchase_order = JSON.parse sendmail_set
     rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller sendmail_purchase_order_page method" }
    end
    add_breadcrumb "Purchase Orders", :sendmails_sendmail_purchase_order_page_path 

  end
  

# this method to display the excess stock for manual mailing after the verification it is only for testing currently no in use
  def sendmails_excess_stock
  
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the sendmails_excess_stock"
  
    begin
    @excess ="Send Excess Stocks"
    
    #@supplier=JSON.parse RestClient.get $api_service+'/suppliers'

    sendmail_set=RestClient.get $api_service+'/send_mails/excess_stock_assign?supplier_id='+params["supplier_id"]
    @excess_stock = JSON.parse sendmail_set

    rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller sendmails_excess_stock method" }
    end
     add_breadcrumb "Excess Stock", :sendmails_sendmails_excess_stock_path 

  end
# this method to display the ratechange claim for manual mailing after the verification it is only for testing currently no in use
  def sendmails_claims_rate_change
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the sendmails_claims_discount"
    begin
    @discounts=[]
    @discount ="Send Rate Change"
    
    @supplier_id = params["supplier_id"] 
    @from_date = params["from_date"].present? .present? ? params["from_date"] : Date.today.to_date.strftime("%d-%m-%Y")
    @to_date = params["to_date"].present? ? params["to_date"] : Date.today.to_date.strftime("%d-%m-%Y")


      if params["id"]=="RateChange"
        @expiry_damage= JSON.parse RestClient.get $api_service+"/send_mails/selectall_claims?id=#{params["id"]}"
        redirect_to action: "sendmails_claims_rate_change"
      elsif params["supplier_id"].present? || params["from_date"].present?
        @discounts=JSON.parse RestClient.get $api_service+"/claims/rates?supplier_id=#{@supplier_id}&from_date=#{@from_date}&to_date=#{@to_date}"    
      else
        @discounts=JSON.parse RestClient.get $api_service+"/claims/rates?supplier_id=&from_date=#{@from_date}&to_date=#{@to_date}"
      end
    rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller sendmails_claims_discount method" }
    end
    add_breadcrumb "Discounts and Offers", :sendmails_sendmails_claims_rate_change_path 
  end
# this method to display the free and discount claim for manual mailing after the verification it is only for testing currently no in use
  def sendmails_claims_discount
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the sendmails_claims_replacement"
    begin
      @replacements=[]
      @replacement ="Send Replacement"
      @supplier_id = params["supplier_id"]
      @from_date = params["from_date"].present? ? params["from_date"] : Date.today.to_date.strftime("%d-%m-%Y")
      @to_date = params["to_date"].present? ? params["to_date"] : Date.today.to_date.strftime("%d-%m-%Y")

     if params["id"]=="Discount"
      @expiry_damage= JSON.parse RestClient.get $api_service+"/send_mails/selectall_claims?id="+params["id"]
            redirect_to action: "sendmails_claims_discount"
     elsif params["supplier_id"].present? || params["from_date"].present?
      @replacements = JSON.parse RestClient.get $api_service+"/claims/discounts?supplier_id=#{@supplier_id}&from_date=#{@from_date}&to_date=#{@to_date}"
     else
	@replacements = JSON.parse RestClient.get $api_service+"/claims/discounts?supplier_id=&from_date=#{@from_date}&to_date=#{@to_date}"
     end
    
       
     rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller sendmails_claims_replacement method" }
    end
    add_breadcrumb "Rate Changes", :sendmails_sendmails_claims_discount_path 
  end
# this method to display the expiry damage claim for manual mailing after the verification it is only for testing currently no in use
  def sendmails_claims_broken_damage
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the sendmails_claims_broken_damage"
    begin
     @brokens=[]
     @broken ="Send Replacement"
     @supplier_id = params["supplier_id"]
     @from_date = params["from_date"].present? ? params["from_date"] : Date.today.to_date.strftime("%d-%m-%Y")
     @to_date = params["to_date"].present? ? params["to_date"] : Date.today.to_date.strftime("%d-%m-%Y")
    if params["id"]=="Expiry"
      @expiry_damage= JSON.parse RestClient.get $api_service+"/send_mails/selectall_claims?id=#{params["id"]}"
    elsif params["supplier_id"].present? || params["from_date"].present?
      @brokens=JSON.parse RestClient.get $api_service+"/claims/expiry_damages?supplier_id=#{@supplier_id}&from_date=#{@from_date}&to_date=#{@to_date}"
    else
      @brokens=JSON.parse RestClient.get $api_service+"/claims/expiry_damages?supplier_id=&from_date=#{@from_date}&to_date=#{@to_date}" 
    end
     
      
      
     rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller sendmails_claims_broken_damage method" }
    end  
    add_breadcrumb "Expiry and Broken", :sendmails_sendmails_claims_broken_damage_path     
  end 
# this method to display the purchase return claim for manual mailing after the verification it is only for testing currently no in use
  def sendmails_claims_purchase_return

 Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the sendmails_claims_broken_damage"
    begin

    @returns=[]
    @return ="Send Replacement"
    @supplier_id = params["supplier_id"]
    @from_date = params["from_date"].present? ? params["from_date"] : Date.today.to_date.strftime("%d-%m-%Y")
    @to_date = params["to_date"].present? ? params["to_date"] : Date.today.to_date.strftime("%d-%m-%Y")
    #@returns=JSON.parse RestClient.get $api_service+'/claims/purchase_returns'
    
    if params["id"]=="Return"
      @expiry_damage= JSON.parse RestClient.get $api_service+"/send_mails/selectall_claims?id=#{params["id"]}"
      redirect_to action: "sendmails_claims_purchase_return"
    elsif params["supplier_id"].present? || params["from_date"].present?
      @returns=JSON.parse RestClient.get $api_service+"/claims/purchase_returns?supplier_id=#{@supplier_id}&from_date=#{@from_date}&to_date=#{@to_date}"
    else
      @returns=JSON.parse RestClient.get $api_service+"/claims/purchase_returns?supplier_id=&from_date=#{@from_date}&to_date=#{@to_date}"
    end
     
      
     rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller sendmails_claims_purchase_return method" }
    end  
    add_breadcrumb "Purchase Returns", :sendmails_sendmails_claims_purchase_return_path 
  end

# this method to assign purchase order to send the mail. it is only for testing currently no in use
  def purchase_order_assign
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the purchase_order_assign"
    begin
    sendmail_set=RestClient.post $api_service+'/send_mails/purchase_assign',{"order_no":params[:order_no]}
    rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller purchase_order_assign method" }
    end
    redirect_to  :action => "index"
  end

# this method to assign purchase order to send the mail. it is only for testing currently no in use
  def purchase_order_assign_duplicate
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the purchase_order_assign"
    begin
    sendmail_set=RestClient.post $api_service+'/send_mails/purchase_assign',{"order_no":params[:order_no]}
    rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller purchase_order_assign method" }
    end
    redirect_to  :action => "index"
  end
# this method to assign excess stock to send the mail. it is only for testing currently no in use
  def excess_stock_assign
    
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the excess_stock_assign"
    begin
      
    sendmail_set=RestClient.post $api_service+'/send_mails/excess_stock_assign_update',{"order_no":params[:order_id]}
    rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller excess_stock_assign method" }
    end
    redirect_to  :action => "index"
  end
# this method to assign free and discoun claim to send the mail. it is only for testing currently no in use
   def freeanddiscount_assign
    
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the claim_assign"
    begin
    sendmail_set=RestClient.post $api_service+'/send_mails/freeanddiscount_assign',{"claim_no":params[:claim_no]}
    rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller claim_assign method" }
    end
    redirect_to  :action => "index"
  end
# this method to assign expiry damage to send the mail. it is only for testing currently no in use
  def expiryanddamage_assign
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the claim_assign"
    begin
    sendmail_set=RestClient.post $api_service+'/send_mails/expiryanddamage_assign',{"claim_no":params[:claim_no]}
    rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller claim_assign method" }
    end
    redirect_to  :action => "index"
  end
  # this method to assign purchase return claim to send the mail. it is only for testing currently no in use
  def purchasereturn_assign
  
       Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the purchasereturn_assign"
    begin
      
    sendmail_set=RestClient.post $api_service+'/send_mails/purchasereturn_assign',{"claim_no":params[:claim_no]}
    rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller purchasereturn_assign method" }
    end
    redirect_to  :action => "index"
  end
  # this method to assign rate change claim to send the mail. it is only for testing currently no in use
  def ratechange_assign
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the claim_assign"
    begin
    sendmail_set=RestClient.post $api_service+'/send_mails/ratechange_assign',{"claim_no":params[:claim_no]}
    rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller claim_assign method" }
    end
    redirect_to  :action => "index"
  end
# to preview the selected order for cross verification
 def order_details

    @total=[]
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User get order_details "
        begin
     orders_set=RestClient.get $api_service+'/purchase_order?order_no='+params[:order_no]
     @order_details= (JSON.parse orders_set)

    
    po_emails=RestClient.get $api_service+'/send_mails/po_emails?order_no='+params[:order_no]
    
    @emails=(JSON.parse po_emails)
      rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller order_details method" }
   
    end
    

  end
# pogr details to send the mail after verification
def pogr_details
 @total=[]
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User get order_details "
        begin
     orders_set=RestClient.get $api_service+'/pogr_mismatch_items?order_no='+params[:order_no]

     @pogr_details= (JSON.parse orders_set)

    
    po_emails=RestClient.get $api_service+'/send_mails/pogr_emails?order_no='+params[:order_no]
    
    @gr_emails=(JSON.parse po_emails).paginate(page: params[:page],per_page: 15)
      rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller order_details method" }
   
    end
end

# assign the pogr compared item for email sending
def pogr_mismatch_assign

 Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the purchase_order_assign"
    begin
    sendmail_set=RestClient.post $api_service+'/send_mails/pogr_assign',{"order_no":params[:order_no]}
    rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller purchase_order_assign method" }
    end
    redirect_to  :action => "index"

end


# this to display the mismatched items

  def pogr_mismatch
 Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the sendmail_purchase_order_page"
    begin
    order_id=[]
    @pogr_mismatch ="Send Po-gr mismatch"
    sendmail_set=RestClient.get $api_service+'/send_mails/get_pogr'
    @pogr_mismatches = JSON.parse sendmail_set

     rescue => e
    Rails.logger.custom_log.error { "#{e} sendmail_controller sendmail_purchase_order_page method" }
    end
    add_breadcrumb "Pogr Mismatch", :sendmails_pogr_mismatch_path 

  end
# not in use
  def datadelete
    
  end
# to adjust the purchase returns claims
  def adjustment_po_return
      
     ids=params["ids"]
     
     credit_amount=params["credit_amount"]
     credit_date=params["credit_date"]
     credit_num=params["credit_num"]
    adjust_quantity=params["adjust_quantity"]
     remarks=params["remarks"]
     actual_amount=params["actual_amount"]     
        index_numbers=params["credit_amount"].each_index.select { |i| params["credit_amount"][i]=="" }
        ids_final=ids.reject.with_index { |e,i| index_numbers.include? i }
        credit_amount_final=credit_amount.reject.with_index { |e,i| index_numbers.include? i }
        credit_date_final=credit_date.reject.with_index { |e,i| index_numbers.include? i }
        credit_num_final=credit_num.reject.with_index { |e,i| index_numbers.include? i }
        remarks_final=remarks.reject.with_index { |e,i| index_numbers.include? i }
        quantity_final=adjust_quantity.reject.with_index{|e,i| index_numbers.include? i}
        actual_amount_final=actual_amount.reject.with_index { |e,i| index_numbers.include? i }
     if credit_amount_final.present?
        data={"ids"=>ids_final,"credit_amount"=>credit_amount_final,"credit_num"=>credit_num_final,"credit_date"=>credit_date_final,"remarks"=>remarks_final,"actual_amount"=>actual_amount_final,"adjust_quantity"=>quantity_final}
        purchase_order=RestClient.post $api_service+'/claims/purchase_return_update',data
     end
      if true
        redirect_to :action => "purchase_return_claims"
      end
  end
# to adjust the expiry damamge claima
  def adjustment_expiry_damage
    

     ids=params["ids"]
     
     credit_amount=params["credit_amount"]
     credit_date=params["credit_date"]
     credit_num=params["credit_num"]
     remarks=params["remarks"]
     adjust_quantity=params["adjust_quantity"]
     actual_amount=params["actual_amount"]
     
        index_numbers=params["credit_amount"].each_index.select { |i| params["credit_amount"][i]=="" }
        ids_final=ids.reject.with_index { |e,i| index_numbers.include? i }
        credit_amount_final=credit_amount.reject.with_index { |e,i| index_numbers.include? i }
        credit_date_final=credit_date.reject.with_index { |e,i| index_numbers.include? i }
        credit_num_final=credit_num.reject.with_index { |e,i| index_numbers.include? i }
        remarks_final=remarks.reject.with_index { |e,i| index_numbers.include? i }
        quantity_final=adjust_quantity.reject.with_index{|e,i| index_numbers.include? i}
        actual_amount_final=actual_amount.reject.with_index{|e,i| index_numbers.include? i}
     if credit_amount_final.present?
        data={"ids"=>ids_final,"credit_amount"=>credit_amount_final,"credit_num"=>credit_num_final,"credit_date"=>credit_date_final,"remarks"=>remarks_final,"actual_amount"=>actual_amount_final,"adjust_quantity"=>quantity_final}
        purchase_order=RestClient.post $api_service+'/claims/expiry_damage_update',data
     end
      if true
        redirect_to :action => "expiry_damage_claims"
      end


  end

# to  adjust the free and discount claims
  def adjustment_free_discount

     ids=params["ids"]
     
     credit_amount=params["credit_amount"]
     credit_date=params["credit_date"]
     credit_num=params["credit_num"]
     remarks=params["remarks"]
     adjust_quantity=params["adjust_quantity"]
     actual_amount=params["actual_amount"]
     
        index_numbers=params["credit_amount"].each_index.select { |i| params["credit_amount"][i]=="" }
        ids_final=ids.reject.with_index { |e,i| index_numbers.include? i }
        credit_amount_final=credit_amount.reject.with_index { |e,i| index_numbers.include? i }
        credit_date_final=credit_date.reject.with_index { |e,i| index_numbers.include? i }
        credit_num_final=credit_num.reject.with_index { |e,i| index_numbers.include? i }
        remarks_final=remarks.reject.with_index { |e,i| index_numbers.include? i }
        quantity_final=adjust_quantity.reject.with_index{|e,i| index_numbers.include? i}
        
        actual_amount_final=actual_amount.reject.with_index{|e,i| index_numbers.include? i}
        
     if credit_amount_final.present?
        data={"ids"=>ids_final,"credit_amount"=>credit_amount_final,"credit_num"=>credit_num_final,"credit_date"=>credit_date_final,"remarks"=>remarks_final,"adjust_quantity"=>quantity_final,"actual_amount"=>actual_amount}
        purchase_order=RestClient.post $api_service+'/claims/free_discount_update',data
     end
      if true
        redirect_to :action => "free_discount_claims"
      end


  end
  
#to adjust the rate change claim
  def adjustment_rate_change

     ids=params["ids"]
     
     credit_amount=params["credit_amount"]
     credit_date=params["credit_date"]
     credit_num=params["credit_num"]
     remarks=params["remarks"]
     #adjust_quantity=params["adjust_quantity"]
     actual_amount=params["actual_amount"]
     
        index_numbers=params["credit_amount"].each_index.select { |i| params["credit_amount"][i]=="" }
        ids_final=ids.reject.with_index { |e,i| index_numbers.include? i }
        credit_amount_final=credit_amount.reject.with_index { |e,i| index_numbers.include? i }
        credit_date_final=credit_date.reject.with_index { |e,i| index_numbers.include? i }
        credit_num_final=credit_num.reject.with_index { |e,i| index_numbers.include? i }
        remarks_final=remarks.reject.with_index { |e,i| index_numbers.include? i }
      #  quantity_final=adjust_quantity.reject.with_index{|e,i| index_numbers.include? i}
        actual_amount_final=actual_amount.reject.with_index{|e,i| index_numbers.include? i}
     if credit_amount_final.present?
        data={"ids"=>ids_final,"credit_amount"=>credit_amount_final,"credit_num"=>credit_num_final,"credit_date"=>credit_date_final,"remarks"=>remarks_final,"actual_amount"=>actual_amount_final}
        purchase_order=RestClient.post $api_service+'/claims/rate_change_update',data
     end
      if true
        redirect_to :action => "rate_change_claims"
      end


  end


# to filter the claims using filter
  def datewisefilter 
  
  if  params["date1"].present?
      date1=params["date1"]
      date2=params["date2"]
      purchase_order=RestClient.get $api_service+"/send_mails/datewisefilter?from_date=#{date1}&to_date=#{date2}"
      @purchase_order=JSON.parse purchase_order
   
  elsif params["supplier_id"].present?
    purchase_order=RestClient.get $api_service+'/send_mails/datewisefilter?supplier_id='+params["supplier_id"]
      @purchase_order=JSON.parse purchase_order
    else
      purchase_order=RestClient.get $api_service+'/send_mails/datewisefilter'
      @purchase_order=JSON.parse purchase_order
  end
     end
# to display the purchase order report by selected date
  def purchase_order_report
    
    if params["from_date"].present? and params["to_date"].present?
     @purchase_order=JSON.parse RestClient.get $api_service+"/send_mails/purchase_order_report?from_date=#{params["from_date"]}&to_date=#{params["to_date"]}&supplier_id=#{params["supplier_id"]}"
    else  
     @purchase_order=JSON.parse RestClient.get $api_service+'/send_mails/purchase_order_report'
    end
    #@suppliers=JSON.parse RestClient.get $api_service+'/suppliers'
  end
# to adjust the purchase return claim for view page
  def purchase_return_ajustment
   @purchase_return_claims=(JSON.parse RestClient.get $api_service+'/purchasereturn_claim?claim_no='+params[:claim_no])
  end
# to adjust the expiry damage claim for view page
  def expiry_damage_adjustment
    @expiry_damage=JSON.parse RestClient.get $api_service+"/claims/expiry_damage_claim_no?claim_no=#{params[:claim_no]}"
  end  
# to adjust the free and discount claim for view page
  def free_discount_adjustment
     @free_discount=JSON.parse RestClient.get $api_service+"/claims/free_discount_claim_no?claim_no=#{params[:claim_no]}"  
  end
  # to adjust the rate change claim for view page
  def rate_change_adjustment
   @rate_change=JSON.parse RestClient.get $api_service+"/claims/rate_change_claim_no?claim_no=#{params[:claim_no]}"  
  end
 # to display the settled claim report by selected date
  def settled_claims_report
    if params["from_date"].present?
     @settled_claims=JSON.parse RestClient.get $api_service+"/send_mails/settled_claims_report?from_date=#{params["from_date"]}&to_date=#{params["to_date"]}}"        
    else
    @settled_claims=JSON.parse RestClient.get $api_service+"/send_mails/settled_claims_report"  
    end
  end
# display the pending claim reports
  def overall_claims_report
    @from_date = params["from_date"].present? ? params["from_date"].to_date.strftime("%d-%m-%Y") : Date.today
    @to_date = params["to_date"].present? ? params["to_date"].to_date.strftime("%d-%m-%Y") : Date.today
    @supplier_id = params["supplier_id"]
    @pending_claims=JSON.parse RestClient.get $api_service+"/send_mails/overall_claims_report?from_date=#{@from_date}&to_date=#{@to_date}&supplier_id=#{params[:supplier_id]}"
  end
#to display the expiry damage claim by slected suppliers

  def expiry_damage_claims
    #@supplier=JSON.parse RestClient.get $api_service+'/suppliers'
    @from_date = params["from_date"].present? ? params["from_date"].to_date.strftime("%d-%m-%Y") : Date.today
    @to_date = params["to_date"].present? ? params["to_date"].to_date.strftime("%d-%m-%Y") : Date.today
    #if params["supplier_id"].present?
      @brokens= JSON.parse RestClient.get $api_service+"/claims/expiry_damage_claims?from_date=#{@from_date}&to_date=#{@to_date}&supplier_id=#{params[:supplier_id]}"
    #else
     # @brokens= JSON.parse RestClient.get $api_service+'/claims/expiry_damage_claims'
    #end

  end
#to display the free and discount claim by slected suppliers
  def free_discount_claims
    #@supplier=JSON.parse RestClient.get $api_service+'/suppliers'
    @from_date = params["from_date"].present? ? params["from_date"].to_date.strftime("%d-%m-%Y") : Date.today
    @to_date = params["to_date"].present? ? params["to_date"].to_date.strftime("%d-%m-%Y") : Date.today
    #if params["supplier_id"].present?
      @brokens=JSON.parse RestClient.get $api_service+"/claims/free_discount_claims?from_date=#{@from_date}&to_date=#{@to_date}&supplier_id=#{params[:supplier_id]}"
    #else
     # @brokens=JSON.parse RestClient.get $api_service+'/claims/free_discount_claims'
    #end
 
  end
#to display the purchase return claim by slected suppliers
  def purchase_return_claims
    #@supplier=JSON.parse RestClient.get $api_service+'/suppliers'
    @from_date = params["from_date"].present? ? params["from_date"].to_date.strftime("%d-%m-%Y") : Date.today
    @to_date = params["to_date"].present? ? params["to_date"].to_date.strftime("%d-%m-%Y") : Date.today
    #if params["supplier_id"].present?
      @brokens=JSON.parse RestClient.get $api_service+"/claims/purchase_return_claims?from_date=#{@from_date}&to_date=#{@to_date}&supplier_id=#{params[:supplier_id]}"
    #else
     #@brokens=JSON.parse RestClient.get $api_service+'/claims/purchase_return_claims'
    #end
     
      
  end
   #to display the rate change claim by slected suppliers
  def rate_change_claims
    #@supplier=JSON.parse RestClient.get $api_service+'/suppliers'
    @from_date = params["from_date"].present? ? params["from_date"].to_date.strftime("%d-%m-%Y") : Date.today
    @to_date = params["to_date"].present? ? params["to_date"].to_date.strftime("%d-%m-%Y") : Date.today
    #if params["supplier_id"].present?
      @brokens=JSON.parse RestClient.get $api_service+"/claims/rate_change_claims?from_date=#{@from_date}&to_date=#{@to_date}&supplier_id=#{params[:supplier_id]}"
    #else
     # @brokens=JSON.parse RestClient.get $api_service+'/claims/rate_change_claims'
    #end
         
  end

  def non_findable_claims
    @from_date = params["from_date"].present? ? params["from_date"].to_date.strftime("%d-%m-%Y") : Date.today
    @to_date = params["to_date"].present? ? params["to_date"].to_date.strftime("%d-%m-%Y") : Date.today
    @brokens=JSON.parse RestClient.get $api_service+"/claims/non_findable_claims?from_date=#{@from_date}&to_date=#{@to_date}&supplier_id=#{params[:supplier_id]}"
  end
  #to display the today's adjustment claims
  def pending_claims_report
    @from_date = params["from_date"].present? ? params["from_date"].to_date.strftime("%d-%m-%Y") : Date.today
    @to_date = params["to_date"].present? ? params["to_date"].to_date.strftime("%d-%m-%Y") : Date.today
    @supplier_id = params["supplier_id"]
    pending_claims = RestClient.get $api_service+"/send_mails/pending_claims_report?from_date=#{@from_date}&to_date=#{@to_date}&supplier_id=#{params[:supplier_id]}"
    @pending_claims = JSON.parse pending_claims
  #@supplier= JSON.parse RestClient.get $api_service+'/suppliers'
  end
# to preview the seleted adjusted claims
  def adjustment_details
    report=RestClient.get $api_service+'/send_mails/adjusment_preview?id='+params["id"]
    @report=JSON.parse report
  end
# display the pending claims using date filter
  def pending_claims_date_filter
    params.permit!
    date1=params["date1"].to_date if params["date1"].present?
    date2=params["date2"].to_date if params["date2"].present? 
    supplier_id = params["supplier_id"]
    @pending_claims = JSON.parse RestClient.get($api_service+"/send_mails/pending_claims_datewise_filter?supplier_id=#{supplier_id}&from_date=#{date1}&to_date=#{date2}",timeout: 1000)
#   data = RestClient::Request.execute(method: 'GET', url: $api_service+"/send_mails/pending_claims_datewise_filter?supplier_id=#{supplier_id}&from_date=#{date1}&to_date=#{date2}", timeout: 90000000)
#   @pending_claims = JSON.parse data
  end


    # filter and display the settled claim by from and to dates
  def settled_claims_date_filter
    params.permit!
   date1=params["date1"]
   date2=params["date2"] 
    
    @settled_claims=JSON.parse RestClient.get $api_service+"/send_mails/settled_claims_datewise_filter?from_date=#{date1}&to_date=#{date2}"
  end
# to display the today's adjustment by date filter
  def today_adjustment_date_filter
   params.permit!
   date1=params["date1"]
   date2=params["date2"] 
    
    report=RestClient.get $api_service+"/send_mails/today_adjustment_date_filter?from_date=#{date1}&to_date=#{date2}"
    @report=JSON.parse report
  
  end
# to dsipaly the exess stock report by date, supplier and division filter
  def excess_stock_report

    if params["from_date"]&&params["to_date"] ||params["supplier_id"].present? || params["division_id"].present?
      date1=params["from_date"]
      date2=params["to_date"] 
      supplier_id=params["supplier_id"] 
      division_id=params["division_id"] 
      @excess_report=JSON.parse RestClient.get $api_service+"/send_mails/excess_stock_date_filter?from_date=#{date1}&to_date=#{date2}&supplier_id=#{supplier_id}&division_id=#{division_id}"
    else
      @excess_report= JSON.parse RestClient.get $api_service+"/send_mails/excess_stock_report"
    end
      #@supplier= JSON.parse RestClient.get $api_service+"/suppliers"
      @division= JSON.parse RestClient.get $api_service+"/divisions"

  end
# this to filter the excess stock using date and contact type filter
  def excess_stock_date_filter

   params.permit!
   from_date=params["from_date"]
   to_date=params["to_date"] 
   supplier_id=params["supplier_id"]
   division_id=params["division_id"]
    redirect_to :action=>"excess_stock_report", :from_date=>from_date,:to_date=>to_date,:supplier_id=>supplier_id,division_id:division_id

  end
  # this to display the excess stocks using suppliers
  def excess_stock_supplier_filter
   params.permit!
   supplier_id=params["supplier_id"]
    redirect_to :action=>"sendmails_excess_stock",:supplier_id=>supplier_id

  end
  # this is to display the dependent dropdown for supplier , manufacturer and division
  def supplier_man_div_filter
   @manufacturer= JSON.parse RestClient.get $api_service+"/send_mails/supplier_man_div_filter?id=#{params[:format]}&type=#{params[:type]}"
  end
# this is filter the manufacture using supplier through products
  def supplier_division_filter
    
      @division=JSON.parse RestClient.get $api_service+'/suppliers/supplier_manufacturer?supplier_id='+params[:format]
  end
  # display the claims by selecting its type and supplier
  def claims_supplier_filter
     if params["filter"]["claim_type"]=="Expiry"
      supplier_id=params["supplier_id"]
      from_date=params["from_date"]
      to_date=params["to_date"]
      redirect_to action: "expiry_damage_claims",:supplier_id=>supplier_id,:from_date=>from_date,:to_date=>to_date
    elsif params["filter"]["claim_type"]=="Free"
      supplier_id=params["supplier_id"]
      from_date=params["from_date"]
      to_date=params["to_date"]
      redirect_to action: "free_discount_claims",:supplier_id=>supplier_id,:from_date=>from_date,:to_date=>to_date
    elsif params["filter"]["claim_type"]=="Rate"
      supplier_id=params["supplier_id"]
      from_date=params["from_date"]
      to_date=params["to_date"]
      redirect_to action: "rate_change_claims",:supplier_id=>supplier_id,:from_date=>from_date,:to_date=>to_date
    elsif params["filter"]["claim_type"]=="Purchase"
      supplier_id=params["supplier_id"]
      from_date=params["from_date"]
      to_date=params["to_date"]
      redirect_to action: "purchase_return_claims",:supplier_id=>supplier_id,:from_date=>from_date,:to_date=>to_date
    elsif params["filter"]["claim_type"]=="NonFindable"
      supplier_id=params["supplier_id"]
      from_date=params["from_date"]
      to_date=params["to_date"]
      redirect_to action: "non_findable_claims",:supplier_id=>supplier_id,:from_date=>from_date,:to_date=>to_date
    end
  end
# purchase order report date filter
  def po_date_filter
   params.permit!
   from_date=params["from_date"]
   to_date=params["to_date"] 
   supplier_id=params["supplier_id"]
   redirect_to :action=>"purchase_order_report", :from_date=>from_date,:to_date=>to_date,:supplier_id=>supplier_id
  end
# this is display today adjustment using datefilter
  def today_adjust_date_filter
   params.permit!
   from_date=params["from_date"]
   to_date=params["to_date"] 
 
   redirect_to :action=>"today_adjustment_report", :from_date=>from_date,:to_date=>to_date
 
  end
# display the settled claim report by using the from and to date
  def settled_adjust_date_filter
    params.permit!
   from_date=params["from_date"]
   to_date=params["to_date"] 
   
   redirect_to :action=>"settled_claims_report", :from_date=>from_date,:to_date=>to_date
 
  end
# display the selected expiry damage claim preview in report
  def expiry_claim_preview
    @expiry_damage=JSON.parse RestClient.get $api_service+"/claims/expiry_damage_claim_no?claim_no=#{params[:claim_no]}&&supplier_id=#{params[:supplier_id]}"
  end
# display the selected free and discount claim preview in report
  def free_claim_preview
    @free_discount=JSON.parse RestClient.get $api_service+"/claims/free_discount_claim_no?claim_no=#{params[:claim_no]}&&supplier_id=#{params[:supplier_id]}"  
  end
# display the selected purchase return claim preview in report
  def purchase_return_claim_preview
    #@purchase_return_claims=(JSON.parse RestClient.get $api_service+'/purchasereturn_claim?claim_no='+params[:claim_no])
    @purchase_return_claims=JSON.parse RestClient.get $api_service+"/claims/purchase_return_claim_no?claim_no=#{params[:claim_no]}&&supplier_id=#{params[:supplier_id]}"
  end  
# display the selected rate change claim preview in report
  def rate_claim_preview
    
   @rate_change=JSON.parse RestClient.get $api_service+"/claims/rate_change_claim_no?claim_no=#{params[:claim_no]}&&supplier_id=#{params[:supplier_id]}"  
  end

  def non_findable_claim_preview
    
   @non_findable_claims=JSON.parse RestClient.get $api_service+"/claims/non_findable_claim_no?claim_no=#{params[:claim_no]}&&supplier_id=#{params[:supplier_id]}"  
  end  

  def sendmail_supplier_filter
     supplier_id=params["supplier_id"]
      from_date = params["from_date"]
      to_date = params["to_date"]
      
     if params["filter"]["claim_type"]=="Expiry"
        redirect_to action: "sendmails_claims_broken_damage",:supplier_id=>supplier_id,:from_date => from_date,:to_date => to_date
    elsif params["filter"]["claim_type"]=="Free"
       redirect_to action: "sendmails_claims_discount",:supplier_id=>supplier_id,:from_date => from_date,:to_date => to_date
    elsif params["filter"]["claim_type"]=="Rate"
      
      redirect_to action: "sendmails_claims_rate_change",:supplier_id=>supplier_id,:from_date => from_date,:to_date => to_date
    elsif params["filter"]["claim_type"]=="Return"
      redirect_to action: "sendmails_claims_purchase_return",:supplier_id=> supplier_id, :from_date => from_date,:to_date => to_date
    end
  end

private

def supplier
  @supplier=JSON.parse RestClient.get $api_service+'/suppliers'
end


end

