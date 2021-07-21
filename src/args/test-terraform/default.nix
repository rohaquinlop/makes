{ __nixpkgs__
, makeScript
, makeTerraformEnvironment
, ...
}:
{ setup
, name
, version
, src
, ...
}:
makeScript {
  entrypoint = ./entrypoint.sh;
  replace = {
    __argSrc__ = src;
  };
  name = "test-terraform-for-${name}";
  searchPaths = {
    source = [
      (makeTerraformEnvironment {
        inherit version;
      })
    ] ++ setup;
  };
}