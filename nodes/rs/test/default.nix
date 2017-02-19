{ subgraph, imsg, nodes, edges }:
let
  FsPath = imsg { class = edges.FsPath; text = ''(path="${builtins.getEnv "HOME"}/todos.db")''; };
  PrimText1 = imsg { class = edges.PrimText; text = ''(text="tcp://127.0.0.1:5551")''; };
  PrimText2 = imsg { class = edges.PrimText; text = ''(text="tcp://127.0.0.1:5552")''; };
  PrimText3 = imsg { class = edges.PrimText; text = ''(text="tcp://127.0.0.1:5553")''; };
  PrimText4 = imsg { class = edges.PrimText; text = ''(text="tcp://127.0.0.1:5554")''; };
  PrimText5 = imsg { class = edges.PrimText; text = ''(text="tcp://127.0.0.1:5555")''; };
  PrimText6 = imsg { class = edges.PrimText; text = ''(text="tcp://127.0.0.1:5556")''; };
  PrimText7 = imsg { class = edges.PrimText; text = ''(text="tcp://127.0.0.1:5557")''; };
  PrimText8 = imsg { class = edges.PrimText; text = ''(text="tcp://127.0.0.1:5558")''; };
in
subgraph {
  src = ./.;
  flowscript = with nodes.rs; ''
    '${FsPath}' -> db_path model(${model})
    '${PrimText1}' -> request_get model()
    '${PrimText2}' -> request_post model()
    '${PrimText3}' -> request_delete model()
    '${PrimText4}' -> request_patch model()
    '${PrimText5}' -> response_get model()
    '${PrimText6}' -> response_post model()
    '${PrimText7}' -> response_delete model()
    '${PrimText8}' -> response_patch model()
  '';
}
