{ buildGoModule, fetchFromGitHub, lib, stdenv }:

buildGoModule rec {
  pname = "goawk";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = "goawk";
    rev = "v${version}";
    sha256 = "sha256-ALzCcSZHnzidj4tQzZWXT8WDPIE147KWbn7n1JHCTRE=";
  };

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  postPatch = ''
    substituteInPlace goawk_test.go \
      --replace "TestCommandLine" "SkipCommandLine" \
      --replace "TestDevStdout" "SkipDevStdout" \
      --replace "TestFILENAME" "SkipFILENAME" \
      --replace "TestWildcards" "SkipWildcards"

    substituteInPlace interp/interp_test.go \
      --replace "TestShellCommand" "SkipShellCommand"
  '';

  doCheck = (stdenv.system != "aarch64-darwin");

  meta = with lib; {
    description = "A POSIX-compliant AWK interpreter written in Go";
    homepage = "https://benhoyt.com/writings/goawk/";
    license = licenses.mit;
    mainProgram = "goawk";
    maintainers = with maintainers; [ abbe ];
  };
}
