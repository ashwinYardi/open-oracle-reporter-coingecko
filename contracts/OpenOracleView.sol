// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "./OpenOraclePriceData.sol";
import "./OpenOracleConfig.sol";
import "./OpenOracleLib.sol";

struct Observation {
    uint256 timestamp;
    uint256 acc;
}

contract OpenOracleView is OpenOracleConfig {
    using FixedPoint for *;

    /// @notice The Open Oracle Price Data contract
    OpenOraclePriceData public immutable priceData;

    /// @notice The number of wei in 1 ETH
    uint256 public constant ethBaseUnit = 1e18;

    /// @notice A common scaling factor to maintain precision
    uint256 public constant expScale = 1e18;

    /// @notice The Open Oracle Reporter
    address public immutable reporter;

    /// @notice The event emitted when the stored price is updated
    event PriceUpdated(string symbol, uint256 price);

    /**
     * @notice Construct a open oracle view for a set of token configurations
     * @param reporter_ The reporter whose prices are to be used
     * @param configs The static token configurations which define what prices are supported and how
     */
    constructor(
        OpenOraclePriceData priceData_,
        address reporter_,
        TokenConfig[] memory configs
    ) public OpenOracleConfig(configs) {
        priceData = priceData_;
        reporter = reporter_;

        for (uint256 i = 0; i < configs.length; i++) {
            TokenConfig memory config = configs[i];
            require(config.baseUnit > 0, "baseUnit must be greater than zero");
        }
    }

    /**
     * @notice Get the official price for a symbol
     * @param symbol The symbol to fetch the price of
     * @return Price denominated in USD, with 6 decimals
     */
    function price(string memory symbol) external view returns (uint256) {
        TokenConfig memory config = getTokenConfigBySymbol(symbol);
        return priceInternal(config);
    }

    function priceInternal(TokenConfig memory config)
        internal
        view
        returns (uint256)
    {
        uint256 reporterPrice = priceData.getPrice(reporter, config.symbol);
        return reporterPrice;
    }

    /**
     * @notice Get the underlying price of a cToken
     * @dev Implements the PriceOracle interface for Compound v2.
     * @param cToken The cToken address for price retrieval
     * @return Price denominated in USD, with 18 decimals, for the given cToken address
     */
    function getUnderlyingPrice(address cToken)
        external
        view
        returns (uint256)
    {
        TokenConfig memory config = getTokenConfigByCToken(cToken);
        // Comptroller needs prices in the format: ${raw price} * 1e(36 - baseUnit)
        // Since the prices in this view have 6 decimals, we must scale them by 1e(36 - 6 - baseUnit)
        return mul(1e30, priceInternal(config)) / config.baseUnit;
    }

    /**
     * @notice Post open oracle reporter prices, and recalculate stored price by comparing to anchor
     * @dev We let anyone pay to post anything, but only prices from configured reporter will be stored in the view.
     * @param messages The messages to post to the oracle
     * @param signatures The signatures for the corresponding messages
     */
    function setUnderlyingPrice(
        bytes[] calldata messages,
        bytes[] calldata signatures
    ) external {
        require(
            messages.length == signatures.length,
            "messages and signatures must be 1:1"
        );

        // Save the prices
        for (uint256 i = 0; i < messages.length; i++) {
            priceData.put(messages[i], signatures[i]);
        }
    }

    /// @dev Overflow proof multiplication
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "multiplication overflow");
        return c;
    }
}
