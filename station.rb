=begin
В классе Station (жд станция) создать метод класса all, который возвращает все станции (объекты), созданные на данный момент
=end

class Station
  include InstanceCounter

  attr_accessor :trains
  attr_reader :name

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    register_instance(self.class)
  end

  def add_train(train)
    self.trains << train  
  end

  def delete_train(train)
    @trains = @trains.reject {|item| item.number == train.number}
    @trains
  end

  def all_trains_by_type(type)
    self.trains.filter { |train| train.type == type }
  end

  def type_count(type)
    self.train_by_type(type).size
  end

end