{s}: 
{
  ghcidScript = s "dev" "ghcid --command 'cabal new-repl lib:hello-haskell' --allow-eval --warnings";
  testScript = s "test" "cabal run test:hello-haskell-tests";
  hoogleScript = s "hgl" "hoogle serve";
}
