# frozen_string_literal: true

class Device < ApplicationRecord
  has_many :capabilities, inverse_of: :device
  accepts_nested_attributes_for :capabilities, reject_if: :all_blank, allow_destroy: true
  belongs_to :user

  TYPES = [
    ['devices.types.light',                 'Лампочка, светильник, люстра.'],
    ['devices.types.socket',                'Розетка.'],
    ['devices.types.switch',                'Выключатель, реле.'],
    ['devices.types.thermostat',            'Водонагреватель, теплый пол, обогреватель, электровентилятор.'],
    ['devices.types.thermostat.ac',         'Кондиционер.'],
    ['devices.types.media_device',          'Аудио, видео, мультимедиа техника.'],
    ['devices.types.media_device.tv',       'Телевизор, ИК-пульт от телевизора'],
    ['devices.types.media_device.tv_box',   'ИК-пульт от тв-приставки, тв-приставка.'],
    ['devices.types.media_device.receiver', 'ИК-пульт от ресивера, ресивер.'],
    ['devices.types.cooking',               'Различная умная кухонная техника.'],
    ['devices.types.cooking.coffee_maker',  'Кофеварка, кофемашина.'],
    ['devices.types.cooking.kettle',        'Чайник.'],
    ['devices.types.cooking.multicooker',   'Мультиварка.'],
    ['devices.types.openable',              'Дверь, ворота, окно, ставни.'],
    ['devices.types.openable.curtain',      'Шторы, жалюзи.'],
    ['devices.types.humidifier',            'Увлажнитель воздуха.'],
    ['devices.types.purifier',              'Очиститель воздуха.'],
    ['devices.types.vacuum_cleaner',        'Робот-пылесос.'],
    ['devices.types.washing_machine',       'Стиральная машина.'],
    ['devices.types.dishwasher',            'Посудомоечная машина.'],
    ['devices.types.iron',                  'Утюг, парогенератор.'],
    ['devices.types.sensor',                'Датчик температуры, влажности, открытия двери, движения.'],
    ['devices.types.other',                 'Остальные устройства.']
  ].freeze

  PINS = [
    { id:  1, bg: 'warning',   num: nil, comment: '3v3'       }, { id:  2, bg: 'danger',    num: nil, comment: '5v0'       },
    { id:  3, bg: 'primary',   num: 2,   comment: 'SDA'       }, { id:  4, bg: 'danger',    num: nil, comment: '5v0'       },
    { id:  5, bg: 'primary',   num: 3,   comment: 'SCL'       }, { id:  6, bg: 'secondary', num: nil, comment: 'GND'       },
    { id:  7, bg: 'success',   num: 4,   comment: 'GPCLK0'    }, { id:  8, bg: 'light',     num: 14,  comment: 'TXD'       },
    { id:  9, bg: 'secondary', num: nil, comment: 'GND'       }, { id: 10, bg: 'light',     num: 15,  comment: 'RXD'       },
    { id: 11, bg: 'success',   num: 17,  comment: 'SPI CE1'   }, { id: 12, bg: 'success',   num: 18,  comment: 'SPI CE0'   },
    { id: 13, bg: 'success',   num: 27,  comment: '-'         }, { id: 14, bg: 'secondary', num: nil, comment: 'GND'       },
    { id: 15, bg: 'success',   num: 22,  comment: '-'         }, { id: 16, bg: 'success',   num: 23,  comment: '-'         },
    { id: 17, bg: 'warning',   num: nil, comment: '3v3'       }, { id: 18, bg: 'success',   num: 24,  comment: '-'         },
    { id: 19, bg: 'info',      num: 10,  comment: 'SPI0 MOS'  }, { id: 20, bg: 'secondary', num: nil, comment: 'GND'       },
    { id: 21, bg: 'info',      num: 9,   comment: 'SPI0 MISO' }, { id: 22, bg: 'success',   num: 25,  comment: '-'         },
    { id: 23, bg: 'info',      num: 11,  comment: 'SPI0 SCLK' }, { id: 24, bg: 'info',      num: 8,   comment: 'SPI0 CE0'  },
    { id: 25, bg: 'secondary', num: nil, comment: 'GND'       }, { id: 26, bg: 'info',      num: 7,   comment: 'SPI0 CE1'  },
    { id: 27, bg: 'primary',   num: 0,   comment: 'ID_SD'     }, { id: 28, bg: 'primary',   num: 1,   comment: '-'         },
    { id: 29, bg: 'success',   num: 5,   comment: '-'         }, { id: 30, bg: 'secondary', num: nil, comment: 'GND'       },
    { id: 31, bg: 'success',   num: 6,   comment: '-'         }, { id: 32, bg: 'success',   num: 12,  comment: 'PWM0'      },
    { id: 33, bg: 'success',   num: 13,  comment: 'PWM1'      }, { id: 34, bg: 'secondary', num: nil, comment: 'GND'       },
    { id: 35, bg: 'info',      num: nil, comment: 'SPI1 MISO' }, { id: 36, bg: 'success',   num: 16,  comment: 'SPI1 CE2'  },
    { id: 37, bg: 'success',   num: 26,  comment: '-'         }, { id: 38, bg: 'info',      num: 20,  comment: 'SPI1 MOSI' },
    { id: 39, bg: 'secondary', num: nil, comment: 'GND'       }, { id: 40, bg: 'info',      num: 21,  comment: 'SPI1 SCLK' }
  ].freeze

  INFO = {
    mac: `ifconfig`.split('ether ')[1][0..16],
    name: 'Bosch_BME280',
    owner: 'dvitvitskiy.pro@gmail.com'
  }.freeze

  def self.narod_mon
    bme280 = JSON.parse RestClient.get('krsz.ru:3004/bme280')
    data = [
      { id: 't', name: 'Температура', value: bme280['t'], unit: 'C'   },
      { id: 'p', name: 'Давление',    value: bme280['p'], unit: 'HPA' },
      { id: 'h', name: 'Влажность',   value: bme280['h'], unit: 'HUM' }
    ]
    RestClient.post('http://narodmon.ru/post', { devices: [INFO.merge(sensors: data)] }.to_json)
  end

  def self.user_devices(user_id)
    eager_load(:capabilities).where(user_id: user_id).map do |d|
      {
        id: d.id.to_s,
        name: d.name,
        description: d.description,
        room: d.room,
        type: d.device_type,
        custom_data: {},
        device_info: { manufacturer: d.manufacturer, model: d.model, hw_version: d.hw_version, sw_version: d.sw_version },
        capabilities: d.capabilities.map { |cap| { type: cap.capability_type, retrievable: cap.retrievable } }
      }
    end
  end

  def self.user_query(user_id)
    eager_load(:capabilities).where(user_id: user_id).map do |d|
      {
        id: d.id, capabilities: d.capabilities.map do |cap|
          { type: cap.capability_type, state: { instance: cap.state_instance, value: true } }
        end
      }
    end
  end
end
