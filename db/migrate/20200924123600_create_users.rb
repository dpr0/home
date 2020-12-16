# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :name
      t.string :email
      t.string :phone
      t.string :provider
      t.string :token
      t.boolean :admin

      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.timestamps null: false
    end
  end
end
