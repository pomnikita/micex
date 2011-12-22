# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


window.showLoading = (link) ->
	loader = $('<div/>', {class : 'loader'});
	$(link).click ->
  	$.blockUI 
  	  message: loader,
  	  css:
  	    border: 'none', 
  	    padding: '30px', 
  	    backgroundColor: '#000', 
  	    '-webkit-border-radius': '10px', 
  	    '-moz-border-radius': '10px', 
  	    opacity: .5, 
  	    color: '#fff'

$ () ->
	new MicexChart('.chart-periods-links', '.micex-charts')
	showLoading '#update-data'
	showLoading '#update-data2'

