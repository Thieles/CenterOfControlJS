#
#
class PessoaFisica
  attr_accessor :cod_pf, :nome, :docrg, :cpf, :email, :data_nascimento,
                :data_emissao_rg, :orgao_emissor, :sexo, :uf_emissor,
                :localizacao_nascimento, :celular, :ddd, :nacionalidade,
                :foto, :create

  def initialize
    @cod_pf = :cod_pf
    @nome = :nome
    @docrg = :docrg
    @cpf = :cpf
    @email = :email
    @data_nascimento = :data_nascimento
    @data_emissao_rg = :data_emissao_rg
    @orgao_emissor = :orgao_emissor
    @sexo = :sexo
    @uf_emissor = :uf_emissor
    @localizacao_nascimento = :localizacao_nascimento
    @celular = :celular
    @ddd = :ddd
    @nacionalidade = :nacionalidade
    @foto = :foto
    @create = @cod_pf == 0 ? true : false
  end
end
