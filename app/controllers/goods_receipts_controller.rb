class GoodsReceiptsController < ApplicationController
# to display the pogr compared date
  def index
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in GoodsReceipts  index method"
  begin
  unless params["from_date"].present?
  	good=RestClient.get $api_service+'/goods_received_notes'
  	@gr_data=(JSON.parse good).paginate(page: params[:page], per_page: 15)
    unless @gr_data.present?
      Rails.logger.debug_log.debug { "#{"gr_data may be not available otherwise check backend"}"}
    end
  else
  	@from=params["from_date"]
  	@to=params["to_date"]
    good=RestClient.post $api_service+'/goods_received_notes/date_filter', {:from_date=>@from,:to_date=>@to}
  	@gr_data=JSON.parse good
    unless @gr_data.present?
      Rails.logger.debug_log.debug { "#{"gr_data may be not available otherwise check backend"}"}
    end
  end 	
  rescue => e
    Rails.logger.custom_log.error { "#{e} goods_receipts_controller index method" }
  end


  end
# to filter the data by its date
  def to_date
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in good receipts to_date method"
	  params.permit!
	  from=params["from_date"]
	  to=params["to_date"]
      redirect_to :action=>"index",:from_date=>from,:to_date=>to
  end 	
# compare the purchase order and goods received
  def compare
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in good receipts to_date method"
    begin
    order_no=params["order_no"]
    response= RestClient.get $api_service+'/goods_received_notes/compare_order_no?order_no='+order_no
     @response_data=JSON.parse response
    rescue => e
      Rails.logger.custom_log.error { "#{e} goods_receipts_controller compare method" }
    end
   
  end
# not in use
  def compare_gr_no
    
  end

end
