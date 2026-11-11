# LEGACY_COMPATIBILITY release channel: version, URL and checksum intentionally unchanged.
# Canonical implementation/provenance is olsisoft/pulse; no new public release is implied.
# Homebrew formula for the Pulse CLI.
#
# This lives here as the canonical source; to publish it, copy it into a tap repo you own
# (e.g. `olsisoft/homebrew-tap` as `Formula/pulse.rb`) so users can:
#
#     brew tap olsisoft/tap
#     brew install pulse
#
# Per release (pulse-cli-vX.Y.Z), update `version` and `sha256` (the checksum is published
# next to the jar as streamflow-pulse.jar.sha256 by .github/workflows/pulse-cli-release.yaml).
#
# This is the JVM-jar formula: it declares an OpenJDK dependency and wraps `java -jar`. It
# works today. When the native single-file binary lands, this can switch to a bottle-style
# per-arch `url`/`sha256` and drop the java dependency. See docs/PULSE-CLI-DISTRIBUTION.md.
class Pulse < Formula
  desc "Pulse — declare a real-time app in YAML; it compiles to an API, SDKs and a UI"
  homepage "https://github.com/olsisoft/pulse"
  version "2.7.7"
  # Source repo is PRIVATE — the jar is fetched through the public release proxy, not github.com.
  url "https://updates.streamflowmesh.io/download/pulse-cli-v2.7.7/streamflow-pulse.jar"
  sha256 "b40cf7e1ff99790c53b5f750c7e047ddcfc3087997918ec643fb7ab80a2a32cf"
  # Set once the repo publishes a LICENSE; omitted here rather than guessing.

  depends_on "openjdk"

  def install
    libexec.install "streamflow-pulse.jar"
    (bin/"pulse").write <<~SH
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" --enable-native-access=ALL-UNNAMED \
        -jar "#{libexec}/streamflow-pulse.jar" "$@"
    SH
  end

  test do
    assert_match "Pulse v", shell_output("#{bin}/pulse --version")
  end
end
