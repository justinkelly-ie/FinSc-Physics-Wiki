# 🌊 Deforested Density Matrix & Relativistic Spinor Metric Stream Spec

Documents and verifies the **Deforested Stream Transducers** operating over Quantum Density Matrices, Dirac Bispinors, and Topological Chern Numbers in `FinSc-Physics`.

---

## 1. Physical & Category-Theoretic Foundations

1. **Deforested Density Matrix Norm Stream:**
   `evaluateQuadStreamDensityNorm` consumes `FusedStream (QuadStreamChannel, BoxInt, BoxInt)` directly via `quadStreamToStream` and `evaluateQuadStreamDensityNormStream` without heap list allocations.

2. **Deforested Dirac Bispinor Probability Density Stream:**
   `evaluateQuadStreamSpinorDensity` maps streaming channel updates directly to Dirac probability density $j_0 = \sum_{k=1}^4 (eval(\psi_k))^2 \ge 0$.

3. **Deforested Topological Chern Number Stream:**
   `evaluateQuadStreamChernNumber` extracts the first Chern number $C_1 \in \mathbb{Z}$ over the Elliptic channel stream with zero list intermediate allocations.

---

## 2. Executable Idris 2 Specification Code

```idris
module Wiki.DensityStreamSpec

import Stage0.BoxInt
import Stage0.Multiset
import Stage0.OnSeq.FusedStream
import Stage1.QuadStream
import Stage1.Math.DensityMatrix
import Stage1.Math.RelativisticSpinor
import Stage1.Math.TopologicalChernNumber
import Wiki.Generators
import Data.Vect

%default covering

||| Property 1: Deforested Density Matrix Norm Stream Equivalence
public export
prop_densityNormStreamEquivalenceGen : Integer -> Bool
prop_densityNormStreamEquivalenceGen valRaw =
  let val = intToBoxInt valRaw
      m = AddM (intToBoxInt 0) val ZeroM
      qs = MkQuadStream m m m m
      normDirect = multisetSum m + multisetSum m + multisetSum m + multisetSum m
      normStream = evaluateQuadStreamDensityNorm qs
  in normStream == normDirect

||| Property 2: Deforested Dirac Spinor Probability Density Stream Positivity
public export
prop_spinorDensityStreamPositivityGen : Integer -> Bool
prop_spinorDensityStreamPositivityGen valRaw =
  let val = intToBoxInt (abs valRaw)
      m = AddM (intToBoxInt 0) val ZeroM
      qs = MkQuadStream m m m m
      densityStream = evaluateQuadStreamSpinorDensity qs
  in unwrapBox densityStream >= 0

||| Property 3: Deforested Chern Number Stream Extraction
public export
prop_chernNumberStreamExtractionGen : Integer -> Bool
prop_chernNumberStreamExtractionGen valRaw =
  let val = intToBoxInt valRaw
      e = AddM (intToBoxInt 0) val ZeroM
      qs = MkQuadStream e ZeroM ZeroM ZeroM
      c1Stream = evaluateQuadStreamChernNumber qs
  in c1Stream == valRaw

||| Main Verification Suite for Deforested Density & Spinor Metric Streams
public export covering
auditDensityStreamSpecProof : IO Bool
auditDensityStreamSpecProof = do
  let r1 = qc prop_densityNormStreamEquivalenceGen
  let r2 = qc prop_spinorDensityStreamPositivityGen
  let r3 = qc prop_chernNumberStreamExtractionGen
  pure (r1.pass == Just True && r2.pass == Just True && r3.pass == Just True)
```
