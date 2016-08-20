# load 'config/database.rb'
# load 'config/environment.rb'

num_chunks = Person.first.chunks.count

index = (Random.rand * num_chunks).ceil

glass_me = Person.first.chunks.offset(index).take(1)[0]

puts "\n\n#{glass_me.text}\n\n"

