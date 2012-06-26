require 'alf'

db  = Alf::Database.examples

puts grouped = db.query{
  group(:suppliers, [:sid, :name, :status], :in_that_city)
}

puts db.query{
  extend(grouped, how_many:   ->{ in_that_city.count }, 
                  avg_status: ->{ in_that_city.avg{ status } })
}

puts summarized = db.query{
  summary = summarize(:suppliers, [:city], how_many: count{ sid }, avg_status: avg{ status })
  join(grouped, summary)
}

require 'json'
puts summarized.to_json