#!/bin/bash

# Kill all nohup processes related to AWS SSM port forwarding
ps aux | grep '[n]ohup sudo aws ssm start-session' | awk '{print $2}' | xargs sudo kill
