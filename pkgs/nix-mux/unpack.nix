{ system, bootstrapFiles }:

derivation {
  name = "nix-mux";

  builder = bootstrapFiles.busybox;

  args = [ "ash" "-e" ./unpack-script.sh ];

  tarball = bootstrapFiles.tarball;

  inherit system;
}
