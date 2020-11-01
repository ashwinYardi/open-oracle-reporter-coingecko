const { ExpressEndpoint } = require("open-oracle-reporter");
const CoinGecko = require("coingecko-api");
const CoinGeckoClient = new CoinGecko();

const app = ExpressEndpoint.endpoint(process.env.PRIVATE_KEY, fetchPrices);

const assets = ["ethereum", "compound-governance-token", "dai", "unifi"];

async function fetchPrices(now) {
  const prices = await CoinGeckoClient.simple.price({
    ids: assets.join(),
    vs_currencies: "usd",
  });
  console.log(prices);
  return [
    now,
    {
      eth: prices.data.ethereum.usd,
      comp: prices.data[`compound-governance-token`].usd,
      dai: prices.data.dai.usd,
    },
  ];
}

app.listen(8000, () => {
  console.log(`Example app listening at 8000`);
});
