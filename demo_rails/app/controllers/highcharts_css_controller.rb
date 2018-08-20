class HighchartsCssController < ApplicationController
  def highcharts_css
      # set the library, to plot charts
    Daru::View.plotting_library = :highcharts

    # options for the charts
    opts = {
      chart: {defaultSeriesType: 'line'},
      title: {
        text: 'Solar Employment Growth by Sector, 2010-2016'
      },

      subtitle: {
        text: 'Source: thesolarfoundation.com'
      },

      yAxis: {
        title: {
          text: 'Number of Employees'
        }
      },
      legend: {
        layout: 'vertical',
        align: 'right',
        verticalAlign: 'middle'
      }
    }

    user_opts = {
      css: ['.highcharts-background {fill: #efefef;stroke: #a4edba;stroke-width: 2px;}']
    }

    # data for the charts
    data = Daru::Vector.new([29.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4])

    # initialize
    @line_graph = Daru::View::Plot.new(data, opts, user_opts)

    opts_styling_axes = {
      chart: {
        type: 'column'
      },

      title: {
          text: 'Styling axes'
      },

      yAxis: [{
          className: 'highcharts-color-0',
          title: {
              text: 'Primary axis'
          }
      }, {
          className: 'highcharts-color-1',
          opposite: true,
          title: {
              text: 'Secondary axis'
          }
      }],

      plotOptions: {
          column: {
              borderRadius: 5
          }
      }
    }

    user_opts_styling_axes = {
      css: ['.highcharts-color-0 {fill: #7cb5ec;stroke: #7cb5ec;}', 
            '.highcharts-axis.highcharts-color-0 .highcharts-axis-line {stroke: #7cb5ec;}',
            '.highcharts-axis.highcharts-color-0 text {fill: #7cb5ec;}',
            '.highcharts-color-1 {fill: #90ed7d;stroke: #90ed7d;}',
            '.highcharts-axis.highcharts-color-1 .highcharts-axis-line {stroke: #90ed7d;}',
            '.highcharts-axis.highcharts-color-1 text {fill: #90ed7d;}',
            '.highcharts-yaxis .highcharts-axis-line {stroke-width: 2px;}'
            ]
    }

    series_dt_styling_axes = [{
      data: [1, 3, 2, 4]
    }, {
        data: [324, 124, 547, 221],
        yAxis: 1
    }]

    # initialize
    @column_graph = Daru::View::Plot.new(series_dt_styling_axes, opts_styling_axes, user_opts_styling_axes)

    render "highcharts_css" , layout: "highcharts_layout"
  end
end
