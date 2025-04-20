module HomeHelper

	def over_all

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
		return rankings
	end #pitching

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
		return rankings
	end #wover_all

##############################   weekly Pitching #######################

	def wpitching
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
		return rankings
	end # wpitching

	#################  weekly batting ######################

	def wbatting
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

	######################################### player overall ranks  #####################################

	def bplayers

		doc = Nokogiri::HTML(URI.open('https://www.mlb.com/stats/hits'))
		n = []
		doc.css('.full-G_bAyq40').each do |data|
			n.push(data.content.strip)
		end

		names = n.each_slice(2).map { |first, last| "#{first} #{last}"}

		dhold = []
		doc.css('td').each do |data|
			dhold.push(data.content.strip)
		end

		dstats = []
		players = Hash.new {|hash,key| hash[key] = []}
		other_stats = Hash.new {|hash,key| hash[key] = []}
		names.each do |name|
			dstats = []
			dstats = dhold.shift(17)
			p = "#{name}, #{dstats[0]}"
			dstats.shift(3)
			other_stats[p] << dstats.delete_at(7)
			other_stats[p] << dstats.delete_at(8)
			players[p] = dstats
		end

		holder = Hash.new
		rankings = Hash.new { |hash, key| hash[key] = [] }
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
		return rankings

	end #bplayers

	def ppitching
		names = []
		phold = []
		n = []
		pages = ['https://www.mlb.com/stats/pitching/era?sortState=asc',
						'https://www.mlb.com/stats/pitching/era?page=2&sortState=asc']
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
		return rankings
	end # ppitching

	############### last 7 days player ranks ####################

	def wbplayers

		doc = Nokogiri::HTML(URI.open('https://www.mlb.com/stats/hits?timeframe=-7'))
		n = []
		doc.css('.full-G_bAyq40').each do |data|
			n.push(data.content.strip)
		end

		names = n.each_slice(2).map { |first, last| "#{first} #{last}"}

		dhold = []
		doc.css('td').each do |data|
			dhold.push(data.content.strip)
		end

		dstats = []
		players = Hash.new {|hash,key| hash[key] = []}
		other_stats = Hash.new {|hash,key| hash[key] = []}
		names.each do |name|
			dstats = []
			dstats = dhold.shift(17)
			p = "#{name}, #{dstats[0]}"
			dstats.shift(3)
			other_stats[p] << dstats.delete_at(7)
			other_stats[p] << dstats.delete_at(8)
			players[p] = dstats
		end

		holder = Hash.new
		rankings = Hash.new { |hash, key| hash[key] = [] }
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
		return rankings

	end #wbplayers

	def wbpitching
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
		return rankings
	end #wbpitching








end #module
