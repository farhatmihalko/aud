var api_translate = function(){

	var url = "http://audarme.kz/assets";
	var generator = (function(){
		//The files to loading
		["/api/default.js", "/api/noty.js"].forEach(function(el, index){
			var script = document.createElement("script");
			script.setAttribute("type", "text/javascript");
			script.setAttribute("src", url + el);
			document.head.appendChild( script );
		});
	});


	var plugin = {
		/**
		* Adding to choosed element functionality
		*/
		appendTo : function(element, action, lan){
			if((typeof element === "object" || typeof element === "array" ) && element.length > 0){
				var SELF = plugin;
				element.on(action, function(event){
					if(window.getSelection){
						var text = window.getSelection().toString();
						var result = SELF.query( text , lan);
					} else console.log( "The browser don't support the api" );
				});
			} else console.log( "Function need jQuery object" );
		},
		/**
		* Query to server api
		*/
		query : function(text, lan){
			//self
			var API = this;
			//end
			var url = "http://audarme.kz/words/" + (lan || "ru") + "/";
			var text = $.trim( text ) || "абадан";
			var result = "";
			url += text;
			$.ajax({
				url : url,
				type : "GET",
				dataType: "JSON",
				beforeSend : function(){
					var connect = "Переводим - " + text;
					API.showTooltip(connect, "alert");
				},
				success : function(data){
					result = "Перевод" + data.definition;
					API.showTooltip(result, "success");
				},
				error : function(errCode){
					console.log( errCode.fail() )
					API.showTooltip("При переводе возникла ошибка", "error");
				}
			});
			return result;
		},
		/**
		* Show helpes to see result (popover)
		*/
		showTooltip : function(text, type){
			var time = 15000;
			var n = noty({
				text : text,
				type : type,
				layout : "bottomRight"
			});
			setTimeout(function(){
				var _id_ = n.options.id;
				$.noty.close( _id_ ); 
			}, time);
		}
	}


	$(document).ready(function(){

		generator();

		if(window === self){
			self.api_translate = plugin;
			self.api_translate.appendTo($("#js-example"), "dblclick", "kz");
		}

	});

};

api_translate();
