require 'alf'

module Database
  include Alf::Schema

  def orders
    Relation(
      Tuple(oid: "O1", city: "London", amount: 100.00),
      Tuple(oid: "O2", city: "Paris",  amount: 100.00))
  end

  def discount_rules
    Relation(
      Tuple(city: "London", rule: ->{ amount * 0.20 }),
      Tuple(city: "Paris",  rule: ->{ amount * 0.15 }))
  end

end

# Let open a connection on this database
db = Database.connect(Path.pwd)

# Compute the discount to apply according to the city
rel = db.query do
  allbut(
    extend( 
      join(orders, discount_rules), 
      discount: ->{ instance_exec(&rule) } ),
    [:rule]
  )
end

puts rel
# +------+--------+---------+-----------+
# | :oid | :city  | :amount | :discount |
# +------+--------+---------+-----------+
# | O1   | London | 100.000 |    20.000 |
# | O2   | Paris  | 100.000 |    15.000 |
# +------+--------+---------+-----------+
