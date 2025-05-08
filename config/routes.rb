# frozen_string_literal: true

Rails.application.routes.draw do
  get 'forecast', to: 'forecasts#show'
  root 'forecasts#show'
end
