# COSCUP - 2024

Code snippet for "A short experience to perform Fuzzing and Formal Verification".

## donation attack in staking v1

The exchange rate contains inflation attack.

```md
exploit
[stake] 1 asset and get 1 share
[vault] 1 asset, 1 share

exploit
[donate] 100e18 asset
[vault] 100e18 + 1 asset, 1 share

user
[stake] 100e18 asset and get 0 share

- share = 100e18 \* 1 / 100e18 + 1 = 0
```

# Commands

## Foundry Unit Test

```bash
forge test --mc UnitTest
```

## Foundry Stateless Fuzzing

```bash
forge test --mc FuzzTest
```

## Foundry Stateful Fuzzing

```bash
forge test --mc Invariant
```

## Echidna Stateful Fuzzing

```bash
solc-select use 0.8.23
echidna ./test/echidna/EchidnaCore.sol --contract StakingInvariant
```

## Solidity Compiler Formal Verification

```bash
FOUNDRY_PROFILE=fv forge build --force
```

## Halmos

```bash
halmos --contract StakingV1Symbol --solver-timeout-assertion 0
```

# Reference

- https://book.getfoundry.sh/
- https://github.com/horsefacts/weth-invariant-testing
- https://github.com/crytic/building-secure-contracts
- https://github.com/crytic/echidna-streaming-series
- https://github.com/a16z/halmos
- https://github.com/a16z/halmos-cheatcodes?tab=readme-ov-file
