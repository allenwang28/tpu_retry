# TPU Retry script

Note: This is not an officially supported Google product.

## About
This is a toy example used for illustration purposes in case a TPU pod fails to recover from a maintenance event for whatever reason.


This example only attempts to delete and re-create a TPU in case it detects that the TPU is in an "unhealthy state".


Please continue reading for expectations:
- Cloud TPUs are expected to hit maintenance events, but the intended behavior is that the TPU recovers.
- Generally, saving checkpoints more often (at least every hour) allows you to gracefully recover. Also ensure that your training script does in fact resume from checkpoint.
- In unexpected circumstances, it's possible that the TPU does not recover from maintenance event. This script showcases an example of how to detect it and delete and re-create the TPU.
- It's possible that your training script crashes as well. You should modify this script to re-try running the train script.
- If you are using TPUEstimator, it will automatically try to resume from the latest checkpoint if you specify the same `--model_dir`.


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

*NOTE*: Please modify the script to reflect the correct TPU deletion/creation command, as this will differ if you're using e.g. TPU VM or a reserved TPU.
