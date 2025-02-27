class CreateSolidCableDashboardEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :solid_cable_dashboard_events do |t|
      t.string :event_type, null: false
      t.string :channel
      t.integer :channel_hash, limit: 8, null: false
      t.integer :byte_size, limit: 4
      t.text :payload
      t.float :duration
      t.datetime :created_at, null: false
      
      t.index [:event_type]
      t.index [:channel_hash]
      t.index [:created_at]
    end
  end
end
