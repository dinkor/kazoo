%%%-------------------------------------------------------------------
%%% @author Edouard Swiac <edouard@2600hz.org>
%%% @copyright (C) 2011, VoIP INC
%%% @doc
%%% Expose system configuration data.
%%% System configuration data is stored as key/values in a namespace
%%% (a doc) in system_config DB. 
%%% @end
%%%-------------------------------------------------------------------
-module(wapi_sysconf).

-export([get_req/1, get_req_v/1
         ,get_resp/1, get_resp_v/1
         ,set_req/1, set_req_v/1
         ,set_resp/1, set_resp_v/1
         ,bind_q/2, unbind_q/2
         ,publish_get_req/1, publish_get_req/2
         ,publish_get_resp/2, publish_get_resp/3
         ,publish_set_req/1, publish_set_req/2
         ,publish_set_resp/2, publish_set_resp/3
        ]).

-include("../wh_api.hrl").

-define(SYSCONF_VALUES, [{<<"Event-Category">>, <<"sysconf">>}]).

%% sysconf whapp routing keys for responses to clients
-define(KEY_SYSCONF_GET_REQ, <<"sysconf.get">>).
-define(KEY_SYSCONF_SET_REQ, <<"sysconf.set">>).

%% Configuration Document Update
%% request to read 
-define(SYSCONF_GET_REQ_HEADERS, [<<"Category">>, <<"Key">>, <<"Node">>]).
-define(OPTIONAL_SYSCONF_GET_REQ_HEADERS, [<<"Default">>]).
-define(SYSCONF_GET_REQ_VALUES, [{<<"Event-Name">>, <<"get_req">>} | ?SYSCONF_VALUES]).

%% answer to a read request
-define(SYSCONF_GET_RESP_HEADERS, [<<"Category">>, <<"Key">>, <<"Value">>]).
-define(OPTIONAL_SYSCONF_GET_RESP_HEADERS, []).
-define(SYSCONF_GET_RESP_VALUES, [{<<"Event-Name">>, <<"get_resp">>} | ?SYSCONF_VALUES]).

%% request a write
-define(SYSCONF_SET_REQ_HEADERS, [<<"Category">>, <<"Key">>, <<"Value">>, <<"Node">>]).
-define(OPTIONAL_SYSCONF_SET_REQ_HEADERS, []).
-define(SYSCONF_SET_REQ_VALUES, [{<<"Event-Name">>, <<"set_req">>} | ?SYSCONF_VALUES]).

%% answer to a write request
-define(SYSCONF_SET_RESP_HEADERS, [<<"Category">>, <<"Key">>, <<"Value">>, <<"Status">>]).
-define(OPTIONAL_SYSCONF_SET_RESP_HEADERS, [<<"Node">>]).
-define(SYSCONF_SET_RESP_VALUES, [{<<"Event-Name">>, <<"set_resp">>} | ?SYSCONF_VALUES]).

-define(SYSCONF_TYPES, [{<<"Category">>, fun is_binary/1}
                        ,{<<"Key">>, fun is_binary/1}
                        ,{<<"Node">>, fun is_binary/1}
                       ]).

%%--------------------------------------------------------------------
%% @doc
%% READ
%% @end
%%--------------------------------------------------------------------
-spec get_req/1 :: (api_terms()) -> {'ok', iolist()} | {'error', string()}.
get_req(Prop) when is_list(Prop) ->
    case get_req_v(Prop) of
        true -> wh_api:build_message(Prop, ?SYSCONF_GET_REQ_HEADERS, ?OPTIONAL_SYSCONF_GET_REQ_HEADERS);
        false -> {error, "Proplist failed validation for sysconf read"}
    end;
get_req(JObj) ->
    get_req(wh_json:to_proplist(JObj)).

-spec get_req_v/1 :: (api_terms()) -> boolean().
get_req_v(Prop) when is_list(Prop) ->
    wh_api:validate(Prop, ?SYSCONF_GET_REQ_HEADERS, ?SYSCONF_GET_REQ_VALUES, ?SYSCONF_TYPES);
get_req_v(JObj) ->
    get_req_v(wh_json:to_proplist(JObj)).

-spec get_resp/1 :: (api_terms()) -> {'ok', iolist()} | {'error', string()}.
get_resp(Prop) when is_list(Prop) ->
    case get_resp_v(Prop) of
        true -> wh_api:build_message(Prop, ?SYSCONF_GET_RESP_HEADERS, ?OPTIONAL_SYSCONF_GET_RESP_HEADERS);
        false -> {error, "Proplist failed validation for sysconf read"}
    end;
get_resp(JObj) ->
    get_resp(wh_json:to_proplist(JObj)).

-spec get_resp_v/1 :: (api_terms()) -> boolean().
get_resp_v(Prop) when is_list(Prop) ->
    wh_api:validate(Prop, ?SYSCONF_GET_RESP_HEADERS, ?SYSCONF_GET_RESP_VALUES, ?SYSCONF_TYPES);
get_resp_v(JObj) ->
    get_resp_v(wh_json:to_proplist(JObj)).

%%--------------------------------------------------------------------
%% @doc
%% WRITE
%% @end
%%--------------------------------------------------------------------
-spec set_req/1 :: (api_terms()) -> {'ok', iolist()} | {'error', string()}.
set_req(Prop) when is_list(Prop) ->
    case set_req_v(Prop) of
        true -> wh_api:build_message(Prop, ?SYSCONF_SET_REQ_HEADERS, ?OPTIONAL_SYSCONF_SET_REQ_HEADERS);
        false -> {error, "Proplist failed validation for sysconf write"}
    end;
set_req(JObj) ->
    set_req(wh_json:to_proplist(JObj)).

-spec set_req_v/1 :: (api_terms()) -> boolean().
set_req_v(Prop) when is_list(Prop) ->
    wh_api:validate(Prop, ?SYSCONF_SET_REQ_HEADERS, ?SYSCONF_SET_REQ_VALUES, ?SYSCONF_TYPES);
set_req_v(JObj) ->
    set_req_v(wh_json:to_proplist(JObj)).

-spec set_resp/1 :: (api_terms()) -> {'ok', iolist()} | {'error', string()}.
set_resp(Prop) when is_list(Prop) ->
    case set_resp_v(Prop) of
        true -> wh_api:build_message(Prop, ?SYSCONF_SET_RESP_HEADERS, ?OPTIONAL_SYSCONF_SET_RESP_HEADERS);
        false -> {error, "Proplist failed validation for sysconf write"}
    end;
set_resp(JObj) ->
    set_resp(wh_json:to_proplist(JObj)).

-spec set_resp_v/1 :: (api_terms()) -> boolean().
set_resp_v(Prop) when is_list(Prop) ->
    wh_api:validate(Prop, ?SYSCONF_SET_RESP_HEADERS, ?SYSCONF_SET_RESP_VALUES, ?SYSCONF_TYPES);
set_resp_v(JObj) ->
    set_resp_v(wh_json:to_proplist(JObj)).


-spec bind_q/2 :: (ne_binary(), proplist()) -> 'ok'.
bind_q(Q, _Prop) -> 
    amqp_util:sysconf_exchange(),
    amqp_util:bind_q_to_sysconf(Q, <<>>),
    ok.

-spec unbind_q/2 :: (ne_binary(), proplist()) -> 'ok'.
unbind_q(Q, _Prop) ->
    amqp_util:unbind_q_from_sysconf(Q).

-spec publish_get_req/1 :: (api_terms()) -> 'ok'.
-spec publish_get_req/2 :: (api_terms(), ne_binary()) -> 'ok'.
publish_get_req(JObj) ->
    publish_get_req(JObj, ?DEFAULT_CONTENT_TYPE).
publish_get_req(Api, ContentType) ->
    {ok, Payload} = wh_api:prepare_api_payload(Api, ?SYSCONF_GET_REQ_VALUES, fun ?MODULE:get_req/1),
    amqp_util:sysconf_publish(?KEY_SYSCONF_GET_REQ, Payload, ContentType).

-spec publish_get_resp/2 :: (ne_binary(), api_terms()) -> 'ok'.
-spec publish_get_resp/3 :: (ne_binary(), api_terms(), ne_binary()) -> 'ok'.
publish_get_resp(RespQ, JObj) ->
    publish_get_resp(RespQ, JObj, ?DEFAULT_CONTENT_TYPE).
publish_get_resp(RespQ, Api, ContentType) ->
    {ok, Payload} = wh_api:prepare_api_payload(Api, ?SYSCONF_GET_RESP_VALUES, fun ?MODULE:get_resp/1),
    amqp_util:sysconf_publish(RespQ, Payload, ContentType).

-spec publish_set_req/1 :: (api_terms()) -> 'ok'.
-spec publish_set_req/2 :: (api_terms(), ne_binary()) -> 'ok'.
publish_set_req(JObj) ->
    publish_set_req(JObj, ?DEFAULT_CONTENT_TYPE).
publish_set_req(Api, ContentType) ->
    {ok, Payload} = wh_api:prepare_api_payload(Api, ?SYSCONF_SET_REQ_VALUES, fun ?MODULE:set_req/1),
    amqp_util:sysconf_publish(?KEY_SYSCONF_SET_REQ, Payload, ContentType).

-spec publish_set_resp/2 :: (ne_binary(), api_terms()) -> 'ok'.
-spec publish_set_resp/3 :: (ne_binary(), api_terms(), ne_binary()) -> 'ok'.
publish_set_resp(RespQ, JObj) ->
    publish_set_resp(RespQ, JObj, ?DEFAULT_CONTENT_TYPE).
publish_set_resp(RespQ, Api, ContentType) ->
    {ok, Payload} = wh_api:prepare_api_payload(Api, ?SYSCONF_SET_RESP_VALUES, fun ?MODULE:set_resp/1),
    amqp_util:sysconf_publish(RespQ, Payload, ContentType).
