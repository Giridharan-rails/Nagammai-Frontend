class AppointmentsController < ApplicationController

# the below method is to dispplay the appointment list based on date filter and contact type
  def index
     add_breadcrumb "Appointments", :appointments_path  
    begin
     Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in appointments index page"
     
     #unless params["to_date"].nil?

      @from_date=params["from_date"].present? ? params["from_date"] : (Date.today).strftime("%d-%m-%Y")
      @to_date=params["to_date"].present? ? params["to_date"] : (Date.today+4.days).strftime("%d-%m-%Y")
      @type=params["type_base"]
      @data=params["data"]
       @all_appointments=(JSON.parse RestClient.get $api_service+"/appointments/appoint_filter?from_date=#{@from_date}&to_date=#{@to_date}&type_base=#{@type}")
     #else      
     #  @all_appointments =(JSON.parse RestClient.get $api_service+'/appointments/appointment_index')#.paginate(page: params[:page], per_page: 15)
     #end
   
     rescue =>e
     Rails.logger.custom_log.error { "#{e} AppointmentsController index method" }
     end

  end
# this method is to create new appointments.It creates both appointments and claim issues
  def new

    begin
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in appointments new page"
    @appointment = "new appointment"
    @claim_issue = "new claim_issue"
    @manufacturers=[]
    @divisions=[]
    @claims=[]
    @claim_issues=[]
    @contacts = []
    @history=[]
    @suppliers = JSON.parse RestClient.get $api_service+'/suppliers'
    unless  @suppliers.present?
    Rails.logger.debug_log.debug { "#{"suppliers may be not available otherwise check backend"}"}
    end
    @all_appointments = JSON.parse RestClient.get $api_service+'/appointments/appointment_index'
    unless  @all_appointments.present?
    Rails.logger.debug_log.debug { "#{"appointments may be not available otherwise check backend"}"}
    end
    rescue =>e
     Rails.logger.custom_log.error { "#{e} AppointmentsController new method" }
     end
    add_breadcrumb "Appointments", :appointments_path  
    add_breadcrumb "New Appointments", :new_appointment_path
  end
# this method for dependent dropdowns for contact types supplier,manufacturer and divisions
  def fetch_manufacturer
    begin
      Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in appointments fetch_manufacturer"
         #@contacts = []
         #@history = []
      if params["format"].present?
        @users=JSON.parse RestClient.get $api_service+'/users'
        puts "===from => #{params[:from]}"
         case params["type"]
              when "supplier_id"
                  if params[:from] == "index"
                   @division=JSON.parse RestClient.get $api_service+'/suppliers/supplier_manufacturer?supplier_id='+params[:format]
                  else                    
                   @contacts= JSON.parse RestClient.get $api_service+'/suppliers/supplier_contact?supplier_id='+params[:format]
                   @history =(JSON.parse RestClient.get $api_service+'/appointments/supplier_histroy?supplier_id='+params[:format])
                   #@manufacturers=JSON.parse RestClient.get $api_service+'/suppliers/supplier_manufacturer?supplier_id='+params[:format]

                   @claims=JSON.parse RestClient.get $api_service+'/suppliers/supplier_claims?supplier_id='+params[:format]
                   @division=JSON.parse RestClient.get $api_service+'/suppliers/supplier_manufacturer?supplier_id='+params[:format]
             
                   @claim_issues=JSON.parse RestClient.get $api_service+'/suppliers/supplier_claim_issue?supplier_id='+params[:format]
                   @manufacturers=[] if @manufacturers[0]["response"].present?
                   @divisions=[]
                  end
                   
                   
              when "manufacturer_id"
                    @contacts = JSON.parse RestClient.get $api_service+'/manufacturers/manufacturer_supplier_contact?manufacturer_id='+params[:format]
                    @history = (JSON.parse RestClient.get $api_service+'/appointments/supplier_histroy?manufacturer_id='+params[:format])
                    @divisions=JSON.parse RestClient.get $api_service+'/manufacturers/manufacturer_division?manufacturer_id='+params[:format]
                    @divisions=[] if @divisions[0]["response"].present?
                    #@claim_issues=JSON.parse RestClient.get $api_service+'/appointments/manufacturer_appointment_issue?manufacturer_id='+params[:format]
                    @claims=JSON.parse RestClient.get $api_service+'/appointments/appointment_pending_claims?manufacturer_id='+params[:format]
              when "division_id"    
                    @contacts = JSON.parse RestClient.get $api_service+'/divisions/division_manufacturer_supplier_contact?division_id='+params[:format]
                    
                    @claims=JSON.parse RestClient.get $api_service+'/divisions/division_claims?division_id='+params[:format]
                    @history = (JSON.parse RestClient.get $api_service+'/appointments/supplier_histroy?division_id='+params[:format])
                    @claim_issues=JSON.parse RestClient.get $api_service+'/appointments/division_appointment_issue?division_id='+params[:format]
                    @divisions="not shake"
              end      
         end  
         if params[:appointment_id].present?
            @appointment = JSON.parse RestClient.get $api_service+'/appointments/'+params[:appointment_id]  
         end

        rescue =>e
             Rails.logger.custom_log.error { "#{e} AppointmentsController fetch_manufacturer method" }
        end
  end

#this method is to get pending claims while selecting contact type from appointment create, edit and view
  def pending_claim_issue
    if params["type"] == "manufacturer_id"
        @claims=JSON.parse RestClient.get $api_service+'/appointments/appointment_pending_claims?manufacturer_id='+params[:format]
        
    else
       @claims=JSON.parse RestClient.get $api_service+'/appointments/appointment_pending_claims?division_id='+params[:format]
    end
  end  

# this method is to post the appointments created
  def create
    
      begin
        Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in appointments create page"
        params.permit!
        appointment = params["new appointment"]
        unless  params["contacts_ids"].nil?
           contacts_ids = params["contacts_ids"].map(&:to_i).join(",")
        else
           contacts_ids = nil
        end
        appoint_time = appointment["appoint_time(4i)"]+":"+appointment["appoint_time(5i)"]    
        appointment = {:appointment => {"appoint_date" => params["appoint_date"], "appoint_time" => appoint_time, "contacts_ids" => contacts_ids, "appoint_note" => appointment["appoint_note"], "division_id" => params["division_id"]}, :claim_issue => {"description" => params["description"], "contact_id" => params["contact_id"], "cut_off_date" => params["cut_off_date"], "status" => params["status"], "notes" => params["notes"] }}
        if  params["division_id"].present?  
           appointment[:additional] =  {app_contact_type: "Division" ,app_contact_id: params["division_id"],supplier_id:params["supplier_id"]} 
        elsif params["manufacturer_id"].present?
           appointment[:additional] = {app_contact_type: "Manufacturer" ,app_contact_id: params["manufacturer_id"]}
        else 
           appointment[:additional] = {app_contact_type: "Supplier" ,app_contact_id: params["supplier_id"]}
        end  
        appointment = RestClient.post $api_service+'/appointments',appointment
        redirect_to :action => "index"
      rescue =>e
        Rails.logger.custom_log.error { "#{e} AppointmentsController create method" }
      end
  end
# this method for appointment create
  def edit
    users=RestClient.get $api_service+'/users'
    @users=JSON.parse users
    @appoin="edit appointment"
    id = params[:id]
    @appointment = JSON.parse RestClient.get $api_service+'/appointments/'+id  
    if @appointment["contacts_ids"].present?
        @contacts_ids=@appointment["contacts_ids"].split(",")
    else
      @contacts_ids=@appointment["contacts_ids"].to_a
      end
    @suppliers = JSON.parse RestClient.get $api_service+'/suppliers'   

    unless  @suppliers.present?
    Rails.logger.debug_log.debug { "#{"suppliers may be not available otherwise check backend"}"}
    end

    #@divisions = JSON.parse RestClient.get $api_service+'/divisions'
   # unless @divisions.present?
    #Rails.logger.debug_log.debug { "#{"divisions may be not available otherwise check backend"}"}
    #end

   #@manufacturers = JSON.parse RestClient.get $api_service+'/manufacturers'
    #unless @manufacturers.present?
    #Rails.logger.debug_log.debug { "#{"manufacturers may be not available otherwise check backend"}"}
    #end

    @current_claim=@appointment["claim_issues"]
    case @appointment["app_contact_type"]
      when "Supplier"
          @claim_issues=JSON.parse RestClient.get $api_service+"/suppliers/supplier_claim_issue?supplier_id=#{@appointment["app_contact_id"]}"
          @claims=JSON.parse RestClient.get $api_service+"/suppliers/supplier_claims?supplier_id=#{@appointment["app_contact_id"]}"
          @contacts = JSON.parse RestClient.get $api_service+"/suppliers/supplier_contact?supplier_id=#{@appointment["app_contact_id"]}"
          @history =(JSON.parse RestClient.get $api_service+'/appointments/supplier_histroy?supplier_id='+"#{@appointment["app_contact_id"]}")
      when "Manufacturer"
         #@claim_issues=JSON.parse RestClient.get $api_service+"/appointments/manufacturer_appointment_issue?manufacturer_id=#{@appointment["app_contact_id"]}"
         #@claims=JSON.parse RestClient.get $api_service+"/manufacturers/manufacturer_claims?manufacturer_id=#{@appointment["app_contact_id"]}"
         #@contacts = JSON.parse RestClient.get $api_service+"/manufacturers/manufacturer_supplier_contact?manufacturer_id=#{@appointment["app_contact_id"]}"
         #@history = (JSON.parse RestClient.get $api_service+"/appointments/supplier_histroy?manufacturer_id=#{@appointment["app_contact_id"]}")
         #@manufacturers = JSON.parse RestClient.get $api_service+"/manufacturers/manufacturer_base_manufacturers?manufacturer_id=#{@appointment["app_contact_id"]}"
         #@manufacturers=[] if @manufacturers[0]["response"].present?
         #@divisions=JSON.parse RestClient.get $api_service+"/manufacturers/manufacturer_division?manufacturer_id=#{@appointment["app_contact_id"]}"
         #@divisions=[] if @divisions[0]["response"].present?
      when "Division"
         @claim_issues=JSON.parse RestClient.get $api_service+"/appointments/division_appointment_issue?division_id=#{@appointment["app_contact_id"]}"
         @claims=JSON.parse RestClient.get $api_service+"/divisions/division_claims?division_id=#{@appointment["app_contact_id"]}"
         @contacts = JSON.parse RestClient.get $api_service+"/divisions/division_manufacturer_supplier_contact?division_id=#{@appointment["app_contact_id"]}"
         @history = (JSON.parse RestClient.get $api_service+'/appointments/supplier_histroy?division_id='+"#{@appointment["app_contact_id"]}")
         division=JSON.parse RestClient.get $api_service+"/divisions/#{@appointment["app_contact_id"]}"
         manufacturer_id=division["manufacturer_id"]
         @manufacturers = JSON.parse RestClient.get $api_service+"/manufacturers/manufacturer_base_manufacturers?manufacturer_id=#{manufacturer_id}"
         @manufacturers=[] if @manufacturers[0]["response"].present?
        # @divisions=JSON.parse RestClient.get $api_service+"/manufacturers/manufacturer_division?manufacturer_id=#{manufacturer_id}"
         #@divisions=[] if @divisions[0]["response"].present?
       
        divisions=JSON.parse RestClient.get $api_service+"/divisions/#{@appointment["app_contact_id"]}"
        
       @divisions=[]
        @divisions << divisions
      end     
     add_breadcrumb "Appointments", :appointments_path  
     add_breadcrumb "Edit Appointments", :edit_appointment_path
  end 
# this method to put the changes of existing seleted appointments
  def update_appointment
    
    begin
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in appointments update_appointment page"
    params.permit!
    appoint_time = params["appoint_time"].values.last(2)
    appoint_time = appoint_time.first+":"+appoint_time.last
    unless params["contacts_ids"].nil?
    contacts_ids = params["contacts_ids"].map { |e| e.to_i  }.join(",")      
    else
      contacts_ids = nil
    end
    appointment = {:appointment => {"appointment_id" => params["id"], "appoint_date" =>  params["appoint_date"], "appoint_time" => appoint_time, "contacts_ids" => contacts_ids, "appoint_note" =>  params["edit appointment"]["appoint_note"]}, :claim_issue => {"issue_ids" => params["issue_ids"], "description" => params["description"], "contact_id" => params["contact_id"], "cut_off_date" => params["cut_off_date"], "status" => params["status"], "notes"=>params["notes"]}}      

    if params["division_id"].present?  
       appointment[:additional] =  {app_contact_type: "Division" ,app_contact_id: params["division_id"],supplier_id:params["supplier_id"]} 
    elsif params["manufacturer_id"].present?
       appointment[:additional] = {app_contact_type: "Manufacturer" ,app_contact_id: params["manufacturer_id"]}
    else 
       appointment[:additional] = {app_contact_type: "Supplier" ,app_contact_id: params["supplier_id"]}
    end 
    appointment = RestClient.post $api_service+'/appointments/appointment_update',appointment
    redirect_to  :action => "index"

    rescue =>e
     Rails.logger.custom_log.error { "#{e} AppointmentsController update_appointment method" }
     end
  end
# this method to show the selected appointment
  def show
    begin
    Rails.logger.info_log.info  " I,[#{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}]" "INFO -- : Entered in appointments show page"
    id = params[:id]
    @appointment = JSON.parse RestClient.get $api_service+'/appointments/'+id  

     if @appointment["contacts_ids"].present?
        @contacts_ids=@appointment["contacts_ids"].split(",")
    else
      @contacts_ids=@appointment["contacts_ids"].to_a
      end
    @suppliers = JSON.parse RestClient.get $api_service+'/suppliers'   
    unless  @suppliers.present?
    Rails.logger.debug_log.debug { "#{"suppliers may be not available otherwise check backend"}"}
    end

    @divisions = JSON.parse RestClient.get $api_service+'/divisions'
    unless @divisions.present?
    Rails.logger.debug_log.debug { "#{"divisions may be not available otherwise check backend"}"}
    end

    #@manufacturers = JSON.parse RestClient.get $api_service+'/manufacturers'
    unless @manufacturers.present?
    Rails.logger.debug_log.debug { "#{"manufacturers may be not available otherwise check backend"}"}
    end
    @current_claim=@appointment["claim_issues"]

    case @appointment["app_contact_type"]
         when "Supplier"
         @claim_issues=JSON.parse RestClient.get $api_service+"/suppliers/supplier_claim_issue?supplier_id=#{@appointment["app_contact_id"]}"
         @claims=JSON.parse RestClient.get $api_service+"/suppliers/supplier_claims?supplier_id=#{@appointment["app_contact_id"]}"
         @contacts = JSON.parse RestClient.get $api_service+"/suppliers/supplier_contact?supplier_id=#{@appointment["app_contact_id"]}"
         @history =(JSON.parse RestClient.get $api_service+'/appointments/supplier_histroy?supplier_id='+"#{@appointment["app_contact_id"]}")
      when "Manufacturer"
         @claim_issues=JSON.parse RestClient.get $api_service+"/appointments/manufacturer_appointment_issue?manufacturer_id=#{@appointment["app_contact_id"]}"
         @claims=JSON.parse RestClient.get $api_service+"/manufacturers/manufacturer_claims?manufacturer_id=#{@appointment["app_contact_id"]}"
         @contacts = JSON.parse RestClient.get $api_service+"/manufacturers/manufacturer_supplier_contact?manufacturer_id=#{@appointment["app_contact_id"]}"
         @history = (JSON.parse RestClient.get $api_service+'/appointments/supplier_histroy?manufacturer_id='+"#{@appointment["app_contact_id"]}")
         @manufacturers = JSON.parse RestClient.get $api_service+"/manufacturers/#{@appointment["app_contact_id"]}"
         @divisions = JSON.parse RestClient.get $api_service+"/manufacturers/manufacturer_division?manufacturer_id=#{@appointment["app_contact_id"]}"
         @suppliers = JSON.parse RestClient.get $api_service+"/manufacturers/manufacturer_supplier?manufacturer_id=#{@appointment["app_contact_id"]}"
         @suppliers =[@suppliers]
         @manufacturers =[@manufacturers]
      when "Division"

         @claim_issues=JSON.parse RestClient.get $api_service+"/appointments/division_appointment_issue?division_id=#{@appointment["app_contact_id"]}"
         
         @claims=JSON.parse RestClient.get $api_service+"/divisions/division_claims?division_id=#{@appointment["app_contact_id"]}"
       
         @contacts = JSON.parse RestClient.get $api_service+"/divisions/division_manufacturer_supplier_contact?division_id=#{@appointment["app_contact_id"]}"
        
         #@contacts=[]
         @history = (JSON.parse RestClient.get $api_service+'/appointments/supplier_histroy?division_id='+"#{@appointment["app_contact_id"]}")
        # @divisions=JSON.parse RestClient.get $api_service+"/divisions/#{@appointment["app_contact_id"]}"  
         @manufacturers=JSON.parse RestClient.get $api_service+"/divisions/division_manufacturer?division_id=#{@appointment["app_contact_id"]}"  
         #@suppliers= JSON.parse RestClient.get $api_service+"/manufacturers/manufacturer_supplier?manufacturer_id=#{@manufacturers["id"]}"
         #@suppliers =[@suppliers]
         @manufacturers =[@manufacturers]
         #@divisions=[@divisions]
         
      end     
   add_breadcrumb "Appointments", :appointments_path  
   add_breadcrumb "View Appointments", :appointment_path
   rescue =>e
    Rails.logger.custom_log.error { "#{e} AppointmentsController show method" }
   end
  end
# filter the appointments based on date and contact type
  def appoint_filter

    
if params["data"].nil?
    from_date=params["from_date"]
    to_date=params["to_date"]
    type=params["drop_value_select"]
    redirect_to :action=>"index", :from_date=>from_date,:to_date=>to_date,:type_base=>type
else
  from_date=params["from_date"]
    to_date=params["to_date"]
    type=params["drop_value_select"]
    redirect_to :action=>"pending_appointment", :from_date=>from_date,:to_date=>to_date,:type_base=>type,data:params["data"]   
end
   
  end
# this method is to display the missed list.which are not made but scheduled
  def pending_appointment
    add_breadcrumb "Appointments", :appointments_path  
    add_breadcrumb "Missed Appointments", :appointments_pending_appointment_path


    if params["data"].present?
        unless params["to_date"].nil?

      @from_date=params["from_date"]
      @to_date=params["to_date"]
      @type=params["type_base"]
      @data=params["data"]

      @appointment_pending=(JSON.parse RestClient.get $api_service+"/appointments/appoint_filter?from_date=#{@from_date}&to_date=#{@to_date}&type_base=#{@type}&data=#{@data}")
       end


    else

    @appointment_pending=JSON.parse RestClient.get $api_service+"/appointments/pending_appointment"
  end
  end


end
