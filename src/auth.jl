function initial_auth()
    @info "open the url in browser and copy the apikey back"
    auth_url = HTTP.URI(
        host="auth.tdameritrade.com",
        scheme="https",
        path="/auth",
        query = [
                 "response_type" => "code", 
                 "redirect_uri" => AUTH_KEY.CALLBACK_URI,
                 "client_id"=>"$(AUTH_KEY.CONSUMER_KEY)@AMER.OAUTHAP"
                ]
   )
end

function access_token(code)
    url = "https://api.tdameritrade.com/v1/oauth2/token"
    params = HTTP.escape([
              "grant_type" => "authorization_code",
              "refresh_token" => "",
              "access_type" => "offline",
              "code" => code,
              "client_id" => AUTH_KEY.CONSUMER_KEY,
              "redirect_uri" => AUTH_KEY.CALLBACK_URI
             ])
    json_result = HTTP.post(
                            url,
                ["Content-Type"=>"application/x-www-form-urlencoded"],
                params
               ).body |> String |> JSON3.read
    json_result
end

function refresh(refresh_token)
    if now() - AUTH_KEY.LAST_REFRESH < Minute(29)
        @info "Refresh not needed"
        return AUTH_KEY.ACCESS_TOKEN
    end
    url = "https://api.tdameritrade.com/v1/oauth2/token"
    params = HTTP.escape([
              "grant_type" => "refresh_token",
              "refresh_token" => refresh_token,
              "access_type" => "",
              "code" => "",
              "client_id" => AUTH_KEY.CONSUMER_KEY,
              "redirect_uri" => ""
             ])
    json_result = HTTP.post(
                            url,
                ["Content-Type"=>"application/x-www-form-urlencoded"],
                params
               ).body |> String |> JSON3.read
    AUTH_KEY.LAST_REFRESH = now()
    json_result[:access_token]
end

function TD_auth()
    cache_path = joinpath(homedir(), ".JL_TD_TOKENS_CACHE")
    if isfile(cache_path)
        last_refresh, last_date = readdlm(cache_path, ',')
        if Date(last_date) > today() - Day(89) # refresh token expires every 90 days
            AUTH_KEY.REFRESH_TOKEN = last_refresh
        else
            @info "Cached token is too old, getting new one"
        end
    end

    AUTH_KEY.CONSUMER_KEY = try
        ENV["JL_TD_CONSUMER_KEY"]
    catch
        error("Key environmen variable JL_TD_CONSUMER_KEY not found")
    end

    if AUTH_KEY.REFRESH_TOKEN == ""
        @info "First time auth needs manual invervention,"
        println(initial_auth())
        @info "extract code=<copy this> from address bar to here"
        print("code:")
        AUTH_KEY.CODE = readline() |> HTTP.URIs.unescapeuri
        token = access_token(AUTH_KEY.CODE)
        AUTH_KEY.ACCESS_TOKEN, AUTH_KEY.REFRESH_TOKEN = token[:access_token], token[:refresh_token]

        AUTH_KEY.LAST_REFRESH = now()
        @info "creating cache at $cache_path for tokens"
        open(cache_path, "w") do io
            writedlm(io, [AUTH_KEY.REFRESH_TOKEN today()], ',')
        end
    else
        @info "REFRESH_TOKEN found, refreshing ACCESS_TOKEN"
        AUTH_KEY.ACCESS_TOKEN = refresh(AUTH_KEY.REFRESH_TOKEN)
    end

    @info "Authentication completed."
    nothing
end
