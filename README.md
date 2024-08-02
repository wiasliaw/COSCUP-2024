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

## Echidna Stateless Fuzzing

```bash
solc-select use 0.8.23
echidna ./test/echidna/EchidnaTester.sol --contract EchidnaTester --test-mode assertion
```

## Foundry Stateful Fuzzing

```bash
forge test --mc Invariant
```

## Solc Formal Verification

```bash
FOUNDRY_PROFILE=fv forge build --force
```

# Reference

- https://blog.openzeppelin.com/a-novel-defense-against-erc4626-inflation-attacks
- https://www.euler.finance/blog/exchange-rate-manipulation-in-erc4626-vaults
