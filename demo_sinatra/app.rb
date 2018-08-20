require 'sinatra'
require 'daru/view'


get '/' do
  erb :index , :layout => :layout
end

get '/nyaplot' do
  nyaplot_example()
  erb :nyaplot, :layout => :nyaplot_layout
end

get '/highcharts' do
  highchart_example
  erb :highcharts, :layout => :highcharts_layout
end

get '/googlecharts' do
  googlecharts_example
  erb :googlecharts, :layout => :googlecharts_layout
end

get '/datatables' do
  datatables_examples
  erb :datatables, :layout => :datatables_layout
end

get '/multiplecharts' do
  multiple_charts
  erb :multiple_charts, :layout => :multiple_charts_layout
end

get '/highchartstockmap' do
  highchart_stock_map
  erb :highchart_stock_map, :layout => :highcharts_layout
end

get '/highchartscss' do
  highcharts_css
  erb :highcharts_css, :layout => :highcharts_layout
end

get '/handlingevents' do
  handling_events_googlecharts
  erb :handling_events, :layout => :googlecharts_layout
end

get '/chartwrapper' do
  chart_wrapper
  erb :chart_wrapper, :layout => :googlecharts_layout
end

get '/charteditor' do
  chart_editor
  erb :chart_editor, :layout => :googlecharts_layout
end

get '/formatters' do
  formatters
  erb :formatters, :layout => :googlecharts_layout
end

def highchart_example
    # bar chart
    opts = {
        chart: {
          type: 'bar',
      },
      title: {
          text: 'Historic World Population by Region'
      },
      subtitle: {
          text: 'Source: <a href="https://en.wikipedia.org/wiki/World_population">Wikipedia.org</a>'
      },
      xAxis: {
          categories: ['Africa', 'America', 'Asia', 'Europe', 'Oceania'],
          title: {
              text: nil
          }
      },
      yAxis: {
          min: 0,
          title: {
              text: 'Population (millions)',
              align: 'high'
          },
          labels: {
              overflow: 'justify'
          }
      },
      tooltip: {
          valueSuffix: ' millions'
      },
      plotOptions: {
          bar: {
              dataLabels: {
                  enabled: true
              }
          }
      },
      legend: {
          layout: 'vertical',
          align: 'right',
          verticalAlign: 'top',
          x: -40,
          y: 80,
          floating: true,
          borderWidth: 1,
          backgroundColor: '#FFFFFF',
          shadow: true
      },
      credits: {
          enabled: false
      },
      adapter: :highcharts
    }

    series_dt = [
      {
          name: 'Year 1800',
          data: [107, 31, 635, 203, 2]
      }, {
          name: 'Year 1900',
          data: [133, 156, 947, 408, 6]
      }, {
          name: 'Year 2012',
          data: [1052, 954, 4250, 740, 38]
      }
    ]
    @bar_basic = Daru::View::Plot.new([], opts)
    @bar_basic.add_series(series_dt[0])
    @bar_basic.add_series(series_dt[1])
    @bar_basic.add_series(series_dt[2])

    # @line_graph = Daru::View::Plot.new(data= make_random_series(3), adapter: :highcharts, name: 'spline1', type: 'spline', title: 'Irregular spline')
end


def nyaplot_example
    dv = Daru::Vector.new [:a, :a, :a, :b, :b, :c], type: :category
    # default adapter is nyaplot only
    @bar_graph = Daru::View::Plot.new(dv, type: :bar, adapter: :nyaplot)

    df = Daru::DataFrame.new({b: [11,12,13,14,15], a: [1,2,3,4,5],
      c: [11,22,33,44,55]},
      order: [:a, :b, :c],
      index: [:one, :two, :three, :four, :five])
    @scatter_graph = Daru::View::Plot.new df, type: :scatter, x: :a, y: :b, adapter: :nyaplot

    df = Daru::DataFrame.new({
      a: [1, 3, 5, 7, 5, 0],
      b: [1, 5, 2, 5, 1, 0],
      c: [1, 6, 7, 2, 6, 0]
      }, index: 'a'..'f')
    @df_line = Daru::View::Plot.new df, type: :line, x: :a, y: :b, adapter: :nyaplot
end

def googlecharts_example
  country_population = [
          ['Germany', 200],
          ['United States', 300],
          ['Brazil', 400],
          ['Canada', 500],
          ['France', 600],
          ['RU', 700]
    ]
  df_cp = Daru::DataFrame.rows(country_population)
  df_cp.vectors = Daru::Index.new(['Country', 'Population'])
  @table = Daru::View::Table.new(df_cp, pageSize: 5, adapter: :googlecharts, height: 400, width: 300)
  @piechart = Daru::View::Plot.new(
    @table.table, type: :pie, is3D: true, adapter: :googlecharts, height: 500, width: 800)
  @geochart = Daru::View::Plot.new(
    @table.table, type: :geo, adapter: :googlecharts, height: 500, width: 800)

  data_customers = 'https://docs.google.com/spreadsheets/d/1aXns2ch8y_rl9ZLxSYZIU5ewUB1ZNAg5O6iPLZLApZI/gviz/tq?header=1&tq='
  query_customers = 'SELECT * WHERE A > 1'
  data_customers << query_customers
  @customers_table = Daru::View::Table.new(data_customers, adapter: :googlecharts)
  @customers_chart = Daru::View::Plot.new(data_customers, {type: :line, adapter: :googlecharts})

  query_products = 'SELECT A, H, O, Q, R, U LIMIT 5 OFFSET 8'
  products = 'https://docs.google.com/spreadsheets/d/1XWJLkAwch5GXAt_7zOFDcg8Wm8' \
          'Xv29_8PWuuW15qmAE/gviz/tq?gid=0&headers=1&tq='
  products << query_products
  column_chart_options = {
    width: 600,
    type: :column,
    adapter: :googlecharts
  }
  table_options = {
    adapter: :googlecharts,
    showRowNumber: true
  }
  @products_table = Daru::View::Table.new(products, table_options)
  @column_chart = Daru::View::Plot.new(products, column_chart_options)
end

def datatables_examples
  # need to give name, otherwise generated thead html code will not work.
  # Because no name means no thead  in vector.
  dv = Daru::Vector.new [1, 2, 3, 4, 5, 6], name: 'series1'
  options = {
    adapter: :datatables,
    html_options: {
      table_options: {
        table_thead: "<thead>
                    <tr>
                      <th></th>
                      <th>Demo Column Name</th>
                    </tr>
                  </thead>",
        width: '90%'
      }
    }
  }
  # default adapter is nyaplot only
  @dt_dv = Daru::View::Table.new(dv, options)

  df1 = Daru::DataFrame.new({b: [11,12,13,14,15], a: [1,2,3,4,5],
    c: [11,22,33,44,55]},
    order: [:a, :b, :c],
    index: [:one, :two, :three, :four, :five])
  options2 = {
    adapter: :datatables,
    html_options: {
      table_options: {
        cellspacing: '0',
        width: "100%"
      }
    }
  }
  @dt_df1 = Daru::View::Table.new(df1, options2)

  df2 = Daru::DataFrame.new({
    a: [1, 3, 5, 7, 5, 0],
    b: [1, 5, 2, 5, 1, 0],
    c: [1, 6, 7, 2, 6, 0]
    }, index: 'a'..'f')
  @dt_df2 = Daru::View::Table.new(df2, pageLength: 3, adapter: :datatables)

  dv_arr = [1, 2, 3, 4, 5, 6]
  @dt_dv_arr = Daru::View::Table.new(dv_arr, pageLength: 3, adapter: :datatables)

  df1_arr = [
    [11,12,13,14,15],
    [1,2,3,4,5],
    [11,22,33,44,55]
  ]
  @dt_df1_arr = Daru::View::Table.new(df1_arr, pageLength: 3, adapter: :datatables)

  df2_arr = [
    [1, 3, 5, 7, 5, 0],
    [1, 5, 2, 5, 1, 0],
    [1, 6, 7, 2, 6, 0]
  ]
  @dt_df2_arr = Daru::View::Table.new(df2_arr, pageLength: 3, adapter: :datatables)

  data = []
  for i in 0..100000
    data << i
  end
  options = {
    searching: false,
    pageLength: 7,
    adapter: :datatables
  }
  @table_array_large = Daru::View::Table.new(data, options)
end

def make_random_series(step)
  data = []
  for i in 0..10
    data << [(rand * 100).to_i]
  end
  data
end

def highchart_stock_map
    # set the library, to plot charts
  Daru::View.plotting_library = :highcharts

  # options for the charts
  chart = {
    type: 'line'
  },
  opts = {
    title: {
      text: 'AAPL Stock Price'
    },
    rangeSelector: {
      selected: 1
    } 
  }

  opts_hc = {
    title: {
      text: 'AAPL Stock Price'
    }
  }

  # data for the charts
  series_dt = ([{
    name: 'AAPL',
    data: [
         [1147651200000,67.79],
         [1147737600000,64.98],
         [1147824000000,65.26],

         [1149120000000,62.17],
         [1149206400000,61.66],
         [1149465600000,60.00],
         [1149552000000,59.72],

         [1157932800000,72.50],
         [1158019200000,72.63],
         [1158105600000,74.20],
         [1158192000000,74.17],
         [1158278400000,74.10],
         [1158537600000,73.89],

         [1170288000000,84.74],
         [1170374400000,84.75],

         [1174953600000,95.46],
         [1175040000000,93.24],
         [1175126400000,93.75],
         [1175212800000,92.91],

         [1180051200000,113.62],
         [1180396800000,114.35],
         [1180483200000,118.77],
         [1180569600000,121.19],
         ]
    }])

  # initialize
  @stock = Daru::View::Plot.new(series_dt, opts, chart_class: 'stock')
  @hchart = Daru::View::Plot.new(series_dt, opts_hc)

  opts_india = {
    chart: {
      map: 'countries/in/in-all'
    },

    title: {
        text: 'Highmaps basic demo'
    },

    subtitle: {
        text: 'Source map: <a href="http://code.highcharts.com/mapdata/countries/in/in-all.js">India</a>'
    },

    mapNavigation: {
        enabled: true,
        buttonOptions: {
            verticalAlign: 'bottom'
        }
    },

    colorAxis: {
        min: 0
    }
  }

  df_india = Daru::DataFrame.new(
    {
      countries: ['in-py', 'in-ld', 'in-wb', 'in-or', 'in-br', 'in-sk', 'in-ct', 'in-tn', 'in-mp', 'in-2984', 'in-ga', 'in-nl', 'in-mn', 'in-ar', 'in-mz', 'in-tr', 'in-3464', 'in-dl', 'in-hr', 'in-ch', 'in-hp', 'in-jk', 'in-kl', 'in-ka', 'in-dn', 'in-mh', 'in-as', 'in-ap', 'in-ml', 'in-pb', 'in-rj', 'in-up', 'in-ut', 'in-jh'],
      data: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]
    }
  )
  @map = Daru::View::Plot.new(df_india, opts_india, chart_class: 'map')


  opts_europe = {
    chart: {
      map: 'custom/europe',
      spacingBottom: 20
    },

    title: {
      text: 'Europe time zones'
    },

    legend: {
      enabled: true
    },

    plotOptions: {
      map: {
        allAreas: false,
        joinBy: ['iso-a2', 'code'],
        dataLabels: {
            enabled: true,
            color: '#FFFFFF',
            style: {
                fontWeight: 'bold'
            },
            # Only show dataLabels for areas with high label rank
            format: nil,
            formatter: "function () {
                if (this.point.properties && this.point.properties.labelrank.toString() < 5) {
                    return this.point.properties['iso-a2'];
                }
            }".js_code
        },
        tooltip: {
            headerFormat: '',
            pointFormat: '{point.name}: <b>{series.name}</b>'
        }
      }
    }
  }


  series_dt_europe = [
    {
      name: 'UTC',
      data: "['IE', 'IS', 'GB', 'PT'].map(function (code) {
          return { code: code };
      })".js_code
  }, {
      name: 'UTC + 1',
      data: "['NO', 'SE', 'DK', 'DE', 'NL', 'BE', 'LU', 'ES', 'FR', 'PL', 'CZ', 'AT', 'CH', 'LI', 'SK', 'HU',
          'SI', 'IT', 'SM', 'HR', 'BA', 'YF', 'ME', 'AL', 'MK'].map(function (code) {
              return { code: code };
          })".js_code
  }, {
      name: 'UTC + 2',
      data: "['FI', 'EE', 'LV', 'LT', 'BY', 'UA', 'MD', 'RO', 'BG', 'GR', 'TR', 'CY'].map(function (code) {
          return { code: code };
      })".js_code
  }, {
      name: 'UTC + 3',
      data: "[{
          code: 'RU'
      }]".js_code
    }
  ]

  @map_europe = Daru::View::Plot.new(series_dt_europe, opts_europe, chart_class: 'map')


  opts_3d = {
      chart: {
        type: 'pie',
        options3d: {
            enabled: true,
            alpha: 45,
            beta: 0
        }
      },
      title: {
          text: 'Browser market shares at a specific website, 2014'
      },
      tooltip: {
          pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
      },
      plotOptions: {
        pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            depth: 35,
            dataLabels: {
                enabled: true,
                format: '{point.name}'
            }
        }
      }
    }

  # data for the charts
  series_dt_3d = ([{
    type: 'pie',
    name: 'Browser share',
    data: [
        ['Firefox', 45.0],
        ['IE', 26.8],
        {
            name: 'Chrome',
            y: 12.8,
            sliced: true,
            selected: true
        },
        ['Safari', 8.5],
        ['Opera', 6.2],
        ['Others', 0.7]
    ]
  }])

  # initialize
  @chart3d = Daru::View::Plot.new(series_dt_3d, opts_3d)


  opts_arearange = {
      chart: {
          type: 'arearange'
      },
      rangeSelector: {
          selected: 2
      },

      title: {
          text: 'Temperature variation by day'
      },

      tooltip: {
          valueSuffix: '°C'
      }
  }

  user_options = {
    chart_class: 'stock',
    modules: ['highcharts-more']
  }

  series_dt_arearange = [
    {
      name: 'Temperatures',
      data: [
              [1483232400000, 1.4, 4.7],
              [1483318800000, -1.3, 1.9],
              [1483405200000, -0.7, 4.3],
              [1483491600000, -5.5, 3.2],
              [1483578000000, -9.9, -6.6],
              [1483664400000, -9.6, 0.1],
              [1483750800000, -0.9, 4.0],
              [1497571200000, 12.3, 14.9],
              [1497657600000, 10.5, 15.1],
              [1497744000000, 11.4, 18.0],
              [1497830400000, 9.9, 14.8],
              [1497916800000, 8.1, 12.4],
              [1498003200000, 8.6, 15.5],
              [1498089600000, 9.4, 13.0],
              [1498176000000, 11.2, 13.0],
              [1498262400000, 9.0, 15.3],
              [1498348800000, 7.7, 13.6],
              [1498435200000, 10.3, 13.6],
              [1498521600000, 6.3, 18.0],
              [1505347200000, 5.1, 15.3],
              [1505433600000, 6.7, 16.8],
              [1505520000000, 4.0, 16.1],
              [1505606400000, 3.5, 15.8],
              [1505692800000, 8.1, 12.7],
              [1505779200000, 10.4, 13.4],
              [1514163600000, 1.0, 3.1],
              [1514250000000, 1.3, 1.6],
              [1514336400000, 0.8, 1.3],
              [1514422800000, -3.3, -1.4],
              [1514509200000, -1.5, -0.2],
              [1514595600000, -2.7, -1.0],
              [1514682000000, -2.8, 0.3]
            ]
    }
  ]

  @area_range = Daru::View::Plot.new(series_dt_arearange, opts_arearange, user_options)

  opts_idea_map = {
    chart: {
        type: 'tilemap',
        marginTop: 15,
        height: '65%'
    },

    title: {
        text: 'Idea map'
    },

    subtitle: {
        text: 'Hover over tiles for details'
    },

    colors: [
        '#fed',
        '#ffddc0',
        '#ecb',
        '#dba',
        '#c99',
        '#b88',
        '#aa7577',
        '#9f6a66'
    ],

    xAxis: {
        visible: false
    },

    yAxis: {
        visible: false
    },

    legend: {
        enabled: false
    },

    tooltip: {
        headerFormat: '',
        backgroundColor: 'rgba(247,247,247,0.95)',
        pointFormat: '<span style="color: {point.color}">●</span>' +
            '<span style="font-size: 13px; font-weight: bold"> {point.name}' +
            '</span><br>{point.desc}',
        style: {
            width: 170
        },
        padding: 10,
        hideDelay: 1000000
    },

    plotOptions: {
        series: {
            keys: ['x', 'y', 'name', 'desc'],
            tileShape: 'diamond',
            dataLabels: {
                enabled: true,
                format: '{point.name}',
                color: '#000000',
                style: {
                    textOutline: false
                }
            }
        }
    }
  }

  series_dt_idea_map = [{
      name: 'Main idea',
      pointPadding: 10,
      data: [
          [5, 3, 'Main idea',
              'The main idea tile outlines the overall theme of the idea map.']
      ],
      color: '#7eb'
  }, {
      name: 'Steps',
      colorByPoint: true,
      data: [
          [3, 3, 'Step 1',
              'First step towards the main idea. Describe the starting point of the situation.'],
          [4, 3, 'Step 2',
              'Describe where to move next in a short term time perspective.'],
          [5, 4, 'Step 3',
              'This can be a larger milestone, after the initial steps have been taken.'],
          [6, 3, 'Step 4',
              'Evaluate progress and readjust the course of the project.'],
          [7, 3, 'Step 5',
              'At this point, major progress should have been made, and we should be well on our way to implementing the main idea.'],
          [6, 2, 'Step 6',
              'Second evaluation and readjustment step. Implement final changes.'],
          [5, 2, 'Step 7',
              'Testing and final verification step.'],
          [4, 2, 'Step 8',
              'Iterate after final testing and finalize implementation of the idea.']
      ]
  }]

  @map_idea = Daru::View::Plot.new(series_dt_idea_map, opts_idea_map, modules: ['modules/tilemap'])
end

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

  usr_opts_css = {
    css: ['.highcharts-background {fill: #efefef;stroke: #a4edba;stroke-width: 2px;}']
  }

  # data for the charts
  data_css = Daru::Vector.new([29.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4])

  # initialize
  @line_graph = Daru::View::Plot.new(data_css, opts, usr_opts_css)

  opts_styling_axis = {
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

  usr_opts_styling_axis = {
    css: ['.highcharts-color-0 {fill: #7cb5ec;stroke: #7cb5ec;}',
          '.highcharts-axis.highcharts-color-0 .highcharts-axis-line {stroke: #7cb5ec;}',
          '.highcharts-axis.highcharts-color-0 text {fill: #7cb5ec;}',
          '.highcharts-color-1 {fill: #90ed7d;stroke: #90ed7d;}',
          '.highcharts-axis.highcharts-color-1 .highcharts-axis-line {stroke: #90ed7d;}',
          '.highcharts-axis.highcharts-color-1 text {fill: #90ed7d;}',
          '.highcharts-yaxis .highcharts-axis-line {stroke-width: 2px;}'
          ]
  }

  series_dt_styling_axis = [{
    data: [1, 3, 2, 4]
  }, {
      data: [324, 124, 547, 221],
      yAxis: 1
  }]

  # initialize
  @column_graph = Daru::View::Plot.new(series_dt_styling_axis, opts_styling_axis, usr_opts_styling_axis)
end

def handling_events_googlecharts
  Daru::View.plotting_library = :googlecharts

  data = [
          ['Year', 'Sales', 'Expenses'],
          ['2013',  1000,      400],
          ['2014',  1170,      460],
          ['2015',  660,       1120],
          ['2016',  1030,      540]
  ]
  user_options = {
      listeners: {
          page: "alert('The user is navigating to page ' + (e['page'] + 1));",
          select: "alert('A table row was selected');"
      }
  }
  @table = Daru::View::Table.new(data, {page: 'enable', pageSize: 2}, user_options)

  user_options_chart = {
      listeners: {
          select: " var selection = chart.getSelection();
                    var selectedValue = data_table.getFormattedValue(selection[0].row, 0);
                    alert('You selected ' + selectedValue + ' year');",
          # exports the chart to PDF format
          ready: "var doc = new jsPDF();
                  doc.addImage(chart.getImageURI(), 0, 0);
                  doc.save('chart.pdf');"
      }
  }
  @column_chart = Daru::View::Plot.new(@table.table, { type: :column, width: 800 }, user_options_chart)
end

def multiple_charts
  idx_sarah = Daru::Index.new ['Topping', 'Slices']
  data_rows_sarah = [
            ['Mushrooms', 1],
            ['Onions', 1],
            ['Olives', 2],
            ['Zucchini', 2],
            ['Pepperoni', 1]
  ]
  df_sarah = Daru::DataFrame.rows(data_rows_sarah)
  df_sarah.vectors = idx_sarah
  
  idx_anthony = Daru::Index.new ['Topping', 'Slices']
  data_rows_anthony = [
            ['Mushrooms', 2],
            ['Onions', 2],
            ['Olives', 2],
            ['Zucchini', 0],
            ['Pepperoni', 3]
  ]
  df_anthony = Daru::DataFrame.rows(data_rows_anthony)
  df_anthony.vectors = idx_anthony

  options_sarah = {
    type: :pie,
    title:'How Much Pizza Sarah Ate Last Night',
    width:400,
    height:300,
    adapter: :googlecharts
  }
  options_anthony = {
    type: :pie,
    title:'How Much Pizza Anthony Ate Last Night',
    width:400,
    height:300,
    adapter: :googlecharts
  }

  @pizza_sarah = Daru::View::Plot.new(df_sarah, options_sarah)
  @pizza_anthony = Daru::View::Plot.new(df_anthony, options_anthony)
  @combined_pizza = Daru::View::PlotList.new([@pizza_sarah, @pizza_anthony])


  df = Daru::DataFrame.new(
    {
      data1: ['Website visits', 'Downloads', 'Requested price list', 'Invoice sent', 'Finalized'],
      data2: [15654, 4064, 1987, 976, 846]
    }
  )
  opts_funnel = {
    chart: {
        type: 'funnel'
    },
    title: {
        text: 'Sales funnel'
    },
    plotOptions: {
        series: {
            dataLabels: {
                enabled: true,
                format: '<b>{point.name}</b> ({point.y:,.0f})',
                softConnector: true
            },
            center: ['40%', '50%'],
            neckWidth: '30%',
            neckHeight: '25%',
            width: '80%'
        }
    },
    legend: {
        enabled: false
    },
    adapter: 'highcharts'
  }
  opts_pyramid = {
    chart: {
        type: 'pyramid'
    },
    title: {
        text: 'Sales pyramid',
        x: -50
    },
    plotOptions: {
        series: {
            dataLabels: {
                enabled: true,
                format: '<b>{point.name}</b> ({point.y:,.0f})',
                softConnector: true
            },
            center: ['40%', '50%'],
            width: '80%'
        }
    },
    legend: {
        enabled: false
    },
    adapter: 'highcharts'
  }
  @funnel_hc = Daru::View::Plot.new(df, opts_funnel, modules: ['modules/funnel'])
  @pyramid_hc = Daru::View::Plot.new(df, opts_pyramid)
  @combined_sales = Daru::View::PlotList.new([@funnel_hc, @pyramid_hc])


  dv = Daru::Vector.new [:a, :a, :a, :b, :b, :c], type: :category
  dv = Daru::Vector.new ['III']*10 + ['II']*5 + ['I']*5, type: :category, categories: ['I', 'II', 'III']
  @bar_graph1 = Daru::View::Plot.new(dv, type: :bar, adapter: :nyaplot)
  @bar_graph2 = Daru::View::Plot.new(dv, type: :bar, adapter: :nyaplot)
  @bar_combined = Daru::View::PlotList.new([@bar_graph1, @bar_graph2])


  options_hc = {
    chart: {
      type: 'pie'
    },
    title: {
      text: 'How Much Pizza Sarah Ate Last Night'
    },
    adapter: 'highcharts'
  }
  @pizza_sarah_hc = Daru::View::Plot.new(df_sarah, options_hc)
  @pizza_sarah_table = Daru::View::Table.new(df_sarah, adapter: :googlecharts)
  @combined_adapters = Daru::View::PlotList.new([@pizza_sarah_table, @pizza_sarah, @pizza_sarah_hc])
end

def chart_wrapper
  # set the library, to plot charts
  Daru::View.plotting_library = :googlecharts

  data = [
        ['Year', 'Sales', 'Expenses'],
        ['2013',  1000,      400],
        ['2014',  1170,      460],
        ['2015',  660,       1120],
        ['2016',  1030,      540]
  ]
  @area_chart_table = Daru::View::Table.new(data, {}, chart_class: 'Chartwrapper')
  
  area_chart_options = {
    type: :area,
    view: {columns: [0, 1]}
  }
  @area_chart_chart = Daru::View::Plot.new(@area_chart_table.table, area_chart_options, chart_class: 'Chartwrapper')

  data_str = 'https://docs.google.com/spreadsheets/d/1aXns2ch8y_rl9ZLxSYZIU5ewUB1ZNAg5O6iPLZLApZI/gviz/tq?header=1&tq='
  @table = Daru::View::Table.new(data_str, {width: 500}, chart_class: 'Chartwrapper')
  @plot = Daru::View::Plot.new(data, {width: 500, view: {columns: [0, 1]}}, chart_class: 'Chartwrapper')

  idx = Daru::Index.new ['City', '2010 Population',]
  data_rows = [
                ['New York City, NY', 8175000],
                ['Los Angeles, CA', 3792000],
                ['Chicago, IL', 2695000],
                ['Houston, TX', 2099000],
                ['Philadelphia, PA', 1526000]
              ]
  df_city_pop = Daru::DataFrame.rows(data_rows)
  df_city_pop.vectors = idx
  @bar_basic_table = Daru::View::Table.new(df_city_pop, {}, chart_class: 'Chartwrapper')

  @bar_custom_table = Daru::View::Table.new(df_city_pop, {view: {columns: [0]}}, chart_class: 'Chartwrapper')

  bar_basic_options = {
    title: 'Population of Largest U.S. Cities',
    type: :bar
  }
  @bar_basic_chart = Daru::View::Plot.new(@bar_basic_table.table, bar_basic_options, chart_class: 'Chartwrapper')
end

def chart_editor
  # set the library, to plot charts
  Daru::View.plotting_library = :googlecharts

  data = [
        ['Year', 'Sales', 'Expenses'],
        ['2013',  1000,      400],
        ['2014',  1170,      460],
        ['2015',  660,       1120],
        ['2016',  1030,      540]
  ]
  data_str = 'https://docs.google.com/spreadsheets/d/1aXns2ch8y_rl9ZLxSYZIU5ewUB1ZNAg5O6iPLZLApZI/gviz/tq?header=1&tq='
  area_chart_options = {
    type: :area
  }

  @area_table = Daru::View::Table.new(data, {}, chart_class: 'Charteditor')
  @area_chart = Daru::View::Plot.new(@area_table.table, area_chart_options, chart_class: 'Charteditor')

  @table = Daru::View::Table.new(data_str, {width: 500}, chart_class: 'Charteditor')
  @plot = Daru::View::Plot.new(data, {width: 500}, chart_class: 'Charteditor')
end

def formatters
  Daru::View.plotting_library = :googlecharts

  data = [
          ['Galaxy', 'Distance', 'Brightness', 'Distance-Galaxy'],
          ['Canis Major Dwarf', 8000, 230.3, 0],
          ['Sagittarius Dwarf', 24000, 4000.5, 0],
          ['Ursa Major II Dwarf', 30000, 1412.3, 0],
          ['Lg. Magellanic Cloud', 50000, 120.9, 0],
          ['Bootes I', 60000, 1223.1, 0]
  ]
  user_options = {
    formatters: {
      # ArrowFormat is not working. Will work if we use loader.js instead of
      #   jsapi to load the charts but that cretes some error in IRuby notebook.
      #   see: https://developers.google.com/chart/interactive/docs/basic_load_libs#update-library-loader-code
      formatter1: {
        type: 'Arrow',
        options: {
          base: 30000
        },
        columns: 1
      },
      formatter2: {
        type: 'Color',
        range: [[1000, 30000, 'red', '#000000'],
                [40000, nil, 'green', 'pink']],
        columns: [1,2]
      },
      formatter3: {
        type: 'Pattern',
        format_string: "{1} - {0}",
        src_cols: [0, 1],
        des_col: 3
      },
      formatter4: {
        type: 'Number',
        options: {prefix: '*'},
        columns: 2
      },
    }
  }
  @table = Daru::View::Table.new(data, {allowHtml: true}, user_options)


  data_date = [
          ['Employee', 'Start Date (Long)', 'Start Date (Medium)', 'Start Date (Short)'],
          ['Mike', Date.parse('2007-11-28'), Date.parse('2007-11-28'), Date.parse('2007-11-28')],
          ['Bob', Date.parse('2006-7-16'), Date.parse('2006-7-16'), Date.parse('2006-7-16')],
          ['Alice', Date.parse('2007-9-2'), Date.parse('2007-9-2'), Date.parse('2007-9-2')]
  ]
  user_options_date = {
    formatters: {
      f1: {
        type: 'Date',
        options: {
          formatType: 'long'
        },
        columns: 1
      },
      f2: {
        type: 'Date',
        options: {
          formatType: 'medium'
        },
        columns: 2
      },
      f3: {
        type: 'Date',
        options: {
          formatType: 'short'
        },
        columns: 3
      }
    }
  }

  @table_date = Daru::View::Table.new(data_date, {}, user_options_date)


  data_bar = [
          ['Year', 'Sales', 'Expenses'],
          ['2013',  1000,      400],
          ['2014',  1170,      460],
          ['2015',  660,       1120],
          ['2016',  1030,      540]
  ]
  user_options_bar = {
    # Generating wierd bars in IRuby notebook, it is working fine in rails
    formatters: {
      f1: {
        type: 'Bar',
        options: {
          base: 1000,
          width: 120
        },
        columns: 2
      }
    }
  }
  @table_bar = Daru::View::Table.new(data_bar, {allowHtml: true}, user_options_bar)

  df = Daru::DataFrame.new({b: [11,12,13,14,15], a: [1,2,3,4,5],
        c: [11,22,33,44,55]},
        order: [:a, :b, :c],
        index: [:one, :two, :three, :four, :five])

  user_options_color = {
    formatters: {
      formatter: {
        type: 'Color',
        range: [[1, 3, 'yellow', 'red'],
                [20, 50, 'green', 'pink']],
        columns: [0,2]
      },
      formatter2: {
        type: 'Color',
        range: [[14, 15, 'blue', 'orange']],
        columns: 1
      }
    }
  }

  # option `allowHtml: true` is necessary to make this work
  @table_color = Daru::View::Table.new(df, {allowHtml: true}, user_options_color)
end
