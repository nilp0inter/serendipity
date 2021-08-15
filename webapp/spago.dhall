{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "serendipity"
, dependencies =
  [ "console"
  , "effect"
  , "halogen"
  , "integers"
  , "maybe"
  , "prelude"
  , "psci-support"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
