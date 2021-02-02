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
    uint256 public constant maxTokens = 10;

    /// @notice The number of tokens this contract actually supports
    uint256 public immutable numTokens;

    address internal immutable cToken00;
    address internal immutable cToken01;
    address internal immutable cToken02;
    address internal immutable cToken03;
    address internal immutable cToken04;
    address internal immutable cToken05;
    address internal immutable cToken06;
    address internal immutable cToken07;
    address internal immutable cToken08;
    address internal immutable cToken09;

    address internal immutable underlying00;
    address internal immutable underlying01;
    address internal immutable underlying02;
    address internal immutable underlying03;
    address internal immutable underlying04;
    address internal immutable underlying05;
    address internal immutable underlying06;
    address internal immutable underlying07;
    address internal immutable underlying08;
    address internal immutable underlying09;

    string internal symbol00;
    string internal symbol01;
    string internal symbol02;
    string internal symbol03;
    string internal symbol04;
    string internal symbol05;
    string internal symbol06;
    string internal symbol07;
    string internal symbol08;
    string internal symbol09;

    uint256 internal immutable baseUnit00;
    uint256 internal immutable baseUnit01;
    uint256 internal immutable baseUnit02;
    uint256 internal immutable baseUnit03;
    uint256 internal immutable baseUnit04;
    uint256 internal immutable baseUnit05;
    uint256 internal immutable baseUnit06;
    uint256 internal immutable baseUnit07;
    uint256 internal immutable baseUnit08;
    uint256 internal immutable baseUnit09;

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
        cToken03 = get(configs, 3).cToken;
        cToken04 = get(configs, 4).cToken;
        cToken05 = get(configs, 5).cToken;
        cToken06 = get(configs, 6).cToken;
        cToken07 = get(configs, 7).cToken;
        cToken08 = get(configs, 8).cToken;
        cToken09 = get(configs, 9).cToken;

        underlying00 = get(configs, 0).underlying;
        underlying01 = get(configs, 1).underlying;
        underlying02 = get(configs, 2).underlying;
        underlying03 = get(configs, 3).underlying;
        underlying04 = get(configs, 4).underlying;
        underlying05 = get(configs, 5).underlying;
        underlying06 = get(configs, 6).underlying;
        underlying07 = get(configs, 7).underlying;
        underlying08 = get(configs, 8).underlying;
        underlying09 = get(configs, 9).underlying;

        symbol00 = get(configs, 0).symbol;
        symbol01 = get(configs, 1).symbol;
        symbol02 = get(configs, 2).symbol;
        symbol03 = get(configs, 3).symbol;
        symbol04 = get(configs, 4).symbol;
        symbol05 = get(configs, 5).symbol;
        symbol06 = get(configs, 6).symbol;
        symbol07 = get(configs, 7).symbol;
        symbol08 = get(configs, 8).symbol;
        symbol09 = get(configs, 9).symbol;

        baseUnit00 = get(configs, 0).baseUnit;
        baseUnit01 = get(configs, 1).baseUnit;
        baseUnit02 = get(configs, 2).baseUnit;
        baseUnit03 = get(configs, 3).baseUnit;
        baseUnit04 = get(configs, 4).baseUnit;
        baseUnit05 = get(configs, 5).baseUnit;
        baseUnit06 = get(configs, 6).baseUnit;
        baseUnit07 = get(configs, 7).baseUnit;
        baseUnit08 = get(configs, 8).baseUnit;
        baseUnit09 = get(configs, 9).baseUnit;
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
        if (cToken == cToken03) return 3;
        if (cToken == cToken04) return 4;
        if (cToken == cToken05) return 5;
        if (cToken == cToken06) return 6;
        if (cToken == cToken07) return 7;
        if (cToken == cToken08) return 8;
        if (cToken == cToken09) return 9;

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
        if (underlying == underlying03) return 3;
        if (underlying == underlying04) return 4;
        if (underlying == underlying05) return 5;
        if (underlying == underlying06) return 6;
        if (underlying == underlying07) return 7;
        if (underlying == underlying08) return 8;
        if (underlying == underlying09) return 9;

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
        if (compareStrings(symbol, symbol03)) return 3;
        if (compareStrings(symbol, symbol04)) return 4;
        if (compareStrings(symbol, symbol05)) return 5;
        if (compareStrings(symbol, symbol06)) return 6;
        if (compareStrings(symbol, symbol07)) return 7;
        if (compareStrings(symbol, symbol08)) return 8;
        if (compareStrings(symbol, symbol09)) return 9;

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
        if (i == 3)
            return
                TokenConfig({
                    cToken: cToken03,
                    underlying: underlying03,
                    symbol: symbol03,
                    baseUnit: baseUnit03
                });
        if (i == 4)
            return
                TokenConfig({
                    cToken: cToken04,
                    underlying: underlying04,
                    symbol: symbol04,
                    baseUnit: baseUnit04
                });
        if (i == 5)
            return
                TokenConfig({
                    cToken: cToken05,
                    underlying: underlying05,
                    symbol: symbol05,
                    baseUnit: baseUnit05
                });
        if (i == 6)
            return
                TokenConfig({
                    cToken: cToken06,
                    underlying: underlying06,
                    symbol: symbol06,
                    baseUnit: baseUnit06
                });
        if (i == 7)
            return
                TokenConfig({
                    cToken: cToken07,
                    underlying: underlying07,
                    symbol: symbol07,
                    baseUnit: baseUnit07
                });
        if (i == 8)
            return
                TokenConfig({
                    cToken: cToken08,
                    underlying: underlying08,
                    symbol: symbol08,
                    baseUnit: baseUnit08
                });
        if (i == 9)
            return
                TokenConfig({
                    cToken: cToken09,
                    underlying: underlying09,
                    symbol: symbol09,
                    baseUnit: baseUnit09
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
