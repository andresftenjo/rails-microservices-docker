class CreateAuditEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :audit_events do |t|
      t.string :entity_type
      t.string :entity_id
      t.string :action
      t.string :status
      t.text :message

      t.timestamps
    end
  end
end
