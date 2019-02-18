{ system ? builtins.currentSystem # TODO: Get rid of this system cruft
, iosSdkVersion ? "10.2"
}:
with import ./.obelisk/impl { inherit system iosSdkVersion; };
project ./. ({pkgs, ... }: {

  overrides = self: super: let
            semantic-reflex = pkgs.fetchFromGitHub {
                            owner = "tomsmalley";
                            repo = "semantic-reflex";
                            rev = "38fce7e4d08d46b8664768f1b7fe38846dbac1e2";
                            sha256 = "1s2p12r682wd8j2z63pjvbi4s9v02crh6nz8kjilwdsfs02yp5p2";
            };

            quickform-semantic-reflex = pkgs.fetchFromGitHub {
            owner = "johnny555";
            repo = "quickform-semantic-reflex";
            rev = "68c23a6cf8314e1ae23fd9bcd45e2fd00516295e";
            sha256 = "1s2p12r682wd8j2z63pjvbi4s9v02crh6nz8kjilwdsfs02yp5p2";
            };

            reflex-dom-contrib = pkgs.fetchFromGitHub {
            owner = "reflex-frp";
            repo = "reflex-dom-contrib";
            rev = "518beb2e0bcc640defb63de0e8e287479fa9c436";
            sha256 ="0b0zlzbhd7c1syggn196jhhm67s4nsddmyd29njjnk537lw1d2qv";
            };

            reflex-dom-nested-routing = pkgs.fetchFromGitHub {
            owner = "3noch";
            repo = "reflex-dom-nested-routing";
            rev = "c49c75c693de8516d1b19314be500482bea9426c";
            sha256 = "00bmakqm9893h8l3w7l1r1fjkpyffifcaicqmj2q5wwlfvm96hbf";
            };

            selda = pkgs.fetchFromGitHub {
            owner = "johnny555";
            repo = "selda";
            rev = "03308ae23bcb5021e0e64f9f02eec196f5772f9f"; # jv v0.3.30
            sha256="07nbasyahmfi6qxld92s00f6vxb80znsbp1fc7lm9xj98g3b6i7s"; # jv v0.3.3.0 hash
            };
            dontHaddock = nixpkgs.pkgs.haskell.lib.dontHaddock;

            in
            {
            reflex-dom-contrib = self.callCabal2nix "reflex-dom-contrib" reflex-dom-contrib {};
            reflex-dom-nested-routing = self.callCabal2nix "reflex-dom-nested-routing" reflex-dom-nested-routing {};
            semantic-reflex = self.callCabal2nix "semantic-reflex" "${semantic-reflex}/semantic-reflex" {};
            selda = dontHaddock (self.callCabal2nix "selda" "${selda}/selda" {});
            selda-sqlite = dontHaddock (self.callCabal2nix "selda-sqlite" "${selda}/selda-sqlite" {});

            frontend = dontHaddock super.frontend;
            backend = dontHaddock super.backend;

};
})
