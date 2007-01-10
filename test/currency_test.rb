require File.dirname(__FILE__) + '/test_helper'

class CurrencyTest < Test::Unit::TestCase
	include GettextLocalize
	include ActionView::Helpers::DateHelper
	include ActionView::Helpers::NumberHelper

	def setup
		GettextLocalize.set_locale('ca_ES')
		@ca_months = ["Gener","Febrer","Març","Abril","Maig","Juny","Juliol","Agost","Setembre","Octubre","Novembre","Desembre"]
	end

	def test_country_options
		countries_yml_file = Pathname.new(File.join(GettextLocalize.get_plugin_dir(),"countries.yml")).realpath.to_s
    countries = YAML::load(File.open(countries_yml_file))
		GettextLocalize.set_country_options	
		country_options = GettextLocalize.get_country_options
		assert_equal country_options, GettextLocalize.string_to_sym(countries["es"])
	end

	def test_number_to_currency
		num = number_to_currency(1234567.8945)
		assert_equal "1.234.567,89 €", num
		num = number_to_currency(1234567.8945,{:unit=>"%",:separator=>":",:delimiter=>"-",:order=>["unit","number"]})
		assert_equal "%1-234-567:89", num
		GettextLocalize.set_locale("en_US")
		num = number_to_currency(1234567.8945)
		assert_equal "$1,234,567.89", num
	end

	def test_select_date
		date = select_date(nil)

		expected = %(<select name="date[day]">\n)
    (1..31).each{ |num| expected << %(<option value="#{num}">#{num}</option>\n)}
    expected << "</select>\n"

    expected << %(<select name="date[month]">\n)
    (1..12).each{ |m| expected << %(<option value="#{m}">#{@ca_months[m-1]}</option>\n) }
    expected << "</select>\n"

    expected <<  %(<select name="date[year]">\n)
    (Date.today.year-5).upto(Date.today.year+5) { |y| expected << %(<option value="#{y}">#{y}</option>\n) }
    expected << "</select>\n"

		assert_equal expected, date
	end

	def test_select_datetime
		datetime = select_datetime(nil)

    expected = %(<select name="date[day]">\n)
    (1..31).each{ |num| expected << %(<option value="#{num}">#{num}</option>\n)}
    expected << "</select>\n"

    expected << %(<select name="date[month]">\n)
    (1..12).each{ |m| expected << %(<option value="#{m}">#{@ca_months[m-1]}</option>\n) }
    expected << "</select>\n"

    expected <<  %(<select name="date[year]">\n)
    (Date.today.year-5).upto(Date.today.year+5) { |y| expected << %(<option value="#{y}">#{y}</option>\n) }
    expected << "</select>\n"

		expected << %(<select name="date[hour]">\n)
		(0..9).each{ |h| expected << %(<option value="0#{h}">0#{h}</option>\n) }
		(10..23).each{ |h| expected << %(<option value="#{h}">#{h}</option>\n) }
    expected << "</select>\n"

    expected << %(<select name="date[minute]">\n)
		(0..9).each{ |h| expected << %(<option value="0#{h}">0#{h}</option>\n) }
    (10..59).each{ |h| expected << %(<option value="#{h}">#{h}</option>\n) }
    expected << "</select>\n"
		assert_equal expected, datetime
	end

	def test_date_select

		date = date_select(nil,nil)

    expected = %(<select name="[(i)]">\n)
		(1..31).each do |num| 
			expected << %(<option value="#{num}")
			expected << %( selected="selected") if (num == Date.today.day)
			expected << %(>#{num}</option>\n)
		end
    expected << "</select>\n"

    expected << %(<select name="[(i)]">\n)
		(1..12).each do |m|
			expected << %(<option value="#{m}")
			expected << %( selected="selected") if (m == Date.today.month)
			expected << %(>#{@ca_months[m-1]}</option>\n)
		end
    expected << "</select>\n"

    expected <<  %(<select name="[(i)]">\n)
    (Date.today.year-5).upto(Date.today.year+5) do |y|
			expected << %(<option value="#{y}")
			expected << %( selected="selected") if (y == Date.today.year)
			expected << %(>#{y}</option>\n)
		end
    expected << "</select>\n"

    assert_equal expected, date
	end

	def test_datetime_select

    datetime = datetime_select(nil,nil)
		time = Time.now

    expected = %(<select name="[(3i)]">\n)
    (1..31).each do |num|
      expected << %(<option value="#{num}")
      expected << %( selected="selected") if (num == Date.today.day)
      expected << %(>#{num}</option>\n)
    end
    expected << "</select>\n"

    expected << %(<select name="[(2i)]">\n)
    (1..12).each do |m|
      expected << %(<option value="#{m}")
      expected << %( selected="selected") if (m == Date.today.month)
      expected << %(>#{@ca_months[m-1]}</option>\n)
    end
    expected << "</select>\n"

    expected <<  %(<select name="[(1i)]">\n)
    (Date.today.year-5).upto(Date.today.year+5) do |y|
      expected << %(<option value="#{y}")
      expected << %( selected="selected") if (y == Date.today.year)
      expected << %(>#{y}</option>\n)
    end
    expected << "</select>\n &mdash; "

    expected << %(<select name="[(4i)]">\n)
    (0..9).each do |h| 
			expected << %(<option value="0#{h}")
			expected << %( selected="selected") if (h == time.hour)
			expected << %(>0#{h}</option>\n)
		end
    (10..23).each do |h|
			expected << %(<option value="#{h}")
			expected << %( selected="selected") if (h == time.hour)
			expected << %(>#{h}</option>\n)
		end
    expected << "</select>\n"

		expected << " : "

    expected << %(<select name="[(5i)]">\n)
    (0..9).each do |m|
			expected << %(<option value="0#{m}")
			expected << %( selected="selected") if (m == time.min)
			expected << %(>0#{m}</option>\n)
		end
    (10..59).each do |m| 
			expected << %(<option value="#{m}")
			expected << %( selected="selected") if (m == time.min)
			expected << %(>#{m}</option>\n)
		end
    expected << "</select>\n"

    assert_equal expected, datetime
  end

	def test_array_to_sentence
		a = [1,2,3,4,5,6]
		assert_equal "1, 2, 3, 4, 5 i 6", a.to_sentence(:skip_last_comma => true)
		assert_equal "1, 2, 3, 4, 5, i 6", a.to_sentence(:skip_last_comma => false)
		assert_equal "1, 2, 3, 4, 5 ju 6", a.to_sentence(:skip_last_comma => true,:connector => "ju")
		assert_equal "1, 2, 3, 4, 5, ju 6", a.to_sentence(:skip_last_comma => false,:connector => "ju")
		GettextLocalize.set_locale("en_US")
		assert_equal "1, 2, 3, 4, 5 and 6", a.to_sentence(:skip_last_comma => true)
		assert_equal "1, 2, 3, 4, 5, and 6", a.to_sentence(:skip_last_comma => false)
	end

end
