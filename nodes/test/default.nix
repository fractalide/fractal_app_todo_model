{ subgraph, nodes, edges }:

subgraph {
  src = ./.;
  flowscript = with nodes; with edges; ''
  '${path}:(path="${builtins.getEnv "HOME"}/todos.db")' -> db_path model(${model})
  '${generic_text}:(text="tcp://127.0.0.1:5551")' -> request_get model()
  '${generic_text}:(text="tcp://127.0.0.1:5552")' -> request_post model()
  '${generic_text}:(text="tcp://127.0.0.1:5553")' -> request_delete model()
  '${generic_text}:(text="tcp://127.0.0.1:5554")' -> request_patch model()
  '${generic_text}:(text="tcp://127.0.0.1:5555")' -> response_get model()
  '${generic_text}:(text="tcp://127.0.0.1:5556")' -> response_post model()
  '${generic_text}:(text="tcp://127.0.0.1:5557")' -> response_delete model()
  '${generic_text}:(text="tcp://127.0.0.1:5558")' -> response_patch model()
  '';
}
