const peri_str = Dict(
            "Minute" => "minute",
            "Day" => "day",
            "Month" => "month",
            "Year" => "year",
            "ytd" => "ytd"
           )
const freq_str = Dict(
            "Minute" => "minute",
            "Day" => "daily",
            "Week" => "weekly",
            "Month" => "monthly"
           )

ms_since_epoch(t::DateTime) = Dates.value(t) - Dates.UNIXEPOCH
"""
price_history(ticker; kwargs...)

periodType="", period="",
frequencyType="", frequency="",
endDate="", startDate="", needExtendedHoursData=""

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

"""
price_history(ticker, freq, peri)

Valid periods by periodType (defaults marked with an asterisk):
day: 1, 2, 3, 4, 5, 10*
month: 1*, 2, 3, 6
year: 1*, 2, 3, 5, 10, 15, 20

Valid frequencyTypes by periodType (defaults marked with an asterisk):
day: minute*
month: daily, weekly*
year: daily, weekly, monthly*

Valid frequencies by frequencyType (defaults marked with an asterisk):
minute: 1*, 5, 10, 15, 30
daily: 1*
weekly: 1*
monthly: 1*
"""
function price_history(ticker, freq, peri)
    Dates.toms(freq) > Dates.toms(peri) && ArgumentError("Period must be larger than frequency")
    frequencyType = freq_str[typeof(freq).name |> string]
    frequency = freq.value
    periodType = peri_str[typeof(peri).name |> string]
    period = peri.value
    price_history(ticker; periodType, period, frequencyType, frequency)
end

"""
price_history(ticker, freq, start::DateTime=now()-Day(1), stop::DateTime=now())

get the price history with `interval` ticks from `start` to `stop`

valid frequency:
minute: 1*, 5, 10, 15, 30
"""
function price_history(ticker, freq, start::DateTime=now()-Day(1), stop::DateTime=now())
    @assert stop > start
    startDate, endDate = ms_since_epoch.((start, stop))
    frequencyType = freq_str[typeof(freq).name |> string]
    frequency = freq.value
    price_history(ticker; startDate, endDate, frequencyType, frequency)
end
