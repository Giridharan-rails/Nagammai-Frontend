class PaymentTermsController < ApplicationController
   add_breadcrumb "Payment Terms", :payment_terms_path  
  
# this controller not in use
  def index
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Paymentterms Index"
     begin
    payment_terms=RestClient.get $api_service+'/payment_terms'
    @payment_terms=(JSON.parse payment_terms)

    user_id = session[:user_id]
  user = RestClient.get $api_service+"/users/#{user_id}"
  @user=JSON.parse user
  
     if @payment_terms.present?
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Payment term successfully displayed"
    else
    Rails.logger.debug_log.debug { "#{"Payment Terms may be not available otherwise check backend"}"}
    end
  
    rescue => e
      Rails.logger.custom_log.error { "#{e} paymentterms_controller index method" }
     end
  end

  def new
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Paymentterms Creation"
    @payment_term="new payment_term"
     add_breadcrumb "New", :new_payment_term_path  
  end

  def payment_term_delete
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in Paymentterms Delete"
    begin
    id=params["format"]    
    payment_term=RestClient.delete $api_service+'/payment_terms/'+id
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Paymentterms Deleted Successfully"
      rescue => e
      Rails.logger.custom_log.error { "#{e} paymentterms_controller payment_term_delete method" }
    end
    redirect_to action: "index"
  end 
   
  def payment_term_update
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the Paymentterms update button"
    begin
    params.permit!
    data=params["payment_terms"]
    payment_term= {:payment_term=>{"job_name":params[:job_name]}}

    payment_term=RestClient.put $api_service+'/payment_terms/'+data[:id],payment_term
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Paymentterms Updated successfully"
    rescue => e
    Rails.logger.custom_log.error { "#{e} paymentterms_controller payment_term_update method" }
    end
    redirect_to action: "index"
  end

  def create
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : User click the Paymentterms create button"
    begin
     params.permit!
     
     payment_term={:payment_term=>{"job_name":params[:job_name]}}
     payment_term=RestClient.post $api_service+'/payment_terms',payment_term
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Paymentterms created successfully"
     rescue => e
    Rails.logger.custom_log.error { "#{e} paymentterms_controller create method" }
   end
     redirect_to  :action => "index"
   end  

  def edit
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in Paymentterms edit page"
    begin
    id=params[:id]
    payment_term=RestClient.get $api_service+'/payment_terms/'+id
    @payment_term=JSON.parse payment_term
     rescue => e
    Rails.logger.custom_log.error { "#{e} paymentterms_controller edit method" }
    end
     add_breadcrumb "Edit", :edit_payment_term_path  
  end

  def show
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in manufacturer show page"
  begin
    id=params[:id]
    payment_term=RestClient.get $api_service+'/payment_terms/'+id 
    @payment_term=JSON.parse payment_term
   rescue => e
   Rails.logger.custom_log.error { "#{e} paymetterms_controller show method" }
  end
   add_breadcrumb "Show", :payment_term_path  
  end

end
