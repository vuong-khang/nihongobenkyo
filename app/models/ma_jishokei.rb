class MaJishokei < ActiveRecord::Base
	require "cl_doshikei"
	require "csv"

	include Doshikei

	self.table_name = self.table_name.chomp("s")

	validates :kotoba_kj, length: {maximum: 50, too_long: "VL0003"}, :presence => { :message => "VL0001" }
	validates :kotoba_hira, length: {maximum: 50, too_long: "VL0003"}, :presence => { :message => "VL0001" }

	def self.import(file)
		@doshi_group = get_data_setting("doshi_group")
		@doshi_kei = get_data_setting("doshi_kei")

		col_1 = @doshi_kei[0]["title_jp"]
		col_2 = "読み方"
		col_3 = "グループ"		

	  	CSV.foreach(file.path, headers: true) do |row|
	  		record_hash = row.to_hash
	  		kotoba_kj = record_hash[col_1].strip.gsub(/[　]/, "")
			kotoba_hira = record_hash[col_2].strip.gsub(/[　]/, "")
			group = @doshi_group.select {|item| item["title_jp"] == record_hash[col_3].strip.gsub(/[　]/, "")}[0]["value"]

      		record = MaJishokei.where(kotoba_kj: kotoba_kj)

      		if record.count == 1
        		kei_shusei(record[0]["index"], kotoba_kj, kotoba_hira, group)
      		else
      			new_index = generate_random_index()
				while MaJishokei.exists?(index: new_index) do
			   		new_index = generate_random_index()
				end				

	        	kei_tsuika(new_index, kotoba_kj, kotoba_hira, group)
	        end
	    end
	end

	def self.kei_tsuika(index, kotoba_kj, kotoba_hira, group)
		current_date_time = Time.now

		MaJishokei.create(
    		index: index,
			kotoba_kj: kotoba_kj,
			kotoba_hira: kotoba_hira,
			group: group,
			dt_create: current_date_time,
			dt_update: current_date_time
		)

		kotoba_ukemikei = Ukemikei.new(kotoba_kj, kotoba_hira, group).format_kei("ukemikei")
		MaUkemikei.create(
			index: index,
			kotoba_kj: kotoba_ukemikei.values[0],
			kotoba_hira: kotoba_ukemikei.values[1],
			dt_create: current_date_time,
			dt_update: current_date_time
		)

		kotoba_shiekikei = Shiekikei.new(kotoba_kj, kotoba_hira, group).format_kei("shiekikei")
		MaShiekikei.create(
			index: index,
			kotoba_kj: kotoba_shiekikei.values[0],
			kotoba_hira: kotoba_shiekikei.values[1],
			dt_create: current_date_time,
			dt_update: current_date_time
		)

		kotoba_shiekiukemikei = Shiekiukemikei.new(kotoba_kj, kotoba_hira, group).format_kei("shiekiukemikei")
		MaShiekiukemikei.create(
			index: index,
			kotoba_kj_1: kotoba_shiekiukemikei.values[0],
			kotoba_kj_2: kotoba_shiekiukemikei.values[1],
			kotoba_hira_1: kotoba_shiekiukemikei.values[2],
			kotoba_hira_2: kotoba_shiekiukemikei.values[3]
		)

		@doshi_kei[1, @doshi_kei.size - 4].each do |kei|
			cls_entity = "Ma" + kei["text"].capitalize
			cls_doshikei = "Doshikei::" + kei["text"].capitalize
			kotoba = Object.const_get(cls_doshikei).new(kotoba_kj, kotoba_hira, group).format_kei(kei["text"])

			Object.const_get(cls_entity).create(
				index: index,
				kotoba_kj: kotoba.values[0],
				kotoba_hira: kotoba.values[1],
				dt_create: current_date_time,
				dt_update: current_date_time
			)
    	end
	end

	def self.kei_shusei(index, kotoba_kj, kotoba_hira, group)
		current_date_time = Time.now

		kotoba_jishokei = MaJishokei.find(index)
		if kotoba_jishokei.present?
	  		kotoba_jishokei.kotoba_kj = kotoba_kj
	  		kotoba_jishokei.kotoba_hira = kotoba_hira
	  		kotoba_jishokei.group = group
	  		kotoba_jishokei.dt_update = current_date_time

	  		kotoba_jishokei.save
  		end

  		kotoba_ukemikei = MaUkemikei.find(index)
		if MaUkemikei.exists?(index)
	  		new_kotoba_ukemikei = Ukemikei.new(kotoba_kj, kotoba_hira, group).format_kei("ukemikei")  		
	  		kotoba_ukemikei.kotoba_kj = new_kotoba_ukemikei.values[0]
	  		kotoba_ukemikei.kotoba_hira = new_kotoba_ukemikei.values[1]
	  		kotoba_ukemikei.dt_update = current_date_time

	  		kotoba_ukemikei.save
	  	end

	  	kotoba_shiekikei = MaShiekikei.find(index)
		if MaShiekikei.exists?(index)
	  		new_kotoba_shiekikei = Shiekikei.new(kotoba_kj, kotoba_hira, group).format_kei("shiekikei")  		
	  		kotoba_shiekikei.kotoba_kj = new_kotoba_shiekikei.values[0]
	  		kotoba_shiekikei.kotoba_hira = new_kotoba_shiekikei.values[1]
	  		kotoba_shiekikei.dt_update = current_date_time

	  		kotoba_shiekikei.save
	  	end

	  	kotoba_shiekiukemikei = MaShiekiukemikei.find(index)
		if MaShiekiukemikei.exists?(index)
	  		new_kotoba_shiekiukemikei = Shiekiukemikei.new(kotoba_kj, kotoba_hira, group).format_kei("shiekiukemikei")  		
	  		kotoba_shiekiukemikei.kotoba_kj_1 = new_kotoba_shiekiukemikei.values[0]
	  		kotoba_shiekiukemikei.kotoba_kj_2 = new_kotoba_shiekiukemikei.values[1]
	  		kotoba_shiekiukemikei.kotoba_hira_1 = new_kotoba_shiekiukemikei.values[2]
	  		kotoba_shiekiukemikei.kotoba_hira_2 = new_kotoba_shiekiukemikei.values[3]
	  		kotoba_shiekiukemikei.dt_update = current_date_time

	  		kotoba_shiekiukemikei.save
	  	end

		@doshi_kei[1, @doshi_kei.size - 4].each do |kei|
			cls_entity = "Ma" + kei["text"].capitalize
			cls_doshikei = "Doshikei::" + kei["text"].capitalize
			kotoba = Object.const_get(cls_entity).find(index)

			if Object.const_get(cls_entity).exists?(index)
		  		new_kotoba = Object.const_get(cls_doshikei).new(kotoba_kj, kotoba_hira, group).format_kei(kei["text"])  		
		  		kotoba.kotoba_kj = new_kotoba.values[0]
		  		kotoba.kotoba_hira = new_kotoba.values[1]
		  		kotoba.dt_update = current_date_time

		  		kotoba.save
		  	end
		end
	end

	def self.generate_random_index
		ran_char = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
		return (0...20).map { ran_char[rand(ran_char.length)] }.join
	end

	def self.get_data_setting(data_name)
  		file = File.read("data/settings/data_settings.js")
	    return JSON.parse(file)["#{data_name}"]
  	end
end
