class CreatePhoneCallers < ActiveRecord::Migration
  def self.up
    create_table :phone_callers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :phone_callers
  end
end
