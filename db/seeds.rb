# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


require 'nokogiri'
require 'open-uri'

# Scrape stats from MLB team stats page
doc = Nokogiri::HTML(URI.open('https://www.mlb.com/stats/team?timeframe=-7'))

names = []
doc.css('.full-G_bAyq40').each do |data|
  names.push(data.content.strip)
end

dhold = []
doc.css('td').each do |data|
  dhold.push(data.content.strip)
end

dstats = []
teams = Hash.new { |hash, key| hash[key] = [] }
other_stats = Hash.new { |hash, key| hash[key] = [] }

# Process teams and stats
names.each do |name|
  dstats = []
  dstats = dhold.shift(17)
  dstats.shift(3)
  other_stats[name] << dstats.delete_at(7)
  other_stats[name] << dstats.delete_at(8)
  teams[name] = dstats
end

holder = Hash.new
rankings = Hash.new { |hash, key| hash[key] = [] }

# Ranking logic for stats
dstats.size.times do |i|
  holder.clear
  hold = []
  teams.each do |team, stats|
    holder[team] = stats[i]
  end
  holder.values.uniq.map { |e| e.to_f }.sort.each do |s|
    holder.each do |team, stat|
      hold.push(team) if stat.to_f == s
    end
  end
  hold.each_with_index do |team, index|
    rankings[team] << index
  end
end

# Process additional stats
2.times do |i|
  holder.clear
  hold = []
  other_stats.each do |team, stats|
    holder[team] = stats[i]
  end
  holder.values.uniq.map { |e| e.to_f }.sort.reverse.each do |s|
    holder.each do |team, stat|
      hold.push(team) if stat.to_f == s
    end
  end
  hold.each_with_index do |team, index|
    rankings[team] << index
  end
end

# Scrape stats from MLB pitching stats page
doc = Nokogiri::HTML(URI.open('https://www.mlb.com/stats/team/pitching?timeframe=-7'))

names = []
doc.css('.full-G_bAyq40').each do |data|
	names.push(data.content.strip)
end

phold = []
doc.css('td').each do |data|
	phold.push(data.content.strip)
end

rstats = []
fstats = []
pstats = []
rteams = Hash.new {|hash,key| hash[key] = []}
fteams = Hash.new {|hash,key| hash[key] = []}
names.each do |name|
	pstats = []
	rstats = []
	fstats = []
	pstats = phold.shift(20)
	fstats = pstats.values_at(7, 17)
	rstats = pstats.values_at(2, 3, 11, 12, 13, 14, 15, 16, 18, 19)
	rteams[name] = rstats
	fteams[name] = fstats
end

rankings = Hash.new {|hash,key| hash[key] = []}
holder = Hash.new {|hash,key| hash[key] = []}
rstats.size.times do |i|
	holder.clear
	hold = []
	rteams.each do |team,stats|
		holder[team] = stats[i]
	end
	holder.values.uniq.map{|e| e.to_f}.sort.reverse.each do |s|
		holder.each do |team,stat|
			hold.push(team) if stat.to_f == s
		end
	end
	hold.each_with_index do |team, index|
		rankings[team] << index
	end
end

fstats.size.times do |i|
	holder.clear
	hold = []
	fteams.each do |team,stats|
		holder[team] = stats[i]
	end
	holder.values.uniq.map{|e| e.to_f}.sort.each do |s|
		holder.each do |team,stat|
			hold.push(team) if stat.to_f == s
		end
	end
	hold.each_with_index do |team, index|
		rankings[team] << index
	end
end

# Calculate average ranking for teams
rankings.each do |team, stats|
  rankings[team] = stats.sum / stats.size
end

# Set post title to the current date
current_date = Time.now.strftime("%B %d, %Y") # e.g., "April 18, 2025"

# Create a new post and add teams from CSV
post = Post.create(title: current_date)
rankings.sort_by { |team, ranking| ranking }.reverse.to_h.each do |team, ranking|
  post.teams.create(name: team)
end

puts "Post titled '#{post.title}' created with teams loaded"


###################### players #################################


doc = Nokogiri::HTML(URI.open('https://www.mlb.com/stats/hits?timeframe=-7'))
	n = []
	doc.css('.full-G_bAyq40').each do |data|
		n.push(data.content.strip)
	end
	
	names = []
	names = n.each_slice(2).map { |first, last| "#{first} #{last}"}

	dhold = []
	doc.css('td').each do |data|
		dhold.push(data.content.strip)
	end

	dstats = []
	players = Hash.new {|hash,key| hash[key] = []}
	names.each do |name|
		dstats = []
		dstats = dhold.shift(17)
		p = "#{name}, #{dstats[0]}"
		dstats.shift(3)
		dstats.delete_at(7)
		dstats.delete_at(8)
		players[p] = dstats
	end

	rankings.clear
	dstats.size.times do |i|
		holder.clear
		hold = []
		players.each do |team,stats|
			holder[team] = stats[i]
		end
		holder.values.uniq.map{|e| e.to_f}.sort.each do |s|
			holder.each do |team,stat|
				hold.push(team) if stat.to_f == s
			end
		end
		hold.each_with_index do |team, index|
			rankings[team] << index
		end
	end
	rankings.sort_by { |player, ranking| ranking }.reverse.to_h.each do |player, ranking|
		post.players.create(name: player)
	end

	puts "players added to the post!"