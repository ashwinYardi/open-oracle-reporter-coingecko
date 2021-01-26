// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

interface CErc20 {
    function underlying() external view returns (address);
}

contract OpenOracleConfig {
    ///  There should be 1 TokenConfig object for each supported asset, passed in the constructor.
    struct TokenConfig {
        address cToken;
        address underlying;
        string symbol;
        uint256 baseUnit;
    }

    /// @notice The max number of tokens this contract is hardcoded to support
    /// @dev Do not change this variable without updating all the fields throughout the contract.
    uint256 public constant maxTokens = 3;

    /// @notice The number of tokens this contract actually supports
    uint256 public immutable numTokens;

    address internal immutable cToken00;
    address internal immutable cToken01;
    address internal immutable cToken02;

    address internal immutable underlying00;
    address internal immutable underlying01;
    address internal immutable underlying02;

    string internal symbol00;
    string internal symbol01;
    string internal symbol02;

    uint256 internal immutable baseUnit00;
    uint256 internal immutable baseUnit01;
    uint256 internal immutable baseUnit02;

    /**
     * @notice Construct an immutable store of configs into the contract data
     * @param configs The configs for the supported assets
     */
    constructor(TokenConfig[] memory configs) public {
        require(configs.length <= maxTokens, "too many configs");
        numTokens = configs.length;

        cToken00 = get(configs, 0).cToken;
        cToken01 = get(configs, 1).cToken;
        cToken02 = get(configs, 2).cToken;

        underlying00 = get(configs, 0).underlying;
        underlying01 = get(configs, 1).underlying;
        underlying02 = get(configs, 2).underlying;

        symbol00 = get(configs, 0).symbol;
        symbol01 = get(configs, 1).symbol;
        symbol02 = get(configs, 2).symbol;

        baseUnit00 = get(configs, 0).baseUnit;
        baseUnit01 = get(configs, 1).baseUnit;
        baseUnit02 = get(configs, 2).baseUnit;
    }

    function get(TokenConfig[] memory configs, uint256 i)
        internal
        pure
        returns (TokenConfig memory)
    {
        if (i < configs.length) return configs[i];
        return
            TokenConfig({
                cToken: address(0),
                underlying: address(0),
                symbol: "", //can be updated to anything
                baseUnit: uint256(0)
            });
    }

    function getCTokenIndex(address cToken) internal view returns (uint256) {
        if (cToken == cToken00) return 0;
        if (cToken == cToken01) return 1;
        if (cToken == cToken02) return 2;

        return uint256(-1);
    }

    function getUnderlyingIndex(address underlying)
        internal
        view
        returns (uint256)
    {
        if (underlying == underlying00) return 0;
        if (underlying == underlying01) return 1;
        if (underlying == underlying02) return 2;

        return uint256(-1);
    }

    function getSymbolIndex(string memory symbol)
        internal
        view
        returns (uint256)
    {
        if (compareStrings(symbol, symbol00)) return 0;
        if (compareStrings(symbol, symbol01)) return 1;
        if (compareStrings(symbol, symbol02)) return 2;

        return uint256(-1);
    }

    /**
     * @notice Get the i-th config, according to the order they were passed in originally
     * @param i The index of the config to get
     * @return The config object
     */
    function getTokenConfig(uint256 i)
        public
        view
        returns (TokenConfig memory)
    {
        require(i < numTokens, "token config not found");

        if (i == 0)
            return
                TokenConfig({
                    cToken: cToken00,
                    underlying: underlying00,
                    symbol: symbol00,
                    baseUnit: baseUnit00
                });
        if (i == 1)
            return
                TokenConfig({
                    cToken: cToken01,
                    underlying: underlying01,
                    symbol: symbol01,
                    baseUnit: baseUnit01
                });
        if (i == 2)
            return
                TokenConfig({
                    cToken: cToken02,
                    underlying: underlying02,
                    symbol: symbol02,
                    baseUnit: baseUnit02
                });
    }

    /**
     * @notice Get the config for symbol
     * @param symbol The symbol of the config to get
     * @return The config object
     */
    function getTokenConfigBySymbol(string memory symbol)
        public
        view
        returns (TokenConfig memory)
    {
        uint256 index = getSymbolIndex(symbol);
        if (index != uint256(-1)) {
            return getTokenConfig(index);
        }

        revert("token config not found");
    }

    /**
     * @notice Get the config for the cToken
     * @dev If a config for the cToken is not found, falls back to searching for the underlying.
     * @param cToken The address of the cToken of the config to get
     * @return The config object
     */
    function getTokenConfigByCToken(address cToken)
        public
        view
        returns (TokenConfig memory)
    {
        uint256 index = getCTokenIndex(cToken);
        if (index != uint256(-1)) {
            return getTokenConfig(index);
        }

        return getTokenConfigByUnderlying(CErc20(cToken).underlying());
    }

    /**
     * @notice Get the config for an underlying asset
     * @param underlying The address of the underlying asset of the config to get
     * @return The config object
     */
    function getTokenConfigByUnderlying(address underlying)
        public
        view
        returns (TokenConfig memory)
    {
        uint256 index = getUnderlyingIndex(underlying);
        if (index != uint256(-1)) {
            return getTokenConfig(index);
        }

        revert("token config not found");
    }

    function compareStrings(string memory a, string memory b)
        internal
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }
}
