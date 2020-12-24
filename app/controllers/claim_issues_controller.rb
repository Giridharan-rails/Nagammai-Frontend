class ClaimIssuesController < ApplicationController
 # before_action :set_claim_issue, only: [:show, :edit, :update, :destroy]
  before_action :set_supplier, only: [:new, :index]

  # GET /claim_issues
  # GET /claim_issues.json
  def index
    @users=JSON.parse RestClient.get $api_service+'/users'
    @from_date, @to_date, @status, @user_id, @supplier_id, @division_id = params["from_date"], params["to_date"], params["status"], params["user_id"], params["supplier_id"], params["division_id"]
    response = RestClient.get $api_service+"/claim_issues?from_date=#{params["from_date"]}&to_date=#{params["to_date"]}&status=#{params["status"]}&division_id=#{params["division_id"]}&user_id=#{params["user_id"]}"
    user = RestClient.get $api_service+"/users/#{session[:user_id]}"
    @claim_issues = JSON.parse response
    @user = JSON.parse user
  end

  # GET /claim_issues/1
  # GET /claim_issues/1.json
  def show
  end

  # GET /claim_issues/new
  def new
    @claim_issue = "new claim_issue"
    @manufacturers=[]
    @divisions=[]
    @claims=[]
    @claim_issues=[]
    @contacts = []
    @users = []
  end

  # GET /claim_issues/1/edit
  def edit
  end

  # POST /claim_issues
  # POST /claim_issues.json
  def create
    begin
    params.permit!
    claim_issue = {:claim_issue => {"description" => params["description"], "contact_id" => params["contact_id"], "user_id" => params["user_id"], "cut_off_date" => params["cut_off_date"],"status"=> params["status"], "notes" => params["notes"], "division_id" => params["division_id"]}}
    response = RestClient.post $api_service+'/claim_issues',claim_issue
    redirect_to :action => "index"
    rescue =>e
        Rails.logger.custom_log.error { "#{e} ClaimIssuesController create method" }
    end
  end

  # PATCH/PUT /claim_issues/1
  # PATCH/PUT /claim_issues/1.json
  def update
    respond_to do |format|
      if @claim_issue.update(claim_issue_params)
        format.html { redirect_to @claim_issue, notice: 'Claim issue was successfully updated.' }
        format.json { render :show, status: :ok, location: @claim_issue }
      else
        format.html { render :edit }
        format.json { render json: @claim_issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /claim_issues/1
  # DELETE /claim_issues/1.json
  def destroy
    response = RestClient.delete $api_service+"/claim_issues/"+params['id']
    redirect_to :action => "index"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_claim_issue
      @claim_issue = ClaimIssue.find(params["id"])
    end

    def set_supplier
      @suppliers = JSON.parse RestClient.get $api_service+'/suppliers'
    end

    # Only allow a list of trusted parameters through.
    def claim_issue_params
      params.fetch(:claim_issue, {})
    end
end
