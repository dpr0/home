# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :trackable, :recoverable, :rememberable,
         :validatable, :omniauthable, omniauth_providers: [:github, :yandex, :telegram, :firebase]
  has_many :access_grants, class_name: 'Doorkeeper::AccessGrant', foreign_key: :resource_owner_id, dependent: :delete_all
  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken', foreign_key: :resource_owner_id, dependent: :delete_all
  has_many :authorizations, dependent: :destroy
  has_many :devices, dependent: :destroy

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth[:provider], uid: auth[:uid]).first
    return authorization.user if authorization

    user = User.where(email: auth[:email], provider: auth[:provider]).first
    user ||= User.create!(auth)
    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth[:provider], uid: auth[:uid])
  end
end
