module Wiki.Main

import System
import Core
import Physics
import Wiki.PhysicsScaleTransformSpec
import Wiki.LawHomomorphismSpec
import Wiki.QuadStreamPhysicalLawsSpec
import Wiki.DensityStreamSpec
import Language.Reflection

%default covering

main : IO ()
main = do
  putStrLn "========================================================"
  putStrLn "  IDRIS 2 PHYSICS WIKI VERIFICATION SUITE"
  putStrLn "========================================================"
  putStrLn "1. Discrete Action & Euler-Lagrange Geodesic Proof Audits:"
  if prop_eulerLagrangeGeodesicValid && prop_leastActionGeodesicValid
     then putStrLn "   [PASSED] Static Action & Geodesic Audits Clean!"
     else do
       putStrLn "   [FAILED] Geodesic Audits Failed!"
       exitWith (ExitFailure 1)
  putStrLn ""
  putStrLn "2. Physics ScaleTransform (Coord2D -> BoxInt) QuickCheck Specs:"
  p1 <- auditPhysicsScaleTransformSpecProof
  if p1
     then putStrLn "   [PASSED] ScaleTransform Metric Quadrance Verified!"
     else do
       putStrLn "   [FAILED] QuickCheck Specs Failed!"
       exitWith (ExitFailure 1)
  putStrLn ""
  putStrLn "3. Physical Law Functor & Category-Theoretic Homomorphism Specs:"
  p2 <- auditLawHomomorphismSpecProof
  if p2
     then putStrLn "   [PASSED] Physical Law Functor Category Laws Verified!"
     else do
       putStrLn "   [FAILED] Functor Category Laws Failed!"
       exitWith (ExitFailure 1)
  putStrLn ""
  putStrLn "4. Quad-Stream Physical Law Passband & Free Energy Specs:"
  p3 <- auditQuadStreamPhysicalLawsProof
  if p3
     then putStrLn "   [PASSED] Quad-Stream Physical Law Passband & Free Energy Specs Verified!"
     else do
       putStrLn "   [FAILED] Quad-Stream Physical Law Specs Failed!"
       exitWith (ExitFailure 1)
  putStrLn ""
  putStrLn "5. Deforested Density Matrix & Relativistic Spinor Metric Stream Specs:"
  p4 <- auditDensityStreamSpecProof
  if p4
     then putStrLn "   [PASSED] Deforested Density Matrix & Relativistic Spinor Stream Specs Verified!"
     else do
       putStrLn "   [FAILED] Deforested Density & Spinor Stream Specs Failed!"
       exitWith (ExitFailure 1)
  putStrLn "========================================================"
  putStrLn "  PHYSICS WIKI VERIFICATION COMPLETE: ALL PASSED!"
  putStrLn "========================================================"
