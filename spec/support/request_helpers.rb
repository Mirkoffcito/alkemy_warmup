# This helper avoids us the trouble of repeating code when accesing to json reponse
module Request
    module JsonHelpers
        def json_response
            @json_response ||= JSON.parse(response.body, symbolize_names: true)
        end
    end
end