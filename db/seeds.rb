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


names = []
n = []
sholder = []
pages = ['https://www.mlb.com/stats/ops?timeframe=-7',
				'https://www.mlb.com/stats/ops?page=2&timeframe=-7',
				'https://www.mlb.com/stats/ops?page=3&timeframe=-7']
pages.each do |page|
	doc = Nokogiri::HTML(URI.open(page))
	doc.css('.full-G_bAyq40').each do |data|
		n.push(data.content.strip)
	end

	doc.css('td').each do |data|
		sholder.push(data.content.strip)
	end
end

all_stats = []
sholder.each_slice(17) do |slice|
	all_stats << slice
end

names = n.each_slice(2).map { |first, last| "#{first} #{last}"}

players = Hash.new {|hash,key| hash[key] = []}
all_stats.each_with_index do |stats, index|
	p = "#{names[index]}, #{stats[0]}"
	g = stats[1].to_f
	r = stats[3].to_f
	h = stats[4].to_f
	b2 = stats[5].to_f
	b3 = stats[6].to_f
	hr = stats[7].to_f
	rbi = stats[8].to_f
	bb = stats[9].to_f
	sb = stats[11].to_f
	b1 = h - (b2+b3+hr)
	mr = (r - hr) + rbi
	totals = (b1 + b2*2 + b3*3 + hr*4 + sb + bb + mr)
	work = (totals/g).round(3)
	players[p] = work
end

sorted = players.sort_by {|k,v| -v}.to_h

sorted.each do |player, stats|
	post.players.create(name: player)
	puts "player: #{player} added"
end

puts "players added to the post!"

#################### Pitchers #####################################

names = []
phold = []
n = []
pages = ['https://www.mlb.com/stats/pitching/era?sortState=asc&timeframe=-14',
				 'https://www.mlb.com/stats/pitching/era?page=2&sortState=asc&timeframe=-14']
pages.each do |page|
	doc = Nokogiri::HTML(URI.open(page))
	doc.css('.full-G_bAyq40').each do |data|
		n.push(data.content.strip)
	end

	doc.css('td').each do |data|
		phold.push(data.content.strip)
	end
end

names = n.each_slice(2).map { |first, last| "#{first} #{last}"}

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
	fstats = pstats.values_at(1, 10, 17)
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

rankings.sort_by { |pitcher, ranking| ranking.sum }.reverse.to_h.each do |pitcher, ranking|
	post.pitchers.create(name: pitcher)
end

puts "pitchers added to the post!"


### end pitchers ####