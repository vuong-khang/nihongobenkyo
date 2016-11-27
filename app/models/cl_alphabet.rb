module Alphabet
	# ベースクラス
	class Alphabet < ApplicationController
		def find_same_row(moji, from_col, in_col)
			@get_from_column = @alphabet_column.select {|item| item["text"] == from_col}[0]["value"]
			@get_in_column = @alphabet_column.select {|item| item["text"] == in_col}[0]["value"]

			return @alphabet.select {|item| item[@get_from_column.to_i] == moji}[0][@get_in_column.to_i]
		end
	end

	#　ひらがなクラス
	class Hiragana < Alphabet
		def initialize
			@alphabet = get_alphabet_setting("hiragana")
			@alphabet_column = get_data_setting("alphabet_column")
		end
	end

	#　カタカナクラス
	class Katakana < Alphabet
		def initialize
			@alphabet = get_alphabet_setting("Katakana")
			@alphabet_column = get_data_setting("alphabet_column")
		end
	end
end