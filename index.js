require("dotenv").config();
const config = require("config");
const { ExpressEndpoint } = require("open-oracle-reporter");
const CoinGecko = require("coingecko-api");

const CoinGeckoClient = new CoinGecko();
const coins = config.get("coins");
const vsCurrency = config.get("vsCurrency");

async function fetchPrices(now) {
  const coingeckoIds = coins.map((coin) => {
    return coin.id;
  });

  const prices = (
    await CoinGeckoClient.simple.price({
      ids: coingeckoIds.join(),
      vs_currencies: vsCurrency,
    })
  ).data;

  const priceFeed = {};

  coins.forEach((coin) => {
    priceFeed[coin.symbol] = prices[coin.id][vsCurrency];
  });

  return [now, priceFeed];
}

const app = ExpressEndpoint.endpoint(process.env.PRIVATE_KEY, fetchPrices);

app.listen(process.env.PORT, () => {
  console.log(`Reporter started. Server is listening at ${process.env.PORT}`);
});
