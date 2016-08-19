# load 'config/database.rb'
# load 'config/environment.rb'

num_chunks = Chunk.where({personrole_id: 1}).length

index = (Random.rand * num_chunks).ceil

glass_me = Chunk.where({personrole_id: 1}).offset(index).take(1)

puts "\n\n#{glass_me[0].text}\n\n"

