require 'alf'
module MemoryDatabase
  include Alf::Viewpoint

  def suppliers
    Relation(
      {:sid => "S1", :name => "Smith", :status => 20, :city => "London"},
      {:sid => "S2", :name => "Jones", :status => 10, :city => "Paris"},
      {:sid => "S3", :name => "Blake", :status => 30, :city => "Paris"},
      {:sid => "S4", :name => "Clark", :status => 20, :city => "London"},
      {:sid => "S5", :name => "Adams", :status => 30, :city => "Athens"})
  end

  def parts
    Relation(
      {:pid => "P1", :name => "Nut", :color => "Red", :weight => 12.0, :city => "London"},
      {:pid => "P2", :name => "Bolt", :color => "Green", :weight => 17.0, :city => "Paris"},
      {:pid => "P3", :name => "Screw", :color => "Blue", :weight => 17.0, :city => "Oslo"},
      {:pid => "P4", :name => "Screw", :color => "Red", :weight => 14.0, :city => "London"},
      {:pid => "P5", :name => "Cam", :color => "Blue", :weight => 12.0, :city => "Paris"},
      {:pid => "P6", :name => "Cog", :color => "Red", :weight => 19.0, :city => "London"})
  end

  def supplies
    Relation(
      {:sid => "S1", :pid => "P1", :qty => 300},
      {:sid => "S1", :pid => "P2", :qty => 200},
      {:sid => "S1", :pid => "P3", :qty => 400},
      {:sid => "S1", :pid => "P4", :qty => 200},
      {:sid => "S1", :pid => "P5", :qty => 100},
      {:sid => "S1", :pid => "P6", :qty => 100},
      {:sid => "S2", :pid => "P1", :qty => 300},
      {:sid => "S2", :pid => "P2", :qty => 400},
      {:sid => "S3", :pid => "P2", :qty => 200},
      {:sid => "S4", :pid => "P2", :qty => 200},
      {:sid => "S4", :pid => "P4", :qty => 300},
      {:sid => "S4", :pid => "P5", :qty => 400})
  end

end

db = MemoryDatabase.connect(Path.dir)

puts db.query{ matching(suppliers, supplies) }