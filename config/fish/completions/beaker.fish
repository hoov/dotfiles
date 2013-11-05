function __fish_beaker_needs_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 -a $cmd[1] = 'beaker' ]
    return 0
  end
  return 1
end

# Generic Beaker options

complete -f -c beaker -n '__fish_beaker_needs_command' -a version -d 'Show beakerd version'
#complete -f -c git -n '__fish_git_using_command fetch' -a '(__fish_git_remotes)' -d 'Remote'

complete -f -c beaker -n '__fish_beaker_needs_command' -s h -l help -d "display this help and exit"
complete -f -c beaker -n '__fish_beaker_needs_command' -l color 
complete -f -c beaker -n '__fish_beaker_needs_command' -l style -a "monokai manni rrt perldoc borland colorful default murphy vs trac tango fruity autumn bw emacs vim pastie friendly native"
