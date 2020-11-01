# open-oracle-reporter-coingecko

The open oracle reporter which fetches the prices from coingecko and creates the signed price feed to be published on chain.

## Setup

### Install all dependencies

`npm install`

### env file setup

Create .env file in project root. File should have following variables defined:

```
PRIVATE_KEY=
PORT=
```

### Running the reporter

`npm start`

## Configuration

Configuration file is located at this path : [open-oracle-reporter/config/default.json]

The configuration object has two properties.

1. coins:

```
"coins": [
    {
      "id": "ethereum",
      "symbol": "eth"
    },
    {
      "id": "compound-governance-token",
      "symbol": "comp"
    },
    {
      "id": "dai",
      "symbol": "dai"
    }
  ]
```

Here, id is the coingecko id for the currency. Coingecko's coins/list api can be used to get the required ids. And, symbol is the coin symbol. For ethereum, the symbol is 'ETH'. For ERC20 tokens, its the regular SYMBOL constant decalred in contract.

This array of coins can be updated to add / remove support for different coins.

2. vsCurrency

This is the curency against which exchange rates will be fetched. In case of Compound, it should be USD.
