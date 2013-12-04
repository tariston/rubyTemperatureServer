require File.dirname(__FILE__) + '/serial_setup'

begin
  port_name = File.read(File.dirname(__FILE__) + '/tty')
  conn = SerialConnection::SerialObject.new(port_name)
  conn.test_stream
end