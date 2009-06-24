class Addstatus < ActiveRecord::Migration
  def self.up
    add_column :service_requests, :status, :text
    add_column :service_requests, :status_updated_at, :timestamp
  end

  def self.down
  end
end
