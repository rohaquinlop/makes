# https://grahamc.com/blog/nix-and-layered-docker-images
# https://github.com/moby/moby/blob/master/image/spec/v1.2.md#image-json-field-descriptions

{ inputs
, ...
}:

{ config ? null
, extraCommands ? ""
, layered ? true
, layers ? [ ]
, runAsRoot ? null
}:
let
  sharedAttrs = {
    inherit config;
    contents = layers;
    created = "1970-01-01T00:00:01Z";
    name = "container-image";
    tag = "latest";
  };
in
if layered
then
  inputs.makesPackages.nixpkgs.dockerTools.buildLayeredImage
    (sharedAttrs // {
      inherit extraCommands;
      maxLayers = 125;
    })
else
  inputs.makesPackages.nixpkgs.dockerTools.buildImage
    (sharedAttrs // {
      inherit runAsRoot;
    })