#!/bin/bash

min_sum=600000000000000000
max_sum=900000000000000000
random_sum=$(shuf -i $min_sum-$max_sum -n 1)

min_time_s=480
max_time_s=720
random_time=$(shuf -i $min_time_s-$max_time_s -n 1)

echo "Enter private key:"
read -r PK

echo "Staking amount: $random_sum, Create tx after $random_time seconds"

sleep $random_time
story validator create --stake $random_sum --private-key="$PK"
