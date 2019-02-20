Rails.application.routes.draw do
  root 'landing#home'
  get 'ap/:id' => 'landing#asset_provider', as: :asset_provider
  get 'ap/:ap_id/f/:f_id' => 'landing#asset_provider_fund', as: :asset_provider_fund
  get 'ap/:ap_id/f/:f_id/s/:s_id' => 'landing#series_details', as: :series_details
end
