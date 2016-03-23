class Person
  attr_accessor :name, :surname
  def initialize(name, surname)
    @name = name
    @surname = surname
  end

  def self.new_from_hash(hash)
    obj = allocate
    obj.name = hash["name"]
    obj.surname = hash["surname"]
    obj
  end
end

per = Person.new_from_hash({"name"=>"juan","surname"=>"perez"})

p per