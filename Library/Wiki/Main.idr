module Wiki.Main

import System
import Core
import ActionDynamics
import Wiki.PhysicsScaleTransformSpec
import Wiki.LawHomomorphismSpec
import Wiki.QuadStreamPhysicalLawsSpec
import Wiki.DensityStreamSpec
import Wiki.DynamicPythagoreanSpreadSpec
import Reflect.ActionAuditor
import Language.Reflection

%default total

||| Compile-time macro invariant witnesses (Rule 01)
0 prfAuditGeodesicLeastAction : Reflect.ActionAuditor.auditGeodesicLeastActionProof = True
prfAuditGeodesicLeastAction = auditGeodesicLeastAction

0 prfAuditNoetherConservation : Reflect.ActionAuditor.auditNoetherConservationProof = True
prfAuditNoetherConservation = auditNoetherConservation

0 prfAuditCausalActionAsymmetry : Reflect.ActionAuditor.auditCausalActionAsymmetryProof = True
prfAuditCausalActionAsymmetry = auditCausalActionAsymmetry

0 prfAuditPipelineQuadStreamLedger : Reflect.ActionAuditor.auditPipelineQuadStreamLedgerProofExport = True
prfAuditPipelineQuadStreamLedger = auditPipelineQuadStreamLedger

0 prfAuditComposableLawAssociativity : Reflect.ActionAuditor.auditComposableLawAssociativityProofExport = True
prfAuditComposableLawAssociativity = auditComposableLawAssociativity

0 prfAuditStreamingCrooks : Reflect.ActionAuditor.auditStreamingCrooksProofExport = True
prfAuditStreamingCrooks = auditStreamingCrooks

0 prfAuditSpinorDensityPositivity : Reflect.ActionAuditor.auditSpinorDensityPositivityProofExport = True
prfAuditSpinorDensityPositivity = auditSpinorDensityPositivity

0 prfAuditBornRuleRationalNormalization : Reflect.ActionAuditor.auditBornRuleRationalNormalizationProofExport = True
prfAuditBornRuleRationalNormalization = auditBornRuleRationalNormalization

0 prfAuditSymplecticFreeParticle : Reflect.ActionAuditor.auditSymplecticFreeParticleProofExport = True
prfAuditSymplecticFreeParticle = auditSymplecticFreeParticle

0 prfAuditDeforestedQuadStreamPipeline : Reflect.ActionAuditor.auditDeforestedQuadStreamPipelineProofExport = True
prfAuditDeforestedQuadStreamPipeline = auditDeforestedQuadStreamPipeline

0 prfAuditCompositeCosmicBaryonConservation : Reflect.ActionAuditor.auditCompositeCosmicBaryonConservationProofExport = True
prfAuditCompositeCosmicBaryonConservation = auditCompositeCosmicBaryonConservation

main : IO ()
main = do
  putStrLn "========================================================"
  putStrLn "  IDRIS 2 PHYSICS WIKI VERIFICATION SUITE"
  putStrLn "========================================================"
  putStrLn "0. Compile-Time Elaborator Reflection Audits (Rule 01):"
  putStrLn "   - Geodesic Least Action Optimality: INJECTED & VALID (Refl) ✅"
  putStrLn "   - Noether Momentum Conservation: INJECTED & VALID (Refl) ✅"
  putStrLn "   - Causal Action Arrow Asymmetry: INJECTED & VALID (Refl) ✅"
  putStrLn "   - Quad-Stream Multi-Law Ledger: INJECTED & VALID (Refl) ✅"
  putStrLn "   - Composable Law Transducer Associativity: INJECTED & VALID (Refl) ✅"
  putStrLn "   - Streaming Crooks Fluctuation: INJECTED & VALID (Refl) ✅"
  putStrLn "   - Spinor Probability Density Positivity: INJECTED & VALID (Refl) ✅"
  putStrLn "   - Born Rule Rational Normalization: INJECTED & VALID (Refl) ✅"
  putStrLn "   - Discrete Symplectic Leapfrog Linear State Transduction: INJECTED & VALID (Refl) ✅"
  putStrLn "   - Deforested Quad-Stream Pipeline Primorial 210 Budget: INJECTED & VALID (Refl) ✅"
  putStrLn "   - Multi-Epoch Cosmic Baryon Evolution & Conservation: INJECTED & VALID (Refl) ✅"

  putStrLn ""
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
  putStrLn ""
  putStrLn "6. Deforested Streaming Partition Functions & Cosmic Sector Scaled Sums:"
  if auditStreamPartitionEquivalenceProof
     then putStrLn "   [PASSED] Deforested StreamPolynumber Partition Function Evaluation Verified!"
     else do
       putStrLn "   [FAILED] Streaming Partition Function Specs Failed!"
       exitWith (ExitFailure 1)
  putStrLn ""
  putStrLn "7. Dynamic Pythagorean Triads, Spread Maxels & Non-Destructive Pixel Basis Specs:"
  p5 <- auditDynamicPythagoreanSpreadSpecProof
  if p5
     then putStrLn "   [PASSED] Dynamic Pythagorean Triads & Spread Maxel Basis Verified!"
     else do
       putStrLn "   [FAILED] Dynamic Pythagorean Spread Specs Failed!"
       exitWith (ExitFailure 1)
  putStrLn "========================================================"
  putStrLn "  PHYSICS WIKI VERIFICATION COMPLETE: ALL PASSED!"
  putStrLn "========================================================"
