#!/bin/bash

min_sum=600000000000000000
max_sum=900000000000000000
random_sum=$(shuf -i $min_sum-$max_sum -n 1)


echo "Enter private key:"
read -r PK

echo "Enter time:"
read -r time

echo "Staking amount: $random_sum, Create tx after $time seconds"

sleep $time
story validator create --stake $random_sum --private-key="$PK"
