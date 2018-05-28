class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
    def charts
    # set the library, to plot charts
    Daru::View.plotting_library = :highcharts

    # options for the charts
    opts = {
      title: {
        text: 'AAPL Stock Price'
      },
      chart_class: 'stock',
      rangeSelector: {
        selected: 1
      }
    }

    # data for the charts
    data =  [
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
              [1180569600000,121.19]
            ]

    # initialize
    @stock = Daru::View::Plot.new(data, opts)

    render "charts" , layout: "application"
  end
end
