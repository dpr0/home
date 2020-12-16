# frozen_string_literal: true

class Capability < ApplicationRecord
  belongs_to :device

  TYPES = [
    ['devices.capabilities.on_off',        'Вкл/выкл.'],
    ['devices.capabilities.color_setting', 'Управление цветом.'],
    ['devices.capabilities.mode',          'Переключение режимов работы устройства.'],
    ['devices.capabilities.range',         'Яркость, громкость, температура.'],
    ['devices.capabilities.toggle',        'Вкл/выкл доп. функций.']
  ].freeze

end
