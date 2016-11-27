class ApplicationController < ActionController::Base
  	# Prevent CSRF attacks by raising an exception.
  	# For APIs, you may want to use :null_session instead.
  	protect_from_forgery with: :exception

    def get_page()
      @page = MaPage.where.not("id" => 0).where("parent_id" => nil)
    end

  	def get_base_message()
  		@file = File.read("data/messages/message_base.jp.js")
	    return JSON.parse(@file)
  	end

  	def get_app_message()
  		@file = File.read("data/messages/message_app.jp.js")
	    return JSON.parse(@file)
  	end

    def get_validate_message()
      @file = File.read("data/messages/validation_message.jp.js")
      return JSON.parse(@file)
    end    

  	def get_data_setting(data_name)
  		@file = File.read("data/settings/data_settings.js")
	    return JSON.parse(@file)["#{data_name}"]
  	end

    def get_alphabet_setting(file_name)
      @file = File.read("data/settings/" + file_name + "_settings.js")
      return JSON.parse(@file)["moji"]
    end

    def get_doshi_reigai_setting(kei)
      @file = File.read("data/settings/doshi_reigai_settings.js")
      return JSON.parse(@file)["#{kei}"]
    end

end
