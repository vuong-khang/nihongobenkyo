module Kaisu
	# ベースクラス
	class Kaisu < ApplicationController
		def initialize(kaisu)
			@kaisu = kaisu.to_i
			str_kaisu = kaisu.to_s

			thousands = ""
			if str_kaisu.length == 4
				thousands = str_kaisu[-4, 1].to_i
			elsif str_kaisu.length == 5
				thousands = str_kaisu[-5, 2].to_i
			else
				thousands = str_kaisu[-6, 3].to_i
			end

			tenthousands = ""
			if str_kaisu.length == 5
				tenthousands = str_kaisu[-5, 1].to_i
			elsif str_kaisu.length == 6
				tenthousands = str_kaisu[-6, 2].to_i
			elsif str_kaisu.length == 7
				tenthousands = str_kaisu[-7, 3].to_i
			else
				tenthousands = str_kaisu[-8, 4].to_i
			end			

			millions = ""
			if str_kaisu.length == 7
				millions = str_kaisu[-7, 1].to_i
			elsif str_kaisu.length == 8
				millions = str_kaisu[-8, 2].to_i
			else
				millions = str_kaisu[-9, 3].to_i
			end

			hundredmillions = ""
			if str_kaisu.length == 9
				hundredmillions = str_kaisu[-9, 1].to_i
			elsif str_kaisu.length == 10
				hundredmillions = str_kaisu[-10, 2].to_i
			elsif str_kaisu.length == 11
				hundredmillions = str_kaisu[-11, 3].to_i
			else
				hundredmillions = str_kaisu[-12, 4].to_i
			end

			billions = ""
			if str_kaisu.length == 10
				billions = str_kaisu[-10, 1].to_i
			elsif str_kaisu.length == 11
				billions = str_kaisu[-11, 2].to_i
			else
				billions = str_kaisu[-12, 3].to_i
			end

			@divide = {
				"unit": str_kaisu[-1, 1].to_i, 
				"tens": str_kaisu[-2, 1].to_i,
				"hundreds": str_kaisu[-3, 1].to_i,
				"thousands": str_kaisu[-4, 1].to_i,
				"group_thousands": thousands.to_i,
				"group_tenthousands": tenthousands.to_i,
				"group_millions": millions.to_i,
				"group_hundredmillions": hundredmillions.to_i,
				"group_billions": billions.to_i				
			}

			@join_char = " / "
			@space_char = " "
		end
	end

	# 回数（英語）
	class KaisuEn < Kaisu
		def yomu
			@kaisu_hatsuon = get_data_setting("kaisu_hatsuon_en")
			@concat_char = " and "
			@comma_char = ", "

	  		if @kaisu <= 10
	  			result = @kaisu_hatsuon.select {|item| item["value"].to_i == @kaisu}[0]["title_en"]
	  			if result.is_a?(Array)
	  				result = result.join(@join_char)
				end

				return result
			elsif @kaisu < 20
	  			result = @kaisu_hatsuon.select {|item| item["value"].to_i == @kaisu}[0]["title_en"]
	  			if result.is_a?(Array)
	  				result = result.join(@join_char)
				end

				return result
			elsif @kaisu < 10 ** 2
				return tens_part_yomu(@divide[:tens], @divide[:unit], @kaisu)
			elsif @kaisu < 10 ** 3
				return hundreds_part_yomu(@divide[:hundreds], @divide[:tens], @divide[:unit], @kaisu)
			elsif @kaisu < 10 ** 6
				return thousands_part_yomu(@divide[:group_thousands])
			elsif @kaisu < 10 ** 9
				return millions_part_yomu(@divide[:group_millions])
			elsif @kaisu < 10 ** 12
				return billions_part_yomu(@divide[:group_billions])
	  		else
	  			return ""
	  		end
	  	end

	  	private def group_kaisu_yomu(kaisu)
	  		sub_str_kaisu = kaisu.to_s
	  		sub_divide = {
				"unit": sub_str_kaisu[-1, 1].to_i, 
				"tens": sub_str_kaisu[-2, 1].to_i,
				"hundreds": sub_str_kaisu[-3, 1].to_i
			}

	  		if kaisu <= 10
				return unit_part_yomu(kaisu, 1)
			elsif kaisu < 20
	  			result = @kaisu_hatsuon.select {|item| item["value"] == kaisu.to_s[-2, 2]}[0]["title_en"]
	  			if result.is_a?(Array)
	  				result = result.join(@join_char)
				end

				return result
			elsif kaisu < 10 ** 2
				return tens_part_yomu(sub_divide[:tens], sub_divide[:unit], kaisu)
			elsif kaisu < 10 ** 3
				return hundreds_part_yomu(sub_divide[:hundreds], sub_divide[:tens], sub_divide[:unit], kaisu)
			else
				return ""
			end
	  	end

	  	private def unit_part_yomu(kaisu, special = 0)
	  		if kaisu <= 10
	  			case special
	  				when 1
	  					case kaisu
	  						when 0
	  							return ""
	  						else
	  							result = @kaisu_hatsuon.select {|item| item["value"].to_i == kaisu}[0]["title_en"]
					  			if result.is_a?(Array)
					  				result = result[0]
								end

								return result
	  					end
	  				else
				  		result = @kaisu_hatsuon.select {|item| item["value"].to_i == kaisu}[0]["title_en"]
			  			if result.is_a?(Array)
			  				result = result[0]
						end

						return result
				end
	  		else
	  			return ""
			end
	  	end

	  	private def tens_part_yomu(kaisu, unit, origin_kaisu)
	  		hypen_char = "-"

	  		if kaisu < 2
				case kaisu
					when 0
						return unit_part_yomu(unit, 1)
	  				else
			  			result = @kaisu_hatsuon.select {|item| item["value"] == origin_kaisu.to_s[-2, 2]}[0]["title_en"]
			  			if result.is_a?(Array)
			  				result = result.join(@join_char)
						end

						return result
				end
	  		elsif kaisu < 10
		  		result = @kaisu_hatsuon.select {|item| item["value"].to_i == kaisu * 10}[0]["title_en"]
		  		if result.is_a?(Array)
					result = result[0]
				end

		  		return result + hypen_char + unit_part_yomu(unit, 1)
	  		else
	  			return ""
			end
	  	end

	  	private def hundreds_part_yomu(kaisu, tens, unit, origin_kaisu)
	  		if kaisu < 10
	  			case kaisu
		  			when 0
		  				return ((tens == 0 and unit == 0) ? "" : @concat_char) + tens_part_yomu(tens, unit, origin_kaisu) 
		  			else
				  		result = @kaisu_hatsuon.select {|item| item["value"] == "10^2"}[0]["title_en"]
				  		if result.is_a?(Array)
							result = result[0]
						end

				  		return unit_part_yomu(kaisu) + @space_char + result + ((tens == 0 and unit == 0) ? "" : @concat_char) + tens_part_yomu(tens, unit, origin_kaisu)
		  		end
	  		else
	  			return ""
			end
	  	end

	  	private def thousands_part_yomu(kaisu)
	  		case kaisu
		  		when 0
		  			return hundreds_part_yomu(@divide[:hundreds], @divide[:tens], @divide[:unit], @kaisu)
		  		else
					result = @kaisu_hatsuon.select {|item| item["value"] == "10^3"}[0]["title_en"]
			  		if result.is_a?(Array)
						result = result[0]
					end

			  		return group_kaisu_yomu(kaisu) + @space_char + result + @comma_char + hundreds_part_yomu(@divide[:hundreds], @divide[:tens], @divide[:unit], @kaisu)
	  		end
  		end

  		private def millions_part_yomu(kaisu)
  			case kaisu
	  			when 0
	  				return thousands_part_yomu(@divide[:group_thousands])
	  			else
		  			result = @kaisu_hatsuon.select {|item| item["value"] == "10^6"}[0]["title_en"]
			  		if result.is_a?(Array)
						result = result[0]
					end

		  			return group_kaisu_yomu(kaisu) + @space_char + result + @comma_char + thousands_part_yomu(@divide[:group_thousands])
		  	end
  		end

  		private def billions_part_yomu(kaisu)
	  		case kaisu
				when 0
					return millions_part_yomu(@divide[:group_millions])
				else
		  			result = @kaisu_hatsuon.select {|item| item["value"] == "10^9"}[0]["title_en"]
			  		if result.is_a?(Array)
						result = result[0]
					end

			  		return group_kaisu_yomu(kaisu) + @space_char + result + @comma_char + millions_part_yomu(@divide[:group_millions])
		  	end		  	
  		end
	end

	# 回数（日本語）
	class KaisuJp < Kaisu
		def yomu
			@kaisu_hatsuon = get_data_setting("kaisu_hatsuon_jp")
			@comma_char = "・"

	  		if @kaisu <= 10
	  			result_kanji = @kaisu_hatsuon.select {|item| item["value"].to_i == @kaisu}[0]["title_zh"]
	  			if result_kanji.is_a?(Array)
	  				result_kanji = result_kanji.join(@join_char)
				end

	  			result_hira = @kaisu_hatsuon.select {|item| item["value"].to_i == @kaisu}[0]["title_jp"]
	  			if result_hira.is_a?(Array)
	  				result_hira = result_hira.join(@join_char)
				end

				return {"kanji": result_kanji, "hira": result_hira}
			elsif @kaisu < 10 ** 2
				return {"kanji": tens_part_yomu_kanji(@divide[:tens], @divide[:unit]), "hira": tens_part_yomu_hira(@divide[:tens], @divide[:unit])}
			elsif @kaisu < 10 ** 3
				return {"kanji": hundreds_part_yomu_kanji(@divide[:hundreds], @divide[:tens], @divide[:unit]), "hira": hundreds_part_yomu_hira(@divide[:hundreds], @divide[:tens], @divide[:unit])}
			elsif @kaisu < 10 ** 4
				return {"kanji": thousands_part_yomu_kanji(@divide[:thousands], @divide[:hundreds], @divide[:tens], @divide[:unit]), "hira": thousands_part_yomu_hira(@divide[:thousands], @divide[:hundreds], @divide[:tens], @divide[:unit])}
			elsif @kaisu < 10 ** 8
				return {"kanji": tenthousands_part_yomu_kanji(@divide[:group_tenthousands]), "hira": tenthousands_part_yomu_hira(@divide[:group_tenthousands])}
			elsif @kaisu < 10 ** 12
				return {"kanji": hundredmillions_part_yomu_kanji(@divide[:group_hundredmillions]), "hira": hundredmillions_part_yomu_hira(@divide[:group_hundredmillions])}
	  		else
	  			return {"kanji": "", "hira": ""}
			end
	  	end

	  	private def group_kaisu_yomu_kanji(kaisu)
	  		sub_str_kaisu = kaisu.to_s
	  		sub_divide = {
				"unit": sub_str_kaisu[-1, 1].to_i, 
				"tens": sub_str_kaisu[-2, 1].to_i,
				"hundreds": sub_str_kaisu[-3, 1].to_i,
				"thousands": sub_str_kaisu[-4, 1].to_i
			}

	  		if kaisu <= 10
				return unit_part_yomu_kanji(kaisu, 1)
			elsif kaisu < 10 ** 2
				return tens_part_yomu_kanji(sub_divide[:tens], sub_divide[:unit])
			elsif kaisu < 10 ** 3
				return hundreds_part_yomu_kanji(sub_divide[:hundreds], sub_divide[:tens], sub_divide[:unit])
			elsif kaisu < 10 ** 4
				return thousands_part_yomu_kanji(sub_divide[:thousands], sub_divide[:hundreds], sub_divide[:tens], sub_divide[:unit])
			else
				return ""
			end
	  	end

	  	private def group_kaisu_yomu_hira(kaisu)
	  		sub_str_kaisu = kaisu.to_s
	  		sub_divide = {
				"unit": sub_str_kaisu[-1, 1].to_i, 
				"tens": sub_str_kaisu[-2, 1].to_i,
				"hundreds": sub_str_kaisu[-3, 1].to_i,
				"thousands": sub_str_kaisu[-4, 1].to_i
			}

	  		if kaisu <= 10
				return unit_part_yomu_hira(kaisu, 1)
			elsif kaisu < 10 ** 2
				return tens_part_yomu_hira(sub_divide[:tens], sub_divide[:unit])
			elsif kaisu < 10 ** 3
				return hundreds_part_yomu_hira(sub_divide[:hundreds], sub_divide[:tens], sub_divide[:unit])
			elsif kaisu < 10 ** 4
				return thousands_part_yomu_hira(sub_divide[:thousands], sub_divide[:hundreds], sub_divide[:tens], sub_divide[:unit])
			else
				return ""
			end
	  	end

	  	private def unit_part_yomu_kanji(kaisu, special = 0)
	  		if kaisu <= 10
				case special
					when 1
						case kaisu
							when 0
								return ""
							else
								result = @kaisu_hatsuon.select {|item| item["value"].to_i == kaisu}[0]["title_zh"]
						  		if result.is_a?(Array)
									result = result[0]
								end

						  		return result
						end
					else			  		
				  		result = @kaisu_hatsuon.select {|item| item["value"].to_i == kaisu}[0]["title_zh"]
				  		if result.is_a?(Array)
							result = result[0]
						end

				  		return result
			  	end
		  	else
		  		return ""
		  	end
	  	end

	  	private def unit_part_yomu_hira(kaisu, special = 0)
			if kaisu <= 10
				case special
					when 1
						case kaisu
							when 0
								return ""
							else
								result = @kaisu_hatsuon.select {|item| item["value"].to_i == kaisu}[0]["title_jp"]
						  		if result.is_a?(Array)
									result = result[0]
								end

						  		return result
						end
					else			  		
				  		result = @kaisu_hatsuon.select {|item| item["value"].to_i == kaisu}[0]["title_jp"]
				  		if result.is_a?(Array)
							result = result[0]
						end

				  		return result
			  	end
		  	else
		  		return ""
		  	end
	  	end

	  	private def tens_part_yomu_kanji(kaisu, unit)
	  		if kaisu < 2
	  			case kaisu
					when 0
						return unit_part_yomu_kanji(unit, 1)
					else
		  				return unit_part_yomu_kanji(kaisu * 10) + unit_part_yomu_kanji(unit, 1)
  				end
	  		elsif kaisu < 10
	  			return unit_part_yomu_kanji(kaisu) + unit_part_yomu_kanji(10) + unit_part_yomu_kanji(unit, 1)
	  		else
		  		return ""
		  	end
	  	end

	  	private def tens_part_yomu_hira(kaisu, unit)
	  		if kaisu < 2
	  			case kaisu
					when 0
						return unit_part_yomu_hira(unit, 1)
					else
		  				return unit_part_yomu_hira(kaisu * 10) + unit_part_yomu_hira(unit, 1)
  				end
	  		elsif kaisu < 10
	  			return unit_part_yomu_hira(kaisu) + unit_part_yomu_hira(10) + unit_part_yomu_hira(unit, 1)
	  		else
		  		return ""
		  	end
	  	end

	  	private def hundreds_part_yomu_kanji(kaisu, tens, unit)
	  		if kaisu < 2
	  			case kaisu
		  			when 0
		  				return tens_part_yomu_kanji(tens, unit)
		  			else
			  			return @kaisu_hatsuon.select {|item| item["value"] == "10^2"}[0]["title_zh"] + tens_part_yomu_kanji(tens, unit) 
			  	end
	  		elsif kaisu < 10
	  			return unit_part_yomu_kanji(kaisu) + @kaisu_hatsuon.select {|item| item["value"] == "10^2"}[0]["title_zh"] + tens_part_yomu_kanji(tens, unit) 
	  		else
		  		return ""
		  	end
	  	end

	  	private def hundreds_part_yomu_hira(kaisu, tens, unit)
	  		if kaisu < 2
	  			case kaisu
		  			when 0
		  				return tens_part_yomu_hira(tens, unit)
		  			else
		  				return @kaisu_hatsuon.select {|item| item["value"] == "10^2"}[0]["title_jp"] + tens_part_yomu_hira(tens, unit) 
  				end
	  		elsif kaisu < 10
	  			case kaisu
  					when 3, 6, 8
						result = @kaisu_hatsuon.select {|item| item["value"] == (kaisu * (10 ** 2)).to_s}[0]["title_jp"]
				  		if result.is_a?(Array)
							result = result[0]
						end

				  		return result + tens_part_yomu_hira(tens, unit) 
  					else
	  					return unit_part_yomu_hira(kaisu) + @kaisu_hatsuon.select {|item| item["value"] == "10^2"}[0]["title_jp"] + tens_part_yomu_hira(tens, unit) 
				end
	  		else
		  		return ""
		  	end
	  	end

	  	private def thousands_part_yomu_kanji(kaisu, hundreds, tens, unit)
	  		if kaisu < 2
	  			case kaisu
		  			when 0
		  				return hundreds_part_yomu_kanji(hundreds, tens, unit)
		  			else
		  				return @kaisu_hatsuon.select {|item| item["value"] == "10^3"}[0]["title_zh"] + hundreds_part_yomu_kanji(hundreds, tens, unit)
  				end
	  		elsif kaisu < 10
	  			return unit_part_yomu_kanji(kaisu) + @kaisu_hatsuon.select {|item| item["value"] == "10^3"}[0]["title_zh"] + hundreds_part_yomu_kanji(hundreds, tens, unit)
	  		else
		  		return ""
		  	end
	  	end

	  	private def thousands_part_yomu_hira(kaisu, hundreds, tens, unit)
	  		if kaisu < 2
	  			case kaisu
		  			when 0
		  				return hundreds_part_yomu_hira(hundreds, tens, unit)
		  			else
		  				return @kaisu_hatsuon.select {|item| item["value"] == "10^3"}[0]["title_jp"] + hundreds_part_yomu_hira(hundreds, tens, unit)
  				end
	  		elsif kaisu < 10
	  			case kaisu
  					when 1, 3, 8
						result = @kaisu_hatsuon.select {|item| item["value"] == (kaisu * (10 ** 3)).to_s}[0]["title_jp"]
				  		if result.is_a?(Array)
							result = result[0]
						end

				  		return result + hundreds_part_yomu_hira(hundreds, tens, unit) 
  					else
	  					return unit_part_yomu_hira(kaisu) + @kaisu_hatsuon.select {|item| item["value"] == "10^3"}[0]["title_jp"] + hundreds_part_yomu_hira(hundreds, tens, unit)
				end
	  		else
		  		return ""
		  	end
	  	end

	  	private def tenthousands_part_yomu_kanji(kaisu)
	  		case kaisu
		  		when 0
		  			return thousands_part_yomu_kanji(@divide[:thousands], @divide[:hundreds], @divide[:tens], @divide[:unit]) 
		  		else
					result = @kaisu_hatsuon.select {|item| item["value"] == "10^4"}[0]["title_zh"]
			  		if result.is_a?(Array)
						result = result[0]
					end

			  		return group_kaisu_yomu_kanji(kaisu) + result + @comma_char + thousands_part_yomu_kanji(@divide[:thousands], @divide[:hundreds], @divide[:tens], @divide[:unit]) 
	  		end
	  	end

	  	private def tenthousands_part_yomu_hira(kaisu)
	  		case kaisu
		  		when 0
		  			return thousands_part_yomu_hira(@divide[:thousands], @divide[:hundreds], @divide[:tens], @divide[:unit]) 
		  		else
					result = @kaisu_hatsuon.select {|item| item["value"] == "10^4"}[0]["title_jp"]
			  		if result.is_a?(Array)
						result = result[0]
					end

			  		return group_kaisu_yomu_hira(kaisu) + result + @comma_char + thousands_part_yomu_hira(@divide[:thousands], @divide[:hundreds], @divide[:tens], @divide[:unit]) 
	  		end
	  	end

	  	private def hundredmillions_part_yomu_kanji(kaisu)
	  		case kaisu
		  		when 0
		  			return tenthousands_part_yomu_kanji(@divide[:group_tenthousands]) 
		  		else
					result = @kaisu_hatsuon.select {|item| item["value"] == "10^8"}[0]["title_zh"]
			  		if result.is_a?(Array)
						result = result[0]
					end

			  		return group_kaisu_yomu_kanji(kaisu) + result + @comma_char + tenthousands_part_yomu_kanji(@divide[:group_tenthousands])
	  		end
	  	end

	  	private def hundredmillions_part_yomu_hira(kaisu)
	  		case kaisu
		  		when 0
		  			return tenthousands_part_yomu_hira(@divide[:group_tenthousands]) 
		  		else
					result = @kaisu_hatsuon.select {|item| item["value"] == "10^8"}[0]["title_jp"]
			  		if result.is_a?(Array)
						result = result[0]
					end

			  		return group_kaisu_yomu_hira(kaisu) + result + @comma_char + tenthousands_part_yomu_hira(@divide[:group_tenthousands])
	  		end
	  	end
	end

	# 回数（ベトナム語）
	class KaisuVi < Kaisu
		def yomu
			@kaisu_hatsuon = get_data_setting("kaisu_hatsuon_vi")
			@concat_char = " lẻ "
			@comma_char = ", "

	  		if @kaisu <= 10
	  			result = @kaisu_hatsuon.select {|item| item["value"].to_i == @kaisu}[0]["title_vi"]
	  			if result.is_a?(Array)
	  				result = result.join(@join_char)
				end

				return result
			elsif @kaisu < 10 ** 2
				return tens_part_yomu(@divide[:tens], @divide[:unit])
			elsif @kaisu < 10 ** 3
				return hundreds_part_yomu(@divide[:hundreds], @divide[:tens], @divide[:unit])
			elsif @kaisu < 10 ** 6
				return thousands_part_yomu(@divide[:group_thousands])
			elsif @kaisu < 10 ** 9
				return millions_part_yomu(@divide[:group_millions])
			elsif @kaisu < 10 ** 12
				return billions_part_yomu(@divide[:group_billions])
	  		else
	  			return ""
			end
	  	end

	  	private def group_kaisu_yomu(kaisu)
	  		sub_str_kaisu = kaisu.to_s
	  		sub_divide = {
				"unit": sub_str_kaisu[-1, 1].to_i, 
				"tens": sub_str_kaisu[-2, 1].to_i,
				"hundreds": sub_str_kaisu[-3, 1].to_i
			}

	  		if kaisu <= 10
				return unit_part_yomu(kaisu, 1)
			elsif kaisu < 10 ** 2
				return tens_part_yomu(sub_divide[:tens], sub_divide[:unit])
			elsif kaisu < 10 ** 3
				return hundreds_part_yomu(sub_divide[:hundreds], sub_divide[:tens], sub_divide[:unit])
			else
				return ""
			end
	  	end

	  	private def unit_part_yomu(kaisu, special = 0)
	  		if kaisu <= 10
	  			case special
  					when 1
  						case kaisu
  							when 0
  								return ""
		  					when 5
		  						return @kaisu_hatsuon.select {|item| item["value"].to_i == kaisu}[0]["special_vi"]
			  				else
			  					result = @kaisu_hatsuon.select {|item| item["value"].to_i == kaisu}[0]["title_vi"]
						  		if result.is_a?(Array)
									result = result[0]
								end

						  		return result
		  				end
  					when 2
  						case kaisu
		  					when 0, 1, 5
		  						return @kaisu_hatsuon.select {|item| item["value"].to_i == kaisu}[0]["special_vi"]
			  				else
			  					result = @kaisu_hatsuon.select {|item| item["value"].to_i == kaisu}[0]["title_vi"]
						  		if result.is_a?(Array)
									result = result[0]
								end

						  		return result
		  				end
  					else
				  		result = @kaisu_hatsuon.select {|item| item["value"].to_i == kaisu}[0]["title_vi"]
				  		if result.is_a?(Array)
							result = result[0]
						end

				  		return result
			  	end
	  		else
	  			return ""
			end
	  	end

	  	private def tens_part_yomu(kaisu, unit)
	  		if kaisu < 2
	  			case kaisu
					when 0
						return unit_part_yomu(unit, 1)
	  				else
		  				return unit_part_yomu(kaisu * 10) + @space_char + unit_part_yomu(unit, 1)
  				end
	  		elsif kaisu < 10
	  			return unit_part_yomu(kaisu) + @space_char + @kaisu_hatsuon.select {|item| item["value"] == "10^1"}[0]["title_vi"] + @space_char + unit_part_yomu(unit, 2)
	  		else
	  			return ""
			end
	  	end

	  	private def hundreds_part_yomu(kaisu, tens, unit)
	  		if kaisu < 10
	  			case kaisu
		  			when 0
	  					return ((tens == 0 and unit == 0) ? "" : @concat_char) + tens_part_yomu(tens, unit)
		  			else
				  		result = @kaisu_hatsuon.select {|item| item["value"] == "10^2"}[0]["title_vi"]
				  		if result.is_a?(Array)
							result = result[0]
						end

				  		return unit_part_yomu(kaisu) + @space_char + result + ((tens == 0 and unit != 0) ? @concat_char : @space_char) + tens_part_yomu(tens, unit) 
		  		end
	  		else
	  			return ""
			end
	  	end

	  	private def thousands_part_yomu(kaisu)
	  		case kaisu
		  		when 0
		  			return hundreds_part_yomu(@divide[:hundreds], @divide[:tens], @divide[:unit])
		  		else
					result = @kaisu_hatsuon.select {|item| item["value"] == "10^3"}[0]["title_vi"]
			  		if result.is_a?(Array)
						result = result[0]
					end

			  		return group_kaisu_yomu(kaisu) + @space_char + result + @comma_char + hundreds_part_yomu(@divide[:hundreds], @divide[:tens], @divide[:unit])
		  	end
	  	end

	  	private def millions_part_yomu(kaisu)
	  		case kaisu
		  		when 0
		  			return thousands_part_yomu(@divide[:group_thousands])
		  		else
		  			result = @kaisu_hatsuon.select {|item| item["value"] == "10^6"}[0]["title_vi"]
			  		if result.is_a?(Array)
						result = result[0]
					end

			  		return group_kaisu_yomu(kaisu) + @space_char + result + @comma_char + " " + thousands_part_yomu(@divide[:group_thousands])
		  	end
  		end

  		private def billions_part_yomu(kaisu)
	  		case kaisu
				when 0
					return millions_part_yomu(@divide[:group_millions])
				else
		  			result = @kaisu_hatsuon.select {|item| item["value"] == "10^9"}[0]["title_vi"]
			  		if result.is_a?(Array)
						result = result[0]
					end

			  		return group_kaisu_yomu(kaisu) + @space_char + result + @comma_char + millions_part_yomu(@divide[:group_millions])
		  	end		  	
  		end
	end
end