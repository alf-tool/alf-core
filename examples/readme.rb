require 'alf'

db  = Alf::Database.examples

puts db.evaluate{
  group(:suppliers, [:sid, :name, :status], :in_that_city)
}

puts db.evaluate{
  grouped = group(:suppliers, [:sid, :name, :status], :in_that_city)
  extend(grouped, how_many:   ->{ in_that_city.count }, 
                  avg_status: ->{ in_that_city.avg{ status } })
}

puts db.evaluate{
  grouped = group(:suppliers, [:sid, :name, :status], :in_that_city)
  summary = summarize(:suppliers, [:city], how_many: count{ sid }, avg_status: avg{ status })
  join(grouped, summary)
}
