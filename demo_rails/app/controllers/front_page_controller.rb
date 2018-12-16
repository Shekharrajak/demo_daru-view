class FrontPageController < ApplicationController
  def front_page
    Daru::View.plotting_library = :googlecharts

    @links = Daru::DataFrame.new({
      Examples:  [
        'Nyaplot',
        'Highcharts',
        'Googlcharts',
        'Datatables',
        'Multiple Charts using PlotList',
        'Highcharts, Highstock and Highmap',
        'Highcharts with CSS styling',
        'Event handling in googlecharts',
        'Chartwrapper',
        'Charteditor',
        'Formatters in google datatables'
      ],
      Links: [
        view_context.link_to('http://localhost:3000/nyaplot', {action: 'nyaplot', controller: 'application'}, target: '_blank'),
        view_context.link_to('http://localhost:3000/highcharts', {action: 'highcharts', controller: 'application'}, target: '_blank'),
        view_context.link_to('http://localhost:3000/googlecharts', {action: 'googlecharts', controller: 'application'}, target: '_blank'),
        view_context.link_to('http://localhost:3000/datatables', {action: 'datatables', controller: 'application'}, target: '_blank'),
        view_context.link_to('http://localhost:3000/multiplecharts', {action: 'multiple_charts', controller: 'multiple_charts'}, target: '_blank'),
        view_context.link_to('http://localhost:3000/highchartstockmap', {action: 'highchart_stock_map', controller: 'highchart_stock_map'}, target: '_blank'),
        view_context.link_to('http://localhost:3000/highchartscss', {action: 'highcharts_css', controller: 'highcharts_css'}, target: '_blank'),
        view_context.link_to('http://localhost:3000/handlingevents', {action: 'handling_events', controller: 'handling_events'}, target: '_blank'),
        view_context.link_to('http://localhost:3000/chartwrapper', {action: 'chart_wrapper', controller: 'chart_wrapper'}, target: '_blank'),
        view_context.link_to('http://localhost:3000/charteditor', {action: 'chart_editor', controller: 'chart_editor'}, target: '_blank'),
        view_context.link_to('http://localhost:3000/formatters', {action: 'formatters', controller: 'formatters'}, target: '_blank')
      ]
    })
    @table_links = Daru::View::Table.new(@links, {allowHtml: true})
    render "front_page" , layout: "googlecharts_layout"
  end
end
