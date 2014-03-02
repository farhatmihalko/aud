//= require jquery
//= require jquery_ujs
//= require semantic
//= require core
//= require modules

$(document).ready(function(){

  var container = $(".words-container"),
      word = $(".word-html");

  $(".link").on("click", function(){
    var definition = $(this).attr("data-definition"),
        language = $(this).attr("data-language"),
        text = $(this).text();

    container.hide();
    word.html(definition);

    return false;
  });

});