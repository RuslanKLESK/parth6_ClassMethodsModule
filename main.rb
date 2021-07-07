require_relative 'modules/company_name'
require_relative 'modules/instance_counter'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'carriage'
require_relative 'passenger_carriage'
require_relative 'cargo_carriage'
require_relative 'station'
require_relative 'route'

class Main
  attr_accessor :stations, :trains, :routes

  def initialize
    @routes = {}
  end

  def menu
    loop do
    puts "Выберите действие:"
    puts "'1' - создать станцию."
    puts "'2' - создать поезд."
    puts "'3' - создать маршрут."
    puts "'4' - добавить станцию в маршрут."
    puts "'5' - удалить станцию из маршрута."
    puts "'6' - назначить маршрут поезду."
    puts "'7' - переместить поезд по маршруту вперед или назад."
    puts "'8' - добавить вагон к поезду."
    puts "'9' - отцепить вагон от поезда."
    puts "'10' - посмотреть список станций."
    puts "'11' - посмотреть список поездов на станции."
    puts "'0' - выхода из программы."

    choice = gets.chomp; break if choice == "0"
    case choice
      when '1'    # чтобы создать станцию
        create_station
      when '2'    # чтобы создать поезд
        create_train
      when '3'    # создать маршрут
        create_route
      when '4'    # добавить станцию в маршрут
        add_station_to_route
      when '5'    # удалить станцию из маршрута
        remove_station_on_route
      when '6'    # назначить маршрут поезду
        add_route_to_train
      when '7'    # переместить поезд по маршруту вперед-назад
        change_train_station
      when '8'    # добавить вагон к поезду
        add_carriage_to_train
      when '9'    # отцепить вагон от поезда
        remove_carriage_to_train
      when '10'   # посмотреть список станций
        show_stations_list_on_route
      when '11'   # посмотреть список поездов на станции
        show_trains_on_station
    # case
    end
    # loop do
    end
  end
  
private # эти методы не используются напрямую. Их будет использовать метод menu. 
  def create_station
    puts "Введите название станции:"; name = gets.chomp.capitalize
    if has_station!(name).length.zero?
      station = Station.new(name) 
      stations << station if station
      puts "#{stations} станция создана"
    else
      puts "#{stations} станция уже существует"
    end
  end

  def create_train
    puts "Введите номер поезда:"; number = gets.chomp
    puts "и тип поезда (cargo, passenger):"; type = gets.chomp
    if type == 'passenger';  train = PassengerTrain.new(number, 'passenger')
    elsif type == 'cargo'; train = CargoTrain.new(number, 'cargo')
    end
    trains[number] = train if train
  end

  def create_route
    puts "Начальная станция:"; start = gets.chomp.capitalize
    puts "Конечная станция:"; finish = gets.chomp.capitalize
    puts "и номер маршрута:"; number = gets.chomp
    if has_station!(start).length.zero?
      start_station = Station.new(start)
      self.stations << start_station
    else 
      start_station = stations.select{|item| item.name == start}
    end
    if has_station!(finish).length.zero?
      finsih_station = Station.new(finish)
      self.stations << finsih_station
    else 
      finsih_station = stations.select{|item| item.name == finish}
    end
    route = Route.new(start_station, finsih_station, number)
    routes[number] = route
    puts "Маршрут создан."
  end

  def add_station_to_route
    puts "Введите название станции:"; name = gets.chomp.capitalize
    puts "и номер маршрута:"; number = gets.chomp
    if has_station!(name).length.zero?
      station = Station.new(name)
      self.stations << station
    else 
      station = stations.select{|item| item.name == name}
    end
    if has_route!(number).length.zero?
      puts "Маршрут не найден."
    else 
      route = has_route!(number).first
      route.add_station(station)
      puts "Станция добавлена на маршрут."
    end
  end

  def remove_station_on_route
    puts "Введите название станции:"; name = gets.chomp.capitalize
    puts "и номер маршрута:"; number = gets.chomp
    if has_station!(name).length.zero? ; puts "Нет такой станции."
    else
      station = stations.select{|item| item.name == name}
    end
    if has_route!(number).length.zero? ; puts "Нет такого маршрута."
    else
      route = has_route!(number).first
      route.remove_station(station.first)
      puts "Станция удалена из маршрута."
    end
  end

  def add_route_to_train
    puts "Введите номер поезда:"; number_train = gets.chomp
    puts "и номер маршрута:"; number_route = gets.chomp
    unless has_route!(number_route).length.zero? && has_train!(number_train).length.zero?
      train = has_train!(number_train).first
      route = has_route!(number_route).first
      train.train_add_route(route)
    else
      puts "Ошибка в номере поезда или маршрута."
    end
  end

  def change_train_station
    puts "Введите номер поезда:"; number_train = gets.chomp
    puts "и номер маршрута:"; number_route = gets.chomp
    loop do
      puts '1 - Вперед.'; puts '2 - Назад.'
      choice = gets.to_i
      break unless choice == 1 || choice == 2
      unless has_route!(number_route).length.zero? && has_train!(number_train).length.zero?
        train = has_train!(number_train).first
        route = has_route!(number_route).first
        train.change_to_next_station(route) if choice == 1
        train.change_to_prew_station(route) if choice == 2
        puts "Поезд перемещен."
      else
        puts "Поезд не найден."
      end
    end
  end

  def add_carriage_to_train
    puts "Введите номер поезда:"; number_train = gets.chomp
    puts "и номер вагона:"; number_carriage = gets.chomp
    unless has_train!(number_train).length.zero?
      train = has_train!(number_train).first
      carriage = CargoCarriage.new(number_carriage) if train.type == 'cargo'
      carriage = PassengerCarriage.new(number_carriage) if train.type == 'passenger'
      train.add_carriage(carriage)
      puts "Вагон добавлен к поезду"
    else
      puts "Поезд не найден"
    end
  end

  def remove_carriage_to_train
    puts "Введите номер поезда:"; number_train = gets.chomp
    puts "и номер вагона:"; number_carriage = gets.chomp
    unless has_train!(number_train).length.zero?
      train = has_train!(number_train).first
      unless has_carriage!(number_carriage, train.carriages).length.zero?
        train.delete_carriage(has_carriage!(number_carriage, train.carriages).first)
        puts "Вагон удален."
      else; puts "Вагон не найден."
      end
    else; puts "Поезд не найден."
    end
  end

  def show_stations_list_on_route
    puts "Номер маршрута:"; number = gets.chomp
    if has_route!(number).length.zero?; puts "Маршрут не найден."
    else 
      route = has_route!(number).first
      route.get_all_routes
      puts "Станции на маршруте:"; route.stations.map {|station| puts station.name}
    end
  end

  def show_trains_on_station
    puts "Имя станции:"; name = gets.chomp
    unless has_station!(name).length.zero?
      station = has_station!(name).first
      puts "Список поездов на станции:"; station.trains.map {|train| puts train.number}
    else; puts "Станция не найдена."
    end
  end

  def has_station!(name)
    has_station = []
    stations.select {|item| has_station << item if item.name == name}
    has_station
  end
  def has_carriage!(number, carriages)
    has_carriage = []
    carriages.select {|item| has_carriage << item if item.number == number}
    has_carriage
  end
  def has_route!(number)
    has_route = []
    has_route << routes[number] if routes[number]
    has_route
  end
  def has_train!(number)
    has_train = []
    has_train << trains[number] if trains[number]
    has_train
  end
# class Main
end

interface = Main.new
interface.menu