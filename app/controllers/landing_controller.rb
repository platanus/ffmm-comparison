# frozen_string_literal: true

class LandingController < ApplicationController
  def home
    @asset_providers = asset_providers
  end

  def asset_provider
    asset_provider_id = params[:id]
    @asset_provider = fintual.asset_provider(asset_provider_id)
    @funds = fintual.asset_provider_funds(asset_provider_id)
  end

  def asset_provider_fund
    asset_provider_id = params[:ap_id]
    @fund_id = params[:f_id]
    @asset_provider = fintual.asset_provider(asset_provider_id)
    @series = fund_series(@fund_id)
    @fund_name = @series.first[:fund_name]
  end

  def series_details
    asset_provider_id = params[:ap_id]
    fund_id = params[:f_id]
    @asset_provider = fintual.asset_provider(asset_provider_id)
    @fund = fintual.fund(fund_id)
    @series_id = params[:s_id]

    #@days = fintual.series_days(serie_id)
  end

  private

  def fintual
    @fintual = FintualClient.new
  end

  def asset_providers
    @asset_providers ||= begin
      result = fintual.asset_providers.map do |ap|
        {
          id: ap[:id],
          short_name: ap[:attributes][:name].remove('ADMINISTRADORA GENERAL DE FONDOS')
        }
      end
      result.sort_by { |r| r[:name] }
    end
  end

  def fund_series(fund_id)
    @fund_series ||= begin
      result = fintual.fund_series(fund_id).map do |s|
        last_day = s[:attributes][:last_day]
        {
          id: s[:id],
          fund_name: s[:attributes][:name],
          serie: s[:attributes][:serie].titleize,
          date: last_day[:date],
          fixed_fee:  to_annual_fee(last_day[:fixed_fee]),
          variable_fee: to_annual_fee(last_day[:variable_fee])
        }
      end
      result.sort_by { |s| s[:serie] }
    end
  end

  def to_annual_fee(daily_fee)
    return 'n/a' if daily_fee.nil?

    (daily_fee * 360.0).to_s
  end
end
