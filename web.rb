require File.dirname(__FILE__) + '/serial_setup'
require 'rubygems'
require 'sinatra'
require 'json'

begin
  port_name = File.read(File.dirname(__FILE__) + '/tty')
  $conn = SerialConnection::SerialObject.new(port_name)

  #var = SerialConnection::SerialObject.parse_temperature(conn.input_stream)
end

get '/temp/:id' do
  puts "get temperature #{params[:id]}"
  temp = SerialConnection::SerialObject.parse_temperature($conn.input_stream)
  #puts temp.length >= params[:id].to_s.to_i
  id = params[:id].to_s.to_i
  if temp.length >= id
    status 200
    body(temp[id].to_json)
  else
    status 404
  end
end

get '/temp/' do
  puts 'get temperatures'
  temp = SerialConnection::SerialObject.parse_temperature($conn.input_stream)
  if temp.nil?
    status 404
  else
    status 200
    body(temp.to_json)
  end

end

