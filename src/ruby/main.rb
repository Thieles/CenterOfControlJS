# require 'jrubyfx'
# require File.join(File.dirname(__FILE__), './swing', 'login')
# require '../depedencias/fontawesomefx-8.9.jar'
# require '../depedencias/jfoenix-8.0.4.jar'
# Login.launch

require_relative 'business/pessoa_fisica_bll'
require_relative 'classe/pessoa_fisica'
require 'json'
pfm = PessoaFisicaBLL.new
rs = pfm.on_get_by_nome "Lopes Possa"
puts rs
v = pfm.on_exists 1
puts v

p '---------------- list'
pfl = pfm.on_get_list
puts pfl

p '------------------- on read'
puts pfm.on_read 1
