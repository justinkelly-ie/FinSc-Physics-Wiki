# 📐 Dynamic Pythagorean Triads, Spread Maxels & Non-Destructive Pixel Multiplication Spec

Documents and verifies the mathematical generalization of the **Pythagorean Triad** from the fixed $(4, 3) \to (25, 7, 24)$ coordinate to dynamic parameterized pairs $(x, y)$, establishing:
1. The **Wildberger Chromogeometric Triad Identity**: $Q_{\text{Red}}^2 + Q_{\text{Green}}^2 = Q_{\text{Blue}}^2$ holds for all integer coordinates $(x, y)$.
2. The **Spread Diagonal Theorem**: In companion spread transfer Maxels $M(s) = \begin{pmatrix} 2 - 4s & -1 \\ 1 & 0 \end{pmatrix}$, the diagonal weight $2 - 4s$ is identically twice the ratio of Hyperbolic (Red) to Elliptic (Blue) quadrance:
   $$2 - 4s = 2 \cdot \frac{Q_{\text{Red}}}{Q_{\text{Blue}}}$$
3. **Discrete Basis Contraction & Non-Destruction**:
   - Matrix basis: $[A, B] \cdot [C, D] = [A, D]$ iff $B = C$ (annihilated otherwise).
   - Vector basis: $[A, B] \cdot [C] = [A]$ iff $B = C$.
   - Diagonal pixels $[A, A]$ acting on $[A]$ produce $[A]$ (preserving coordinate $A$ without destruction or coordinate drift).
   - Off-diagonal pixels $[A, B]$ ($A \neq B$) induce coordinate transitions $B \mapsto A$ or annihilation when mismatched.

---

## Executable Idris 2 Specification Code

```idris
module Wiki.DynamicPythagoreanSpreadSpec

import Stage0.BoxInt
import Stage0.Multiset
import Stage1.Basis.Coordinate
import Stage1.RationalTrig
import Stage1.Multiset.PrimordialUnfolding
import Wiki.Generators
import Data.List

%default total

||| Clamps an Integer into a positive BoxInt bound [1, maxVal].
public export
clampPositive : Integer -> Integer -> BoxInt
clampPositive n maxVal =
  let pos = if n <= 0 then 1 - n else n
      bounded = 1 + (pos `mod` maxVal)
  in intToBoxInt bounded

||| Clamps an Integer into a positive Nat bound [1, maxVal].
public export
clampPositiveNat : Integer -> Integer -> Nat
clampPositiveNat n maxVal =
  let b = clampPositive n maxVal
  in integerToNat (unwrapBox b)

||| Computes exact Wildberger chromogeometric quadrance for dynamic coordinates (x, y):
||| - Q_Blue  = x^2 + y^2  (Elliptic bound-state canvas)
||| - Q_Red   = x^2 - y^2  (Hyperbolic lightcone phase)
||| - Q_Green = 2 * x * y  (Parabolic shear transport)
public export
dynamicTriad : BoxInt -> BoxInt -> TriadQuadrance
dynamicTriad x y = pythagoreanFixedPoint x y

------------------------------------------------------------------------
-- QUICKCHECK PROPERTY SUITES
------------------------------------------------------------------------

||| Property 1 (Generative QuickCheck): Universal Pythagorean Triad Invariance
||| For all positive coordinates (x, y), Q_Red^2 + Q_Green^2 == Q_Blue^2.
public export
prop_dynamicPythagoreanTriadGen : (Integer, Integer) -> Bool
prop_dynamicPythagoreanTriadGen (xRaw, yRaw) =
  let x = clampPositive xRaw 100
      y = clampPositive yRaw 100
      t = dynamicTriad x y
      lhs = mulBox t.blueQ t.blueQ
      rhs = addBox (mulBox t.redQ t.redQ) (mulBox t.greenQ t.greenQ)
  in boxEq lhs rhs

||| Property 2 (Generative QuickCheck): Spread Diagonal Chromogeometric Ratio Identity
||| The diagonal entry 2 - 4s scaled by Q_Blue identically equals 2 * Q_Red:
||| (2 * Q_Blue - 4 * y^2) == 2 * Q_Red.
public export
prop_spreadDiagonalChromogeometricRatioGen : (Integer, Integer) -> Bool
prop_spreadDiagonalChromogeometricRatioGen (xRaw, yRaw) =
  let x = clampPositive xRaw 100
      y = clampPositive yRaw 100
      qBlue = (x * x) + (y * y)
      qRed  = (x * x) - (y * y)
      lhs = (intToBoxInt 2 * qBlue) - (intToBoxInt 4 * (y * y))
      rhs = intToBoxInt 2 * qRed
  in boxEq lhs rhs

||| Property 3 (Generative QuickCheck): Discrete Pixel Basis Multiplication Contraction
||| [A, B] * [C, D] = [A, D] iff B == C, and Nothing otherwise.
public export
prop_pixelBasisMultiplicationContractibilityGen : (Integer, Integer) -> (Integer, Integer) -> Bool
prop_pixelBasisMultiplicationContractibilityGen (aRaw, bRaw) (cRaw, dRaw) =
  let a = clampPositiveNat aRaw 20
      b = clampPositiveNat bRaw 20
      c = clampPositiveNat cRaw 20
      d = clampPositiveNat dRaw 20
      p1 = MkPixel a b
      p2 = MkPixel c d
      expected = if b == c then Just (MkPixel a d) else Nothing
  in mulPixel p1 p2 == expected

||| Property 4 (Generative QuickCheck): Diagonal Maxels Preserve Vexel Coordinates
||| For any diagonal Maxel M_diag = w1 [1, 1] + w2 [2, 2], acting on Vexel v = v1 [1] + v2 [2]
||| preserves the coordinate basis without destruction or cross-coordinate drift:
||| coordinate 1 maps to coordinate 1 (scaled by w1), and 2 maps to 2 (scaled by w2).
public export
prop_diagonalMaxelPreservesVexelSupportGen : (Integer, Integer) -> (Integer, Integer) -> Bool
prop_diagonalMaxelPreservesVexelSupportGen (w1Raw, w2Raw) (v1Raw, v2Raw) =
  let w1 = intToBoxInt (if w1Raw == 0 then 1 else w1Raw)
      w2 = intToBoxInt (if w2Raw == 0 then 1 else w2Raw)
      v1 = intToBoxInt (if v1Raw == 0 then 1 else v1Raw)
      v2 = intToBoxInt (if v2Raw == 0 then 1 else v2Raw)
      mDiag = singletonCell (MkPixel 1 1) w1 <+> singletonCell (MkPixel 2 2) w2
      vIn = singletonCell (MkUnixel 1) v1 <+> singletonCell (MkUnixel 2) v2
      vOut = canonicalizeCell (actMaxelVexel mDiag vIn)
      out1 = lookupCellMultiset (MkUnixel 1) vOut
      out2 = lookupCellMultiset (MkUnixel 2) vOut
  in boxEq out1 (w1 * v1) && boxEq out2 (w2 * v2)

||| Property 5 (Generative QuickCheck): Off-Diagonal Maxels Induce Pure Coordinate Transitions
||| Green metric Maxel [1, 2] + [2, 1] acting on pure state [1] yields pure state [2],
||| completely destroying coordinate 1.
public export
prop_offDiagonalMaxelTransitionsOrDestroysGen : Integer -> Bool
prop_offDiagonalMaxelTransitionsOrDestroysGen vRaw =
  let vWeight = intToBoxInt (if vRaw == 0 then 1 else vRaw)
      vState1 = singletonCell (MkUnixel 1) vWeight
      vOut = canonicalizeCell (actMaxelVexel greenMetricMaxel2D vState1)
      out1 = lookupCellMultiset (MkUnixel 1) vOut
      out2 = lookupCellMultiset (MkUnixel 2) vOut
  in boxEq out1 (intToBoxInt 0) && boxEq out2 vWeight

||| Property 6 (Generative QuickCheck): Dynamic Pythagorean Spread Maxel Recurrence Action
||| Acting with pythagoreanSpreadMaxel x y on pure basis state [1] preserves coordinate 1
||| with exact weight (2 * Q_Red * v1) and transitions to coordinate 2 with weight (Q_Blue * v1).
public export
prop_pythagoreanSpreadMaxelActionGen : (Integer, Integer) -> Integer -> Bool
prop_pythagoreanSpreadMaxelActionGen (xRaw, yRaw) vRaw =
  let x = clampPositive xRaw 50
      y = clampPositive yRaw 50
      v1 = intToBoxInt (if vRaw == 0 then 1 else vRaw)
      qBlue = (x * x) + (y * y)
      qRed  = (x * x) - (y * y)
      mSpread = pythagoreanSpreadMaxel x y
      vIn = singletonCell (MkUnixel 1) v1
      vOut = canonicalizeCell (actMaxelVexel mSpread vIn)
      persistedWeight = lookupCellMultiset (MkUnixel 1) vOut
      transitionWeight = lookupCellMultiset (MkUnixel 2) vOut
      expectedPersisted = (intToBoxInt 2 * qRed) * v1
      expectedTransition = qBlue * v1
  in boxEq persistedWeight expectedPersisted && boxEq transitionWeight expectedTransition

------------------------------------------------------------------------
-- MAIN SPECIFICATION VERIFICATION RUNNER
------------------------------------------------------------------------

||| Main verification runner for Dynamic Pythagorean Triads & Spread Maxels.
public export
auditDynamicPythagoreanSpreadSpecProof : IO Bool
auditDynamicPythagoreanSpreadSpecProof = do
  let r1 = qc prop_dynamicPythagoreanTriadGen
  let r2 = qc prop_spreadDiagonalChromogeometricRatioGen
  let r3 = qc2 prop_pixelBasisMultiplicationContractibilityGen
  let r4 = qc2 prop_diagonalMaxelPreservesVexelSupportGen
  let r5 = qc prop_offDiagonalMaxelTransitionsOrDestroysGen
  let r6 = qc2 prop_pythagoreanSpreadMaxelActionGen
  pure ( r1.pass == Just True
      && r2.pass == Just True
      && r3.pass == Just True
      && r4.pass == Just True
      && r5.pass == Just True
      && r6.pass == Just True
       )
```
