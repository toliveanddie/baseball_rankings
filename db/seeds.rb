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
##############################   weekly Pitching #######################

def swpitching
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
		holder.values.uniq.map{|e| e.to_f}.sort.each do |s|
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
		holder.values.uniq.map{|e| e.to_f}.sort.reverse.each do |s|
			holder.each do |team,stat|
				hold.push(team) if stat.to_f == s
			end
		end
		hold.each_with_index do |team, index|
			rankings[team] << index
		end
	end
	rankings.each do |k,v|
		rankings[k] = v.sum/v.size
	end
	sorted = rankings.sort_by{|k,v| v}.to_h
	return sorted
end # swpitching

#################  weekly batting ######################

def swbatting
	names = []
	sholder = []

	doc = Nokogiri::HTML(URI.open('https://www.mlb.com/stats/team/ops?timeframe=-7'))
	doc.css('.full-G_bAyq40').each do |data|
		names.push(data.content.strip)
	end

	doc.css('td').each do |data|
		sholder.push(data.content.strip)
	end


	all_stats = []
	sholder.each_slice(17) do |slice|
		all_stats << slice
	end

	bteams = Hash.new {|hash,key| hash[key] = []}
	all_stats.each_with_index do |stats, index|
		bteams[names[index]] = stats.values_at(3,8,9,11,13,14,15,16)
	end

	# Initialize an empty hash to store rankings
	ranked_stats = Hash.new {|hash, key| hash[key] = []}

	# Iterate over each index in the stat arrays
	(0...bteams.values.first.size).each do |stat_index|
		# Sort teams based on the stat at the current index
		ranked = bteams.sort_by { |_, stats| stats[stat_index].to_f }.reverse

		# Assign ranks
		ranked.each_with_index do |(team, _), rank|
			ranked_stats[team] << rank
		end
	end
	
	ranked_stats.each do |k,v|
		ranked_stats[k] = v.sum/v.size
	end
	sorted = ranked_stats.sort_by{|k,v| v}.to_h
	return sorted
end # swbatting

######################  weekly overall ########################


def swover_all

	rankings = Hash.new
	swpitching.each do |k,v|
		rankings[k] = (swpitching[k] + swbatting[k])/2
	end
	return rankings.sort_by{|k,v| v}.to_h
	
end #swover_all

# Set post title to the current date
current_date = Time.now.strftime("%B %d, %Y") # e.g., "April 18, 2025"

# Create a new post and add teams from CSV
post = Post.create(title: current_date)
swover_all.each do |team, ranking|
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
	r = stats[3].to_i
	h = stats[4].to_i
	d = stats[5].to_i
	t = stats[6].to_i
	hr = stats[7].to_i
	rbi = stats[8].to_i
	bb = stats[9].to_i
	sb = stats[11].to_i
	s = h - (d + t + hr)
	tb = s + (d*2) + (t*3) + (hr*4)
	work = r + tb + rbi + bb + sb
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

############## weekly batting stat leaders ###################################

def batting_leaders
	names = []
	n = []
	sholder = []
	pages = ['https://www.mlb.com/stats/ops?timeframe=-7',
					'https://www.mlb.com/stats/ops?page=2&timeframe=-7',
					'https://www.mlb.com/stats/ops?page=3&timeframe=-7',
					'https://www.mlb.com/stats/ops?page=4&timeframe=-7']

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
		stats.shift(2)
		players[p] = stats.map(&:to_f)
	end

	stat_name = ['AB', 'R', 'H', '2B', '3B', 'HR', 'RBI', 'BB', 'SO', 'SB', 'CS', 'AVG', 'OBP', 'SLG', 'OPS']
	leaders = Hash.new
	stat_name.each_with_index do |stat, index|
		sorted = players.sort_by {|name, stats| -stats[index]}
		top_three = sorted.first(3).map do |player|
			{ name: player[0], stat: player[1][index]}
		end
		leaders[stat] = top_three
	end
	return leaders
end #batting_leaders

batting_leaders.each do |stat, players|
	post.leaders.create(
		stat: stat,
		name1: players[0][:name],
		stat1: players[0][:stat].to_s,
		name2: players[1][:name],
		stat2: players[1][:stat].to_s,
		name3: players[2][:name],
		stat3: players[2][:stat].to_s)
	puts "#{stat} added"
end

########### weekly pitching stat leaders #######################

def pitching_leaders
	names = []
	n = []
	sholder = []
	pages = ['https://www.mlb.com/stats/pitching/era?sortState=asc&timeframe=-15',
					'https://www.mlb.com/stats/pitching/era?page=2&sortState=asc&timeframe=-15',
					'https://www.mlb.com/stats/pitching/era?page=3&sortState=asc&timeframe=-15']

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
	sholder.each_slice(20) do |slice|
		all_stats << slice
	end

	names = n.each_slice(2).map { |first, last| "#{first} #{last}"}

	pitchers = Hash.new {|hash,key| hash[key] = []}
	spitchers = Hash.new {|hash,key| hash[key] = []}
	all_stats.each_with_index do |stats, index|
		p = "#{names[index]}, #{stats[0]}"
		pitchers[p] = stats.values_at(3, 11, 12, 13, 16, 18, 19).map(&:to_f)
		spitchers[p] = stats.values_at(10, 17).map(&:to_f)
	end

	stat_name = ['era', 'H', 'R', 'ER', 'BB', 'WHIP', 'avg']
	leaders = Hash.new
	stat_name.each_with_index do |stat, index|
		sorted = pitchers.sort_by {|name, stats| stats[index]}
		top_three = sorted.first(3).map do |pitcher|
			{ name: pitcher[0], stat: pitcher[1][index]}
		end
		leaders[stat] = top_three
	end

	stat_name = ['IP', 'SO']
	stat_name.each_with_index do |stat, index|
		sorted = spitchers.sort_by {|name, stats| -stats[index]}
		top_three = sorted.first(3).map do |pitcher|
			{name: pitcher[0], stat: pitcher[1][index]}
		end
		leaders[stat] = top_three
	end
	return leaders
end

pitching_leaders.each do |stat, pitchers|
	post.pleaders.create(
		stat: stat,
		name1: pitchers[0][:name],
		stat1: pitchers[0][:stat].to_s,
		name2: pitchers[1][:name],
		stat2: pitchers[1][:stat].to_s,
		name3: pitchers[2][:name],
		stat3: pitchers[2][:stat].to_s)
	puts "#{stat} added"
end