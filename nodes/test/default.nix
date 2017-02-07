{ subgraph, imsgs, nodes, edges }:

subgraph rec {
  src = ./.;
  imsg = imsgs {
    edges = with edges; [ FsPath PrimText];
  };
  flowscript = with nodes; ''
  '${imsg}.FsPath:(path="${builtins.getEnv "HOME"}/todos.db")' -> db_path model(${model})
  '${imsg}.PrimText:(text="tcp://127.0.0.1:5551")' -> request_get model()
  '${imsg}.PrimText:(text="tcp://127.0.0.1:5552")' -> request_post model()
  '${imsg}.PrimText:(text="tcp://127.0.0.1:5553")' -> request_delete model()
  '${imsg}.PrimText:(text="tcp://127.0.0.1:5554")' -> request_patch model()
  '${imsg}.PrimText:(text="tcp://127.0.0.1:5555")' -> response_get model()
  '${imsg}.PrimText:(text="tcp://127.0.0.1:5556")' -> response_post model()
  '${imsg}.PrimText:(text="tcp://127.0.0.1:5557")' -> response_delete model()
  '${imsg}.PrimText:(text="tcp://127.0.0.1:5558")' -> response_patch model()
  '';
}
