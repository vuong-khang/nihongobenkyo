require "cl_kaisu"

class KaisuyomiController < ApplicationController
	include Kaisu

  	def yomi
  		@base_msg = get_base_message()
		@app_msg = get_app_message()
		@val_msg = get_validate_message()
		@page = get_page()
		@gengo = get_data_setting("gengo")
		@kaisu_hatsuon_jp = get_data_setting("kaisu_hatsuon_jp")
		@kaisu_hatsuon_vi = get_data_setting("kaisu_hatsuon_vi")
		@limit = [0, (10 ** 12) - 1]
		
		comma_char = ","
		hypen_char = "-"
		dot_char = "・"

		cookies[:kaisu] = params[:kaisu]

		if params[:kaisu]
			@kaisu_en = KaisuEn.new(params[:kaisu]).yomu().capitalize.strip.chomp(comma_char).chomp(hypen_char)
			@kaisu_jp = KaisuJp.new(params[:kaisu]).yomu()
			@kaisu_jp[:kanji] = @kaisu_jp[:kanji].gsub(/[　]/, "").chomp(dot_char)
			@kaisu_jp[:hira] = @kaisu_jp[:hira].gsub(/[　]/, "").chomp(dot_char)
			@kaisu_vi = KaisuVi.new(params[:kaisu]).yomu().capitalize.strip.chomp(comma_char).chomp(hypen_char)
			@arr_kekka = [
				{"gengo": @gengo[0], "kekka": @kaisu_en},
				{"gengo": @gengo[1], "kekka": @kaisu_jp},
				{"gengo": @gengo[2], "kekka": @kaisu_vi}
			]
		end

		respond_to do |format|
	  		format.html
	  		format.js
	  	end
  	end
end