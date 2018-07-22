class ChartEditorController < ApplicationController
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

    render "chart_editor" , layout: "googlecharts_layout"
  end
end
