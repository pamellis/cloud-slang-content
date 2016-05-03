#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrieves the list of branches from a Github project.
#! @input token - CircleCi user token.
#!                To authenticate, add an API token using your account dashboard
#!                Log in to CircleCi: https://circleci.com/vcs-authorize/
#!                Go to : https://circleci.com/account/api and copy the API token.
#!                If you don`t have any token generated, enter a new token name and then click on
#! @input protocol: optional - connection protocol
#!                  valid: 'http', 'https'
#!                  default: 'https'
#! @input host - circleci address
#!              Default: "circleci.com"
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! #input username - CircleCi username.
#! #input project - Github project name.
#! @input content_type: optional - content type that should be set in the request header, representing the MIME-type of the
#!                      data in the message body - Default: 'application/json'
#! @input headers: optional - list containing the headers to use for the request separated by new line (CRLF);
#!                 header name - value pair will be separated by ":" - Format: According to HTTP standard for
#!                 headers (RFC 2616) - Example: 'Accept:application/json'
#! @output return_result: information returned
#! @output error_message: return_result if status_code different than '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: status code of the HTTP call
#! @output branches: a list of branches
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.ci.circleci

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json
  lists: io.cloudslang.base.lists

flow:
  name: get_project_branches
  inputs:
    - host:
        default: "circleci.com"
        private: true
    - protocol:
        default: "https"
    - proxy_host:
        required: false
    - proxy_port:
        default: "8080"
        required: false
    - token
    - content_type:
        default: "application/json"
        private: true
    - headers:
        default: "Accept:application/json"
        private: true

  workflow:
    - get_project_info:
        do:
          rest.http_client_get:
            - url: ${protocol + '://' + host + '/api/v1/projects?circle-token=' + token}
            - protocol
            - host
            - proxy_host
            - proxy_port
            - content_type
            - headers

        publish:
          - return_result
          - return_code
          - status_code
          - error_message

        navigate:
          - SUCCESS: get_branches
          - FAILURE: FAILURE

    - get_branches:
        do:
          json.get_keys:
            - json_input: ${return_result}
            - json_path: [0, 'branches']

        publish:
          - branches: ${keys}
          - error_message

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - branches

  results:
    - SUCCESS
    - FAILURE
