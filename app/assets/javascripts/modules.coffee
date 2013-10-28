new Module {
	name : "Set global tasks"
	autoload : true
	init : ->

		# local_address = "http://audarme.kz/"
		local_address = "http://audarme.kz/"

		window.local_address = local_address

		window.switcLan = ->
			SITE_ENT.get_language_container().click()

		#global word
		window.setWord = (value) ->
			window.CURRENT_WORD = value if value.length > 0

		#query ajax for searching word
		window.query = (val, callback) ->
			console.log val
			#blank?
			return false if val.length == 0
			#start search
			language = window.CURRENT_LANGUAGE
			val = val.toLowerCase()
			$.ajax {
				url : "#{local_address}/words/#{language}/#{val}"
				success : (data)->
					callback @, data
				error : (data)->
				beforeSend : ->
					console.log "Translate with query '#{val}'"
			}

		window.autocomplete = (inp_string, callback) ->
			val = inp_string.toLowerCase()
			console.log inp_string
			return false if val.length == 0
			#init
			local_address = ""
			language = window.CURRENT_LANGUAGE
			$.ajax {
				word : val
				url : "#{local_address}/words/suggest/#{language}/#{val}"
				success : (data) ->
					callback @,data
			}

		window.nearby = (inp_string, callback) ->
			val = inp_string.toLowerCase()
			console.log inp_string
			return false if val.length == 0
			#init
			language = window.CURRENT_LANGUAGE
			$.ajax {
				word : val
				url : "#{local_address}/words/nearby/#{language}/#{val}"
				success : (data) ->
					callback @,data
			}

		window.current_light = null
		window.updateLi = ->
			list = SITE_ENT.get_suggestion_point()
			list.on 'click', ->
				window.current_light.removeClass('active') if window.current_light
				$(this).addClass 'active'
				window.current_light = $(this)
				setValue =  $(this).find('a').text()
				SITE_ENT.get_search_input().val( setValue ).focus()
				SITE_ENT.get_search_button().click()
				window.setWord $(this).find('a').text()

		window.create_menu = (list, select) ->
			content = ""
			list.forEach (a, index) ->
				className = "js-suggestion-li "
				className += "active" if a is window.CURRENT_WORD or a is select
				content += "<li class='#{className}'><a>#{a}</a></li>"
			content


}

new Module {
	name : "Keyboard toggler"
	autoload : true
	init : ->
		SITE_ENT.get_keyboard_tumblr().on 'click', ->
			# SITE_ENT.get_keyboard_container()
			SITE_ENT.get_keyboard_container().parent().toggle('fast')
}

new Module {
	name : "Language switch"
	autoload : true
	init : ->
		window.CURRENT_LANGUAGE = 'ru'
		ari = {
			'ru' : 'казахский'
			'kz' : 'русский'
		}
		al = {
			'ru' : 'kz'
			'kz' : 'ru'
		}
		SITE_ENT.get_language_container().on 'click', ->
			window.CURRENT_LANGUAGE = al[window.CURRENT_LANGUAGE]
			self = $(this)
			self.find('a').each ->
				$(this).text( ari[$(this).attr('value')] ).attr('value', al[$(this).attr('value')])
}


new Module {
	name : "translating"
	autoload : true
	init : ->
		SITE_ENT.get_search_button().on 'click', ->
 			inp = SITE_ENT.get_search_input()
 			window.query inp.val(), (obj, data) ->
 				data = JSON.parse data
 				name = data.name.substring(0, 1).toUpperCase() + data.name.substring(1, data.name.length)
 				SITE_ENT.get_text_container().html( "<h2>#{name}</h2><p>#{data.definition}</p>" )

 				#adding and fix bugs
 				SITE_ENT.get_text_container().find('a').each ->
 					$(this).on 'click', ->
 						window.switcLan()
 						SITE_ENT.get_search_input().val( $(this).text() )
 						SITE_ENT.get_search_button().click()
 						return false
 				#end

				window.nearby inp.val(), (obj, data) ->
					menu = SITE_ENT.get_suggestion_menu()
					list = []
					data.forEach (a, index) ->
						list.push a.name
					# console.log list	
					menu.html (window.create_menu list, name)
					window.updateLi()


 		SITE_ENT.get_search_input().on 'keyup', (e) ->
 			SITE_ENT.get_search_button().trigger('click') if e.keyCode is 13
}

new Module {
	name : 'autocomplete'
	autoload : true
	init : ->
		SITE_ENT.get_search_input().on 'keyup', (e) ->
			inp = $(this)
			window.setWord inp.val()
			window.autocomplete inp.val(), (obj, data) ->
				if window.CURRENT_WORD is obj.word
					menu = SITE_ENT.get_suggestion_menu()
					console.log data	
					menu.html (window.create_menu data)
					window.updateLi()
}



new Module {
	autoload : true
	name : 'Keyboard'
	init : ->
		btn = SITE_ENT.get_keyboard_container().find('.btn')
		btn.on 'click', ->
			inp = SITE_ENT.get_search_input()
			inp.val( inp.val() + $(this).text() )
			inp.trigger('keyup')
}


new Module {
	autoload : true
	name : 'initial loading'
	init : ->

		random = ->
			$.ajax {
				url : "#{window.local_address}random/#{window.CURRENT_LANGUAGE}"
				success : (data) ->
					list = []
					data.forEach (a, index) ->
						if index == 4
							list.push 'Audarme.kz'
						list.push a.name

					menu = SITE_ENT.get_suggestion_menu()
					menu.html (window.create_menu list, "Audarme.kz")
					window.updateLi()
			}

		container = $(".js-init-load")
		if container.attr('data-status') is "false"
			random()
			
}