class Dog
  attr_accessor :id, :name, :breed

  def initialize(id = null, name, breed)
    self.id = id
    self.name = name
    self.breed = breed
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

end
