$(document).ready ->
	new Module {
		name: "Popup generator"
		autoload: true
		init: ->
			$(".popup-header-target").popup()
	}