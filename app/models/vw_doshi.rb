class VwDoshi < ActiveRecord::Base
	self.table_name = self.table_name.chomp("s")

	def self.to_csv(options = {})
		@doshi_kei = get_data_setting("doshi_kei")
		@doshi_group = get_data_setting("doshi_group")

	  	CSV.generate(options) do |csv|
	    	@arr_kei_title = []
	    	@arr_kei_title.push(@doshi_kei[0]["title_jp"])
	    	@arr_kei_title.push("読み方")
	    	@arr_kei_title.push("グループ")	    	
	    	@doshi_kei.drop(1).each do |kei|
		    	@arr_kei_title.push(kei["title_jp"])
		    end
		    csv << @arr_kei_title

		    all.each do |kekka|
		    	csv << [kekka.jishokei, kekka.yomikata, @doshi_group.select {|item| item["value"] == kekka.group.to_s}[0]["title_jp"], kekka.masukei, kekka.tekei, kekka.kakokei, kekka.hiteikei, kekka.kanokei, kekka.ishikei, kekka.jyokenkei, kekka.meireikei, kekka.kinshikei, kekka.ukemikei, kekka.shiekikei, kekka.shiekiukemikei]
			end
	  	end
	end

	def self.get_data_setting(data_name)
  		@file = File.read("data/settings/data_settings.js")
	    return JSON.parse(@file)["#{data_name}"]
  	end
end
