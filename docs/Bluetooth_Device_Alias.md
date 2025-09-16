# Bluetooth Device Alias

To change the name of a paired Bluetooth device as shown in settings, you can use `bluetoothctl`.

1. First, connect to the device as you normally would.

1. Open `bluetoothctl`:

   ```bash
   bluetoothctl
   ```

   The prompt should look like:

   ```bash
   [Device current name]>
   ```

1. Update the alias for the connected device:

   ```bash
   set-alias "My device"
   ```

1. Exit `bluetoothctl`:

   ```bash
   exit
   ```
