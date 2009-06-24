class AddShush < ActiveRecord::Migration
  def self.up
    add_column :service_requests,:is_silenced,:boolean,:default=>false
  end

  def self.down
  end
end
