class MultipleChartsController < ApplicationController
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
    user_options = {
      modules: ['modules/funnel']
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
    @funnel_hc = Daru::View::Plot.new(df, opts_funnel, user_options)
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

    render "multiple_charts" , layout: "multiple_charts_layout"
  end
end
