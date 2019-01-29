class FintualClient
  BASE_URL = ENV.fetch('FINTUAL_API_URL', 'https://fintual.cl/api')

  def banks
    fetch(bank_uri)
  end

  def asset_providers
    fetch(asset_providers_uri)
  end

  def asset_provider(asset_provider_id)
    fetch(asset_providers_uri(asset_provider_id))
  end

  def asset_provider_funds(asset_provider_id)
    fetch(asset_provider_funds_uri(asset_provider_id))
  end

  def fund(fund_id)
    fetch(fund_uri(fund_id))
  end

  def fund_series(fund_id)
    fetch(fund_series_uri(fund_id))
  end

  def series_days(id)
    fetch(series_days_uri(id))
  end

  private

  def fetch(uri)
    response = HTTParty.get(uri)
    return [] unless response.code == 200

    result = JSON.parse(response.body, symbolize_names: true)
    result[:data]
  end

  def bank_uri
    "#{BASE_URL}/banks"
  end

  def asset_providers_uri(id = nil)
    to_rest("#{BASE_URL}/asset_providers", id)
  end

  def asset_provider_funds_uri(asset_provider_id)
    asset_providers_uri(asset_provider_id) + '/conceptual_assets'
  end

  def fund_uri(fund_id)
    "#{BASE_URL}/conceptual_assets/#{fund_id}"
  end

  def fund_series_uri(fund_id)
    fund_uri(fund_id) + '/real_assets'
  end

  def series_days_uri(id)
    "#{BASE_URL}/real_assets/#{id}/days"
  end

  def to_rest(uri, id = nil)
    uri + (id.nil? ? '' : "/#{id}")
  end
end
