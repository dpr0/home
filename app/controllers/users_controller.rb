# frozen_string_literal: true

class UsersController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :doorkeeper_authorize! # -> { doorkeeper_authorize! :read, :write }

  def index
    head(:ok)
  end

  def show; end

  def unlink
    render_status({})
  end

  def devices
    render_status(user_id: current_user.id.to_s, devices: Device.user_devices(current_user.id))
  end

  def query
    render_status(devices: Device.user_query(current_user.id))
  end

  def action
    user_devices = Device.eager_load(:capabilities).where(user_id: current_user.id).all
    devices_response = (params.dig(:payload, :devices) || []).map do |d|
      ud = user_devices.find(d[:id]) # user_device
      {
        id: d[:id],
        custom_data: {},
        capabilities: d[:capabilities].map do |cap|
          dc = ud.capabilities.find_by(capability_type: cap[:type]) # device_capability
          dc.update(status: cap[:state][:value])
          resp = RestClient.post("http://#{ud.host}:#{ud.port}/#{dc.path}", { pin: dc.pin, status: cap[:state][:value] }.to_json)
          # response = JSON.parse(resp.body)
          { type: cap[:type], state: { instance: dc.state_instance, action_result: { status: resp.code == 200 ? 'DONE' : 'ERROR' } } }
        end
      }
    end
    render_status(devices: devices_response)
  end

  private

  def current_user
    @user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def render_status(payload = {})
    json = { request_id: request.headers['X-Request-Id'], payload: payload }
    Rails.logger.info JSON.pretty_generate(json)
    render status: :ok, json: json
  end
end
