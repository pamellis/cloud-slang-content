#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.openstack.keypair

imports:
  openstack_content: io.cloudslang.openstack

flow:
  name: test_openstack_keypairs
  inputs:
    - host
    - identity_port: "'5000'"
    - compute_port: "'8774'"
    - username
    - password
    - tenant_name
    - keypair_name
    - public_key:
        required: false

  workflow:
    - create_openstack_keypair:
        do:
          create_openstack_keypair_flow:
            - host
            - identity_port
            - compute_port
            - username
            - password
            - tenant_name
            - keypair_name
            - public_key
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - error_message
        navigate:
          SUCCESS: list_keypairs
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          CREATE_KEY_PAIR_FAILURE: CREATE_KEY_PAIR_FAILURE

    - list_keypairs:
        do:
          get_openstack_keypairs_flow:
            - host
            - username
            - password
            - tenant_name
            - identity_port
            - compute_port
        publish:
          - keypair_list
        navigate:
          SUCCESS: delete_keypair
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          GET_KEY_PAIRS_FAILURE: GET_KEY_PAIRS_FAILURE
          EXTRACT_KEYPAIRS_FAILURE: EXTRACT_KEYPAIRS_FAILURE

    - delete_keypair:
        do:
          delete_openstack_keypair_flow:
            - host
            - username
            - password
            - tenant_name
            - identity_port
            - compute_port
            - keypair_name
        navigate:
          SUCCESS: SUCCESS
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          DELETE_KEY_PAIR_FAILURE: DELETE_KEY_PAIR_FAILURE

  outputs:
    - keypair_list
  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - CREATE_KEY_PAIR_FAILURE
    - GET_KEY_PAIRS_FAILURE
    - EXTRACT_KEYPAIRS_FAILURE
    - DELETE_KEY_PAIR_FAILURE