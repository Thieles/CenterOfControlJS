begin
  require_relative 'business'
  require_relative '../features/features'
  require_relative File.join(File.dirname(__FILE__), '../database/pessoa_fisica_dal')
  require_relative File.join(File.dirname(__FILE__), '../classe/pessoa_fisica')
  # senha root => 'C2h@4e3.z9_dev!DB'
=begin
  def initialize
    @pf_dal = PessoaFisicaDAL.new hostserver: 'localhost',
                                  user: 'centerofcontrol',
                                  password: 'C2h@4e3.z9_App?'
    on_init
  end
=end
end

#
class PessoaFisicaBLL
  include Business
  include Features


  def on_read(param)
    result = @pf_dal.on_read param
    convert_class_json(convert_list_hash(result, {}))
  end

  def on_delete(param)
    @pf_dal.on_delete param.cod_pf
  end

  def on_create_or_update(param)
    if param.create
      rs = @pf_dal.on_create param
      convert_class_json(convert_list_hash(rs, {}))
    else
      result = @pf_dal.on_update param
      convert_class_json(convert_list_hash(result, {}))
    end
  end

  def on_exists(param)
    rs = @pf_dal.on_exists param
    convert_class_json(convert_list_hash(rs, {}))
  end

  def on_get_by_nome(param)
    rs = @pf_dal.on_get_by_nome param
    convert_class_json(convert_list_hash(rs, {}))
  end

  def on_get_list
    list = @pf_dal.on_get_list
    list.each do |obj|
      @list_json[obj.nome] = convert_list_hash obj, {}
    end
    convert_class_json @list_json
  end

  def on_preenche_classe
    pessoa_fisica = require_classe
    pessoa_fisica.cod_pf = @cod_pf
    pessoa_fisica.nome = @jtnome.text
    pessoa_fisica.docrg = @jtrg.text
    pessoa_fisica.cpf = @jtcpf.text
    pessoa_fisica.email = @jtemail.text
    pessoa_fisica.data_nascimento = @jtdata_nascimento.text
    pessoa_fisica.data_emissao_rg = @jtdata_emissao_rg.text
    pessoa_fisica.orgao_emissor = @jtorgao_emissor.text
    pessoa_fisica.sexo = @jcsexo.get_selected_item.to_s
    pessoa_fisica.uf_emissor = @jtuf_emissor.text
    pessoa_fisica.localizacao_nascimento = @jtlocalizacao_nascimento.text
    pessoa_fisica.celular = @jtcelular.text
    pessoa_fisica.ddd = @jtddd.text
    pessoa_fisica.nacionalidade = @jtnacionalidade.text
    pessoa_fisica.foto = @jtfoto.text
    pessoa_fisica.create = pessoa_fisica.cod_pf.zero? ? true : false
    rs = on_create_or_update(pessoa_fisica)
    rs
  end

  def on_preenche_swing(pessoafisica)
    @cod_pf = pessoafisica.cod_pf
    @jtnome.text = pessoafisica.nome
    @jtdocrg.text = pessoafisica.docrg
    @jtcpf.text = pessoafisica.cpf
    @jtemail.text = pessoafisica.email
    @jtdata_nascimento.text = pessoafisica.data_nascimento
    @jtdata_emissao_rg.text = pessoafisica.data_emissao_rg
    @jtorgao_emissor.text = pessoafisica.orgao_emissor
    @jcsexo.text = pessoafisica.sexo
    @jtuf_emissor.text = pessoafisica.uf_emissor
    @jtlocalizacao_nascimento.text = pessoafisica.localizacao_nascimento
    @jtcelular.text = pessoafisica.celular
    @jtddd.text = pessoafisica.ddd
    @jtnacionalidade.text = pessoafisica.nacionalidade
    @jtfoto.text = pessoafisica.foto
  end

  def on_valida_cpf(valor_cpf)
    cpf = []
    aux = 0
    soma = 0
    peso = [11, 10, 9, 8, 7, 6, 5, 4, 3, 2]
    mutiplicador = []

    valor_cpf.each_char do |index, num = aux|
      if (index == '.') || (index == '-')
      else
          cpf.insert(num, index)
      end
      num += 1
    end
    cpf.reverse!
    peso[1..9].each do |index|
      mutiplicador.insert(aux, index * cpf[aux].to_i)
      aux += 1
    end

    mutiplicador.each do |index|
      soma += index
    end

    resultado = soma % 11

    digito1 = resultado < 2 ? 0 : 11 - resultado

    mutiplicador.clear
    aux = 0
    soma = 0

    peso.each do |index|
      mutiplicador.insert(aux, index * cpf[aux].to_i)
      aux += 1
    end

    mutiplicador.each do |index|
      soma += index
    end

    resultado = soma % 11

    digito2 = resultado < 2 ? 0 : 11 - resultado
    result = if (cpf[9].to_i == digito1.to_i) && (cpf[10].to_i == digito2.to_i)
               'CPF válido'
             else
               'CPF inválido!'
             end
    result
  end

  def on_valida_email(email); end

  def convert_list_hash(obj,h2)
    if obj.nil?
      h2 = "Não encontrado!"
    else
      h2[@pf.instance_variable_get('@cod_pf')] = obj.cod_pf
      h2[@pf.instance_variable_get('@nome')] = obj.nome
      h2[@pf.instance_variable_get('@docrg')] = obj.docrg
      h2[@pf.instance_variable_get('@cpf')] = obj.cpf
      h2[@pf.instance_variable_get('@email')] = obj.email
      h2[@pf.instance_variable_get('@data_nascimento')] = obj.data_nascimento
      h2[@pf.instance_variable_get('@data_emissao_rg')] = obj.data_emissao_rg
      h2[@pf.instance_variable_get('@orgao_emissor')] = obj.orgao_emissor
      h2[@pf.instance_variable_get('@sexo')] = obj.sexo
      h2[@pf.instance_variable_get('@uf_emissor')] = obj.uf_emissor
      h2[@pf.instance_variable_get('@localizacao_nascimento')] = obj.localizacao_nascimento
      h2[@pf.instance_variable_get('@celular')] = obj.celular
      h2[@pf.instance_variable_get('@ddd')] = obj.ddd
      h2[@pf.instance_variable_get('@nacionalidade')] = obj.nacionalidade
      h2[@pf.instance_variable_get('@foto')] = obj.foto
      h2
    end
  end

  private

  def on_init
    @pf = PessoaFisica.new
    @list_json = {}
  end
end
