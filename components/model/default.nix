{ stdenv
  , buildFractalideSubnet
  , app_todo_components
  , nanomsg_components
  , ip_clone
  , ...}:
buildFractalideSubnet rec {
   src = ./.;
   subnet = ''
   db_path => input clone(${ip_clone})
   clone() clone[1] -> db_path get(${app_todo_components.todo_get})
   clone() clone[2] -> db_path post(${app_todo_components.todo_post})
   clone() clone[3] -> db_path delete(${app_todo_components.todo_delete})
   clone() clone[4] -> db_path patch(${app_todo_components.todo_patch})

   request_get => connect request_get(${nanomsg_components.pull})
   request_post => connect request_post(${nanomsg_components.pull})
   request_delete => connect request_delete(${nanomsg_components.pull})
   request_patch => connect request_patch(${nanomsg_components.pull})

   response_get => connect response_get(${nanomsg_components.push})
   response_post => connect response_post(${nanomsg_components.push})
   response_delete => connect response_delete(${nanomsg_components.push})
   response_patch => connect response_patch(${nanomsg_components.push})

   request_get() ip -> input get() response -> ip response_get()
   request_post() ip -> input post() response -> ip response_post()
   request_delete() ip -> input delete() response -> ip response_delete()
   request_patch() ip -> input patch() response -> ip response_patch()
   '';

   meta = with stdenv.lib; {
    description = "Subnet: Counter app";
    homepage = https://github.com/fractalide/fractalide/tree/master/components/development/test;
    license = with licenses; [ mpl20 ];
    maintainers = with upkeepers; [ dmichiels sjmackenzie];
  };
}
