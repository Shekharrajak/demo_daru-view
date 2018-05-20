class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
    def charts
	    # set the library, to plot charts
		Daru::View.plotting_library = :googlecharts
	    @query_string = 'SELECT A, H, O, Q, R, U LIMIT 5 OFFSET 8'
	    @data = 'https://docs.google.com/spreadsheets/d/1XWJLkAwch5GXAt_7zOFDcg8Wm8' \
	            'Xv29_8PWuuW15qmAE/gviz/tq?gid=0&headers=1&tq=' 
	    @data << @query_string
	    @column_chart_options = {
	      width: 600,	
	      type: :column
	    }
	    @column_chart_chart = Daru::View::Plot.new(@data, @column_chart_options)

	    render "charts" , layout: "application"
	end
end
