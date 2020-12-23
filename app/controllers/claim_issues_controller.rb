class ClaimIssuesController < ApplicationController
  before_action :set_claim_issue, only: [:show, :edit, :update, :destroy]
  before_action :set_supplier, only: [:new]

  # GET /claim_issues
  # GET /claim_issues.json
  def index
    response = RestClient.get $api_service+'/claim_issues'
    @claim_issues = JSON.parse response
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
    @history=[]
  end

  # GET /claim_issues/1/edit
  def edit
  end

  # POST /claim_issues
  # POST /claim_issues.json
  def create
    @claim_issue = ClaimIssue.new(claim_issue_params)

    respond_to do |format|
      if @claim_issue.save
        format.html { redirect_to @claim_issue, notice: 'Claim issue was successfully created.' }
        format.json { render :show, status: :created, location: @claim_issue }
      else
        format.html { render :new }
        format.json { render json: @claim_issue.errors, status: :unprocessable_entity }
      end
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
    @claim_issue.destroy
    respond_to do |format|
      format.html { redirect_to claim_issues_url, notice: 'Claim issue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_claim_issue
      @claim_issue = ClaimIssue.find(params[:id])
    end

    def set_supplier
      @suppliers = JSON.parse RestClient.get $api_service+'/suppliers'
    end

    # Only allow a list of trusted parameters through.
    def claim_issue_params
      params.fetch(:claim_issue, {})
    end
end
