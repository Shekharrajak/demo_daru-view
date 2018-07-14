class ChartWrapperController < ApplicationController
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

    render "chart_wrapper" , layout: "googlecharts_layout"
  end
end
