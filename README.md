# pakemon

This is a gamified frontend for hacking tools, meant to run with limited input (joystick) like on a pizero made to look like a gameboy.

It needs love & docker installed to develop locally.

## setup

```
# get files and deps
git clone --recursive https://github.com/notnullgames/pakemon-love-bettercap.git
cd pakemon-love-bettercap
make setup


# run test-net + bettercap server + frontend, in hot-reloading mode
make run

# lighter run,  with dev-tools disabled
make run-light

# If you are running a local bettercap, it's better for testing real stuff, and you can run the frontend in hot-reloading mode
make run-real

# get a list of more things you can do with make
make
```


## environment variables

There are a few environment variables that control the system.

```sh
# the love app is running in (live-reloading) dev-mode
PAKEMON_DEV=1

# location & credentials for the bettercap backend, defaults to setup in docker-compose
PAKEMON_URL=http://pakemon:pakemon@localhost:8081
```

## credits

I am trying to keep track of all artwork used.

- [portrait images](https://www.spriters-resource.com/pc_computer/rpgmakervx/sheet/100109/)