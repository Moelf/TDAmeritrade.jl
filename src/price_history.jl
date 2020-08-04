"""
price_history(ticker; periodType="", period="",
               frequencyType="", frequency="",
               endDate="", startDate="", needExtendedHoursData="")

Get price history of a given ticker, everything but `ticker` have
default value specified by TD api: 
https://developer.tdameritrade.com/price-history/apis/get/marketdata/{symbol}/pricehistory

required:
ticker

optional kwargs:
periodType
period
frequencyType
frequency
endDate
startDate
needExtendedHoursData

"""
function price_history(ticker; kwargs...)
    kwargs = Dict(kwargs)
    kwargs = merge(kwargs, Dict(
                       "apikey" => AUTH_KEY.CONSUMER_KEY,
                       "Authorization" => "Bearer "*AUTH_KEY.ACCESS_TOKEN
                      )
          )
    uri = construct_api("marketdata/$ticker/pricehistory", kwargs)
    return @pipe HTTP.get(uri).body |> JSON3.read |> _[:candles]
end
