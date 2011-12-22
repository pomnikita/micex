# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#@chart = (series) ->	
#	chart1 = new Highcharts.Chart
#  	chart:
#    	renderTo: 'container'
#    	type: 'scatter'
#    title:
#    	text: 'Buy/Sell statistics'
#    series: series
#

class @MicexChart
	constructor: (@links, @charts) ->
		
		$('a', @links).click (e) =>
			@hideCharts()
			@showChart $(e.currentTarget).attr 'data_period'
			$(e.currentTarget).addClass 'active'
			
	hideCharts: () ->
		$('a', @links).removeClass 'active'
		$('div', @charts).hide()
		
	showChart: (chartPeriod) ->
		$("[class=#{chartPeriod}]").show()

@chart = (series1, yMin, yMax) ->
	chart1 = new Highcharts.StockChart
		chart:
			renderTo: 'container'
		
		tooltip:
			formatter: () ->
				s = "Price: " + @points[0].y.toFixed(2)
				s += "<br/>Value: " + Math.round(@points[1].y)

		buttons: [{
			type: 'all',
			text: 'all'
		}]
		
		rangeSelector:
			enabled: false
				
		yAxis: [{
			title:
				text: 'Price'
			height: 300
			lineWidth: 2
			min: parseInt(yMin) + 1
			max: parseInt(yMax) + 1
			},{
			title:
      	text: 'Volume'
      top: 350
      # max: 100000000
#      max: -290000000
      height: 200
			lineWidth: 2
			offset: 0
		}]
		series: series1

@ohlcChart = (data, volume) ->
	chart1 = new Highcharts.StockChart
		chart:
			renderTo: 'container'
		
		rangeSelector:
			buttons: [{
				type : 'month',
				count : 1,
				text : '1h'
			}]
			selected: 0
			inputEnabled: false
			
			
		yAxis: [{
			title:
				text: 'Price'
			height: 300
			lineWidth: 2
			},{
			title:
      	text: 'Volume'
      top: 350
      height: 200
			lineWidth: 2
			offset: 0
		}]
		series: [{
			type : 'candlestick',
			name : 'chart',
			data : data
		}	, {
			type: 'column',
			name: 'Volume',
			data: volume,
			yAxis: 1
		}]

		
#namespace = (target, name, block) ->
#  [target, name, block] = [(if typeof exports isnt 'undefined' then exports else window), arguments...] if arguments.length < 3
#  top    = target
#  target = target[item] or= {} for item in name.split '.'
#  block target, top


