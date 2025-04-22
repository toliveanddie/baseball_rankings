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


	######################  weekly overall ########################


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

		names = []
		n = []
		sholder = []
		pages = ['https://www.mlb.com/stats/ops',
						'https://www.mlb.com/stats/ops?page=2',
						'https://www.mlb.com/stats/ops?page=3']
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
		return sorted

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
			p = "#{name}, #{pstats[0]}"
			fstats = pstats.values_at(1, 10, 17)
			rstats = pstats.values_at(2, 3, 11, 12, 13, 14, 15, 16, 18, 19)
			rteams[p] = rstats
			fteams[p] = fstats
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
		return sorted

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
			p = "#{name}, #{pstats[0]}"
			fstats = pstats.values_at(1, 10, 17)
			rstats = pstats.values_at(2, 3, 11, 12, 13, 14, 15, 16, 18, 19)
			rteams[p] = rstats
			fteams[p] = fstats
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
