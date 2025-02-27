{ stdenv, fetchFromGitLab, fetchpatch }:

# This is not actually the build derivation...
# We're co-opting this derivation as a source of truth for the version and src.
stdenv.mkDerivation rec {
  version = "6.12";

  src = fetchFromGitLab {
    owner = "torvalds";
    repo = "linux";
    rev = "adc218676eef25575469234709c2d87185ca223a";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
}
