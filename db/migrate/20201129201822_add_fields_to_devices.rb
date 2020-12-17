# frozen_string_literal: true

class AddFieldsToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices,      :host,   :string
    add_column :devices,      :port,   :integer
    add_column :capabilities, :path,   :string
    add_column :capabilities, :pin,    :integer
    add_column :capabilities, :status, :boolean
  end
end
