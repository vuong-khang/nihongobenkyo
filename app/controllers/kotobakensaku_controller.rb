class KotobakensakuController < ApplicationController
  	require "json"

  	def kensaku
  		@kekka = VwDoshi.all
  		@base_msg = get_base_message()
  		@app_msg = get_app_message()
  		@val_msg = get_validate_message()
  		@page = get_page()
  		@shosa_mode = get_data_setting("shosa_mode")
  		@doshi_kei = get_data_setting("doshi_kei")
  		@doshi_group = get_data_setting("doshi_group")
  		@message_box = get_data_setting("message_box")
  		@max_search_data_count = get_data_setting("max_search_data_count")

  		params[:search_kotoba] = params[:search_kotoba].nil? ? params[:search_kotoba] : params[:search_kotoba].strip.gsub(/[　]/, "")
  		params[:search_kei] = params[:search_kei].nil? ? params[:search_kei] : ActiveSupport::JSON.decode(params[:search_kei])  		

  		cookies[:auto_search] = params[:auto_search]
    	cookies[:search_kotoba] = params[:search_kotoba]
    	cookies[:search_doshi_group] = params[:search_doshi_group]
    	cookies[:search_kei] = params[:search_kei]

	    if params[:search_kotoba] && params[:search_kotoba].length > 0
			@kekka = @kekka.where("jishokei LIKE ? OR yomikata LIKE ?", "%#{params[:search_kotoba]}%", "%#{params[:search_kotoba]}%")			
		end

		if params[:search_doshi_group] && params[:search_doshi_group].length > 0
			@kekka = @kekka.where(:group => params[:search_doshi_group])
		end

	  	if params[:search_kei]
		  	params[:search_kei].each do |kei|
		  		@doshi_kei.drop(1).each do |doshi_kei|
		  			if kei == doshi_kei["value"]
		  				@kekka = @kekka.select(doshi_kei["text"], "#{doshi_kei["text"] + "_yomikata"}")
	  				end
	  			end
  			end
	  	end

	  	@kekka = @kekka.select("index", "jishokei", "yomikata", "group", "dt_create", "dt_update")
  						.order("jishokei")

		if @kekka.size > @max_search_data_count
			@message = {"type": @message_box[0], "content": @base_msg["MS0011"].gsub("{0}", @max_search_data_count.to_s)}

			@kekka = @kekka.take(@max_search_data_count)
		end

	  	respond_to do |format|
	  		format.html
	  		format.js
	  	end
  	end

  	def sentaku_sakujyo
		@base_msg = get_base_message()
  		@app_msg = get_app_message()
  		@val_msg = get_validate_message()
  		@page = get_page()
  		@doshi_kei = get_data_setting("doshi_kei")
  		@message_box = get_data_setting("message_box")
  		@message = nil

		params[:sentaku] = params[:sentaku].nil? ? params[:sentaku] : ActiveSupport::JSON.decode(params[:sentaku])

		if params[:sentaku]
		  	params[:sentaku].each do |index|
		  		ActiveRecord::Base.connection.execute("CALL sp_sentaku_sakujyo('#{index}')")
  			end
	  	end

	 	@message = {"type": @message_box[1], "content": @base_msg["MS0008"]}

	 	respond_to do |format|
	     	format.html
	     	format.js
	   	end
	end

	def csv_shutsuryoku
  		@kekka = VwDoshi.all
  		@base_msg = get_base_message()
  		@app_msg = get_app_message()
  		@val_msg = get_validate_message()
  		@page = get_page()
  		@doshi_kei = get_data_setting("doshi_kei")
  		@doshi_group = get_data_setting("doshi_group")

	    if cookies[:search_kotoba] && cookies[:search_kotoba].length > 0
			@kekka = @kekka.where("jishokei LIKE ? OR yomikata LIKE ?", "%#{cookies[:search_kotoba]}%", "%#{cookies[:search_kotoba]}%")
		end		

		if cookies[:search_doshi_group] && cookies[:search_doshi_group].length > 0
			@kekka = @kekka.where(:group => cookies[:search_doshi_group])
		end

  		@kekka = @kekka.order("jishokei")  		

		respond_to do |format|
		    format.csv {send_data @kekka.to_csv, :type => "text/csv; header=present", :filename => "動詞台帳.csv"}
	  	end
	end

	def excel_shutsuryoku
  		@kekka = VwDoshi.all
  		@base_msg = get_base_message()
  		@app_msg = get_app_message()
  		@val_msg = get_validate_message()
  		@page = get_page()
  		@doshi_kei = get_data_setting("doshi_kei")
  		@doshi_group = get_data_setting("doshi_group")

	    if cookies[:search_kotoba] && cookies[:search_kotoba].length > 0
			@kekka = @kekka.where("jishokei LIKE ? OR yomikata LIKE ?", "%#{cookies[:search_kotoba]}%", "%#{cookies[:search_kotoba]}%")
		end		

		if cookies[:search_doshi_group] && cookies[:search_doshi_group].length > 0
			@kekka = @kekka.where(:group => cookies[:search_doshi_group])
		end

		@arr_kekka = [
  			{"group": @doshi_group[0], "kekka": @kekka.where(:group => @doshi_group[0]["value"]).order("jishokei")},
  			{"group": @doshi_group[1], "kekka": @kekka.where(:group => @doshi_group[1]["value"]).order("jishokei")},
  			{"group": @doshi_group[2], "kekka": @kekka.where(:group => @doshi_group[2]["value"]).order("jishokei")}
  		]

		respond_to do |format|
		    format.xlsx {response.headers['Content-Disposition'] = 'attachment; filename="動詞台帳.xlsx"'}
	  	end
	end
end
