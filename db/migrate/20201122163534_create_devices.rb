# frozen_string_literal: true

class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.integer :user_id
      t.boolean :enabled
      t.string :name
      t.string :description
      t.string :room
      t.string :device_type
      t.string :manufacturer
      t.string :model
      t.string :hw_version
      t.string :sw_version

      t.timestamps null: false
    end
  end
end
