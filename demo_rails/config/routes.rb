Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/nyaplot', to: 'application#nyaplot'
  get '/highcharts', to: 'application#highcharts'
  get '/googlecharts', to: 'application#googlecharts'
  get '/datatables', to: 'application#datatables'
  get '/chartwrapper', to: 'chart_wrapper#chart_wrapper'
end
