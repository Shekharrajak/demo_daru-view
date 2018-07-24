class FormattersController < ApplicationController
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
    render "formatters" , layout: "googlecharts_layout"
  end
end
