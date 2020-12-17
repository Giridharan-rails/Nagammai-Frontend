class SopReportsController < ApplicationController
  # to display the sop report
  def index
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
     
  end
end
