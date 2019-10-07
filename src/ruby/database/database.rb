begin
  require 'java'
  require 'jdbc/mysql'
  require 'date'
rescue LoadError => ex
  puts "Essa é do arquivo #{__FILE__} classe:#{ex.class}
  \n e essa é a inspeção: #{ex.inspect}"
end
#
#
#
module JavaSql
  include_package 'java.sql'
#
#
  module ClassMethods
    def on_crud(*nome_metodo)
      nome_metodo.each do |nome|
        define_method("on_#{nome}") { |&block|
          begin
            @pst.execute_query 'START TRANSACTION;'
            block.call
            @conecte.commit
          rescue JavaSql::SQLException => ex
            @conecte.rollback
            return ex
          end
        }
      end
    end

    # terminar a contrução do método
    def on_(*name_method)
      name_method.each do |name|
        define_method("on_#{nome}") { |c|
        }
      end
    end
  end

  module DataBase
    def self.included(class_de_metodos)
      class_de_metodos.extend JavaSql::ClassMethods
      class_de_metodos.class_eval do
        def initialize(inicia_app = {})
          Jdbc::MySQL.load_driver
          @conecte = nil
          @hostserver = inicia_app[:hostserver]
          @user = inicia_app[:user]
          @password = inicia_app[:password]
          begin
            if @conecte.nil?
              @conecte = JavaSql::DriverManager.get_connection("jdbc:mysql://#{@hostserver}:3306/CenterOfControl","#{@user}","#{@password}")
              @pst = @conecte.create_statement
              @conecte.set_auto_commit false
            end
          rescue JavaSql::SQLException => erro_conecte
            puts "#{erro_conecte.class} \n #{erro_conecte.inspect}"
          end
        end
      end
    end
  end
end
