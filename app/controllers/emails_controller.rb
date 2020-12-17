class EmailsController < ApplicationController

 add_breadcrumb "Inbox", :emails_path  

# to display all received mails for assign to specific supplier
  def index
  Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in emails index method"
   begin
    email=RestClient.get $api_service+'/emails'
  	@emails=JSON.parse email

    unless  @emails.present?

    Rails.logger.debug_log.debug { "#{"emails  may be not available otherwise check backend"}"}
    end
  	supplier=RestClient.get $api_service+'/suppliers'
  	@suppliers=JSON.parse supplier
 unless @suppliers.present?
Rails.logger.debug_log.debug { "#{"suppliers  may be not available otherwise check backend"}"}

    end
    rescue => e
    Rails.logger.custom_log.error { "#{e} Emails_controller index method" }
    end
   end

# this method assign email to selected supplier
  def email_assign
  
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in email_assign method"
  	begin
    id=params["id"]
  	email=RestClient.get $api_service+'/emails/'+id
  	@emails=JSON.parse email
     unless @emails.present?
      Rails.logger.debug_log.debug { "#{"emails  may be not available otherwise check backend"}"}
     end
  	supplier=RestClient.get $api_service+'/suppliers'
  	@suppliers=JSON.parse supplier
    unless @suppliers.present?
    Rails.logger.debug_log.debug { "#{"suppliers  may be not available otherwise check backend"}"}
    end
    rescue => e
    Rails.logger.custom_log.error { "#{e} Emails_controller email_assign method" }
    end
    add_breadcrumb "Assign", :emails_email_assign_path  
   end
# this method is to update the emails by supplier id
   def email_update
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in email_update method"
    begin
   	id=params["email_id"]
   	data={email:{"supplier_id":params["supplier"]["supplier_id"]}}
   	email=RestClient.put $api_service+'/emails/'+id,data
    rescue => e
    Rails.logger.custom_log.error { "#{e} Emails_controller email_assign method" }
    end
   	redirect_to action: "index"
   end
# this method to filter the emails by supplier
   def suppliers_list
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in supplier_list method"
    begin
    email=RestClient.get $api_service+'/emails/suppliers_list?id='+params["id"]
    @emails=JSON.parse email
    unless @emails.present?
      Rails.logger.debug_log.debug { "#{"emails  may be not available otherwise check backend"}"}
     end
    rescue => e
  Rails.logger.custom_log.error { "#{e} Emails_controller suppliers_list method" }
    end
  end
  # this mthod is to download the mail attachments
def download
  
send_file(
   params[:id],
    filename: params["id"].split("/").last,
    type: "application/#{params["id"].split("/").last.split(".").last}"
  )
  #send_file params[:id], :disposition => 'attachment'

end

end
