require 'alf'

db = Alf.examples

grouped = db.query{
  group(suppliers, [:sid, :name, :status], :in_that_city)
}
puts grouped

grouped2 = db.query{
  extend(grouped, how_many:   ->{ in_that_city.count }, 
                  avg_status: ->{ in_that_city.avg{ status } })
}
puts grouped2

summarized = db.query{
  summary = summarize(suppliers, [:city], how_many: count{ sid }, avg_status: avg{ status })
  join(grouped, summary)
}
puts summarized

require 'json'
puts summarized.to_json