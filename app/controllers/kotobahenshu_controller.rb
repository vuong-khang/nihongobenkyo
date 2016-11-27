require "cl_doshikei"
require "csv"

class KotobahenshuController < ApplicationController
	include Doshikei

  	def henshu
		@base_msg = get_base_message()
  		@app_msg = get_app_message()
  		@val_msg = get_validate_message()
  		@page = get_page()
  		@hiragana = get_alphabet_setting("hiragana")
  		@katakana = get_alphabet_setting("katakana")
  		@doshi_reigai = get_doshi_reigai_setting("reigai")
  		@alphabet_column = get_data_setting("alphabet_column")
  		@shosa_mode = get_data_setting("shosa_mode")
  		@doshi_group = get_data_setting("doshi_group")

  		if params[:mode] == @shosa_mode[1]["value"]
			@kotoba = MaJishokei.find(params[:index])
		else
			@kotoba = nil
  		end
	end

	def hozon
		@base_msg = get_base_message()
  		@app_msg = get_app_message()
  		@val_msg = get_validate_message()
  		@page = get_page()
  		@hiragana = get_alphabet_setting("hiragana")
  		@katakana = get_alphabet_setting("katakana")
  		@alphabet_column = get_data_setting("alphabet_column")
  		@shosa_mode = get_data_setting("shosa_mode")
  		@doshi_group = get_data_setting("doshi_group")
  		@doshi_kei = get_data_setting("doshi_kei")
  		@message_box = get_data_setting("message_box")

  		@entity = nil
  		@message = {"type": @message_box[0], "content": @base_msg["MS0007"]}

  		params[:input_kotoba_kj] = params[:input_kotoba_kj].nil? ? params[:input_kotoba_kj] : params[:input_kotoba_kj].strip.gsub(/[　]/, "")
  		params[:input_kotoba_hira] = params[:input_kotoba_hira].nil? ? params[:input_kotoba_hira] : params[:input_kotoba_hira].strip.gsub(/[　]/, "")

  		if (params[:mode] != @shosa_mode[2]["value"] &&
  			(!params[:mode] || !params[:input_kotoba_kj] || !params[:input_kotoba_hira] || !params[:input_doshi_group]))
  			@message = {"type": @message_box[2], "content": @base_msg["MS0007"]}
		else
			case params[:mode]
		  		when @shosa_mode[0]["value"]
		  			@new_index = generate_random_index()
		  			while MaJishokei.exists?(index: @new_index) do
				   		@new_index = generate_random_index()
					end

		  			@entity = kei_tsuika(@new_index, params[:input_kotoba_kj], params[:input_kotoba_hira], params[:input_doshi_group])
				when @shosa_mode[1]["value"]
					@entity = kei_shusei(params[:index], params[:input_kotoba_kj], params[:input_kotoba_hira], params[:input_doshi_group])
		  		when @shosa_mode[2]["value"]
					@entity = kei_sakujo(params[:index])
				else
					@message = {"type": @message_box[2], "content": @base_msg["MS0006"]}
	  		end
  		end

  		flash[:auto_search] = cookies[:auto_search]

	   	respond_to do |format|
	     	format.html {redirect_to params[:mode] == @shosa_mode[2]["value"] ? kotoba_kensaku_path(auto_search: cookies[:auto_search], search_kotoba: cookies[:search_kotoba], search_doshi_group: cookies[:search_doshi_group]) : kotoba_henshu_path(index: params[:index])}
	     	format.js {render action: "henshu", index: params[:index]}
	   	end
  	end

  	def csv_upload
  		@base_msg = get_base_message()
  		@app_msg = get_app_message()
  		@val_msg = get_validate_message()
  		@page = get_page()
  		@hiragana = get_alphabet_setting("hiragana")
  		@katakana = get_alphabet_setting("katakana")
  		@alphabet_column = get_data_setting("alphabet_column")
  		@shosa_mode = get_data_setting("shosa_mode")
  		@doshi_group = get_data_setting("doshi_group")
  		@doshi_kei = get_data_setting("doshi_kei")
  		@message_box = get_data_setting("message_box")

  		MaJishokei.import(params[:csv_file])
  		@message = {"type": @message_box[2], "content": @base_msg["MS0007"]}
  		
  		respond_to do |format|
	     	format.html {redirect_to kotoba_henshu_path(mode: @shosa_mode[0]["value"])}
	     	format.js {render action: "henshu"}
	   	end
  	end

	private def kei_tsuika(index, kotoba_kj, kotoba_hira, group)
		if MaJishokei.exists?(kotoba_kj: kotoba_kj)
			@message = {"type": @message_box[2], "content": @base_msg["MS0005"]} 

			return nil
		else
			@current_date_time = Time.now

			@entity_jishokei = MaJishokei.create(
				index: index,
				kotoba_kj: kotoba_kj,
				kotoba_hira: kotoba_hira,
				group: group,
				dt_create: @current_date_time,
				dt_update: @current_date_time
			)
			if !@entity_jishokei.save
		    	@message = {"type": @message_box[2], "content": @entity_jishokei.errors.full_messages}
			    return nil
			end

			@kotoba_ukemikei = Ukemikei.new(kotoba_kj, kotoba_hira, group).format_kei("ukemikei")
			@entity_ukemikei  = MaUkemikei.create(
				index: index,
				kotoba_kj: @kotoba_ukemikei.values[0],
				kotoba_hira: @kotoba_ukemikei.values[1],
				dt_create: @current_date_time,
				dt_update: @current_date_time
			)
			if !@entity_ukemikei.save
		    	@message = {"type": @message_box[2], "content": @entity_ukemikei.errors.full_messages}
		    	return nil
	    	end

			@kotoba_shiekikei = Shiekikei.new(kotoba_kj, kotoba_hira, group).format_kei("shiekikei")
			@entity_shiekikei = MaShiekikei.create(
				index: index,
				kotoba_kj: @kotoba_shiekikei.values[0],
				kotoba_hira: @kotoba_shiekikei.values[1],
				dt_create: @current_date_time,
				dt_update: @current_date_time
			)
			if !@entity_shiekikei.save
		    	@message = {"type": @message_box[2], "content": @entity_shiekikei.errors.full_messages}
		    	return nil
	    	end

			@kotoba_shiekiukemikei = Shiekiukemikei.new(kotoba_kj, kotoba_hira, group).format_kei("shiekiukemikei")
			@entity_shiekiukemikei = MaShiekiukemikei.create(
				index: index,
				kotoba_kj_1: @kotoba_shiekiukemikei.values[0],
				kotoba_kj_2: @kotoba_shiekiukemikei.values[1],
				kotoba_hira_1: @kotoba_shiekiukemikei.values[2],
				kotoba_hira_2: @kotoba_shiekiukemikei.values[3]
			)
			if !@entity_shiekiukemikei.save
		    	@message = {"type": @message_box[2], "content": @entity_shiekiukemikei.errors.full_messages}
		    	return nil
	    	end

			@doshi_kei[1, @doshi_kei.size - 4].each do |kei|
				@cls_entity = "Ma" + kei["text"].capitalize
				@cls_doshikei = "Doshikei::" + kei["text"].capitalize
				@kotoba = Object.const_get(@cls_doshikei).new(kotoba_kj, kotoba_hira, group).format_kei(kei["text"])

				@entity = Object.const_get(@cls_entity).create(
					index: @new_index,
					kotoba_kj: @kotoba.values[0],
					kotoba_hira: @kotoba.values[1],
					dt_create: @current_date_time,
					dt_update: @current_date_time
				)
				if !@entity.save
			    	@message = {"type": @message_box[2], "content": @entity.errors.full_messages}			    	
			    	return nil
			    end
	    	end

			@message = {"type": @message_box[1], "content": @base_msg["MS0003"]} 
			return @entity_jishokei
		end
	end

	private def kei_shusei(index, kotoba_kj, kotoba_hira, group)
		if MaJishokei.exists?(kotoba_kj: kotoba_kj)
			@message = {"type": @message_box[2], "content": @base_msg["MS0005"]}
			return MaJishokei.find(index)
		else
			if !MaJishokei.exists?(index)
				@message = {"type": @message_box[2], "content": @base_msg["MS0010"]}
				return nil
			end
			
			@current_date_time = Time.now

			@kotoba_jishokei = MaJishokei.find(index)
			if @kotoba_jishokei.present?
		  		@kotoba_jishokei.kotoba_kj = kotoba_kj
		  		@kotoba_jishokei.kotoba_hira = kotoba_hira
		  		@kotoba_jishokei.group = group
		  		@kotoba_jishokei.dt_update = @current_date_time

		  		if !@kotoba_jishokei.save
			    	@message = {"type": @message_box[2], "content": @kotoba_jishokei.errors.full_messages}
				    return nil
				else
					@kotoba_jishokei.save
				end
	  		end

	  		@kotoba_ukemikei = MaUkemikei.find(index)
			if MaUkemikei.exists?(index)
		  		@new_kotoba_ukemikei = Ukemikei.new(kotoba_kj, kotoba_hira, group).format_kei("ukemikei")  		
		  		@kotoba_ukemikei.kotoba_kj = @new_kotoba_ukemikei.values[0]
		  		@kotoba_ukemikei.kotoba_hira = @new_kotoba_ukemikei.values[1]
		  		@kotoba_ukemikei.dt_update = @current_date_time

		  		if !@kotoba_ukemikei.save
			    	@message = {"type": @message_box[2], "content": @kotoba_ukemikei.errors.full_messages}
				    return nil
				else
					@kotoba_ukemikei.save
				end
		  	end

		  	@kotoba_shiekikei = MaShiekikei.find(index)
			if MaShiekikei.exists?(index)
		  		@new_kotoba_shiekikei = Shiekikei.new(kotoba_kj, kotoba_hira, group).format_kei("shiekikei")  		
		  		@kotoba_shiekikei.kotoba_kj = @new_kotoba_shiekikei.values[0]
		  		@kotoba_shiekikei.kotoba_hira = @new_kotoba_shiekikei.values[1]
		  		@kotoba_shiekikei.dt_update = @current_date_time
		  		
		  		if !@kotoba_shiekikei.save
			    	@message = {"type": @message_box[2], "content": @kotoba_shiekikei.errors.full_messages}
				    return nil
				else
					@kotoba_shiekikei.save
				end
		  	end

		  	@kotoba_shiekiukemikei = MaShiekiukemikei.find(index)
			if MaShiekiukemikei.exists?(index)
		  		@new_kotoba_shiekiukemikei = Shiekiukemikei.new(kotoba_kj, kotoba_hira, group).format_kei("shiekiukemikei")  		
		  		@kotoba_shiekiukemikei.kotoba_kj_1 = @new_kotoba_shiekiukemikei.values[0]
		  		@kotoba_shiekiukemikei.kotoba_kj_2 = @new_kotoba_shiekiukemikei.values[1]
		  		@kotoba_shiekiukemikei.kotoba_hira_1 = @new_kotoba_shiekiukemikei.values[2]
		  		@kotoba_shiekiukemikei.kotoba_hira_2 = @new_kotoba_shiekiukemikei.values[3]
		  		@kotoba_shiekiukemikei.dt_update = @current_date_time
		  		
		  		if !@kotoba_shiekiukemikei.save
			    	@message = {"type": @message_box[2], "content": @kotoba_shiekiukemikei.errors.full_messages}
				    return nil
				else
					@kotoba_shiekiukemikei.save
				end
		  	end

			@doshi_kei[1, @doshi_kei.size - 4].each do |kei|
				@cls_entity = "Ma" + kei["text"].capitalize
				@cls_doshikei = "Doshikei::" + kei["text"].capitalize
				@kotoba = Object.const_get(@cls_entity).find(index)

				if Object.const_get(@cls_entity).exists?(index)
			  		@new_kotoba = Object.const_get(@cls_doshikei).new(kotoba_kj, kotoba_hira, group).format_kei(kei["text"])  		
			  		@kotoba.kotoba_kj = @new_kotoba.values[0]
			  		@kotoba.kotoba_hira = @new_kotoba.values[1]
			  		@kotoba.dt_update = @current_date_time
			  		
			  		if !@kotoba.save
				    	@message = {"type": @message_box[2], "content": @kotoba.errors.full_messages}
					    return nil
					else
						@kotoba.save
					end
			  	end
			end

			@message = {"type": @message_box[1], "content": @base_msg["MS0003"]}
			return @kotoba_jishokei
		end
	end

	private def kei_sakujo(index)
		if !MaJishokei.exists?(index)
			@message = {"type": @message_box[2], "content": @base_msg["MS0010"]}
			return nil
		end

		@kotoba_jishokei = MaJishokei.find(index)
		@kotoba_jishokei.destroy

		@doshi_kei[1, @doshi_kei.size].each do |kei|
			@cls_entity = "Ma" + kei["text"].capitalize

			@doshikei = Doshikei.const_get(@cls_entity).find(index)
			if Object.const_get(@cls_entity).exists?(index)
				@doshikei.destroy
			end
		end

		@message = {"type": @message_box[1], "content": @base_msg["MS0008"]}
		return nil
	end

	private def generate_random_index
		@ran_char = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
		return (0...20).map { @ran_char[rand(@ran_char.length)] }.join
	end
end