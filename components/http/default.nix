{ stdenv
  , buildFractalideSubnet
  , net_http_components
  , nanomsg_components
  , ip_clone
  , ...}:
buildFractalideSubnet rec {
   src = ./.;
   subnet = ''
   listen => listen http(${net_http_components.http})

   request_get => connect request_get(${nanomsg_components.push})
   request_post => connect request_post(${nanomsg_components.push})
   request_delete => connect request_delete(${nanomsg_components.push})
   request_patch => connect request_patch(${nanomsg_components.push})

   response_get => connect response_get(${nanomsg_components.pull})
   response_post => connect response_post(${nanomsg_components.pull})
   response_delete => connect response_delete(${nanomsg_components.pull})
   response_patch => connect response_patch(${nanomsg_components.pull})

   http() GET[/todos/.+] -> ip request_get()
   response_get() ip -> response http()
   http() POST[/todos/?] -> ip request_post()
   response_post() ip -> response http()
   http() DELETE[/todos/.+] -> ip request_delete()
   response_delete() ip -> response http()
   http() PATCH[/todos/.+] -> ip request_patch()
   http() PUT[/todos/.+] -> ip request_patch()
   response_patch() ip -> response http()
   '';

   meta = with stdenv.lib; {
    description = "Subnet: Counter app";
    homepage = https://github.com/fractalide/fractalide/tree/master/components/development/test;
    license = with licenses; [ mpl20 ];
    maintainers = with upkeepers; [ dmichiels sjmackenzie];
  };
}
