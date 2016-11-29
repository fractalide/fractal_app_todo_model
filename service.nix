{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.app_todo_model;
  fractalide = import <fractalide> {};
  support = fractalide.support;
  contracts = fractalide.contracts;
  components = fractalide.components;
  fractal = import ./default.nix { inherit pkgs support contracts components;
    fractalide = null;
  };
  serviceSubnet = support.buildFractalideSubnet rec {
    src = ./.;
    name = "app_todo_model_service";
    subnet = ''
    '${contracts.path}:(path="${cfg.dataDir}/${cfg.dbName}")' -> db_path model(${fractal.components.model})
    '${contracts.generic_text}:(text="${cfg.request_get}:${toString cfg.request_get_port}")' -> request_get model()
    '${contracts.generic_text}:(text="${cfg.request_post}:${toString cfg.request_post_port}")' -> request_post model()
    '${contracts.generic_text}:(text="${cfg.request_delete}:${toString cfg.request_delete_port}")' -> request_delete model()
    '${contracts.generic_text}:(text="${cfg.request_patch}:${toString cfg.request_patch_port}")' -> request_patch model()
    '${contracts.generic_text}:(text="${cfg.response_get}:${toString cfg.response_get_port}")' -> response_get model()
    '${contracts.generic_text}:(text="${cfg.response_post}:${toString cfg.response_post_port}")' -> response_post model()
    '${contracts.generic_text}:(text="${cfg.response_delete}:${toString cfg.response_delete_port}")' -> response_delete model()
    '${contracts.generic_text}:(text="${cfg.response_patch}:${toString cfg.response_patch_port}")' -> response_patch model()
    '';
  };
  fvm = import (<fractalide> + "/support/fvm/") {inherit pkgs support contracts components;};
in
{
  options.services.app_todo_model = {
    enable = mkEnableOption "Fractalide app_todo_model Example";
    package = mkOption {
      default = serviceSubnet;
      defaultText = "fractalComponents.app_todo_model";
      type = types.package;
      description = ''
        Workbench example.
      '';
    };
    user = mkOption {
      type = types.str;
      default = "app_todo_model";
      description = "User account under which app_todo_model runs.";
    };
    dbName = mkOption {
      type = types.str;
      default = "todos.db";
      description = "the database file name.";
    };
    dataDir = mkOption {
      type = types.path;
      default = "/var/fractalide/app_todo_model";
      description = "The DB will be written to this directory, with the filename specified using the 'dbName' configuration.";
    };
    request_get = mkOption {
      type = types.string;
      default = "tcp://127.0.0.1";
      description = "HTTP REQUEST GET interface pin connection string";
    };
    request_get_port = mkOption {
      type = types.int;
      default = 5551;
      description = "HTTP REQUEST GET interface pin connection port";
    };
    request_post = mkOption {
      type = types.string;
      default = "tcp://127.0.0.1";
      description = "HTTP REQUEST POTS interface pin connection string";
    };
    request_post_port = mkOption {
      type = types.int;
      default = 5552;
      description = "HTTP REQUEST POST interface pin connection port";
    };
    request_delete = mkOption {
      type = types.string;
      default = "tcp://127.0.0.1";
      description = "HTTP REQUEST DELETE interface pin connection string";
    };
    request_delete_port = mkOption {
      type = types.int;
      default = 5553;
      description = "HTTP REQUEST DELETE interface pin connection port";
    };
    request_patch = mkOption {
      type = types.string;
      default = "tcp://127.0.0.1";
      description = "HTTP REQUEST PATCH interface pin connection string";
    };
    request_patch_port = mkOption {
      type = types.int;
      default = 5554;
      description = "HTTP REQUEST PATCH interface pin connection port";
    };
    response_get = mkOption {
      type = types.string;
      default = "tcp://127.0.0.1";
      description = "HTTP RESPONSE GET interface pin connection string";
    };
    response_get_port = mkOption {
      type = types.int;
      default = 5555;
      description = "HTTP RESPONSE GET interface pin connection port";
    };
    response_post = mkOption {
      type = types.string;
      default = "tcp://127.0.0.1";
      description = "HTTP RESPONSE POST interface pin connection string";
    };
    response_post_port = mkOption {
      type = types.int;
      default = 5556;
      description = "HTTP RESPONSE POST interface pin connection port";
    };
    response_delete = mkOption {
      type = types.string;
      default = "tcp://127.0.0.1";
      description = "HTTP RESPONSE DELETE interface pin connection string";
    };
    response_delete_port = mkOption {
      type = types.int;
      default = 5557;
      description = "HTTP RESPONSE DELETE interface pin connection port";
    };
    response_patch = mkOption {
      type = types.string;
      default = "tcp://127.0.0.1";
      description = "HTTP RESPONSE PATCH interface pin connection string";
    };
    response_patch_port = mkOption {
      type = types.int;
      default = 5558;
      description = "HTTP RESPONSE PATCH interface pin connection port";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open ports in the firewall for the server.
      '';
    };
  };
  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [
        cfg.request_get_port
        cfg.request_post_port
        cfg.request_delete_port
        cfg.request_patch_port
        cfg.response_get_port
        cfg.response_post_port
        cfg.response_delete_port
        cfg.response_patch_port
      ];
    };
    users.extraUsers.app_todo_model = {
      name = cfg.user;
      #uid = config.ids.uids.app_todo_model;
      description = "Workbench database user";
    };
    systemd.services.app_todo_model_init = {
      description = "Workbench Server Initialisation";
      wantedBy = [ "app_todo_model.service" ];
      before = [ "app_todo_model.service" ];
      serviceConfig.Type = "oneshot";
      script = ''
        if ! test -e ${cfg.dataDir}/${cfg.dbName}; then
          mkdir -m 0777 -p ${cfg.dataDir}
          ${pkgs.sqlite.bin}/bin/sqlite3 ${cfg.dataDir}/${cfg.dbName} 'CREATE TABLE `todos` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `ip` BLOB)'
          chown -R ${cfg.user} ${cfg.dataDir}
        fi
      '';
    };
    systemd.services.app_todo_model = {
      description = "Workbench example";
      path = [ cfg.package ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        PermissionsStartOnly = true;
        Restart = "always";
        ExecStart = "${fvm}/bin/fvm ${cfg.package}";
        User = cfg.user;
      };
    };
    environment.systemPackages = [ fvm cfg.package ];
  };
}
