module Wiki.Generators

import public QuickCheck
import Core
import ActionDynamics

%default total

public export
Show LatticeCoord2D where
  show (MkCoord2D x y) = "(" ++ show (unwrapBox x) ++ ", " ++ show (unwrapBox y) ++ ")"

public export
Arbitrary LatticeCoord2D where
  arbitrary = do
    x <- arbitrary {a = Integer}
    y <- arbitrary {a = Integer}
    pure (MkCoord2D (intToBoxInt x) (intToBoxInt y))

  coarbitrary (MkCoord2D x y) gen =
    coarbitrary (unwrapBox x) (coarbitrary (unwrapBox y) gen)

public export
Arbitrary FundamentalGeometry where
  arbitrary = elements [EllipticGeom, HyperbolicGeom, ParabolicGeom, SubstrateGeom]

  coarbitrary EllipticGeom gen   = coarbitrary (the Nat 0) gen
  coarbitrary HyperbolicGeom gen = coarbitrary (the Nat 1) gen
  coarbitrary ParabolicGeom gen  = coarbitrary (the Nat 2) gen
  coarbitrary SubstrateGeom gen  = coarbitrary (the Nat 3) gen

