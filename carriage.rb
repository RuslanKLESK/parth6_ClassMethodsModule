class Carriage
  include CompanyName
  attr_accessor :type, :number

  def initialize(number)
    @number = number
  end

end