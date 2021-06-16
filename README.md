# TPU Retry script

Note: This is not an officially supported Google product.

This is a simple script used to monitor a TPU and re-create it in case the TPU undergoes a maintenance event.


## Example usage
You can run this script on your VM. This assumes that you have already exported the tpu name, e.g.
```
export TPU_NAME={my_tpu}
```

Within your VM you can run this script:
```
./retry.sh $TPU_NAME &
```

You are free to modify the polling frequency, the re-creation logic, etc.

Note that this runs indefinitely, so you will need to `pkill` the script once you are done.
