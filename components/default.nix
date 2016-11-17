{ pkgs, support, allContracts, allComponents, ... }:
let
callPackage = pkgs.lib.callPackageWith (pkgs // support // allContracts // allComponents);
self = rec { # use one line only to insert a component (utils/new_component.py sorts this list)
  model = callPackage ./model {};
  test = callPackage ./test {};
}; # use one line only to insert a component (utils/new_component.py sorts this list)
in
self
