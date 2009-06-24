class CreateServiceRequests < ActiveRecord::Migration
  def self.up
    create_table :service_requests do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :service_requests
  end
end
