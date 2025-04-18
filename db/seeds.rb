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
require 'csv'

# CSV file path
csv_path = Rails.root.join('teams.csv')

# Scrape stats from MLB team stats page
doc = Nokogiri::HTML(URI.open('https://www.mlb.com/stats/team?timeframe=-6'))

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
doc = Nokogiri::HTML(URI.open('https://www.mlb.com/stats/team/pitching?timeframe=-6'))

names = []
doc.css('.full-G_bAyq40').each do |data|
  names.push(data.content.strip)
end

phold = []
doc.css('td').each do |data|
  phold.push(data.content.strip)
end

pstats = []
pteams = Hash.new { |hash, key| hash[key] = [] }

names.each do |name|
  pstats = []
  pstats = phold.shift(20)
  pstats.shift(2)
  pstats.delete_at(2)
  pstats.delete_at(2)
  pstats.delete_at(2)
  pstats.delete_at(2)
  pstats.delete_at(2)
  pstats.delete_at(2)
  pstats.delete_at(2)
  pstats.delete_at(6)
  pteams[name] = pstats
end

pstats.size.times do |i|
  holder.clear
  hold = []
  pteams.each do |team, stats|
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

# Calculate average ranking for teams
rankings.each do |team, stats|
  rankings[team] = stats.sum / stats.size
end

puts "CSV file 'teams.csv' created successfully!"

# Set post title to the current date
current_date = Time.now.strftime("%B %d, %Y") # e.g., "April 18, 2025"

# Create a new post and add teams from CSV
post = Post.create(title: current_date)
rankings.sort_by { |team, ranking| ranking }.reverse.to_h.each do |team, ranking|
  post.teams.create(name: team)
end

puts "Post titled '#{post.title}' created with teams loaded"
