# dotfiles

## Notes

- `greetd` launches `tuigreet` as `greeter` user. This means that it must be
  able to access the symlinked files in `/etc/tuigreet/{launchers,sessions}`.
  This is done using `chmod o+x <dir>` for all parent directories of
  `./root/etc/tuigreet/` to ensure that they are travesable by `greeter`.
