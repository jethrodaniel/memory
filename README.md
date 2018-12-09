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
```

## Testing

```
rspec
```

## Documentation

```
yard doc
```
