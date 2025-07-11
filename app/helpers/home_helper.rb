module HomeHelper

##############################   YTD team Pitching #######################

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
	end #pitching

	#################  YTD team batting ######################

	def batting
		names = []
		sholder = []

		doc = Nokogiri::HTML(URI.open('https://www.mlb.com/stats/team'))
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
			bteams[names[index]] = stats.values_at(2,3,4,5,6,7,8,9,11,13,14,15,16)
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
	end # batting

	################################## YTD overall team ranks ######################
	def over_all

		rankings = Hash.new
		pitching.each do |k,v|
			rankings[k] = (pitching[k] + batting[k])/2
		end
		return rankings.sort_by{|k,v| v}.to_h
		
	end #over_all

##############################   9 Day Pitching #######################

	def wpitching
		doc = Nokogiri::HTML(URI.open('https://www.mlb.com/stats/team/pitching?timeframe=-9'))
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
	end # wpitching

	#################  weekly batting ######################

	def wbatting
		names = []
		sholder = []

		doc = Nokogiri::HTML(URI.open('https://www.mlb.com/stats/team/ops?timeframe=-9'))
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
			bteams[names[index]] = stats.values_at(2,3,4,5,6,7,8,9,11,13,14,15,16)
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
	end # wbatting

	######################  weekly overall ########################


	def wover_all

		rankings = Hash.new
		wpitching.each do |k,v|
			rankings[k] = (wpitching[k] + wbatting[k])/2
		end
		return rankings.sort_by{|k,v| v}.to_h
		
	end #wover_all


	######################################### player overall ranks  #####################################

	def bplayers

		names = []
		n = []
		sholder = []
		pages = (1..25).map do |page_number|
			if page_number == 1
				"https://www.mlb.com/stats/hits?"
			else
				"https://www.mlb.com/stats/hits?page=#{page_number}"
			end
		end
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
			g = stats[1].to_i
			ab = stats[2].to_i
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
		return sorted

	end #bplayers
  ########################### YTD Pitching ###################################
	def ppitching
		names = []
		phold = []
		n = []
		pages = ['https://www.mlb.com/stats/pitching/innings-pitched',
						 'https://www.mlb.com/stats/pitching/innings-pitched?page=2',
						 'https://www.mlb.com/stats/pitching/innings-pitched?page=3',
						 'https://www.mlb.com/stats/pitching/innings-pitched?page=4',
						 'https://www.mlb.com/stats/pitching/innings-pitched?page=5',
						 'https://www.mlb.com/stats/pitching/innings-pitched?page=6',]
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

	######################### Weekly player ranks ####################

	def wbplayers

		players = Hash.new
		names = []
		n = []
		sholder = []
		days_back = "9"
		pages = (1..17).map do |page_number|
			if page_number == 1
				"https://www.mlb.com/stats/hits?timeframe=-"
			else
				"https://www.mlb.com/stats/hits?page=#{page_number}&timeframe=-"
			end
		end
		pages.each do |page|
			full_url = "#{page}#{days_back}"
			doc = Nokogiri::HTML(URI.open(full_url))
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

		all_stats.each_with_index do |stats, index|
			p = "#{names[index]}, #{stats[0]}"
			g = stats[1].to_i
			ab = stats[2].to_i
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
		return sorted

	end #wbplayers

############################ Weekly pitching ###################################

	def wbpitching
		players = Hash.new
		names = []
		n = []
		sholder = []
		days_back = "9"
		pages = (1..19).map do |page_number|
			if page_number == 1
				"https://www.mlb.com/stats/pitching/innings-pitched?timeframe=-"
			else
				"https://www.mlb.com/stats/pitching/innings-pitched?page=#{page_number}&timeframe=-"
			end
		end
		pages.each do |page|
			full_url = "#{page}#{days_back}"
			doc = Nokogiri::HTML(URI.open(full_url))
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

		all_stats.each_with_index do |stats, index|
			p = "#{names[index]}, #{stats[0]}"
			ip = stats[10].to_f
			totals = stats.values_at(11, 13, 15, 16).map(&:to_i).sum.to_f
			work = (totals * 9)/ip
			if ip > 4.2
				players[p] = work.round(2)
			end
		end

		sorted = players.sort_by{|k,v| v}.to_h
		return sorted
	end #wbpitching

	################################## k per nine ######################

	def k_per_nine
		players = Hash.new
		names = []
		n = []
		sholder = []
		days_back = "9"
		pages = (1..21).map do |page_number|
			if page_number == 1
				"https://www.mlb.com/stats/pitching/innings-pitched?timeframe=-"
			else
				"https://www.mlb.com/stats/pitching/innings-pitched?page=#{page_number}&timeframe=-"
			end
		end
		pages.each do |page|
			full_url = "#{page}#{days_back}"
			doc = Nokogiri::HTML(URI.open(full_url))
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

		all_stats.each_with_index do |stats, index|
			p = "#{names[index]}, #{stats[0]}"
			ip = stats[10].to_f
			pstats = stats[17].to_f
			work = ((pstats * 9)/ip).round(2)
			if ip > 4.2
				players[p] = work
			end
		end

		sorted = players.sort_by{|k,v| v}.reverse.to_h
		return sorted
	end #k per nine

	########################### weekly individual stat leaders #######################

	def batting_leaders
		names = []
		n = []
		sholder = []
		pages = (1..17).map do |page_number|
			if page_number == 1
				"https://www.mlb.com/stats/at-bats?timeframe=-9"
			else
				"https://www.mlb.com/stats/at-bats?page=#{page_number}&timeframe=-9"
			end
		end

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
			players[p] = stats.map(&:to_f) if stats[0].to_i > 10
		end

		stat_name = ['AB', 'R', 'H', '2B', '3B', 'HR', 'RBI', 'BB', 'SO', 'SB', 'CS', 'AVG', 'OBP', 'SLG', 'OPS']
		leaders = Hash.new
		stat_name.each_with_index do |stat, index|
			sorted = players.sort_by {|name, stats| -stats[index]}
			top_ten = sorted.first(10).map do |player|
				{ name: player[0], stat: player[1][index]}
			end
			leaders[stat] = top_ten
		end
		return leaders
	end #batting_leaders

		########### weekly pitching stat leaders #######################

	def pitching_leaders
		names = []
		n = []
		sholder = []
		pages = (1..18).map do |page_number|
			if page_number == 1
				"https://www.mlb.com/stats/pitching/innings-pitched?timeframe=-9"
			else
				"https://www.mlb.com/stats/pitching/innings-pitched?page=#{page_number}&timeframe=-9"
			end
		end

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
			pitchers[p] = stats.values_at(3, 11, 12, 13, 16, 18, 19).map(&:to_f) if stats[10].to_f > 4.2
			spitchers[p] = stats.values_at(10, 17).map(&:to_f) if stats[10].to_f > 4.2
		end

		stat_name = ['ERA', 'H', 'R', 'ER', 'BB', 'WHIP', 'AVG']
		leaders = Hash.new
		stat_name.each_with_index do |stat, index|
			sorted = pitchers.sort_by {|name, stats| stats[index]}
			top_ten = sorted.first(10).map do |pitcher|
				{ name: pitcher[0], stat: pitcher[1][index]}
			end
			leaders[stat] = top_ten
		end

		stat_name = ['IP', 'SO']
		stat_name.each_with_index do |stat, index|
			sorted = spitchers.sort_by {|name, stats| -stats[index]}
			top_ten = sorted.first(10).map do |pitcher|
				{name: pitcher[0], stat: pitcher[1][index]}
			end
			leaders[stat] = top_ten
		end
		return leaders
	end #pitching_leaders


############################## cycle watch ###########################

	def player_stat_cycle

		players = Hash.new
		9.downto(0) do |days|
			names = []
			n = []
			sholder = []
			pages = ['https://www.mlb.com/stats/triples?timeframe=-',
							'https://www.mlb.com/stats/triples?page=2&timeframe=-',
							'https://www.mlb.com/stats/triples?page=3&timeframe=-',
							'https://www.mlb.com/stats/triples?page=4&timeframe=-',
							'https://www.mlb.com/stats/triples?page=5&timeframe=-']
			pages.each do |page|
				full_url = "#{page}#{days}"
				doc = Nokogiri::HTML(URI.open(full_url))
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

			all_stats.each_with_index do |stats, index|
				p = "#{names[index]}, #{stats[0]}"
				h = stats[4].to_i
				b2 = stats[5].to_i
				b3 = stats[6].to_i
				hr = stats[7].to_i
				b1 = h - (b2+b3+hr)
				players[p] = days unless [b1,b2,b3,hr].include?(0)
			end
			puts days
		end

		return players.sort_by{|k,v| v}.to_h

	end # player_stat_cycle


	def team_stat_cycle

		teams = Hash.new

		9.downto(0) do |days|
			names = []
			sholder = []
			base = "https://www.mlb.com/stats/team?timeframe=-"
			doc = Nokogiri::HTML(URI.open("#{base}#{days}"))
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


			all_stats.each_with_index do |stats, index|
				hits = stats[4].to_i
				doubles = stats[5].to_i
				triples = stats[6].to_i
				homeruns = stats[7].to_i
				singles = hits - (doubles + triples + homeruns)
				teams[names[index]] = days unless [singles, doubles, triples, homeruns].include?(0)
			end
			puts days
		end

		return teams.sort_by{|k,v| v}.to_h

	end #team_stat_cycle


end #module
