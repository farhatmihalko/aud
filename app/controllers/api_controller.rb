class ApiController < ApplicationController
	
	def index
	end

	def define
		@word = Word.where(:language => params['lang'], :name => params['name']).first
		#raise Word.where(:language => 'ru').order(:name).limit(100).inspect
		json = generate_json(@word.definition)
		render :text => '<pre>' + JSON.pretty_generate(json) + '</pre>'
	end

	def parse
		@word = Word.where(:language => params['lang'], :name => params['name']).first
		json = generate_json(@word.definition)
		json['name'] = @word.name
		@html = to_html(json)
		render 'api/test'
	end

	def to_html s
		html = ''
		if s['type'] == 'disambiguation'
			html = html +'<ul class="disambig">'
			s['list'].each_with_index do |el, i|
				html = html + '<li class="disambig">' +
					'<h5>' + s['name'] + '<sup>' + (i + 1).to_s + '</sup></h5>' +
					el['attr'].join(' ') + ' '
				el.delete('attr')
				html = html + to_html(el) + '</li>'
			end
			html = html +'</ul>'
		elsif s['type'] == 'parts of speech'
			s['list'].each do |el|
				html = html +'<div class="parts">' +
					el['attr'].join(' ') + ' '
				el.delete('attr')
				html = html + to_html(el) + '</div>'
			end
		elsif s['type'] == 'equivalents'
			html = html +'<ul class="equiv">'
			s['list'].each_with_index do |el, i|
				html = html +'<li>' +
					'<span class="equiv-enum" >' + (i + 1).to_s + ') </span>' +
					el['attr'].join(' ') + ' '
				el.delete('attr')
				html = html + to_html(el) + '</li>'
			end
			html = html +'</ul>'
		else
			if s.has_key? 'meanings'
				html = html +'<span class="meaning">' +
						s['attr'].join(' ') + ' '
				s['meanings'].each_with_index do |el, i|
					html = html + el + ((i < s['meanings'].size - 1) ? '; ': '')
				end
				html = html + '</span>'
			end
			html = html + '<ul class="examples">'
			s['examples'].each do |el|
				html = html + '<li class="example">' + el + '</li>'
			end
			html = html + '</ul>'
			if s.has_key? 'syn'
				html = html + '<div class="syn">Syn: ' + s['syn'].join(' ') + '</div>'
			end
			
		end
		return html
	end


	def words
		words = Word.order(:indexed_name).limit(1000)
		names = words.collect{|w| w.name}
		raise names.inspect
	end

	def indexed_name
		name = params[:word]
		chars = Hash[* [1040, 1240, 1072, 1241, 1043, 1170, 1075, 1171, 1050, 1178, 1082, 1179, 1053,
			1186, 1085, 1187, 1054, 1256, 1086, 1257, 1059, 1198, 1091, 1199, 1061, 1210, 1093, 1211,
			1067, 73, 1099, 105]].invert
		map = {}
		chars.each do |k,v|
			map[k] = v.chr + '1'
		end
		map[1200] = 1059.chr + '2'; map[1201] = 1091.chr + '2'
		map[1030] = 1067.chr + '1'; map[1110] = 1099.chr + '1'
		raise map.inspect
		index = ''
		name.each_char do |c|
			index += map.key?(c.ord) ? map[c.ord] : c + '0'
		end
		index
	end

	def strip_white!(s)
		s.sub!(/^[ ]*<br[^>]*>[ ]*/,'')
		s.sub!(/[ ]*<br[^>]*>[ ]*$/,'')
		s.strip!
	end

	def find_syn
		ww = ''
		Word.find(:all, :limit => 2000).each do |word|
			ww = ww + word.name + '<br>' if word.definition =~ /Syn.*;.*</
		end
		render :text => ww
	end

	def find_abbr
		ww = Set.new
		Word.find(:all).each do |word|
			if abbr = word.definition.match(/^<abbr[^>]*>([^<>]*)<[^>]*abbr>[ ]*/)
				ww << abbr.captures[0].strip
			end
		end
		tt = ''
		ww.each do |a|
			tt = tt + a + '<br>'
		end
		render :text => tt
	end


	def generate_json(s)
		strip_white!(s)
		json = Hash.new {|h,k| h[k]=[]}
		while (abbr = s.match(/^<abbr[^>]*>([^<>]*)<[^>]*abbr>[ ]*/))
			json['attr'] << abbr[0].strip
			s.sub!(/^<abbr[^>]*>[^<>]*<[^>]*abbr>[ ]*/,'')
		end

		strip_white!(s)
		
		if s =~ /^I[.].*/
			json['type'] = "disambiguation"
			s.split(/[XVI]+[.]/).each do |m|
				json['list'] << generate_json(m) if !m.empty?
			end
		elsif s =~ /^1[.].*/
			json['type'] = "parts of speech"
			s.split(/[0-9]+[.]/).each do |m|
				json['list'] << generate_json(m) if !m.empty?
			end
		elsif s =~ /^1[)].*/
			json['type'] = "equivalents"
			s.split(/[0-9]+[)]/).each do |m|
				json['list'] << generate_json(m) if !m.empty?
			end
		else
			if !(s =~ /^<span>/)
				s.split(/<br[^>]*>/)[0].split(/;/).each do |m|
					json['meanings'] << m.strip if !m.empty?
				end
			end

			s.scan(/<span>([^<>]*(<em>|<abbr[^>]*>)?[^<>]*(<\/em>|<\/abbr>)?[^<>]*)<\/span>/) do |m|
				json['examples'] << m[0].strip	if !m.nil?
			end

			if syn = s.match(/Syn[:](.*)/)
				json['syn'] <<	syn.captures[0].split(/<br[^>]*>/)[0].strip
			end
		end
		return json
	end
end
