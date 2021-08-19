class CreateAuditTrails < ActiveRecord::Migration[6.1]
  def change
    create_table :audit_trails do |t|
      t.integer :record_id
      t.string :record_type, limit: 30
      t.string :event, limit: 20
      t.integer :user_id
      t.datetime :created_at
    end
  end
end
