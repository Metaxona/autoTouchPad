# Touchpad Toggler Service

It Disables Touchpad Input if a (Mouse | Wireless Receiver) is Plugged in
and Enables Touchpad Input if There's no (Mouse | Wireless Receiver) is Plugged in

It rely's on `xinput` to toggles inputs

Default Polling is 5 seconds

## Installation

```bash
make install
```

## Uninstall

```bash
make uninstall
```

## Run Once

```bash
make run@single
```

## Run in Loop (Same as What The Service Will Do)

```bash
make run@loop
```

