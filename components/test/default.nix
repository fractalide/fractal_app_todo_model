{ stdenv
  , buildFractalideSubnet
  , model
  , path
  , generic_text
  , ...}:

buildFractalideSubnet rec {
  src = ./.;
  subnet = ''
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

   meta = with stdenv.lib; {
    description = "Subnet: Counter app";
    homepage = https://github.com/fractalide/fractalide/tree/master/components/development/test;
    license = with licenses; [ mpl20 ];
    maintainers = with upkeepers; [ dmichiels sjmackenzie];
  };
}
