const HDWalletProvider = require('truffle-hdwallet-provider')
const fs = require("fs")
const { join } = require('path')

const mochaGasSettings = {
  reporter: 'eth-gas-reporter',
  reporterOptions: {
    currency: 'USD',
    gasPrice: 3
  }
}


const mocha = process.env.GAS_REPORTER ? mochaGasSettings : {}

//TODO add dappchain config options

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '*',
      gasPrice: 1
    },
    ganache: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*',
      gasPrice: 1
    }
  },
  mocha,
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
}
