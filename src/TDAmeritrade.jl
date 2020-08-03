module TDAmeritrade

using HTTP 
using JSON3

include("auth.jl")
include("price_history.jl")

function construct_api(path, query=Dict())
    HTTP.URI(
    host="api.tdameritrade.com",
    scheme="https",
    path="/v1/$path",
    query=query
   )
end

mutable struct AUTH_KEYS{T<:AbstractString}
    CONSUMER_KEY::T
    CODE::T
    ACCESS_TOKEN::T
    REFRESH_TOKEN::T
    CALLBACK_URI::T
    AUTH_KEYS() = new{String}("", "", "", "","http://localhost")
end

AUTH_KEY = AUTH_KEYS()
end
