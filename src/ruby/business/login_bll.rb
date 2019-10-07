begin
  require 'jrubyfx'
  require 'openssl'
  # require_relative 'business'
  require File.join(File.dirname(__FILE__), '../swing/home')
  fxml_root File.join(File.dirname(__FILE__), '../swing/fxml')
rescue LoadError => exception
  puts "\n---------------\n \nLoginBLL\n#{exception.inspect} \nClasse\n#{exception.class} \n----------------------------------------------\n"
end

class LoginBLL
  include JRubyFX::Controller
  fxml 'login.fxml'

  def initialize
    @token = created_key
    @login.text = 'Thieles Lopes Possa'
  end

  def logga
    if secure_login(@login.text, @password.text)
      Home.new
      @stage.close
    else
      puts "#{@login.text}, mete o pé daqui mano vaza igual gás!"
    end
  rescue StandardError => exception
    File.open('./log/view_login_bll.log', 'w') do |f|
      f.write "Inicio\n"
      f.write "------------------------||-------------------------\n"
      f.write "Classe\n"
      f.write "#{exception.class}\n"
      f.write "------------------------||-------------------------\n"
      f.write "Back Trace\n"
      f.write "#{exception.backtrace}\n"
      f.write "------------------------||-------------------------\n"
      f.write "Inspenção do erro!\n"
      f.write "#{exception.inspect}\n"
      f.write "------------------------||-------------------------\n"
      f.write 'Fim'
      f.close
    end
  end

  on(:loggar) do
    logga
  end

  on(:quit) { Platform.exit }

  private

  def secure_login(login, password)
    cert = send_token(encrypt_data(@token, log: login, pwsd: password))
    decryption_data(cert)
  end

  def created_key
    cipher = OpenSSL::Cipher.new 'AES-128-CBC'
    pwd = 'C2h@4e3.z9_dev_cert'
    salt = OpenSSL::Random.random_bytes 16
    iter = 20_000
    key_len = cipher.key_len
    digest = OpenSSL::Digest::SHA256.new
    key = OpenSSL::PKCS5.pbkdf2_hmac pwd, salt, iter, key_len, digest
    cipher.key = key
    cipher
  end

  def encrypt_data(cipher, data = {})
    cipher.encrypt
    encrypted = cipher.update data
    encrypted << cipher.final
  end

  def decryption_data(cert)
    @token.decrypt
    decrypted = @token.update cert
    decrypted << @token.final
    true
  end

  def send_token(certificate)
    certificate
  end
end
