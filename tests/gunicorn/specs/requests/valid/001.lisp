(list :request-method :PUT
      :request-uri "/stuff/here?foo=bar"
      :script-name "/stuff/here"
      :query-string "foo=bar"
      :server-name "127.0.0.1"
      :server-port 5984
      :http-host "127.0.0.1:5984"
      :url-scheme :http
      :server-protocol :HTTP/1.0
      :content-length 14
      :content-length "application/json"
      :raw-body (make-string-input-stream "{\"nom\": \"nom\"}"))
