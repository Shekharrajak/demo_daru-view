class HandlingEventsController < ApplicationController
  def handling_events
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

    render "handling_events" , layout: "googlecharts_layout"
  end
end
