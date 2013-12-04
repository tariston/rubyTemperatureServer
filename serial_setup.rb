require 'serialport'

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

    def test_stream
      buffer = ''
      until buffer =~ /\{(.*?)\}/
        valid = select([@serial], nil, nil, 0.01)
        next unless valid && valid[0]
        buffer << @serial.getc
      end
    end
  end
end