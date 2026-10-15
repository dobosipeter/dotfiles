# Local Sessionx fixes

`tmux-sessionx-local-fixes.patch` was created against
`omerxx/tmux-sessionx` commit `5e8df209e0c9ae826784555afa834db8722378a6`.
It is already applied to `~/.tmux/plugins/tmux-sessionx` on this machine.

## Fixes

- Keep tmux's automatic first-window naming when creating sessions with zoxide
  mode enabled. Use a matched directory only when the query succeeds and the
  directory exists; otherwise create a normal session without explicit `-c` or
  `-n` arguments.
- Make the post-delete session list respect `@sessionx-filter-current`, using
  the same cached option as the initial picker. When filtering is enabled,
  compare literal, complete session names rather than substrings or regexes.
  Preserve the existing behavior of keeping the only remaining session visible.

The scripts are read on each launch/refresh. Reopen Sessionx after applying;
no tmux server restart or configuration reload is required. Existing blank window
names are not modified by this patch.

## Plugin updates and reapplication

TPM updates may fail because the plugin has local modifications, or a reinstall
may remove the fixes. Do not reset unrelated plugin changes to force an update.
After an update, inspect the upstream code first: either fix may have landed
upstream, in which case this patch must be adjusted or retired.

To check whether the complete patch is already present:

```sh
git -C ~/.tmux/plugins/tmux-sessionx apply --reverse --check \
  ~/git/dotfiles/tmux/patches/tmux-sessionx-local-fixes.patch
```

If it is not already present, check that it applies cleanly before applying:

```sh
git -C ~/.tmux/plugins/tmux-sessionx apply --check \
  ~/git/dotfiles/tmux/patches/tmux-sessionx-local-fixes.patch
# Only if the check succeeds:
git -C ~/.tmux/plugins/tmux-sessionx apply \
  ~/git/dotfiles/tmux/patches/tmux-sessionx-local-fixes.patch
```

If neither check succeeds, stop and review the new upstream code rather than
forcing the patch. These local fixes have not been submitted upstream.
