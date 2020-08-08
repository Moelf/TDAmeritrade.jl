const peri_str = Dict(
            Minute => "minute",
            Day => "day",
            Month => "month",
            Year => "year",
           )
const freq_str = Dict(
            Minute => "minute",
            Day => "daily",
            Week => "weekly",
            Month => "monthly"
           )

"""
ms_since_epoch(t::DateTime)

get the milisecond since UNIX EPOCH of a DateTime object.
"""
ms_since_epoch(t::DateTime) = Dates.value(t) - Dates.UNIXEPOCH

"""
price_history(ticker; kwargs...)

Get price history of a given ticker, everything but `ticker` have
default value specified by TD api: 
https://developer.tdameritrade.com/price-history/apis/get/marketdata/{symbol}/pricehistory

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
    return @pipe HTTP.get(uri; retries = 1).body |> JSON3.read |> _[:candles]
end

"""
price_history(ticker, freq, peri)

see TD API for default and compatible frequency vs. tickers
"""
function price_history(ticker, freq, peri)
    Dates.toms(freq) > Dates.toms(peri) && ArgumentError("Period must be larger than frequency")

    frequencyType = freq_str[typeof(freq)]
    frequency = freq.value

    periodType = peri_str[typeof(peri)]
    period = peri.value

    price_history(ticker; periodType=periodType, 
                        period=period, 
                        frequencyType=frequencyType, 
                        frequency=frequency)
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
    frequencyType = freq_str[typeof(freq)]
    frequency = freq.value
    price_history(ticker; startDate=startDate, 
                endDate=endDate, 
                frequencyType=frequencyType, 
                frequency=frequency)
end
