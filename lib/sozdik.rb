<<<<<<< HEAD
require "net/http"
require "uri"

class Sozdik

	def self.get_word word
		url = URI.parse("http://sozdik.kz/ru/dictionary/translate/kk/ru/" + URI::encode(word) + "/")
		req = Net::HTTP::Get.new(url.path)

		headers = {
			"Host" => "sozdik.kz",
			"User-Agent" => "Mozilla/5.0 (Windows NT 6.1; rv:7.0.1) Gecko/20100101 Firefox/7.0.1",
			"Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
			"Accept-Language" => "ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3",
			"Accept-Charset" => "windows-1251,utf-8;q=0.7,*;q=0.7",
			"Content-Type" => "text/html; charset=utf-8",
			"Referer" => "http://sozdik.kz/"
		}
		headers.each do |k , v|
			req[k] = v
		end

		res = Net::HTTP.new(url.host, url.port).start do |http|
		    http.request(req)
		end

		if !res.body.match(/dictionary_article_translation"><p>(.*)<\/p><\/div>/)			
			return false
		else
			return res.body.match(/dictionary_article_translation"><p>(.*)<\/p><\/div>/)
				.captures[0]
		end

	end
	
	def self.push_words lang
		File.open("dictionary_raw/" + lang + "words_new.html", "r:UTF-8").each do |word|
			if (Word.where(language: lang, name: word.chomp!).all.count > 0)
				next
			end
			definition = get_word(word)
			if (definition == false)
				next
			end
			word = Word.new
			word.name = word
			word.language = lang
			word.definition = definition
		    word.save
		end
	end

end

=======
require "net/http"
require "uri"

class Sozdik

	def self.get_word word
		url = URI.parse("http://sozdik.kz/ru/dictionary/translate/kk/ru/" + URI::encode(word) + "/")
		req = Net::HTTP::Get.new(url.path)

		headers = {
			"Host" => "sozdik.kz",
			"User-Agent" => "Mozilla/5.0 (Windows NT 6.1; rv:7.0.1) Gecko/20100101 Firefox/7.0.1",
			"Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
			"Accept-Language" => "ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3",
			"Accept-Charset" => "windows-1251,utf-8;q=0.7,*;q=0.7",
			"Content-Type" => "text/html; charset=utf-8",
			"Referer" => "http://sozdik.kz/"
		}
		headers.each do |k , v|
			req[k] = v
		end

		res = Net::HTTP.new(url.host, url.port).start do |http|
		    http.request(req)
		end

		if !res.body.match(/dictionary_article_translation"><p>(.*)<\/p><\/div>/)			
			return false
		else
			return res.body.match(/dictionary_article_translation"><p>(.*)<\/p><\/div>/)
				.captures[0]
		end

	end

end

>>>>>>> d66f200ae5a7ba52ee3ecf78f25b9004e2abad18
