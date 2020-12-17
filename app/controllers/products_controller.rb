class ProductsController < ApplicationController
  # to displa all products but not in use
  def index
  	 Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in sops products_view page"
  begin
  if params[:division_id] == nil
 products= RestClient::Request.execute(:method => :get, :url => $api_service+'/products', :timeout => 10000, :open_timeout => 10000)
    #products=RestClient.get ($api_service+'/products' )
    @product=(JSON.parse products)
  else
     products= RestClient::Request.execute(:method => :get, :url => $api_service+'/products/division_product_view?division_id='+params[:division_id], :timeout => 10, :open_timeout => 10)
   #products=RestClient.get ($api_service+'/products/division_product_view?division_id='+params[:division_id])
    @product=(JSON.parse products)
   end 

   
  
    rescue => e
    Rails.logger.custom_log.error { "#{e} product_controller products_view method" }
   end 
   add_breadcrumb "Sops", :sops_path  
   add_breadcrumb "Products", :sops_products_view_path  

  end
end
