require 'serialport'
require 'time'

REGEX_ARDUINO = /\{Temperature,([A-Za-z0-9:=\.\[\],\r\n]*)}/
REGEX_RIP = /\[([a-zA-Z0-9:=\.,]+)\],/
REGEX_TEMP_SPLIT = /=(.*?)[,\]"]/

module SerialConnection
  class SerialObject
    BAUD_RATE = 9600
    DATA_BITS = 8
    STOP_BITS = 1
    PARITY = SerialPort::NONE
    attr_reader :serial, :queue
    def initialize(port_name)
      @serial = SerialPort.new(port_name, BAUD_RATE, DATA_BITS, STOP_BITS)
      puts 'Initializing'
      3.times {puts '.'; sleep(1)}
      puts '.'
    end

    def input_stream
      buffer = ''
      until buffer[REGEX_ARDUINO, 1]
        valid = select([@serial], nil, nil, 0.01)
        next unless valid && valid[0]
        buffer << @serial.getc
      end
      puts buffer
      buffer = buffer[REGEX_ARDUINO, 1]
      trimmed = buffer.scan(REGEX_RIP)
      puts trimmed
      return trimmed
    end

    def self.parse_temperature(input = '')
      temps = []
      input.each { |x|
        fields = x.to_s.scan(REGEX_TEMP_SPLIT)
        temps.push(SerialConnection::Temperature.new(fields[0][0].to_s,fields[1][0].to_s,fields[2][0].to_s,fields[3][0].to_s,fields[4][0].to_s,fields[5][0].to_s,fields[6][0].to_s))
      }
      return temps
    end
  end

  class Temperature
    def initialize(rom = '', chip ='', data = '', crc = '', res = '', celc = '', fahr = '')
      @rom = rom
      @chip = chip
      @data = data
      @crc = crc
      @resolution = res
      @celsius = celc
      @fahrenheit = fahr
      @time = Time.now
    end
    def to_json(*a)
      {
        'ROM' => @rom,
        'chip' => @chip,
        'data' => @data,
        'crc' => @crc,
        'resolution' => @resolution,
        'celsius'=> @celsius,
        'fahrenheit' => @fahrenheit,
        'created' => @time
      }.to_json(*a)
    end
  end

end