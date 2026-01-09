{ pkgs, ... }: {
  channel = "stable-23.11";
  packages = [
    pkgs.openjdk17
  ];
  idx = {
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];
    workspace = {
      onCreate = {
        default.openFiles = ["lib/main.dart"];
      };
      onStart = {
        flutter-clean = "flutter clean && flutter pub get";
      };
    };
    previews = {
      enable = true;
      previews = {
        web = {
          command = ["flutter" "run" "--machine" "-d" "web-server" "--web-hostname" "0.0.0.0" "--web-port" "$PORT"];
          manager = "flutter";
        };
      };
    };
  };
}
