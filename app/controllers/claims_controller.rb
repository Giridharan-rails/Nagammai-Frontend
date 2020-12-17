class ClaimsController < ApplicationController
 add_breadcrumb "Claims"

# not in use
  def index
    begin
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in Claims index page"

  	@claim = "new claim"
  	@claims = (JSON.parse RestClient.get $api_service+'/claims/claim_index')
    unless @claims.present?
     Rails.logger.debug_log.debug { "#{"Claims may be not available otherwise check backend"}"}
    end
    rescue => e
    Rails.logger.custom_log.error { "#{e} claims_controller index method" }
    end

  add_breadcrumb "Mapping Claims", :claims_path  
  end
# to adjust the clams
  def create
    begin
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in Claims create page"

  	params.permit!
  	replacement = (params["replacement"].present? ? params["replacement"].map{|i| {i => "replacement"}} : []).reduce({}, :merge)
  	free_discount = (params["free_discount"].present? ? params["free_discount"].map{|i| {i => "free_discount"}} : []).reduce({}, :merge)
  	expiry_damage = (params["expiry_damage"].present? ? params["expiry_damage"].map{|i| {i => "expiry_damage"}} : []).reduce({}, :merge)
    closed = (params["closed"].present? ? params["closed"].map{|i| {i => "closed"}} : []).reduce({}, :merge)
    claim = {:claim => {"type_of_claim" => replacement.merge(free_discount).merge(expiry_damage), "status" => closed}}
  	claims = RestClient.post $api_service+'/claims/claim_update',claim
  	redirect_to  :action => "index"
    rescue => e
    Rails.logger.custom_log.error { "#{e} claims_controller create method" }
    end

  end
# to display all pending claims
   def pending_claims
    begin
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in Pending claims page"

    @claims = (JSON.parse RestClient.get $api_service+'/claims/pending_claim')#.paginate(page: params[:page], per_page: 15)
    
   

    unless @claims.present?
     Rails.logger.debug_log.debug { "#{"Claims may be not available otherwise check backend"}"}
    end
    rescue => e
    Rails.logger.custom_log.error { "#{e} claims_controller pending_claims method" }
    end



  end
# date wise filter for pnding claims report

  def datefilter
    begin   
    
    dates = params["from_date"].split("=")
    data="/claims/claim_date_report?from_date=#{dates}"
    @claims = (JSON.parse RestClient.get $api_service+data)#.paginate(page: params[:page], per_page: 15)
    
    unless @claims.present?
     Rails.logger.debug_log.debug { "#{"Claims may be not available otherwise check backend"}"}
    end

    rescue => e
    Rails.logger.custom_log.error { "#{e} claims_controller data filter method" }
    end


  end
# to display the settled claim report
  def settled_claim
    begin    
  
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in settled_claims page"

    @claims = (JSON.parse RestClient.get $api_service+'/claims/settled_claims')#.paginate(page: params[:page], per_page: 15)
    unless @claims.present?
     Rails.logger.debug_log.debug { "#{"Claims may be not available otherwise check backend"}"}
    end
    rescue => e
    Rails.logger.custom_log.error { "#{e} claims_controller settled_claim method" }
    end


    add_breadcrumb "Settled Claims", :claims_settled_claim_path  
  end
# to display the settled claim report by filters
  def settled_claim_filter
     begin
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in  settled_claim_filter"

    data="/claims/datewise_settled_claims?from_date="+params["from_date"]+"&to_date="+params["to_date"]
    @claims = (JSON.parse RestClient.get $api_service+data)#.paginate(page: params[:page], per_page: 15)
    unless @claims.present?
     Rails.logger.debug_log.debug { "#{"Claims may be not available otherwise check backend"}"}
    end

    rescue => e
    Rails.logger.custom_log.error { "#{e} claims_controller settled_claim_filter method" }
    end


  end
# to display the completedly settled whih means closed claims
  def closed_claim
    begin
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in  closed_claim page"

    @claims = (JSON.parse RestClient.get $api_service+'/claims/status_close')#.paginate(page: params[:page], per_page: 15)
    unless @claims.present?
     Rails.logger.debug_log.debug { "#{"Claims may be not available otherwise check backend"}"}
    end

    rescue => e
    Rails.logger.custom_log.error { "#{e} claims_controller closed_claim method" }
    end


     add_breadcrumb "Closed Claims", :claims_closed_claim_path  
  end
# to filter the closed claims in above method and view
  def closed_claim_filter
    begin
    data="/claims/datewise_close_claim?from_date="+params["from_date"]+"&to_date="+params["to_date"]
    @claims = (JSON.parse RestClient.get $api_service+data)#.paginate(page: params[:page], per_page: 15)
    unless @claims.present?
     Rails.logger.debug_log.debug { "#{"Claims may be not available otherwise check backend"}"}
    end
    rescue => e
    Rails.logger.custom_log.error { "#{e} claims_controller closed_claim_filter method" }
    end


  end

#to diplay the free and discount claims in sendmails tab
  def free_discounts
    begin
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in free_discount index page"
      @free_discounts=[]
      @free_discounts=(JSON.parse RestClient.get $api_service+'/claims/discounts')#.paginate(page: params[:page], per_page: 15)

    unless @free_discounts.present?
     Rails.logger.debug_log.debug { "#{"Claims may be not available otherwise check backend"}"}
    end

    rescue => e
    Rails.logger.custom_log.error { "#{e} claims_controller free_discounts method" }
    end


 add_breadcrumb "Free and Discount Claims", :claims_free_discounts_path  
  end
# to display  the expiry damage claims in sendmails tab
  def expiry_damage
    begin
  Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in expiry_damage index page"
 @expiry_damages=[]
  @expiry_damages=(JSON.parse RestClient.get $api_service+'/claims/expiry_damages')#.paginate(page: params[:page], per_page: 15)
  unless   @expiry_damages.present?
     Rails.logger.debug_log.debug { "#{"Claims may be not available otherwise check backend"}"}
    end

    rescue => e
    Rails.logger.custom_log.error { "#{e} claims_controller expiry_damage method" }
    end


  add_breadcrumb "Expiry and Damage Claims", :claims_expiry_damage_path  
  end
  # to disply the ratechange claims in sendmails tab
  def rate_change
    begin
   Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered rate_changes index page"
 @rate_changes=[]
  @rate_changes=(JSON.parse RestClient.get $api_service+'/claims/rates')#.paginate(page: params[:page], per_page: 15)
  unless  @rate_changes.present?
     Rails.logger.debug_log.debug { "#{"Claims may be not available otherwise check backend"}"}
  end
  
  rescue => e
    Rails.logger.custom_log.error { "#{e} claims_controller rate_changes method" }
    end


  add_breadcrumb "Rate Change Claims", :claims_rate_change_path  
  
  end
  # to preview the selected ratechange claim
def rate_change_claim
  begin
  @total=[]

  @rate_change_claims=(JSON.parse RestClient.get $api_service+'/rate_claim?claim_no='+params[:claim_no]+'&claim_date='+params[:claim_date])#.paginate(page: params[:page], per_page: 15)

  email=RestClient.get $api_service+'/send_mails/rate_change_emails?claim_no='+params[:claim_no]+'&claim_date='+params[:claim_date]
  @emails=JSON.parse email
  unless  @rate_change_claims.present?
  Rails.logger.debug_log.debug { "#{"Claims may be not available otherwise check backend"}"}
  end

   rescue => e
    Rails.logger.custom_log.error { "#{e} claims_controller rate_change_claim method" }
    end


end
# to preview the selected expiry damage claim
def expiry_damage_claim
  begin
     @total=[]
     @gross=[]
     @vat=[]
     @expiry_damage_claims = (JSON.parse RestClient.get $api_service+'/expiry_claim?claim_no='+params[:claim_no]+'&claim_date='+params[:claim_date]) #.paginate(page: params[:page], per_page: 15)
     expiry_damage_emails = RestClient.get $api_service+'/send_mails/expiry_damage_emails?claim_no='+params[:claim_no]+'&claim_date='+params[:claim_date] 
     @ed_emails = JSON.parse expiry_damage_emails
     unless @expiry_damage_claims.present?
  	Rails.logger.debug_log.debug { "#{"Claims may be not available otherwise check backend"}"}
     end
  rescue => e
     Rails.logger.custom_log.error { "#{e} claims_controller expiry_damage_claim method" }
  end
end


# to preview selected purchase return claims
def purchase_return_claim
  begin
     @total=[]
  @purchase_return_claims=(JSON.parse RestClient.get $api_service+'/purchasereturn_claim?claim_no='+params[:claim_no]+'&claim_date='+params[:claim_date])

    purchase_return_emails=RestClient.get $api_service+'/send_mails/purchase_return_emails?claim_no='+params[:claim_no]+'&claim_date='+params[:claim_date]
    
    @pr_emails=JSON.parse purchase_return_emails
  unless @purchase_return_claims.present?
  Rails.logger.debug_log.debug { "#{"Claims may be not available otherwise check backend"}"}
  end

 rescue => e
 Rails.logger.custom_log.error { "#{e} claims_controller purchase_return_claim method" }
 end
end

# to preview the selected free and discount claim
def free_discounts_claim
  begin
 @total=[]
  @free_discounts_claims=(JSON.parse RestClient.get $api_service+'/discount_claim?claim_no='+params[:claim_no]+'&claim_date='+params[:claim_date]) # .paginate(page: params[:page], per_page: 15)
  
  email=RestClient.get $api_service+'/send_mails/free_discount_emails?claim_no='+params[:claim_no]+'&claim_date='+params[:claim_date]
  @emails=JSON.parse email

unless @free_discounts_claims.present?
 Rails.logger.debug_log.debug { "#{"Claims may be not available otherwise check backend"}"}
end

rescue => e
  Rails.logger.custom_log.error { "#{e} claims_controller free_discounts_claim method" }
end

  
end




end
