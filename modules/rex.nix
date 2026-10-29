# Rex server, shared across hosts.
#
# We run the *login server* rather than the personal or shared server:
#
#   - It starts at boot as a system service, so sessions survive logout. The
#     home-manager personal server stops at logout and ends every session
#     unless lingering is enabled.
#   - Sessions run as our own account. The shared server runs everything as the
#     `rex` user, where anyone in the `rex` group can see and type into every
#     session.
#   - It supports Tailscale Serve, which forwards HTTPS to Rex's socket over
#     each host's existing tailscaled and tailnet name. Rex's built-in
#     Tailscale instead joins the tailnet as its own tsnet device named `rex`,
#     which would collide across hosts and add a device per machine -- pointless
#     here, since every host is already a tailnet node.
#
# So each host is reachable from the Rex client at its own tailnet name:
#
#   rex hosts add vm-dev   https://vm-dev.tailb3adf.ts.net
#   rex hosts add desktop  https://framework-desktop-nixos.tailb3adf.ts.net
#
# This needs HTTPS enabled for the tailnet (it is) and the host logged in to
# Tailscale. The module writes the accounts to /etc/rex/accounts.jsonc but does
# not create them, so `leon` has to exist on the host -- it does, on both.
{inputs, ...}: {
  imports = [
    inputs.rex.nixosModules.default
  ];

  services.rex.loginServer = {
    enable = true;

    # Tailnet identity, not a local username: `tailscale status --json` reports
    # this as the LoginName. Account changes reload the server without ending
    # sessions.
    accounts.leon.principals = ["tailscale:aumitleon@gmail.com"];

    tailscaleServe.enable = true;
  };
}
