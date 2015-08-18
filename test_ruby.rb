load 'nova_except.rb'

class Test_ruby
  def test_excpt
    i = 1.freeze
    begin
      raise NovaExcept.new('i') if i.frozen?
      while i <=5
        puts i+=i
      end
    rescue NovaExcept => e
      puts e
    end
  end

  def test_for  # ou for i in list #
    (0..5).each{|item| puts item}
  end

  def test_lambda(val)
    mult_por_5 = -> valor do
      puts(valor * 5)
    end

    mult_por_5.(val)
  end

  def test_selecao_de_itens
    puts((1..8).select {|v| v.even?})
    map = {1 => 'um', 2 => 'dois', 3 => 'tres'}
    puts(map.select {|chave| chave > 1}) #seleciona itens da lista, ou map conforme condicao

    puts(map.max {|chave, valor| chave <=> valor})
  end

  def test_dividir_colecao
   map = (0..10).partition {|var| var.odd?}
   puts map[0][0] # array com impares
   puts map[1][0] # array com pares
  end

  def soma_lanca_expt(val1, val2)
    puts(val1+val2)
  rescue #tratando excpt direto no metodo
    nil
  end
end

class Carro #< Struct.new(:marca, :modelo, :preco) |-> esse seria um outro jeito para deixas as vars de instancia acessiveis
  INSTANSE_VARS = %w(marca modelo preco)
  attr_accessor *INSTANSE_VARS #um atalho para gets e sets
  @@var_de_classe = 0 # var de classe, não é boa pratica
  #attr_writer = :var... sets
  #attr_reader = :var... gets

  def initialize(marca, modelo, preco)
    @marca  =  marca
    @modelo =  modelo
    @preco  =  preco
    @@var_de_classe += 1
  end

  def to_s
   "Marca: #{@marca}, Modelo: #{@modelo}, Preco: #{@preco}"
  end

  #atributo virtual
  def preco_financiado
    @preco * 2
  end
end

#exemplo de metaprogramacao, adicionando um metodo na classe depois que criada
Carro.send(:define_method, "soma_preco") do |valor|
  @preco + valor
end

#Interface fluente use > self :)
class Sql
  attr_writer :table, :conditions, :orderBy

  def from(table)
    @table = table
    self
  end

  def where(conditions)
    @conditions = conditions
    self
  end

  def orderBy(orderBy)
    @orderBy = orderBy
    self
  end

  def to_s
    "Select * From #{@table} Where #{@conditions} orderBy #{@orderBy}"
  end
end

class TestMetodosDinamicos
  def self.method_added(meth) end
  def self.method_removed(meth) end
end

t = Test_ruby.new
t.test_excpt
t.test_for
t.test_lambda(5)
t.test_selecao_de_itens
t.test_dividir_colecao
t.soma_lanca_expt(1, :um)

array = %w(um dois tres) #transforma em array
puts(* array); #'explode' o array

carro = Carro.new( :Volks, :Fox, 20000)
puts ("Carro #{carro}")
carro.marca = :Fiat

#metaclass bruxaria, adicionando um metodo somente a nivel de instancia
(class << carro; self; end).send(:define_method, "diminui_preco"){|val| @preco - val}

#tambem pode ser feito assim:
test_metedos_dimanicos = TestMetodosDinamicos.new

test_metedos_dimanicos.class.send(:define_method, "soma_uala") do |val1, val2|  #wtf bruxas
  puts ("metodo dinamico, só pra ver no console #{val1+val2}")
end

test_metedos_dimanicos.soma_uala(30,30)

puts carro.diminui_preco(1000)
puts carro.marca
puts carro.preco_financiado
puts carro.soma_preco(2)

sql = Sql.new
sql.from("clientes").where("cliente.nome = 'thiago'").orderBy("condicao")
puts(sql)