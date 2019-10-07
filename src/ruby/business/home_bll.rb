begin
  require 'jrubyfx'
  fxml_root File.join(File.dirname(__FILE__), '../swing/fxml')
  require_relative 'business'
  require 'forwardable'
rescue LoadError => exception
  puts "Esse erro está vindo do carregamento #{exception.class}
  \n #{exception.inspect}"
end

class HomeBLL
  extend Forwardable
  include JRubyFX::Controller
  include Business

  attr_reader :classe_require

  def_delegator :classe_require, :on_clear_field, :clear_field

  fxml 'home.fxml'

  on(:create) { clear_field }

  on(:go_home) { home }
  on(:cad_user) { cadastro_user }

  private

  def home
    @pane_center.set_center nil
    @classe_require = nil
  end

  def cadastro_user
    # require_relative 'pessoa_fisica_bll'
    require File.join(File.dirname(__FILE__), '../swing/pessoa_fisica_swing')
    carrega_fxmls(PessoaFisica)
    @classe_require = PessoaFisicaBLL.new
  end

  def carrega_fxmls(arquivo_fxml)
    # root = JRubyFX::Controller.get_fxml_loader("#{arquivo_fxml}.fxml").load
    @pane_center.set_center arquivo_fxml.new
  end
end
