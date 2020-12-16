# frozen_string_literal: true

class CreateCapabilities < ActiveRecord::Migration[6.0]
  def change
    create_table :capabilities do |t|
      t.integer :device_id
      t.boolean :enabled
      t.boolean :retrievable
      t.string  :capability_type
      t.string  :state
      t.string  :state_instance
      t.integer :state_value

      t.timestamps
    end
  end
end
