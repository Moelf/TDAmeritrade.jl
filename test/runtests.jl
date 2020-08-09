using TDAmeritrade, HTTP
using Test

@testset "TDAmeritrade.jl" begin
    # Write your tests here.
    @test TDAmeritrade.construct_api("marketdata/quotes", 
                        (;symbol="AAPL,FB")
                        ) == 
    HTTP.URI("https://api.tdameritrade.com/v1/marketdata/quotes?symbol=AAPL%2CFB")
end
