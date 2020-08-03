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

function inter_auth(KEY=AUTH_KEY)
    KEY.CONSUMER_KEY = try
        ENV["JL_TD_CONSUMER_KEY"]
    catch
        error("Key environmen variable JL_TD_CONSUMER_KEY not found")
    end

    KEY.CODE = try
        ENV["JL_TD_CODE"]
    catch
        @info "first time auth needs manual invervention"
        ""
    end

    if KEY.CODE |> isempty
        @info initial_auth()
        @info "paste code=<blah> from address bar to here"
        print("code:")
        KEY.CODE = readline() |> HTTP.URIs.unescapeuri
    end

    token = access_token(KEY.CODE)
    KEY.ACCESS_TOKEN, KEY.REFRESH_TOKEN = token[:access_token], token[:refresh_token]

    @info "interactive auth done"
    nothing
end
