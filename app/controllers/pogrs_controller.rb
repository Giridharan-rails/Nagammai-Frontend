class PogrsController < ApplicationController
 require 'byebug'
# this method to for comapare pogr pages display
  def index


    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Pogrs Index"
    #@purchase_orders =(JSON.parse RestClient.get $api_service+'/products/purchase_order_all').paginate(page: params[:page], per_page: 8)
    begin
  
    if params.keys[2]=="po_number"
  
    @order_no = {"po":params[:po_number],"grn":params[:grn_number]}
    @compared_data = (JSON.parse RestClient.post $api_service+'/products/purchase_goods_receipt',@order_no)#.paginate(page: params[:page], per_page: 8)

      if  @compared_data.present?
        Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Pogrs display Succesfully"
       else
        Rails.logger.debug_log.debug { "#{"pogr may be not available otherwise check backend"}"}
     end
   else
 @compared_data=[]

    end
      rescue => e
      Rails.logger.custom_log.error { "#{e} pogrs_controller index method" }
     end

     add_breadcrumb "PO-GR Mismatch", :pogrs_path  
  end
# this method is to compare the purchase order and 
  def pogr_compare
   
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Pogrs compare"
     
    @order_no = {"po":eval(params.keys[0])[:po],"grn":eval(params.keys[0])[:po]}
    @compared_data = (JSON.parse RestClient.post $api_service+'/products/purchase_goods_receipt',@order_no)#.paginate(page: params[:page], per_page: 8)

    if @compared_data.present?
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Pogrs compared_data display Succesfully"
    else
      Rails.logger.debug_log.debug { "#{"pogr may be not available otherwise check backend"}"}
    end
     add_breadcrumb "PO-GR Mismatch", :pogrs_path 
     add_breadcrumb "Comparision", :pogrs_path 
  end
# to send email compared data email to suppliers
  def map_pogr
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Pogr map"
    data=[]

    params["replacement"].map{|i| data<<eval(i)}
    send_data=[]
    data.map{|i| send_data<<{"po_number":i["purchase_order"],"gr_number":i["gr_qty"],"product_code":i["product_code"],"product_name":i["product_name"],"supplier_code":i["supplier_name"]["supplier_code"],"supplier_name":i["supplier_name"]["supplier_name"],"po_quantity":i["purchase_qty"],"gr_quantity":i["gr_qty"].map{|k|k["quantity"]}.map{|j| j.to_i}.sum,"excess_quantity":(i["gr_qty"].map{|k|k["quantity"]}.map{|j| j.to_i}.sum - i["purchase_qty"].to_i)}}


    result=RestClient.post $api_service+'/pogr_syns/pogr_mismatch',{"data": send_data}
    

   redirect_to :action=>"index"

  end

end