class AddServiceRequestFields < ActiveRecord::Migration
  def self.up
    add_column :service_requests, :token,:string
    add_column :service_requests, :service_id,:string
    add_column :service_requests, :service_code,:string
    add_column :service_requests, :aid,:string
    add_column :service_requests, :fields,:text
    add_column :service_requests, :phone_number,:string
    add_column :service_requests, :email,:string
    add_column :service_requests, :description,:text
  end

  def self.down
  end
end
