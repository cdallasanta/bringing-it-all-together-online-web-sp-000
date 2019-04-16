class Dog
  attr_accessor :id, :name, :breed

  def initialize(id = null, attribute_hash)
    self.id = id
    attribute_hash.each do |attr, value|
      self.send("#{attr}=",value)
    end
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dog(
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      );
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE dogs;")
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?,?);
      SQL

      DB[:conn].execute(sql, self.name, self.breed)
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs;")
    end
  end

  def self.create(hash)
    new_dog = Dog.new
    new_dog.save
  end
end
