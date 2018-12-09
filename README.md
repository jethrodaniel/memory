# Programming Assignment 4

## Setup

This code is written in [Ruby 💎](https://www.ruby-lang.org/en/), a programming
language that's pretty awesome. It should be installable via your OS's package
manager, but [rvm](https://rvm.io/) is a more reliable solution.

To [install](https://rvm.io/rvm/install) ruby with rvm:

```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable --ruby
source "$HOME/.rvm/scripts/rvm"
```

then download dependencies

```
gem install bundle
bundle install
```

## Usage

```
./bin/prog4

Input: M 100 20

100 bytes physical memory (5 frames) have been created.

Input: A 20 1

20 bytes of memory have been allocated for process 1.

Input: W 1 20 1


Input: P

f1->p0 (proc1): 00000000000000000001
f2: 00000000000000000000
f3: 00000000000000000000
f4: 00000000000000000000
f5: 00000000000000000000

Input: R 1 20 1

1

Input: R 1 19 1

0

Input: R 1 21 1

Illegal memory access!

Input: A 20 2

20 bytes of memory have been allocated for process 2.

Input: P

f1->p0 (proc1): 00000000000000000001
f2->p0 (proc2): 00000000000000000000
f3: 00000000000000000000
f4: 00000000000000000000
f5: 00000000000000000000

Input: D 2

pass bytes of memory have been dellocated from process 2.

Input: P

f1->p1 (proc1): 00000000000000000001
f2: 00000000000000000000
f3: 00000000000000000000
f4: 00000000000000000000
f5: 00000000000000000000

Input: help

Commands:
  A [ALLOC_SIZE] [PID]       # Allocate a chunk of memory to a process
  D [PID]                    # Deallocate memory from a process
  M [MEM_SIZE] [FRAME_SIZE]  # Create a simulated physical memory space
  P                          # Print the memory's contents
  R [PAGE] [OFFSET] [PID]    # Read a byte from a process's memory location
  W [PAGE] [OFFSET] [PID]    # Write a `1` to a process's memory location
  help [COMMAND]             # Describe available commands or one specific command
  quit                       # Exit the program

Input: quit


Exiting ...
```

## Testing

```
rspec
```

## Documentation

```
yard doc
```
