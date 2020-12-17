class IssuesController < ApplicationController

# to display the claim issues in issues screen by date filter
  def index

  Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in sops issue_closed_reopened page"
    begin

      
    if params["from_date"].present?
      @from_date=params["from_date"]
      @to_date=params["to_date"]
      @stat=params["stat"]

     issues=RestClient.get $api_service+"/claims/datewise_filter_claim?from_date=#{@from_date}&&to_date=#{@to_date}&&status=#{@stat}"
    else
    issues=RestClient.get $api_service+'/appointments/claim_issues'
    end
    @issues=JSON.parse issues
    rescue => e
    Rails.logger.custom_log.error { "#{e} sops_controller issue_closed_reopened method" }
    end
    
    add_breadcrumb "Issues Audit Report", :issues_index_path
  end
# update the status of issues like approved,open,close and reopen
  def issue_update

    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in issue_update page"
    #begin 
    ids=params["ids"]
  
    status=params["status"]
  
    approval=params["approval"]

    remarks=params["remarks"]
    
    issue={"ids"=>ids,"status"=>status,"approval"=>approval,"remarks"=> remarks }
    data=RestClient.post $api_service+'/sops/issues_update',issue
    #rescue => e
   # Rails.logger.custom_log.error { "#{e.class} #{sops_controller issue_update method}" }
    #end
    #JSON.parse data
    redirect_to :action=>"index"
    
  end
# this is to filter the issues by fromdate, todate and status
  def datewisefilter
  
  from_date=params["from_date"]
  to_date=params["to_date"]
  status=params["status"]
  redirect_to :action=>"index",stat:status,from_date:from_date,to_date:to_date
 
  end
  # this method is to filter the approved claim issues
  def approved_claims_filter
    data=RestClient.get $api_service+'/claims/approved_claims_filter?date='+params["date"]
    @approval=JSON.parse data
  end
# this is to show only approved claim issues
  def approved_claims
    
    data=RestClient.get $api_service+'/claims/approved_claims'
    @issues=JSON.parse data

  end
  # this method is to filter the claim issues by status
   def filterstatus

       @status=RestClient.get $api_service+"/claims/status_filter?id=#{params[:format]}&type=#{params[:type]}"
       @status=JSON.parse @status
  end
end
