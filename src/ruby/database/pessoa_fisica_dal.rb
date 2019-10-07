begin
  require_relative 'database'
rescue LoadError => ex
  puts ex.bracktrace
end

class PessoaFisicaDAL
  include JavaSql::DataBase

  def on_create(param)
    __send__ 'on_create_pessoa_fisica' do
      @pst = @conecte.prepare_call %{CALL p_create_pessoa_fisica(?, ?, ?,
                                         ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}
      on_action_param_query(@pst, param)
      @pst.execute_query
      @rs = @pst.get_output_parameters param.cod_pf
    end
    @rs.class == Integer && @rs.zero? ? true : false
  end

  def on_read(param)
    rs = nil
    __send__ 'on_read_pessoa_fisica' do
      @pst = @conecte.prepare_call %{CALL p_read_pessoa_fisica(?)}
      @pst.set_int 1, param
      rs = @pst.execute_query
    end
    on_action_result(rs) do |classe|
      result_simple classe
    end
  end

  def on_update(param)
    __send__ 'on_update_pessoa_fisica' do
      @pst = @conecte.prepare_call %{CALL p_update_pessoa_fisica(?, ?, ?, ?, ?,
                                    ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}
      on_action_param_query(@pst, param)
      @pst.execute_query
    end
    @rs.class == Integer && @rs.zero? ? true : false
  end

  def on_delete(param)
    __send__ 'on_delete_pessoa_fisica' do
      @pst = @conecte.prepare_call %{CALL p_delete_pessoa_fisica(?)}
      @pst.set_int 1, param
      @pst.execute_query
    end
  end

  def on_exists(param)
    __send__ 'on_exists_pessoa_fisica' do
      @pst = @conecte.prepare_call %{CALL p_exists_pessoa_fisica(?)}
      @pst.set_int 1, param
      rs = @pst.execute_query
      while rs.next do @rs = rs.get_string('COUNT(*)') end
    end
    @rs == 0 ? false : on_read(param.to_i)
  end

  def on_get_by_nome(param)
    @result = nil
    __send__ 'on_get_by_nome_pessoa_fisica' do
      @pst = @conecte.prepare_call %{CALL p_read_pessoa_fisica_by_nome(?)}
      @pst.set_string 1, param
      @result = @pst.execute_query
    end
    on_action_result(@result) do |classe|
      result_simple classe
    end
  end

  def on_get_list
    @pst = @conecte.prepare_call %{CALL p_read_all_pessoa_fisica()}
    @result = @pst.execute_query
    on_action_result(@result) do |param|
      @classes << param
    end
  end

  on_crud 'create_pessoa_fisica', 'read_pessoa_fisica', 'update_pessoa_fisica',
          'delete_pessoa_fisica', 'exists_pessoa_fisica',
          'get_by_nome_pessoa_fisica'

  class << self
    attr_reader :result, :rs, :classe, :classes
  end

  private

  def on_action_result(result, &block)
    lista = nil
    @classes = []
    while result.next
      @classe = require_classe
      @classe.cod_pf                 = result.get_int 'cod_pf'
      @classe.nome                   = result.get_string 'nome'
      @classe.docrg                  = result.get_string 'docrg'
      @classe.cpf                    = result.get_string 'cpf'
      @classe.email                  = result.get_string 'email'
      @classe.data_nascimento        = result.get_date 'data_nascimento'
      @classe.data_emissao_rg        = result.get_date 'data_emissao_rg'
      @classe.orgao_emissor          = result.get_string 'orgao_emissor'
      @classe.sexo                   = result.get_int 'sexo'
      @classe.uf_emissor             = result.get_string 'uf_emissor'
      @classe.localizacao_nascimento = result.get_string 'localizacao_nascimento'
      @classe.celular                = result.get_string 'celular'
      @classe.ddd                    = result.get_string 'ddd'
      @classe.nacionalidade          = result.get_string 'nacionalidade'
      @classe.foto                   = result.get_string 'foto'
      lista = yield @classe
    end
    lista
  end

  def on_action_param_query(param)
    @pst.to_i 1, param.cod_pf
    @pst.set_string 2, param.nome
    @pst.set_string 3, param.docrg
    @pst.set_string 4, param.cpf
    @pst.set_string 5, param.email
    @pst.set_date 6, param.data_nascimento
    @pst.set_date 7, param.data_emissao_rg
    @pst.set_string 8, param.orgao_emissor
    @pst.set_int 9, param.sexo
    @pst.set_string 10, param.uf_emissor
    @pst.set_string 11, param.localizacao_nascimento
    @pst.set_string 12, param.celular
    @pst.set_string 13, param.ddd
    @pst.set_string 14, param.nacionalidade
    @pst.set_string 15, param.foto
  end

  def require_classe
    require File.join(File.dirname(__FILE__), '../classe/pessoa_fisica')
    PessoaFisica.new
  end

  def result_list(param)
    @classes[param.cpf] ||= []
    @classes[param.cpf] << param
  end

  def result_simple(cls)
    cls
  end
end
