#encoding: utf-8
begin
  require File.join(File.dirname(__FILE__), '..', 'database/pessoa_fisica_dal')
end
module Business
  module ClassMethods
      define_method(:on_) { |name, *args, &block|
          args.each do |name, *args, &block|
              if args == "delete"
                  def on_#{name}(param)
                      begin
                          args[classdb].on_delete param.cod
                      rescue Exception => ex
                          puts ex.inspect
                      end
                  end
               elsif args == "create_or_update"
                  def on_#{name}(param)
                      begin
                          if(param.create)
                              result = args[classdb].on_create param
                              return result
                          else
                              result = args[classdb].on_update param
                              return result
                          end
                      rescue Exception => ex
                          puts ex.inspect
                      end
                  end
              else
                  def on_#{name}(param)
                      begin
                          result = args[classdb].on_read param
                          result
                      rescue Exception => ex
                          puts ex.inspect
                      end
                  end
              end
          end
      }
  end
  
  def self.included(klass)
      klass.extend ClassMethods
      klass.class_eval {
          def initialize(inicia = {})
              inicia[:localhost] = "localhost"
              inicia[:root] = "centerofcontrol"
              inicia[:password] = "C2h@4e3.z9_App?"
              @pf_dal = PessoaFisicaDAL.new({hostserver: inicia[:localhost],user: inicia[:root], password: inicia[:password]})
              on_init
          end
      }
  end
  
end