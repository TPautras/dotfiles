{ self, inputs, ... }: {
  flake.homeManagerModules.aiTools = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.aiTools;
  in {
    options.hm.aiTools.enable = mkEnableOption "Claude Code CLI + AI tools";

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default

        nodejs

        python3
        python3Packages.anthropic
        python3Packages.requests
        python3Packages.python-dotenv
        python3Packages.pydantic
        python3Packages.httpx

        ollama

        jq
        yq
        curl
        wget
        git
      ];
    };
  };
}
