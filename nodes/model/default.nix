{ subgraph, nodes, edges }:

subgraph {
  src = ./.;
  flowscript = with nodes; with edges; ''
  db_path => input clone(${ip_clone})
  clone() clone[1] -> db_path get(${app_todo_nodes.todo_get})
  clone() clone[2] -> db_path post(${app_todo_nodes.todo_post})
  clone() clone[3] -> db_path delete(${app_todo_nodes.todo_delete})
  clone() clone[4] -> db_path patch(${app_todo_nodes.todo_patch})

  request_get => connect request_get(${nanomsg_nodes.pull})
  request_post => connect request_post(${nanomsg_nodes.pull})
  request_delete => connect request_delete(${nanomsg_nodes.pull})
  request_patch => connect request_patch(${nanomsg_nodes.pull})

  response_get => connect response_get(${nanomsg_nodes.push})
  response_post => connect response_post(${nanomsg_nodes.push})
  response_delete => connect response_delete(${nanomsg_nodes.push})
  response_patch => connect response_patch(${nanomsg_nodes.push})

  request_get() ip -> input get() response -> ip response_get()
  request_post() ip -> input post() response -> ip response_post()
  request_delete() ip -> input delete() response -> ip response_delete()
  request_patch() ip -> input patch() response -> ip response_patch()
  '';
}
