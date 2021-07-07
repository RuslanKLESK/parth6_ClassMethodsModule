=begin
- ƒобавить к поезду атрибут Ќомер (произвольна€ строка), если его еще нет, который указыватес€ при его создании
- ¬ классе Train создать метод класса find, который принимает номер поезда (указанный при его создании) и возвращает объект поезда по номеру или nil, если поезд с таким номером не найден.
=end

class Train
  include CompanyName
  include InstanceCounter
  
  attr_accessor :current_speed, :carriages
  attr_reader :number, :type

  @@trains = {}

  def initialize(number, type)
    @number = number
    @type = type
    @current_speed = 0
    @carriages = []
    @@trains[number] = self
    register_instance(self.class)
    puts "Train #{number} created. Type: #{type}. Current speed: #{current_speed}"
  end

  def self.find(number)
    @@trains[number] if @@trains[number]
  end

  def current_speed     # ћожет возвращать текущую скорость
    @current_speed
  end

  def speed_up(number)  # ћожет набирать скорость
    @current_speed += number
  end

  def brake             # ћожет тормозить до 0.
    @current_speed = 0
  end

  def add_carriage(carriage)   
    self.carriages << carriage if type == carriage.type && current_speed.zero?
  end

  def delete_carriage(carriage)
    if current_speed.zero?
      self.carriages = carriages.reject {|item| item.number == carriage.number}
    end
    carriages
  end

  def train_add_route(route)
    route.set_train(self)
  end

  def change_to_next_station(route)
    route.change_station(self, 'next')
  end

  def change_to_prew_station(route)
    route.change_station(self, 'prew')
  end

  def show_current_prew_next_stations(route)
    route.show_stations_nearby(self)
  end

  def move_next_station
    if next_station != nil
      self.station = next_station unless next_station
    end
  end
  
  def move_previous_station
    if self.station != self.route.stations.first
      self.station = previous_station unless previous_station
    end
  end
end