=begin
+ Создать модуль InstanceCounter, содержащий следующие методы класса и инстанс-методы, которые подключаются автоматически при вызове include в классе:
- Методы класса:
       - instances, который возвращает кол-во экземпляров данного класса
- Инстанс-методы:
       - register_instance, который увеличивает счетчик кол-ва экземпляров класса и который можно вызвать из конструктора. При этом данный метод не должен быть публичным.
+ Подключить этот модуль в классы поезда, маршрута и станции.
=end

module InstanceCounter

  attr_accessor :instances

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    @@instances = {}

    def instances
      @@instances[self]
    end

    def increment(initializeClass)
      if @@instances[initializeClass]
        @@instances[initializeClass] = @@instances[initializeClass] + 1
      else
        @@instances[initializeClass] = 1
      end
    end

  end

  module InstanceMethods

    protected

    def register_instance(initializeClass)
      self.class.increment(initializeClass)
    end

  end
end