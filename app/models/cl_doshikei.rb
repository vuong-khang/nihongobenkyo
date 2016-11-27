require "cl_alphabet"

module Doshikei
	# ベースクラス
	class Doshikei < ApplicationController
		include Alphabet

		def initialize(jishokei_kj, jishokei_hira, group)
			@alphabet_column = get_data_setting("alphabet_column")
			@doshi_group = get_data_setting("doshi_group")

			@jishokei_kj = jishokei_kj
			@jishokei_hira = jishokei_hira
			@group = group
		end

		def format_kei(kei)			
			@kotoba_reigai = get_doshi_reigai_setting(kei)
			@kei_end = get_data_setting(kei + "_end")

			if !@jishokei_kj.blank? && !@jishokei_hira.blank?
				if !is_reigai_kotoba(@kotoba_reigai, @jishokei_kj)
					case @group
						when @doshi_group[0]["value"]
							return format_kei_group_1
						when @doshi_group[1]["value"]
							return format_kei_group_2
						when @doshi_group[2]["value"]
							return format_kei_group_3
			  		end
		  		else
					@kotoba_kei_reigai = @kotoba_reigai.select {|item| item[0] == @jishokei_kj}

					if @kotoba_kei_reigai[0].size == 4
						return {"kotoba_kj": @kotoba_kei_reigai[0][2], "kotoba_hira": @kotoba_kei_reigai[0][3]}
					else
						return "Lỗi"
					end
	  			end
  			end
		end

		protected def format_kei_group_1			
		end

		protected def format_kei_group_2
		end

		protected def format_kei_group_3
		end

		protected def is_reigai_kotoba(kotoba_reigai, kotoba)
			return kotoba_reigai.any? {|item| item[0] == kotoba} || kotoba_reigai.any? {|item| item[1] == kotoba}
		end
	end

	#　ます形クラス
	class Masukei < Doshikei
		private def format_kei_group_1			
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@masukei_last_char = @kei_end[0]["text"]
			@masukei_sub_last_char = Hiragana.new().find_same_row(@jishokei_last_char[0], "う_col", "い_col")

			@masukei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@masukei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@masukei_kj = @masukei_kj_first_part + @masukei_sub_last_char + @masukei_last_char
			@masukei_hira = @masukei_hira_first_part + @masukei_sub_last_char + @masukei_last_char

			return {"kotoba_kj": @masukei_kj, "kotoba_hira": @masukei_hira} 
		end

		private def format_kei_group_2
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@masukei_last_char = @kei_end[0]["text"]

			@masukei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@masukei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@masukei_kj = @masukei_kj_first_part + @masukei_last_char
			@masukei_hira = @masukei_hira_first_part + @masukei_last_char

			return {"kotoba_kj": @masukei_kj, "kotoba_hira": @masukei_hira} 
		end

		private def format_kei_group_3
			@jishokei_last_char = @jishokei_kj[-2, 2]
			@masukei_last_char = @kei_end[0]["text"]
			@masukei_sub_last_char = Hiragana.new().find_same_row(@jishokei_last_char[0], "う_col", "い_col")

			@masukei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@masukei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@masukei_kj = @masukei_kj_first_part + @masukei_sub_last_char + @masukei_last_char
			@masukei_hira = @masukei_hira_first_part + @masukei_sub_last_char + @masukei_last_char

			return {"kotoba_kj": @masukei_kj, "kotoba_hira": @masukei_hira}
		end
	end

	#　て形クラス
	class Tekei < Doshikei
		private def format_kei_group_1
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@tekei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]
										.select {|item| item["end_with"].index(@jishokei_last_char)}[0]["sub_text"]

			@tekei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@tekei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@tekei_kj = @tekei_kj_first_part + @tekei_last_char
			@tekei_hira = @tekei_hira_first_part + @tekei_last_char

			return {"kotoba_kj": @tekei_kj, "kotoba_hira": @tekei_hira}
		end

		private def format_kei_group_2
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@tekei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@tekei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@tekei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@tekei_kj = @tekei_kj_first_part + @tekei_last_char
			@tekei_hira = @tekei_hira_first_part + @tekei_last_char

			return {"kotoba_kj": @tekei_kj, "kotoba_hira": @tekei_hira}
		end

		private def format_kei_group_3
			@jishokei_last_char = @jishokei_kj[-2, 2]
			@tekei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@tekei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@tekei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@tekei_kj = @tekei_kj_first_part + @tekei_last_char
			@tekei_hira = @tekei_hira_first_part + @tekei_last_char

			return {"kotoba_kj": @tekei_kj, "kotoba_hira": @tekei_hira}
		end
	end

	#　過去形クラス
	class Kakokei < Doshikei
		private def format_kei_group_1
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@kakokei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]
											.select {|item| item["end_with"].index(@jishokei_last_char)}[0]["sub_text"]

			@kakokei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@kakokei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@kakokei_kj = @kakokei_kj_first_part + @kakokei_last_char
			@kakokei_hira = @kakokei_hira_first_part + @kakokei_last_char

			return {"kotoba_kj": @kakokei_kj, "kotoba_hira": @kakokei_hira} 
		end

		private def format_kei_group_2
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@kakokei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@kakokei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@kakokei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@kakokei_kj = @kakokei_kj_first_part + @kakokei_last_char
			@kakokei_hira = @kakokei_hira_first_part + @kakokei_last_char

			return {"kotoba_kj": @kakokei_kj, "kotoba_hira": @kakokei_hira}
		end

		private def format_kei_group_3
			@jishokei_last_char = @jishokei_kj[-2, 2]
			@kakokei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@kakokei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@kakokei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@kakokei_kj = @kakokei_kj_first_part + @kakokei_last_char
			@kakokei_hira = @kakokei_hira_first_part + @kakokei_last_char

			return {"kotoba_kj": @kakokei_kj, "kotoba_hira": @kakokei_hira}
		end
	end

	#　否定形クラス
	class Hiteikei < Doshikei
		private def format_kei_group_1			
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@hiteikei_last_char = @kei_end[0]["text"]
			if @jishokei_last_char == @kei_end[0]["special"][0]
				@hiteikei_sub_last_char = @kei_end[0]["special"][1]
			else
				@hiteikei_sub_last_char = Hiragana.new().find_same_row(@jishokei_last_char, "う_col", "あ_col")
			end			

			@hiteikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@hiteikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@hiteikei_kj = @hiteikei_kj_first_part + @hiteikei_sub_last_char + @hiteikei_last_char
			@hiteikei_hira = @hiteikei_hira_first_part + @hiteikei_sub_last_char + @hiteikei_last_char

			return {"kotoba_kj": @hiteikei_kj, "kotoba_hira": @hiteikei_hira}
		end

		private def format_kei_group_2
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@hiteikei_last_char = @kei_end[0]["text"]

			@hiteikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@hiteikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@hiteikei_kj = @hiteikei_kj_first_part + @hiteikei_last_char
			@hiteikei_hira = @hiteikei_hira_first_part + @hiteikei_last_char

			return {"kotoba_kj": @hiteikei_kj, "kotoba_hira": @hiteikei_hira}			
		end

		private def format_kei_group_3
			@jishokei_last_char = @jishokei_kj[-2, 2]
			@hiteikei_last_char = @kei_end[0]["text"]
			@hiteikei_sub_last_char = Hiragana.new().find_same_row(@jishokei_last_char[0], "う_col", "い_col")

			@hiteikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@hiteikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@hiteikei_kj = @hiteikei_kj_first_part + @hiteikei_sub_last_char + @hiteikei_last_char
			@hiteikei_hira = @hiteikei_hira_first_part + @hiteikei_sub_last_char + @hiteikei_last_char

			return {"kotoba_kj": @hiteikei_kj, "kotoba_hira": @hiteikei_hira}
		end
	end

	#　可能形クラス
	class Kanokei < Doshikei
		private def format_kei_group_1			
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@kanokei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]
			@kanokei_sub_last_char = Hiragana.new().find_same_row(@jishokei_last_char, "う_col", "え_col")

			@kanokei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@kanokei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@kanokei_kj = @kanokei_kj_first_part + @kanokei_sub_last_char + @kanokei_last_char
			@kanokei_hira = @kanokei_hira_first_part + @kanokei_sub_last_char + @kanokei_last_char

			return {"kotoba_kj": @kanokei_kj, "kotoba_hira": @kanokei_hira}
		end

		private def format_kei_group_2
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@kanokei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@kanokei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@kanokei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@kanokei_kj = @kanokei_kj_first_part + @kanokei_last_char
			@kanokei_hira = @kanokei_hira_first_part + @kanokei_last_char

			return {"kotoba_kj": @kanokei_kj, "kotoba_hira": @kanokei_hira}
		end

		private def format_kei_group_3
			@jishokei_last_char = @jishokei_kj[-2, 2]
			@kanokei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@kanokei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@kanokei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@kanokei_kj = @kanokei_kj_first_part + @kanokei_last_char
			@kanokei_hira = @kanokei_hira_first_part + @kanokei_last_char

			return {"kotoba_kj": @kanokei_kj, "kotoba_hira": @kanokei_hira}
		end
	end

	#　意志形クラス
	class Ishikei < Doshikei
		private def format_kei_group_1			
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@ishikei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]
			@ishikei_sub_last_char = Hiragana.new().find_same_row(@jishokei_last_char, "う_col", "お_col")

			@ishikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@ishikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@ishikei_kj = @ishikei_kj_first_part + @ishikei_sub_last_char + @ishikei_last_char
			@ishikei_hira = @ishikei_hira_first_part + @ishikei_sub_last_char + @ishikei_last_char

			return {"kotoba_kj": @ishikei_kj, "kotoba_hira": @ishikei_hira}
		end

		private def format_kei_group_2
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@ishikei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@ishikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@ishikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@ishikei_kj = @ishikei_kj_first_part + @ishikei_last_char
			@ishikei_hira = @ishikei_hira_first_part + @ishikei_last_char

			return {"kotoba_kj": @ishikei_kj, "kotoba_hira": @ishikei_hira}
		end

		private def format_kei_group_3
			@jishokei_last_char = @jishokei_kj[-2, 2]
			@ishikei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@ishikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@ishikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@ishikei_kj = @ishikei_kj_first_part + @ishikei_last_char
			@ishikei_hira = @ishikei_hira_first_part + @ishikei_last_char

			return {"kotoba_kj": @ishikei_kj, "kotoba_hira": @ishikei_hira}
		end
	end

	#　条件形クラス
	class Jyokenkei < Doshikei
		private def format_kei_group_1			
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@jyokenkei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]
			@jyokenkei_sub_last_char = Hiragana.new().find_same_row(@jishokei_last_char, "う_col", "え_col")

			@jyokenkei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@jyokenkei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@jyokenkei_kj = @jyokenkei_kj_first_part + @jyokenkei_sub_last_char + @jyokenkei_last_char
			@jyokenkei_hira = @jyokenkei_hira_first_part + @jyokenkei_sub_last_char + @jyokenkei_last_char

			return {"kotoba_kj": @jyokenkei_kj, "kotoba_hira": @jyokenkei_hira}
		end

		private def format_kei_group_2
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@jyokenkei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@jyokenkei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@jyokenkei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@jyokenkei_kj = @jyokenkei_kj_first_part + @jyokenkei_last_char
			@jyokenkei_hira = @jyokenkei_hira_first_part + @jyokenkei_last_char

			return {"kotoba_kj": @jyokenkei_kj, "kotoba_hira": @jyokenkei_hira}
		end

		private def format_kei_group_3
			@jishokei_last_char = @jishokei_kj[-2, 2]
			@jyokenkei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@jyokenkei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@jyokenkei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@jyokenkei_kj = @jyokenkei_kj_first_part + @jyokenkei_last_char
			@jyokenkei_hira = @jyokenkei_hira_first_part + @jyokenkei_last_char

			return {"kotoba_kj": @jyokenkei_kj, "kotoba_hira": @jyokenkei_hira}
		end
	end

	#　命令形クラス
	class Meireikei < Doshikei
		private def format_kei_group_1			
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@meireikei_sub_last_char = Hiragana.new().find_same_row(@jishokei_last_char, "う_col", "え_col")

			@meireikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@meireikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@meireikei_kj = @meireikei_kj_first_part + @meireikei_sub_last_char
			@meireikei_hira = @meireikei_hira_first_part + @meireikei_sub_last_char

			return {"kotoba_kj": @meireikei_kj, "kotoba_hira": @meireikei_hira}
		end

		private def format_kei_group_2
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@meireikei_last_char = @kei_end[0]["text"]

			@meireikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@meireikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@meireikei_kj = @meireikei_kj_first_part + @meireikei_last_char
			@meireikei_hira = @meireikei_hira_first_part + @meireikei_last_char

			return {"kotoba_kj": @meireikei_kj, "kotoba_hira": @meireikei_hira}
		end

		private def format_kei_group_3
			@jishokei_last_char = @jishokei_kj[-2, 2]
			@meireikei_last_char = @kei_end[0]["text"]
			@meireikei_sub_last_char = Hiragana.new().find_same_row(@jishokei_last_char[0], "う_col", "い_col")

			@meireikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@meireikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@meireikei_kj = @meireikei_kj_first_part + @meireikei_sub_last_char + @meireikei_last_char
			@meireikei_hira = @meireikei_hira_first_part + @meireikei_sub_last_char + @meireikei_last_char

			return {"kotoba_kj": @meireikei_kj, "kotoba_hira": @meireikei_hira}
		end
	end

	#　禁止形クラス
	class Kinshikei < Doshikei
		private def format_kei_group_1
			@kinshikei_last_char = @kei_end[0]["text"]

			@kinshikei_kj = @jishokei_kj + @kinshikei_last_char
			@kinshikei_hira = @jishokei_hira + @kinshikei_last_char

			return {"kotoba_kj": @kinshikei_kj, "kotoba_hira": @kinshikei_hira}
		end

		private def format_kei_group_2
			@kinshikei_last_char = @kei_end[0]["text"]

			@kinshikei_kj = @jishokei_kj + @kinshikei_last_char
			@kinshikei_hira = @jishokei_hira + @kinshikei_last_char

			return {"kotoba_kj": @kinshikei_kj, "kotoba_hira": @kinshikei_hira}
		end

		private def format_kei_group_3
			@kinshikei_last_char = @kei_end[0]["text"]

			@kinshikei_kj = @jishokei_kj + @kinshikei_last_char
			@kinshikei_hira = @jishokei_hira + @kinshikei_last_char

			return {"kotoba_kj": @kinshikei_kj, "kotoba_hira": @kinshikei_hira}
		end
	end

	#　受身形クラス
	class Ukemikei < Doshikei
		private def format_kei_group_1			
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@ukemikei_last_char = @kei_end[0]["text"]
			if @jishokei_last_char == @kei_end[0]["special"][0]
				@ukemikei_sub_last_char = @kei_end[0]["special"][1]
			else
				@ukemikei_sub_last_char = Hiragana.new().find_same_row(@jishokei_last_char, "う_col", "あ_col")
			end

			@ukemikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@ukemikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@ukemikei_kj = @ukemikei_kj_first_part + @ukemikei_sub_last_char + @ukemikei_last_char
			@ukemikei_hira = @ukemikei_hira_first_part + @ukemikei_sub_last_char + @ukemikei_last_char

			return {"kotoba_kj": @ukemikei_kj, "kotoba_hira": @ukemikei_hira}
		end

		private def format_kei_group_2
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@ukemikei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@ukemikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@ukemikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@ukemikei_kj = @ukemikei_kj_first_part + @ukemikei_last_char
			@ukemikei_hira = @ukemikei_hira_first_part + @ukemikei_last_char

			return {"kotoba_kj": @ukemikei_kj, "kotoba_hira": @ukemikei_hira}
		end

		private def format_kei_group_3
			@jishokei_last_char = @jishokei_kj[-2, 2]
			@ukemikei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@ukemikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@ukemikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@ukemikei_kj = @ukemikei_kj_first_part + @ukemikei_last_char
			@ukemikei_hira = @ukemikei_hira_first_part + @ukemikei_last_char

			return {"kotoba_kj": @ukemikei_kj, "kotoba_hira": @ukemikei_hira}
		end
	end

	#　使役形クラス
	class Shiekikei < Doshikei
		private def format_kei_group_1			
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@shiekikei_last_char = @kei_end[0]["text"]
			if @jishokei_last_char == @kei_end[0]["special"][0]
				@shiekikei_sub_last_char = @kei_end[0]["special"][1]
			else
				@shiekikei_sub_last_char = Hiragana.new().find_same_row(@jishokei_last_char, "う_col", "あ_col")
			end			

			@shiekikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@shiekikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@shiekikei_kj = @shiekikei_kj_first_part + @shiekikei_sub_last_char + @shiekikei_last_char
			@shiekikei_hira = @shiekikei_hira_first_part + @shiekikei_sub_last_char + @shiekikei_last_char

			return {"kotoba_kj": @shiekikei_kj, "kotoba_hira": @shiekikei_hira}
		end

		private def format_kei_group_2
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@shiekikei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@shiekikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@shiekikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@shiekikei_kj = @shiekikei_kj_first_part + @shiekikei_last_char
			@shiekikei_hira = @shiekikei_hira_first_part + @shiekikei_last_char

			return {"kotoba_kj": @shiekikei_kj, "kotoba_hira": @shiekikei_hira}
		end

		private def format_kei_group_3
			@jishokei_last_char = @jishokei_kj[-2, 2]
			@shiekikei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@shiekikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@shiekikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@shiekikei_kj = @shiekikei_kj_first_part + @shiekikei_last_char
			@shiekikei_hira = @shiekikei_hira_first_part + @shiekikei_last_char

			return {"kotoba_kj": @shiekikei_kj, "kotoba_hira": @shiekikei_hira}
		end
	end

	#　使役受身形クラス
	class Shiekiukemikei < Doshikei
		def format_kei(kei)			
			@kotoba_reigai = get_doshi_reigai_setting(kei)
			@kei_end = get_data_setting(kei + "_end")

			if !@jishokei_kj.blank? && !@jishokei_hira.blank?
				if !is_reigai_kotoba(@kotoba_reigai, @jishokei_kj)
					case @group
						when @doshi_group[0]["value"]
							return format_kei_group_1
						when @doshi_group[1]["value"]
							return format_kei_group_2
						when @doshi_group[2]["value"]
							return format_kei_group_3
			  		end
		  		else
					@kotoba_kei_reigai = @kotoba_reigai.select {|item| item[0] == @jishokei_kj}

					if @kotoba_kei_reigai[0].size == 6
						return {"kotoba_kj_1": @kotoba_kei_reigai[0][2], "kotoba_kj_2": @kotoba_kei_reigai[0][3], "kotoba_hira_1": @kotoba_kei_reigai[0][4], "kotoba_hira_2": @kotoba_kei_reigai[0][5]}
					else
						return "Lỗi"
					end
	  			end
  			end
		end

		private def format_kei_group_1			
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@shiekiukemikei_last_char_1 = @kei_end[0]["text_1"]
			@shiekiukemikei_last_char_2 = @kei_end[0]["text_2"]
			if @jishokei_last_char == @kei_end[0]["special"][0]
				@shiekiukemikei_sub_last_char = @kei_end[0]["special"][1]
			else
				@shiekiukemikei_sub_last_char = Hiragana.new().find_same_row(@jishokei_last_char, "う_col", "あ_col")
			end

			@shiekiukemikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@shiekiukemikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@shiekiukemikei_kj_1 = @shiekiukemikei_kj_first_part + @shiekiukemikei_sub_last_char + @shiekiukemikei_last_char_1
			@shiekiukemikei_hira_1 = @shiekiukemikei_hira_first_part + @shiekiukemikei_sub_last_char + @shiekiukemikei_last_char_1
			@shiekiukemikei_kj_2 = @shiekiukemikei_kj_first_part + @shiekiukemikei_sub_last_char + @shiekiukemikei_last_char_2
			@shiekiukemikei_hira_2 = @shiekiukemikei_hira_first_part + @shiekiukemikei_sub_last_char + @shiekiukemikei_last_char_2

			return {"kotoba_kj_1": @shiekiukemikei_kj_1, "kotoba_kj_2": @shiekiukemikei_kj_2, "kotoba_hira_1": @shiekiukemikei_hira_1, "kotoba_hira_2": @shiekiukemikei_hira_2}
		end

		private def format_kei_group_2
			@jishokei_last_char = @jishokei_kj[-1, 1]
			@shiekiukemikei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@shiekiukemikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@shiekiukemikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@shiekiukemikei_kj = @shiekiukemikei_kj_first_part + @shiekiukemikei_last_char
			@shiekiukemikei_hira = @shiekiukemikei_hira_first_part + @shiekiukemikei_last_char

			return {"kotoba_kj_1": @shiekiukemikei_kj, "kotoba_kj_2": "", "kotoba_hira_1": @shiekiukemikei_hira, "kotoba_hira_2": ""}
		end

		private def format_kei_group_3
			@jishokei_last_char = @jishokei_kj[-2, 2]
			@shiekiukemikei_last_char = @kei_end.select {|item| item["value"] == @group}[0]["text"]

			@shiekiukemikei_kj_first_part = @jishokei_kj.chomp(@jishokei_last_char)
			@shiekiukemikei_hira_first_part = @jishokei_hira.chomp(@jishokei_last_char)

			@shiekiukemikei_kj = @shiekiukemikei_kj_first_part + @shiekiukemikei_last_char
			@shiekiukemikei_hira = @shiekiukemikei_hira_first_part + @shiekiukemikei_last_char

			return {"kotoba_kj_1": @shiekiukemikei_kj, "kotoba_kj_2": "", "kotoba_hira_1": @shiekiukemikei_hira, "kotoba_hira_2": ""}
		end
	end
end