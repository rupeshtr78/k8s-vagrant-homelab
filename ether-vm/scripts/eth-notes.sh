Password:
Repeat password:we12come

Your new key was generated

Public address of the key:   0x32d0D6886B19839f693Dc5dF8F6d6Bd414B2A714
Path of the secret key file: /home/vagrant/.ethereum/keystore/UTC--2022-10-07T19-48-43.378695554Z--32d0d6886b19839f693dc5df8f6d6bd414b2a714

Public address of the key:   0xA3efEC2C1B582f80b04E5EEc74916Fd8F55C4468
Path of the secret key file: /home/vagrant/keystore/UTC--2022-10-07T20-15-09.915503053Z--a3efec2c1b582f80b04e5eec74916fd8f55c4468

geth init --datadir eth-data genesis/genesis.json


geth --datadir="ethchain" \
--networkid 12345 \
--nodiscover console \
--unlock E7e91c1FCfB7B2eB3d8bC247bAC5dAED3Db30167 \
--rpc --rpcport "8000" --rpcaddr "0.0.0.0" \
--rpccorsdomain "*" --rpcapi "eth,net,web3,miner,debug,personal,rpc"


geth --datadir="ethchain" \
--networkid 12345 \
--nodiscover console \
--unlock E7e91c1FCfB7B2eB3d8bC247bAC5dAED3Db30167

