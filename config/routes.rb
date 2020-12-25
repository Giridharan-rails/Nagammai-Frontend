Rails.application.routes.draw do

  resources :tasks
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
  
  post 'sendmails/sendmail_supplier_filter'
  post 'pages/edit_reports'
  post 'contacts/csv_sheet'
  get 'sendmails/rate_claim_preview'
  get 'sendmails/purchase_return_claim_preview'
  get  'sendmails/free_claim_preview'
  get  'sendmails/expiry_claim_preview'
  get  'sendmails/non_findable_claim_preview'
  post 'sendmails/settled_adjust_date_filter'
  post 'sendmails/today_adjust_date_filter'
  post 'sendmails/po_date_filter'
  post 'sendmails/claims_supplier_filter'
  get 'sendmails/supplier_division_filter'
  post 'contacts/file_download'
  get 'sendmails/supplier_man_div_filter'
  post 'sendmails/excess_stock_supplier_filter'
  post 'sendmails/excess_stock_date_filter'
  get 'sendmails/excess_stock_report'
  get 'sendmails/today_adjustment_date_filter'
  get 'sendmails/settled_claims_date_filter'
  get 'sendmails/pending_claims_date_filter'
  get 'issues/filterstatus'
  get 'sendmails/adjustment_details'
  get 'sendmails/pending_claims_report'
  post 'sendmails/pending_claims_report'
  get 'sendmails/rate_change_claims'
  get 'sendmails/non_findable_claims'
  get 'sendmails/purchase_return_claims'
  get 'sendmails/free_discount_claims'
  get 'sendmails/expiry_damage_claims'
  post 'sendmails/adjustment_rate_change'
  get 'sendmails/overall_claims_report'
  post 'sendmails/overall_claims_report'
  get 'sendmails/settled_claims_report'
  post 'sendmails/adjustment_free_discount'
  get 'sendmails/free_discount_adjustment'
  post 'sendmails/adjustment_expiry_damage'
  get 'users/old_password_check'
  get 'users/change_password'
  post 'users/change_password_update'

  get 'sendmails/expiry_damage_adjustment'
  get 'sendmails/rate_change_adjustment'

  get 'sendmails/purchase_order_report'
  get 'sendmails/datewisefilter'
  get 'sendmails/purchase_return_ajustment'
  post 'sendmails/adjustment_po_return'
  get 'sendmails/datadelete'
  get 'appointments/pending_appointment'
  get 'issues/approved_claims_filter'
  get 'issues/approved_claims'
  post 'appointments/appoint_filter'
  post 'issues/datewisefilter'
  get 'appointments/pending_claim_issue'
  get 'appointments/history'
  get 'pages/dashboard'
  get 'pages/reports'
  post 'pages/reports'
  get 'divisions/display'
  get 'products/index'
  get 'issues/index'
  get 'sendmails/pogr_mismatch'

  get 'sop_reports/index'
  post 'issues/issue_update'

    get 'contacts/contacts_selection'

  get 'map_pogr' => 'pogrs#map_pogr'
  post 'map_pogr' => 'pogrs#map_pogr'
  
  get 'pogrs' => 'pogrs#index'
  post 'pogrs' => 'pogrs#index'
  get 'send_pogr' => 'pogrs#send_pogr'
  post 'send_pogr' => 'pogrs#send_pogr'

  get 'pogr_compare' => 'pogrs#pogr_compare'
  post 'pogr_compare' => 'pogrs#pogr_compare'
  get 'claims/rate_change'
  get 'claims/expiry_damage'

  get 'claims/rate_change_claim'
  get 'claims/expiry_damage_claim'
  get 'claims/free_discounts_claim'


  #get 'claims/expiry_damage'
  get 'claims/closed_claim_filter'
  get 'claims/settled_claim_filter'  
  get 'claims/datefilter'
  get 'pending_claims' => 'claims#pending_claims'
  get 'sops/dynamic_sop'
  post 'sops/issue_update'
  post 'goods_receipts/compare'
  post 'appointments/update_appointment'  
  get 'appointments/fetch_manufacturer'
  get 'suppliers/_form'
  delete 'suppliers/supplier_delete'
  post 'suppliers/supplier_update'
  delete 'manufacturers/manufacturer_delete'
  post 'manufacturers/manufacturer_update'
  delete 'divisions/division_delete'
  post 'divisions/division_update'
  get 'divisions/dynamic_manufacturer'
  delete 'contacts/contact_delete'
  post 'contacts/contact_update'
  get 'contacts/dynamic_manufacturer'
  get 'contacts/dynamic_division'
  get 'contacts/sup_man_div_based_contacts'
  get 'contacts/contact_edit'
  post 'contacts/contact_edit_update'
  get 'contacts/contact_edit_update'
 # post 'users/login'
  get 'users/login'
  get 'users/user_assign'
  post 'users/login_create'
  get 'users/new'
  get 'users/_form'
  delete 'users/delete'
  post 'users/user_update'
  post 'users/user_supplier'  
  delete 'sops/sop_delete'
  post 'sops/sop_update'
  get 'sops/products_view'
  get 'sops/issue_closed_reopened'
  get 'sops/offers_claims_report'
  get 'sops/offers_claims_report_pdf'
  get 'contacts/cfa_radio_dropdown'
  delete 'cfas/cfa_delete'
  post 'cfas/cfa_update'
  delete 'marketings/marketing_delete'
  post 'marketings/marketing_update'
  delete 'payment_terms/payment_term_delete'
  post 'payment_terms/payment_term_update'
  get 'users/logout'  
  get 'syncsettings/sync_setting_page'
  get 'sops/div_supplier_manufacture'
  get 'syncsettings/wondersoft'
  
  post 'syncsettings/wondersoft_create'
  put 'syncsettings/wondersoft_edit'

get 'emails/download'
#post 'emails/download'

get 'wondersofts/wondersoft'
  
  post 'wondersofts/wondersoft_create'
  put 'wondersofts/wondersoft_edit'




  get 'syncsettings/nagammai'
  post 'syncsettings/nagammai_create'
  put 'syncsettings/nagammai_edit'
  get 'sendmails/_form'
 get 'sendmails/sendmail_setting_page'
 get 'sendmails/order_details'
  get 'sendmails/pogr_details'
 post 'syncsettings/sync_setting_update'
 post 'receivemails/receivemail_update'
 get 'receivemails/receive_setting_page'
 post 'sendmails/sendmail_update'
 post 'receivemails/receivemail_update'
 get 'receivemails/receive_setting_page'
 post 'sendmails/sendmail_update'
 get 'sendmails/sendmail_redirect_page'
 get 'sendmails/sendmail_purchase_order_page'
 match "sendmails/sendmail_purchase_order_page" => "sendmails#sendmail_purchase_order_page", via: [:get, :post]
 get 'sendmails/sendmails_excess_stock'
 get 'sendmails/sendmails_claims_discount'
 get 'sendmails/sendmails_claims_rate_change'
 get 'sendmails/sendmails_claims_broken_damage'
  get 'sendmails/sendmails_claims_purchase_return'

  post 'sendmails/purchase_order_assign'
  post 'sendmails/pogr_mismatch_assign'
  post 'sendmails/excess_stock_assign'
  post 'sendmails/freeanddiscount_assign'
  post 'sendmails/expiryanddamage_assign'
  post 'sendmails/purchasereturn_assign'
  post 'sendmails/ratechange_assign'
  post 'sendmails/purchasereturn_assign'
  post 'goods_receipts/to_date'
  get 'emails/email_assign'
   post 'emails/email_update'
   get 'emails/suppliers_list'

     get 'claims/settled_claim'
  get 'claims/closed_claim'
  post 'claims/date_report'
  post 'claims/date_report1'
  get 'manufacturers/manufacturer_list'
get 'users/dashboard'
get 'contacts/_contact'
get 'contacts/selection_update'
get 'claims/free_discounts'
get 'claims/purchase_return_claim'




 
  resources :claims
  resources :appointments
  resources :users
  resources :suppliers
  resources :manufacturers
  resources :divisions
  resources :sops
  resources :contacts
  resources :cfas
  resources :marketings
  resources :payment_terms
  resources :syncsettings
  resources :sendmails
  resources :receivemails
  resources :emails
  resources :goods_receipts
  resources :claim_issues
  root :to => "users#login"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
