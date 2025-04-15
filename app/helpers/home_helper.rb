module HomeHelper

	def over_all
		require 'nokogiri'
		require 'open-uri'

		doc = Nokogiri::HTML(URI.open('https://www.mlb.com/stats/team'))
		names = []
		doc.css('.full-G_bAyq40').each do |data|
			names.push(data.content.strip)
		end

		dhold = []
		doc.css('td').each do |data|
			dhold.push(data.content.strip)
		end

		dstats = []
		teams = Hash.new {|hash,key| hash[key] = []}
		other_stats = Hash.new {|hash,key| hash[key] = []}
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
		dstats.size.times do |i|
			holder.clear
			hold = []
			teams.each do |team,stats|
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

		2.times do |i|
			holder.clear
			hold = []
			other_stats.each do |team,stats|
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

		doc = Nokogiri::HTML(URI.open('https://www.mlb.com/stats/team/pitching'))
		names = []
		doc.css('.full-G_bAyq40').each do |data|
			names.push(data.content.strip)
		end

		phold = []
		doc.css('td').each do |data|
			phold.push(data.content.strip)
		end

		pstats = []
		pteams = Hash.new {|hash,key| hash[key] = []}
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
			pteams.each do |team,stats|
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
		return rankings

	end #over_all

##############################   Pitching #######################

	def pitching
		doc = Nokogiri::HTML(URI.open('https://www.mlb.com/stats/team/pitching'))
		names = []
		doc.css('.full-G_bAyq40').each do |data|
			names.push(data.content.strip)
		end

		phold = []
		doc.css('td').each do |data|
			phold.push(data.content.strip)
		end

		pstats = []
		pteams = Hash.new {|hash,key| hash[key] = []}
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

		rankings = Hash.new{|hash,key| hash[key] = []}
		holder = Hash.new{|hash,key| hash[key] = []}

		pstats.size.times do |i|
			holder.clear
			hold = []
			pteams.each do |team,stats|
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
		return rankings
	end # pitching

	#################  batting ######################

	def batting
		doc = Nokogiri::HTML(URI.open('https://www.mlb.com/stats/team'))
		names = []
		doc.css('.full-G_bAyq40').each do |data|
			names.push(data.content.strip)
		end

		dhold = []
		doc.css('td').each do |data|
			dhold.push(data.content.strip)
		end

		dstats = []
		teams = Hash.new {|hash,key| hash[key] = []}
		other_stats = Hash.new {|hash,key| hash[key] = []}
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
		dstats.size.times do |i|
			holder.clear
			hold = []
			teams.each do |team,stats|
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

		2.times do |i|
			holder.clear
			hold = []
			other_stats.each do |team,stats|
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
		return rankings
	end # batting


	######################  weekly start ########################


	def wover_all
		require 'nokogiri'
		require 'open-uri'

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
		teams = Hash.new {|hash,key| hash[key] = []}
		other_stats = Hash.new {|hash,key| hash[key] = []}
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
		dstats.size.times do |i|
			holder.clear
			hold = []
			teams.each do |team,stats|
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

		2.times do |i|
			holder.clear
			hold = []
			other_stats.each do |team,stats|
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
		pteams = Hash.new {|hash,key| hash[key] = []}
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
			pteams.each do |team,stats|
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
		return rankings

	end #wover_all

##############################   weekly Pitching #######################

	def wpitching
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
		pteams = Hash.new {|hash,key| hash[key] = []}
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

		rankings = Hash.new{|hash,key| hash[key] = []}
		holder = Hash.new{|hash,key| hash[key] = []}

		pstats.size.times do |i|
			holder.clear
			hold = []
			pteams.each do |team,stats|
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
		return rankings
	end # wpitching

	#################  weekly batting ######################

	def wbatting
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
		teams = Hash.new {|hash,key| hash[key] = []}
		other_stats = Hash.new {|hash,key| hash[key] = []}
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
		dstats.size.times do |i|
			holder.clear
			hold = []
			teams.each do |team,stats|
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

		2.times do |i|
			holder.clear
			hold = []
			other_stats.each do |team,stats|
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
		return rankings
	end # wbatting



end #module
