#!/bin/bash

# This script is used to deploy the NoopToken contract to the target network
# This avoids trying to predict what address it might be deployed to

evm_endpoint=$1

# if evm_endpoint is unset, use http://0.0.0.0:8545
if [ -z "$evm_endpoint" ]; then
  evm_endpoint="http://0.0.0.0:8545"
fi

# first fund account if necessary
THRESHOLD=100000000000000000000 # 100 Eth
ACCOUNT="0xF87A299e6bC7bEba58dbBe5a5Aa21d49bCD16D52"
BALANCE=$(cast balance $ACCOUNT --rpc-url "$evm_endpoint")
if (( $(echo "$BALANCE < $THRESHOLD" | bc -l) )); then
  printf "12345678\n" | seid tx evm send $ACCOUNT 100000000000000000000 --from admin --evm-rpc "$evm_endpoint"
  sleep 3
fi
cd loadtest/contracts/evm || exit 1

./setup.sh > /dev/null

git submodule update --init --recursive > /dev/null

# NoOp
# /root/.foundry/bin/forge create -r "$evm_endpoint" --gas-price=100gwei --private-key 57acb95d82739866a5c29e40b0aa2590742ae50425b7dd5b5d279a986370189e src/NoopToken.sol:NoopToken --json --constructor-args "NoopToken" "NT" | jq -r '.deployedTo'
# 0xbD5d765B226CaEA8507EE030565618dAFFD806e2

# ERC20
# /root/.foundry/bin/forge create -r "$evm_endpoint" --gas-price=100gwei --private-key 57acb95d82739866a5c29e40b0aa2590742ae50425b7dd5b5d279a986370189e src/ERC20Token.sol:ERC20Token --json --constructor-args "BrazilToken" "BT" | jq -r '.deployedTo'
# === now using forge script instead

# Get from the forge script call
ADDR=0x46AeD8f9B26c359bA8842662ABEEd800408315Bf

cast call $ADDR "totalSupply()"

# mint some tokens to the $ACCOUNT
cast call $ADDR "balanceOf(address)(uint64)" $ACCOUNT
# cast call --gas-price=100gwei --private-key 57acb95d82739866a5c29e40b0aa2590742ae50425b7dd5b5d279a986370189e --json $ADDR "mint(address,uint256)" $ACCOUNT 1000

# forge script call here
