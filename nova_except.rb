class NovaExcept < StandardError
  def initialize(var)
    super "Variavel #{var} congelada"
  end
end