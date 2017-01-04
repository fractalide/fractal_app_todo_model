{ subgraph, nodes, edges }:

subgraph {
  src = ./.;
  edges = with edges; [ fs_path prim_text ];
  flowscript = with nodes; with edges; ''
  '${fs_path}:(path="${builtins.getEnv "HOME"}/todos.db")' -> db_path model(${model})
  '${prim_text}:(text="tcp://127.0.0.1:5551")' -> request_get model()
  '${prim_text}:(text="tcp://127.0.0.1:5552")' -> request_post model()
  '${prim_text}:(text="tcp://127.0.0.1:5553")' -> request_delete model()
  '${prim_text}:(text="tcp://127.0.0.1:5554")' -> request_patch model()
  '${prim_text}:(text="tcp://127.0.0.1:5555")' -> response_get model()
  '${prim_text}:(text="tcp://127.0.0.1:5556")' -> response_post model()
  '${prim_text}:(text="tcp://127.0.0.1:5557")' -> response_delete model()
  '${prim_text}:(text="tcp://127.0.0.1:5558")' -> response_patch model()
  '';
}
