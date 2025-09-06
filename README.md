# dotfiles

## Notes

- `greetd` launches `tuigreet` as `greeter` user. This means that it must be
  able to access the symlinked files in `/etc/tuigreet/{launchers,sessions}`.
  This is done using `chmod o+x <dir>` for all parent directories of
  `./root/etc/tuigreet/` to ensure that they are travesable by `greeter`.
- Ensure the partitions contain the [GPT metadata][1] to automount partitions in
  case `/etc/fstab` is malformed or not found. Can be easily done using
  `gnome-disks` and `swaplabel`.

[1]: https://wiki.archlinux.org/title/Partitioning#Partition_scheme
