class PagesController < ApplicationController
  # this is to display mandatory details in view page
  def dashboard
  dashboard=RestClient.get $api_service+'/users/dashboard'
  @dashboards=JSON.parse dashboard
  @month_names = 12.downto(1).map { |n| DateTime::MONTHNAMES.drop(1)[( Date.today.month - n) % 12] }.map{|i| i[0..2]}
  end
# to dsplay the synced data details filtered using dates
  def reports

  	 if params["from_date"].present? and params["to_date"].present?
      @date=params[:from_date]
     @data=JSON.parse RestClient.get $api_service+"/claims/data_report?from_date=#{params["from_date"]}&to_date=#{params["to_date"]}"
     elsif params[:date]
      @data=JSON.parse RestClient.get $api_service+"/claims/data_report?from_date=#{params["date"]}&to_date=#{params["date"]}"
      @date=params[:date]
     else 
     @date=Date.today  
     @data=JSON.parse RestClient.get $api_service+'/claims/data_report'
    end

  end
# this is to edit the synced data details for sync verification
  def edit_reports
 
   # name = params["module_name"]
    #count = params["wondersoft"]

    wondersoft_value ={
     purchase_order_count: params[:purchase_order_count], purchase_order_reason: params[:purchase_order_reason], purchase_order_email_reason: params[:purchase_order_email_reason],
      expiry_broken_count: params[:expiry_broken_count], expiry_broken_reason: params[:expiry_broken_reason], expiry_broken_email_reason: params[:expiry_broken_email_reason],
       free_discount_count: params[:free_discount_count], free_discount_reason: params[:free_discount_reason], free_discount_email_reason: params[:free_discount_email_reason],
        purchase_return_count: params[:purchase_return_count], purchase_return_reason: params[:purchase_return_reason], purchase_return_email_reason: params[:purchase_return_email_reason], 
        rate_change_count: params[:rate_change_count], rate_change_reason: params[:rate_change_reason], rate_change_email_reason: params[:rate_change_email_reason], 
        excess_stock_count: params[:excess_stock_count], excess_stock_reason: params[:excess_stock_reason], excess_stock_email_reason: params[:excess_stock_email_reason], 
        pogr_count: params[:pogr_count], pogr_reason: params[:pogr_reason], pogr_email_reason: params[:pogr_email_reason], appointment_count: params[:appointment_count], 
        appointment_reason: params[:appointment_reason], appointment_email_reason: params[:appointment_email_reason], claim_issue_count: params[:claim_issue_count], 
        claim_issue_reason: params[:claim_issue_reason], claim_issue_email_reason: params[:claim_issue_email_reason], inbox_count: params[:inbox_count], 
        inbox_reason: params[:inbox_reason], inbox_email_reason: params[:inbox_email_reason], non_findable_claim_count: params[:non_findable_claim_count], 
        non_findable_claim_reason: params[:non_findable_claim_reason], non_findable_claim_email_reason: params[:non_findable_claim_email_reason], report_date: params[:report_date]
      }
    
    wondersoft=RestClient.post $api_service+'/claims/edit_reports',wondersoft_value
 
  end
end
