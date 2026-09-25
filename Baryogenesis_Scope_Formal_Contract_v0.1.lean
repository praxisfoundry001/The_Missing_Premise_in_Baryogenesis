/-
BARYOGENESIS SCOPE FORMAL CONTRACT v0.1
Lean 4 append contract for Structural_Flow_Universal_Kernel_v1.0.lean

Execution model
---------------
Paste / append this COMPLETE contract immediately after the final:

  end StructuralFlow

of the compatible Structural Flow Universal Kernel.

Purpose
-------
Machine-check the scoped logical claim that a generation-from-zero baryogenesis
burden is licensed only where the relevant zero antecedent is independently
established at the same declared scope.

The contract does NOT claim:
  * that this universe began with zero baryon asymmetry;
  * that this universe began with nonzero baryon asymmetry;
  * that baryogenesis did or did not occur;
  * that any particular baryogenesis mechanism is physically correct;
  * that inflation, reheating, washout, freeze-out, CP violation, or any other
    physical mechanism has been empirically adjudicated here;
  * that Structural Flow selects the sign or magnitude of the baryon asymmetry;
  * that a counterexample history encoded below is the actual history of this
    universe;
  * that machine closure establishes empirical truth;
  * that defeating universal zero across admissible histories proves the actual
    early-universe antecedent was nonzero.

Positive semantic target
------------------------
  same-scope zero established
  + observed nonzero asymmetry
  -> generation-from-zero burden live at that scope.

A model-local zero does not silently promote to universal zero across the declared admissible history space.
Universal promotion requires a separately supplied scope-extension warrant.

Falsifier
---------
A single physically admissible relevant history lacking the required zero
antecedent defeats a UNIVERSAL-zero claim over the declared admissible history
space. This is a falsifier of the universalized object, not a claim that the
witness history is actual.
-/

namespace StructuralFlow
namespace BaryogenesisScopeContract

open UniversalTranslationContract

universe u

/-! ==========================================================================
0. ACTUAL-HISTORY FIREWALL
============================================================================ -/

/-
This contract targets the UNIVERSALIZATION claim across the declared physically
admissible history space. It does not identify the actual early history.

A counterexample history can refute:

  every admissible relevant history has a zero antecedent

without establishing:

  the actual history of this universe had a nonzero antecedent.

A future independent empirical or theoretical warrant about the ACTUAL history
would be a distinct domain claim.
-/

/-! ==========================================================================
1. HISTORY-SPACE CORE
============================================================================ -/

/--
A declared relevant early-universe history space.

`admissible` and `zeroAntecedent` are domain-owned predicates. Lean does not
empirically decide either one.
-/
structure HistorySpace where
  History : Type u
  admissible : History -> Prop
  zeroAntecedent : History -> Prop

/--
Universal-zero claim over the declared admissible history space.
Every admitted relevant history carries the required effective zero antecedent.
-/
def UniversalZeroAcrossAdmissibleHistories (H : HistorySpace) : Prop :=
  ∀ h : H.History, H.admissible h → H.zeroAntecedent h

/--
Counterexample witness against universal zero across the declared admissible history space.
One admitted relevant history lacks the required zero antecedent.
-/
def UniversalZeroCounterexample (H : HistorySpace) : Prop :=
  ∃ h : H.History, H.admissible h ∧ ¬ H.zeroAntecedent h

/--
Explicit falsifier theorem.
One admissible nonzero-antecedent witness defeats the universal-zero claim.
-/
theorem counterexample_falsifies_universal_zero
    (H : HistorySpace)
    (hCounter : UniversalZeroCounterexample H) :
    ¬ UniversalZeroAcrossAdmissibleHistories H := by
  intro hUniversal
  rcases hCounter with ⟨h, hAdmissible, hNotZero⟩
  exact hNotZero (hUniversal h hAdmissible)

/-! ==========================================================================
2. GENERATION-FROM-ZERO BURDENS
============================================================================ -/

/--
A model- or otherwise restricted-scope generation-from-zero burden.
The observed nonzero fact and the scoped zero antecedent are both explicit.
-/
def ScopedGenerationFromZeroBurden
    (observedNonzero scopedZeroEstablished : Prop) : Prop :=
  observedNonzero ∧ scopedZeroEstablished

/--
Universalized generation-from-zero burden.
The zero antecedent is the all-admissible-history claim, not a model-local
surrogate.
-/
def UniversalizedGenerationFromZeroBurden
    (observedNonzero : Prop)
    (H : HistorySpace) : Prop :=
  observedNonzero ∧ UniversalZeroAcrossAdmissibleHistories H

/-- Positive theorem: same-scope established zero plus observation activates
    the universalized generation-from-zero burden. -/
theorem universal_zero_and_observation_activate_burden
    (observedNonzero : Prop)
    (H : HistorySpace)
    (hObserved : observedNonzero)
    (hZero : UniversalZeroAcrossAdmissibleHistories H) :
    UniversalizedGenerationFromZeroBurden observedNonzero H := by
  exact ⟨hObserved, hZero⟩

/-- The universalized burden cannot be live without universal zero across the declared admissible history space. -/
theorem universe_burden_requires_universal_zero
    (observedNonzero : Prop)
    (H : HistorySpace)
    (hBurden : UniversalizedGenerationFromZeroBurden observedNonzero H) :
    UniversalZeroAcrossAdmissibleHistories H := by
  exact hBurden.2

/-- The universalized burden also requires the observed nonzero datum. -/
theorem universe_burden_requires_observed_nonzero
    (observedNonzero : Prop)
    (H : HistorySpace)
    (hBurden : UniversalizedGenerationFromZeroBurden observedNonzero H) :
    observedNonzero := by
  exact hBurden.1

/-! ==========================================================================
3. SCOPE-EXTENSION BRIDGE
============================================================================ -/

/--
A scope-extension warrant is explicit structure.
It is the missing bridge from a restricted/model-local zero antecedent to universal zero across the declared admissible history space.
-/
structure ScopeExtensionWarrant
    (scopedZeroEstablished : Prop)
    (H : HistorySpace) where
  promote : scopedZeroEstablished -> UniversalZeroAcrossAdmissibleHistories H

/--
Positive promotion theorem.
A scoped generation-from-zero burden can be promoted to universalized scope only
when an explicit scope-extension warrant is supplied.
-/
theorem scoped_burden_promotes_with_explicit_warrant
    (observedNonzero scopedZeroEstablished : Prop)
    (H : HistorySpace)
    (hScoped :
      ScopedGenerationFromZeroBurden
        observedNonzero
        scopedZeroEstablished)
    (bridge : ScopeExtensionWarrant scopedZeroEstablished H) :
    UniversalizedGenerationFromZeroBurden observedNonzero H := by
  exact ⟨hScoped.1, bridge.promote hScoped.2⟩

/-! ==========================================================================
4. NON-PROMOTION COUNTERMODEL
============================================================================ -/

/-- Finite history space used only to prove logical non-promotion. -/
inductive DemoHistory where
  | zeroLike
  | nonzeroLike
  deriving DecidableEq, Repr

/--
Both histories are admitted; one lacks the zero antecedent.
This is a logic witness, not an empirical cosmology claim.
-/
def demoHistorySpace : HistorySpace where
  History := DemoHistory
  admissible := fun _ => True
  zeroAntecedent := fun h =>
    match h with
    | DemoHistory.zeroLike => True
    | DemoHistory.nonzeroLike => False

/-- The demo history space contains the universal-zero falsifier witness. -/
theorem demo_has_universal_zero_counterexample :
    UniversalZeroCounterexample demoHistorySpace := by
  refine ⟨DemoHistory.nonzeroLike, ?_, ?_⟩
  · trivial
  · simp [demoHistorySpace]

/-- Therefore universal zero across the declared admissible history space fails in the demo history space. -/
theorem demo_not_universal_zero :
    ¬ UniversalZeroAcrossAdmissibleHistories demoHistorySpace := by
  exact
    counterexample_falsifies_universal_zero
      demoHistorySpace
      demo_has_universal_zero_counterexample

/--
A model-local zero and observed nonzero can jointly activate a scoped burden.
-/
theorem demo_scoped_burden_live :
    ScopedGenerationFromZeroBurden True True := by
  exact ⟨trivial, trivial⟩

/--
The same data do not activate a universalized burden when the universal zero across the declared admissible history space claim fails.
-/
theorem demo_universalized_burden_not_live :
    ¬ UniversalizedGenerationFromZeroBurden True demoHistorySpace := by
  intro hBurden
  exact demo_not_universal_zero hBurden.2

/--
Formal non-promotion witness:
a scoped generation-from-zero burden can be live while the universalized
burden is not live.
-/
theorem scoped_burden_does_not_by_itself_promote :
    ScopedGenerationFromZeroBurden True True
    ∧ ¬ UniversalizedGenerationFromZeroBurden True demoHistorySpace := by
  exact ⟨demo_scoped_burden_live, demo_universalized_burden_not_live⟩

/--
Observation of nonzero alone does not establish universal zero across the declared admissible history space.
The demo gives a concrete model in which the observation-side proposition is
true while universal zero across admissible histories is false.
-/
theorem observed_nonzero_does_not_by_itself_establish_universal_zero :
    True ∧ ¬ UniversalZeroAcrossAdmissibleHistories demoHistorySpace := by
  exact ⟨trivial, demo_not_universal_zero⟩

/-! ==========================================================================
5. EXPLICIT FALSIFIER AGAINST THE UNIVERSALIZED BURDEN
============================================================================ -/

/--
The falsifier is named explicitly so later empirical/theorem work has a single
machine target.
-/
def UniversalizedBaryogenesisFalsifier (H : HistorySpace) : Prop :=
  UniversalZeroCounterexample H

/--
If the falsifier is discharged, the universalized generation-from-zero burden
is unavailable, even if the observed nonzero fact is retained.
-/
theorem falsifier_blocks_universalized_generation_burden
    (observedNonzero : Prop)
    (H : HistorySpace)
    (hFalsifier : UniversalizedBaryogenesisFalsifier H) :
    ¬ UniversalizedGenerationFromZeroBurden observedNonzero H := by
  intro hBurden
  exact
    (counterexample_falsifies_universal_zero H hFalsifier)
      hBurden.2

/--
Reopening theorem.
If domain physics establishes universal zero across the full declared admitted
history space, then with observed nonzero the universalized burden becomes
live. Lean checks only the implication.
-/
theorem universal_zero_reopens_universe_burden
    (observedNonzero : Prop)
    (H : HistorySpace)
    (hObserved : observedNonzero)
    (hEveryAdmissibleZero :
      ∀ h : H.History,
        H.admissible h → H.zeroAntecedent h) :
    UniversalizedGenerationFromZeroBurden observedNonzero H := by
  exact
    universal_zero_and_observation_activate_burden
      observedNonzero
      H
      hObserved
      hEveryAdmissibleZero

/-! ==========================================================================
6. UNIVERSAL-TRANSLATION ADAPTER
============================================================================ -/

/--
Object-specific structural burdens for the scope contract.
These are formal contract burdens, not new universal SF objects.
-/
inductive ObjectBurden where
  | antecedentScopePin
  | noSilentPromotion
  | observationAntecedentFirewall
  | falsifierRegistered
  deriving DecidableEq, Repr

/--
Domain burdens.
`observedNonzero` is an entry burden for this contract.
`universalZeroCoverage` remains downstream empirical/theorem work.
-/
inductive DomainBurden where
  | observedNonzero
  | universalZeroCoverage
  deriving DecidableEq, Repr

/-- All universal core translation burdens are discharged for the adapter. -/
def coreState : CoreBurden -> Disposition :=
  fun _ => Disposition.discharged

/-- All object-specific logical burdens are discharged by the contract above. -/
def objectRequired : ObjectBurden -> Prop :=
  fun _ => True

def objectState : ObjectBurden -> Disposition :=
  fun _ => Disposition.discharged

/-- Observation is an entry burden; universal-zero adjudication is downstream. -/
def domainEntryRequired : DomainBurden -> Prop
  | DomainBurden.observedNonzero => True
  | DomainBurden.universalZeroCoverage => False

def domainDownstreamRequired : DomainBurden -> Prop
  | DomainBurden.observedNonzero => False
  | DomainBurden.universalZeroCoverage => True

theorem domain_roles_disjoint :
    ∀ b : DomainBurden,
      ¬ (domainEntryRequired b ∧ domainDownstreamRequired b) := by
  intro b
  cases b <;>
    simp [domainEntryRequired, domainDownstreamRequired]

/--
Current adjudication posture:
  observed nonzero = DISCHARGED
  universal zero across the declared admissible history space = OPEN
-/
def currentDomainState : DomainBurden -> Disposition
  | DomainBurden.observedNonzero => Disposition.discharged
  | DomainBurden.universalZeroCoverage => Disposition.open

/--
Future falsifier posture:
  observed nonzero remains DISCHARGED
  universal-zero coverage adjudication becomes VIOLATED
-/
def falsifiedDomainState : DomainBurden -> Disposition
  | DomainBurden.observedNonzero => Disposition.discharged
  | DomainBurden.universalZeroCoverage => Disposition.violated

/--
Future reopening posture:
  observed nonzero remains DISCHARGED
  universal-zero coverage adjudication becomes DISCHARGED
-/
def reopenedDomainState : DomainBurden -> Disposition
  | DomainBurden.observedNonzero => Disposition.discharged
  | DomainBurden.universalZeroCoverage => Disposition.discharged

/-- Minimal bookkeeping evidence for declared machine disposition. -/
def stateEvidence
    {B : Type u}
    (state : B -> Disposition)
    (b : B)
    (d : Disposition) : Prop :=
  d = state b

/-- Current structurally closed / empirically open adapter world. -/
def currentWorld : World ObjectBurden DomainBurden where
  coreState := coreState
  coreEvidence := stateEvidence coreState
  coreWarrant := by intro b; rfl
  objectRequired := objectRequired
  objectState := objectState
  objectEvidence := stateEvidence objectState
  objectWarrant := by intro b _hRequired; rfl
  domainEntryRequired := domainEntryRequired
  domainDownstreamRequired := domainDownstreamRequired
  domainRoleDisjoint := domain_roles_disjoint
  domainState := currentDomainState
  domainEvidence := stateEvidence currentDomainState
  domainWarrant := by intro b _hRequired; rfl

/-- Falsifier world: structural contract survives; universal-zero seat is negative. -/
def falsifiedWorld : World ObjectBurden DomainBurden :=
  { currentWorld with
      domainState := falsifiedDomainState
      domainEvidence := stateEvidence falsifiedDomainState
      domainWarrant := by intro b _hRequired; rfl }

/-- Reopened world: structural contract survives; universal-zero seat is closed. -/
def reopenedWorld : World ObjectBurden DomainBurden :=
  { currentWorld with
      domainState := reopenedDomainState
      domainEvidence := stateEvidence reopenedDomainState
      domainWarrant := by intro b _hRequired; rfl }

/-- Current adapter satisfies all structural gating burdens. -/
theorem current_world_structural_conforms :
    StructuralConforms currentWorld := by
  refine ⟨?_, ?_, ?_⟩
  · intro c
    rfl
  · intro o _hRequired
    rfl
  · intro d hRequired
    cases d with
    | observedNonzero => rfl
    | universalZeroCoverage =>
        change domainEntryRequired DomainBurden.universalZeroCoverage at hRequired
        simp [domainEntryRequired] at hRequired

/-- Current universal-zero empirical/theorem seat remains OPEN. -/
theorem current_world_universal_zero_open :
    DomainBurdenOpen currentWorld := by
  exact
    ⟨DomainBurden.universalZeroCoverage,
     by simp
       [currentWorld,
        domainDownstreamRequired],
     by simp
       [currentWorld,
        currentDomainState]⟩

/-- The falsifier does not damage structural conformance. -/
theorem falsified_world_structural_conforms :
    StructuralConforms falsifiedWorld := by
  refine ⟨?_, ?_, ?_⟩
  · intro c
    rfl
  · intro o _hRequired
    rfl
  · intro d hRequired
    cases d with
    | observedNonzero => rfl
    | universalZeroCoverage =>
        change domainEntryRequired DomainBurden.universalZeroCoverage at hRequired
        simp [domainEntryRequired] at hRequired

/--
Machine-visible falsifier disposition:
the universal-zero downstream seat returns a negative domain outcome.
-/
theorem falsified_world_domain_negative :
    DomainOutcomeNegative falsifiedWorld := by
  exact
    ⟨DomainBurden.universalZeroCoverage,
     by simp
       [falsifiedWorld,
        currentWorld,
        domainDownstreamRequired],
     by simp
       [falsifiedWorld,
        falsifiedDomainState]⟩

/-- Reopening does not damage structural conformance. -/
theorem reopened_world_structural_conforms :
    StructuralConforms reopenedWorld := by
  refine ⟨?_, ?_, ?_⟩
  · intro c
    rfl
  · intro o _hRequired
    rfl
  · intro d hRequired
    cases d with
    | observedNonzero => rfl
    | universalZeroCoverage =>
        change domainEntryRequired DomainBurden.universalZeroCoverage at hRequired
        simp [domainEntryRequired] at hRequired

/--
If physics/theorem work discharges universal zero across the declared admissible history space, all downstream domain
burdens in this contract are closed.
-/
theorem reopened_world_domain_closed :
    DomainBurdensClosed reopenedWorld := by
  intro d hRequired
  cases d with
  | observedNonzero =>
      change domainDownstreamRequired DomainBurden.observedNonzero at hRequired
      simp [domainDownstreamRequired] at hRequired
  | universalZeroCoverage => rfl

/-! ==========================================================================
7. NON-GUARANTEE / NON-OUTPUT FIREWALLS
============================================================================ -/

/-- Candidate outputs that the scope contract must not select. -/
inductive CandidateOutput where
  | actualInitialZero
  | actualInitialNonzero
  | matterSignSelected
  | antimatterSignSelected
  | specificBaryogenesisMechanism
  | standardModelSuffices
  | newPhysicsRequired
  deriving DecidableEq, Repr

/--
A structurally closed scope contract can coexist with every candidate physical
output being false. Therefore machine closure does not select any of them.
-/
def noFreeOutput : CandidateOutput -> Prop :=
  fun _ => False

theorem structural_closure_has_no_free_physical_output :
    StructuralConforms currentWorld
    ∧ (∀ o : CandidateOutput, ¬ noFreeOutput o) := by
  constructor
  · exact current_world_structural_conforms
  · intro o
    simp [noFreeOutput]

/-! ==========================================================================
8. PUBLIC CHECKPOINT
============================================================================ -/

/--
Public machine checkpoint for this domain contract.

It records:
  * positive same-scope burden logic;
  * explicit bridge requirement for scope promotion;
  * a concrete non-promotion witness;
  * an explicit universal-zero falsifier;
  * current STRUCTURAL CONFORMS with downstream universal-zero OPEN;
  * falsifier world -> downstream NEGATIVE;
  * reopening world -> downstream CLOSED;
  * no free physical-output selection.
-/
theorem baryogenesis_scope_contract_checkpoint :
    StructuralConforms currentWorld
    ∧ DomainBurdenOpen currentWorld
    ∧ StructuralConforms falsifiedWorld
    ∧ DomainOutcomeNegative falsifiedWorld
    ∧ StructuralConforms reopenedWorld
    ∧ DomainBurdensClosed reopenedWorld
    ∧ ScopedGenerationFromZeroBurden True True
    ∧ ¬ UniversalizedGenerationFromZeroBurden True demoHistorySpace := by
  exact
    ⟨current_world_structural_conforms,
     current_world_universal_zero_open,
     falsified_world_structural_conforms,
     falsified_world_domain_negative,
     reopened_world_structural_conforms,
     reopened_world_domain_closed,
     demo_scoped_burden_live,
     demo_universalized_burden_not_live⟩

end BaryogenesisScopeContract
end StructuralFlow
