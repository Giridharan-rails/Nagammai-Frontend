class ContactsController < ApplicationController
  require 'csv'


  # to show all the contacts
  def index
 
  begin
  Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in contact index page"
  contacts=RestClient.get $api_service+'/contacts'
  @contacts=(JSON.parse contacts)

  user_id = session[:user_id]
  user = RestClient.get $api_service+"/users/#{user_id}"
  @user=JSON.parse user

  if  @contacts.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : contacts successfully displayed"
  else
   Rails.logger.debug_log.debug { "#{"contact may be not available otherwise check backend"}"}
  end  

  rescue => e
      Rails.logger.custom_log.error { "#{e} contact_controller index method" }
  end
  
#  params[:file] = "/home/nagammaialtius/Nagammai/Nagammai-Frontend/app/assets/images/CONTACTS.csv"
    
if params["file"].present?
    send_file params[:file], :disposition => 'attachment'
end

  end
# not in use
  def _from
    
  end  
# for creating new contacts we need contact types , cfa title, marketing title and mail allocations
  def new
    begin    
    
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in contact new page"
    @contact="new contact"
    suppliers=RestClient.get $api_service+'/suppliers'
    @supplier_data=JSON.parse suppliers
    if  @supplier_data.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : supplier_data successfully displayed"
    else
    Rails.logger.debug_log.debug { "#{"supplier_data may be not available otherwise check backend"}"}
    end  

    @manufacturer_dropdown=JSON.parse (RestClient.get $api_service+'/manufacturers')
    if  @manufacturer_dropdown.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : manufacturer successfully displayed"
    else
    Rails.logger.debug_log.debug { "#{"manufacturer may be not available otherwise check backend"}"}
    end  


    @division_dropdown=JSON.parse (RestClient.get $api_service+'/divisions')

    if @division_dropdown.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : division successfully displayed"
    else
    Rails.logger.debug_log.debug { "#{"division may be not available otherwise check backend"}"}
    end  



    cfas=RestClient.get $api_service+'/cfa_titles'
    @cfa_data=JSON.parse cfas

    if @cfa_data.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : cfa successfully displayed"
    else
    Rails.logger.debug_log.debug { "#{"cfa may be not available otherwise check backend"}"}
    end  


    marketing=RestClient.get $api_service+'/marketing_titles'
    @marketing_data=JSON.parse marketing 

    if @marketing_data.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : marketing successfully displayed"
    else
    Rails.logger.debug_log.debug { "#{"marketing may be not available otherwise check backend"}"}
    end  


    rescue => e
      Rails.logger.custom_log.error { "#{e} contact_controller new method" }
    end
    
  end
# this method is to delete the contacts
  def contact_delete
    begin
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in contact delete"
    id=params["format"]    
    user=RestClient.delete $api_service+'/contacts/'+id
    unless user.present?
      Rails.logger.debug_log.debug { "#{"contact may be not available otherwise check backend"}"}
    end
    redirect_to action: "index"
    rescue => e
      Rails.logger.custom_log.error { "#{e} contact_controller contact_delete method" }
    end
    
  end 
# this method is to update the selected contact changes
  def contact_update
    
    begin
      
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in  contact_update "

    params.permit!
    data=params["contacts"]
    id=data[:id]
    (params["mail"].present?) ? mail=params["mail"].join(",") :  mail=nil

    if params["cars"]=="Supplier"
        supplier_id=params["contacts"]["supplier_id"]
    elsif params["cars"]=="Manufacturer"
        manufacturer_id=params["contacts"]["manufacturer_id"]
      else
        division_id=params["contacts"]["division_id"]
      end
  

=begin      if params[:division_id].present?
        contact={:contact=>{"name":params[:name],"email":params[:email],"phone_number":params[:phone_number],"landline_number":params[:landline_number],"address":params[:address],"jobs_name_id":data[:jobs_name_id],"jobs_name_type":data[:jobs_name_type],"sub_contact_type": "Division","mail_allocation": mail}}
      elsif params[:manufacturer_id].present?
        contact={:contact=>{"name":params[:name],"email":params[:email],"phone_number":params[:phone_number],"landline_number":params[:landline_number],"address":params[:address],"jobs_name_id":data[:jobs_name_id],"jobs_name_type":data[:jobs_name_type],"sub_contact_type": "Manufacturer","mail_allocation": mail}}
      else
        
        contact = {:contact=>{"name":params[:name],"email":params[:email],"phone_number":params[:phone_number],"landline_number":params[:landline_number],"address":params[:address],"jobs_name_id":data[:jobs_name_id],"jobs_name_type":data[:jobs_name_type],"sub_contact_type": "Supplier","mail_allocation": mail}}

     end 
=end

        contact = {:contact=>{"name":params[:name],"email":params[:email],"phone_number":params[:phone_number],"landline_number":params[:landline_number],"address":params[:address],"jobs_name_id":data[:jobs_name_id],"jobs_name_type":data[:jobs_name_type],"mail_allocation": mail}}

    RestClient.put $api_service+'/contacts/'+id,contact
    redirect_to  :action => "index" #,:id=>data[:id]
    rescue => e
      Rails.logger.custom_log.error { "#{e} contact_controller contact_update method" }
    end
    
  end
# this method is used to post the newly created contact
  def create
    begin   
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in contact create"
      
     params.permit!
     data=params["new contact"]
     (params["mail"].present?) ? mail=params["mail"].join(",") :  mail=nil

       
     if params["division_id"].present?
        contact={:contact=>{"name":params[:name],"email":params[:email],"phone_number":params[:phone_number],"landline_number":params[:landline_number],"address":params[:address],"jobs_name_id":data[:jobs_name_id],"jobs_name_type":data[:jobs_name_type],"sub_contact_id":params[:division_id],"mail_allocation": mail,"sub_contact_type": "Division"}}
      elsif params["manufacturer_id"].present?
        contact={:contact=>{"name":params[:name],"email":params[:email],"phone_number":params[:phone_number],"landline_number":params[:landline_number],"address":params[:address],"jobs_name_id":data[:jobs_name_id],"jobs_name_type":data[:jobs_name_type],"sub_contact_id":params[:manufacturer_id],"mail_allocation": mail,"sub_contact_type": "Manufacturer"}}
  
        else
        contact={:contact=>{"name":params[:name],"email":params[:email],"phone_number":params[:phone_number],"landline_number":params[:landline_number],"address":params[:address],"jobs_name_id":data[:jobs_name_id],"jobs_name_type":data[:jobs_name_type],"sub_contact_id":params[:supplier_id],"mail_allocation": mail,"sub_contact_type": "Supplier"}}

     end            
     contact=RestClient.post $api_service+'/contacts',contact
     redirect_to  :action => "index"
     rescue => e
      Rails.logger.custom_log.error { "#{e} contact_controller create method" }
    end
    
  end  
# this method is to update the selected contact view page 
  def edit
    begin     
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in  contact edit"

    id=params[:id]
    contact=RestClient.get $api_service+'/contacts/'+id
    @contact=JSON.parse contact

    suppliers=RestClient.get $api_service+'/suppliers'
    @supplier_data=JSON.parse suppliers

    if  @supplier_data.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : supplier_data successfully displayed"
    else
    Rails.logger.debug_log.debug { "#{"supplier_data may be not available otherwise check backend"}"}
    end  

    
    manufacturers=RestClient.get $api_service+'/manufacturers'
    @manufacturer_data=JSON.parse manufacturers

    if  @manufacturer_dropdown.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : manufacturer successfully displayed"
    else
    Rails.logger.debug_log.debug { "#{"manufacturer may be not available otherwise check backend"}"}
    end  

    
    divisions=RestClient.get $api_service+'/divisions'
    @division_data=JSON.parse divisions

    if @division_dropdown.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : division successfully displayed"
    else
    Rails.logger.debug_log.debug { "#{"division may be not available otherwise check backend"}"}
    end  

    
    cfas=RestClient.get $api_service+'/cfa_titles'
    @cfa_data=JSON.parse cfas

   if @cfa_data.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : cfa successfully displayed"
    else
    Rails.logger.debug_log.debug { "#{"cfa may be not available otherwise check backend"}"}
    end  


    
    marketing=RestClient.get $api_service+'/marketing_titles'
    @marketing_data=JSON.parse marketing

   if @marketing_data.present?
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : marketing successfully displayed"
    else
    Rails.logger.debug_log.debug { "#{"marketing may be not available otherwise check backend"}"}
    end  

    if @contact["sub_contact_type"] == "Supplier"
      @contact["supplier_id"]=@contact["sub_contact_id"]
     elsif  @contact["sub_contact_type"] == "Manufacturer"
      @contact["manufacturer_id"]=@contact["sub_contact_id"]
      id=@contact["sub_contact_id"]
      manu=RestClient.get $api_service+'/manufacturers/'+id.to_s
      data=JSON.parse manu
      @contact["supplier_id"]=data["supplier_id"]
      else
     @contact["division_id"]=@contact["sub_contact_id"]
     id=@contact["sub_contact_id"]
     divi= RestClient.get $api_service+'/divisions/'+id.to_s
     data=JSON.parse divi
     
     @contact["manufacturer_id"]=data["manufacturer_id"]
     @contact["supplier_id"]=data["supplier_id"]
    end 
    rescue => e
      Rails.logger.custom_log.error { "#{e} contact_controller contact_edit method" }
    end
    
      
  end
# to display the selected contacts
  def show
         Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in  contact show"
    begin      
    
    id=params[:id]
    contact=RestClient.get $api_service+'/contacts'+id 
    @contact=JSON.parse contact

    unless @contact.present?
      Rails.logger.debug_log.debug { "#{"contact may be not available otherwise check backend"}"}
    end
    
    rescue => e
      Rails.logger.custom_log.error { "#{e} contact_controller show method" }
    end
    
    
  end
# to get supplier wise manufacturer
  def dynamic_manufacturer
    begin
      
    manufacturers=RestClient.get $api_service+'/suppliers/supplier_manufacturer?supplier_id='+params["format"]
    @manufacturer_dropdown=JSON.parse manufacturers

    unless @manufacturer_dropdown.present?
      Rails.logger.debug_log.debug { "#{"contact may be not available otherwise check backend"}"}
    end
    
    rescue => e
      Rails.logger.custom_log.error { "#{e} ContactsController dynamic_manufacturer method" }
    end
    
    
  end  
# to get the manufacturer wise division
  def dynamic_division   
    begin 
    
    divisions=RestClient.get $api_service+'/manufacturers/manufacturer_division?manufacturer_id='+params["format"]
    @division_dropdown=JSON.parse divisions

    unless @division_dropdown.present?
    Rails.logger.debug_log.debug { "#{"contact may be not available otherwise check backend"}"}
    end
  

    rescue => e
      Rails.logger.custom_log.error { "#{e} contact_controller dynamic_division method" }
    end
    
    
  end  
# to get the cfa and marketting details for contact creation and updation
def cfa_radio_dropdown  
  
  begin 

     if params["format"].to_s == "CfaTitle"
    cfas=RestClient.get $api_service+'/cfa_titles'
    @cfa_data=JSON.parse cfas
         
   else
    cfas=RestClient.get $api_service+'/marketing_titles'
    @cfa_data=JSON.parse cfas
    
   end 

   rescue => e
      Rails.logger.custom_log.error { "#{e} contact_controller cfa_radio_dropdown method" }
    end
    
end  
# filter the contacts based on contact types

def sup_man_div_based_contacts
  begin  

  if params[:supplier_id].present?
      contacts=RestClient.get $api_service+'/suppliers/supplier_contact?supplier_id='+params[:supplier_id]
      names=RestClient.get $api_service+'/suppliers/'+params[:supplier_id]
      name=JSON.parse names
      @name=name["supplier_name"]
      @contact_data=JSON.parse contacts
      @identify="supplier"
   elsif params[:manufacturer_id].present?
      contacts=RestClient.get $api_service+'/manufacturers/manufacturer_contact?manufacturer_id='+params[:manufacturer_id]
      names=RestClient.get $api_service+'/manufacturers/'+params[:manufacturer_id]
      name=JSON.parse names
      @name=name["manufacturer_name"]
      @contact_data=JSON.parse contacts
      @identify="manufacturer"
  else
      contacts=RestClient.get $api_service+'/divisions/division_contact?division_id='+params[:division_id]
      names=RestClient.get $api_service+'/divisions/'+params[:division_id]
      name=JSON.parse names
      @name=name["div_name"]
      @contact_data=JSON.parse contacts
      @identify="division"
  end 
  
  
   rescue => e
      Rails.logger.custom_log.error { "#{e} contact_controller  sub_man_div_basedmethod" }
    end
  
 end  
 # this is to edit the contacts which have been selected for view page

 def contact_edit 
     begin

   
    id=params[:format]
    contact=RestClient.get $api_service+'/contacts/'+id
    @contact=JSON.parse contact
      unless @contact.present?
      Rails.logger.debug_log.debug { "#{"contact may be not available otherwise check backend"}"}
    end
  
    cfas=RestClient.get $api_service+'/cfa_titles'
    @cfa_data=JSON.parse cfas  

    unless @cfa_data.present?
    Rails.logger.debug_log.debug { "#{"cfa may be not available otherwise check backend"}"}
    end
  

    marketing=RestClient.get $api_service+'/marketing_titles'
    @marketing_data=JSON.parse marketing

     unless @marketing_data.present?
     Rails.logger.debug_log.debug { "#{"marketing_titles may be not available otherwise check backend"}"}
    end
  
     rescue => e
      Rails.logger.custom_log.error { "#{e} contact_controller contact_edit method" }
    end
  
    
 end 
# to put the contact updates to back end
 def contact_edit_update
     begin
      
    params.permit!
    data=params["contacts"]
    contact_id=data[:id]
    contact= {contact:{"name":data[:name],"email":data[:email],"phone_number":data[:phone_number],"address":data[:address],"jobs_name_id"=>data[:jobs_name_id],"jobs_name_type"=>data["jobs_name_type"]}}
    contacts=RestClient.put $api_service+'/contacts/'+contact_id,contact
    contact_response=JSON.parse contacts

    unless contact_response.present?
    Rails.logger.debug_log.debug { "#{"contact may be not available otherwise check backend"}"}
    end
  
    
    if "Supplier" == contact_response["sub_contact_type"]
       redirect_to :action=>"sup_man_div_based_contacts",:supplier_id=>contact_response["sub_contact_id"]
    elsif "Manufacturer" == contact_response["sub_contact_type"]
      redirect_to :action=>"sup_man_div_based_contacts",:manufacturer_id=>contact_response["sub_contact_id"]
     else
      redirect_to :action=>"sup_man_div_based_contacts",:division_id=>contact_response["sub_contact_id"]
     end
     rescue => e
      Rails.logger.custom_log.error { "#{e} contact_controller contact_edit_update method" }
    end
  


 end 

# filter the contacts based on contact type like supplier , manufaturer and divisions
def contacts_selection 
  begin

   if params[:format]=="Supplier"
    @suppliers= JSON.parse(RestClient.get $api_service+'/suppliers/')
 elsif params[:format]=="Manufacturer"
    @manufacturers=JSON.parse (RestClient.get $api_service+'/manufacturers/')
 else
    @divisions=JSON.parse (RestClient.get $api_service+'/divisions/')
  end 
  rescue => e
      Rails.logger.custom_log.error { "#{e} contact_controller contacts_selection method" }
    end
  
end

# get the specific contacts by contact type
def selection_update 
  begin
   
   @contacts_selection=JSON.parse(RestClient.get $api_service+"/contacts/#{params["format"]}")

   unless @contacts_selection.present?
    Rails.logger.debug_log.debug { "#{"contact may be not available otherwise check backend"}"}
    end
   


   if params["type"]=="Supplier"
    @suppliers= JSON.parse(RestClient.get $api_service+'/suppliers/')
 elsif params["type"]=="Manufacturer"
    @manufacturers=JSON.parse (RestClient.get $api_service+'/manufacturers/')
 else
    @divisions=JSON.parse (RestClient.get $api_service+'/divisions/')
  end 

  rescue => e
      Rails.logger.custom_log.error { "#{e} contact_controller selection_update method" }
    end
  

end

# to upload the file for bulk contact update
def file_download

file={"file":params["contacts"]["file"]}
begin
  contact=RestClient.post $api_service+'/contacts/file_upload',file
  if contact.present?
   result=JSON.parse contact
  end
  redirect_to action: "index"
  flash[:notice]="SuceesFully Uploaded"
rescue => e
  redirect_to action: "index"
  flash[:notice]="Something went wrong while uploading file, Check input data format"
end



end
# download the contacts using csv
def csv_sheet
  
  contacts=RestClient.get $api_service+'/contacts'
  @contacts=(JSON.parse contacts)


  p = Axlsx::Package.new

    sheet = p.workbook.add_worksheet(:name => "Customer Report")
    title = sheet.styles.add_style(:fg_color=>"#FF000000",:b => true,:alignment=>{:horizontal => :center})

    sheet.add_row ["Name", "Email", "Mobile No", "Contact type", "Supplier/Manufacturer/Division", "Title(Cfa Title/Marketing Title)", "Title Name" ], :style=>title
    @contacts.map  do |i| 
        if i["sub_contact_type"] =="Supplier"
          type=i["sub_contact"]["supplier_name"]
        elsif i["sub_contact_type"]=="Manufacturer"
          type= i["sub_contact"]["manufacturer_name"]
        else 
          type=i["sub_contact"]["div_name"]
        end
        sheet.add_row [i["name"], i["email"],i["phone_number"], i["sub_contact_type"],type,i["jobs_name_type"],i["jobs_name"]["job_name"]] 
    end
    path = "#{Rails.root}/public/contact_report.xlsx"
    p.serialize(path)
    send_file path  
    
  
end



end
