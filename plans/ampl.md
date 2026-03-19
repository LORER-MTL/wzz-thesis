# AMPL's Approach to Canonicalization and Matrix Stuffing

## Analysis of `ampl/mp`, `ampl/asl`, and the AMPL Ecosystem

**Summary for William's thesis chapter on canonicalization and matrix stuffing in optimization modeling languages**

---

## 1. Key Architectural Insight: AMPL Does Not Do "Matrix Stuffing" in the CVXPY/JuMP Sense

The most important finding is that **AMPL's architecture is fundamentally different from CVXPY and JuMP/MOI when it comes to the canonicalization step.** AMPL does not perform "matrix stuffing" — the construction of dense/sparse A, b, c matrices from a high-level problem representation — as a single monolithic transformation. Instead, AMPL uses a **multi-stage pipeline** with a fundamentally different intermediate representation:

1. **AMPL Translator** (proprietary, closed-source) → produces an **NL file**
2. **NL file** is consumed by a **solver driver** (either ASL-based or MP-based)
3. The solver driver either:
   - (ASL path) reads the NL file and provides the problem data via C callbacks
   - (MP path) reads the NL file, flattens expression trees, reformulates constraints, and feeds individual constraints one-by-one to the solver's native API

**There is no single "matrix stuffing" step where a complete A matrix is assembled.** Instead, constraints arrive at the solver API individually, and the solver itself accumulates them into its internal matrix representation.

---

## 2. The NL File Format: AMPL's Intermediate Representation

The NL file format (documented in David Gay's "Writing .nl Files", SAND2005-7907P) is the canonical IR between the AMPL translator and solvers. Key aspects:

### Structure
- **Header**: Problem statistics — number of variables, constraints, objectives, nonzero counts
- **Expression graphs**: Polish prefix notation for nonlinear parts of constraints/objectives
- **J segments**: Linear terms of constraints (sparse: variable index + coefficient pairs)
- **G segments**: Linear terms of objectives (sparse: variable index + coefficient pairs)
- **Defined variables (V segments)**: Named common subexpressions, split into linear + nonlinear parts

### How Linear Coefficients Are Stored
The NL file stores the **Jacobian sparsity** and linear coefficients in a constraint-by-constraint fashion via J segments:

```
J0 3          # Constraint 0 has 3 nonzero linear terms
2 3.0         # variable 2, coefficient 3.0
5 1.0         # variable 5, coefficient 1.0
6 -2.0        # variable 6, coefficient -2.0
```

The header also contains `k` segments with cumulative column counts to enable **column-ordered** sparse matrix reconstruction — this is the closest AMPL gets to "matrix stuffing" awareness:

> ".nl files contain extra information about the sparsity of constraints, to facilitate computing a Jacobian matrix stored columnwise, since many nonlinear solvers want to see Jacobians stored this way." — David Gay

### Key Observation for Your Thesis
The NL file already stores the constraint matrix in **coordinate (COO) sparse format** — row-by-row via J segments, with column-order reconstruction metadata in k segments. This means the AMPL translator has *already performed coefficient extraction* during its (closed-source) compilation step. The Jacobian nonzero count is pre-computed and appears in the header.

---

## 3. The ASL (AMPL Solver Library): The Legacy Path

The ASL (`ampl/asl` repository) is a C library that reads NL files and provides:

- **Automatic differentiation** of nonlinear expressions
- **Jacobian evaluation** (both structure and values)
- **Hessian evaluation** for the Lagrangian
- Direct access to linear constraint coefficients

### What ASL Does for "Matrix Stuffing"
ASL does *not* perform canonicalization in the CVXPY sense. It:

1. **Reads** the NL file (which already contains pre-extracted coefficients)
2. **Provides** the constraint matrix via `A_colstarts`, `A_rownos`, `A_vals` arrays (CSC format)
3. **Evaluates** nonlinear expressions and their derivatives on demand
4. The **solver driver** then calls the solver's native API to pass this data

For a linear solver like CPLEX via the old ASL interface, the "matrix stuffing" is essentially:
```c
// Pseudocode: ASL provides pre-extracted sparse data
// Solver driver passes it to CPLEX's API
CPXcopylp(env, lp, numcols, numrows,
          objsense, obj_coeffs,
          rhs, sense,
          matbeg, matcnt, matind, matval,  // CSC format from ASL
          lb, ub, rngval);
```

The coefficients were extracted by the AMPL translator when it wrote the NL file. ASL merely reads them back.

---

## 4. The MP Library: The Modern Path (and Where the Action Is)

The MP library (`ampl/mp` repository) is the modern replacement for ASL-based solver drivers. It introduces a **sophisticated reformulation pipeline** that is the closest analogue to CVXPY's canonicalization:

### Pipeline Architecture

```
NL File
  │
  ▼
NL Reader (mp::NLReader2)
  │
  ▼
Problem Flattener (mp::ProblemFlattener)
  │  - Walks expression tree
  │  - Introduces auxiliary variables for nonlinear subexpressions
  │  - Produces "flat" constraints (each has a defined type)
  │
  ▼
Flat Converter (mp::FlatConverter / mp::MIPFlatConverter)
  │  - Receives typed flat constraints
  │  - Reformulates unsupported constraints into supported ones
  │  - SOCP recognition, exponential cone detection
  │  - Logical constraint linearization (big-M, indicator)
  │  - Quadratic decomposition
  │  - Piecewise-linear approximation
  │  - Subexpression elimination (expression maps)
  │
  ▼
Flat Model API (mp::BasicFlatModelAPI)
  │  - Solver-specific implementation
  │  - Receives individual constraints via AddConstraint()
  │  - Receives variables via AddVariables()
  │  - Receives objectives via SetLinearObjective() / SetQuadraticObjective()
  │
  ▼
Solver Native API (e.g., MSK_putarow, GRBaddconstr, etc.)
```

### The Flat Model API: AMPL's "Matrix Stuffing" Equivalent

The closest analogue to CVXPY's matrix stuffing is the **Flat Model API** (`BasicFlatModelAPI`), which is the interface between the MP reformulation engine and the solver's native API. For the MOSEK driver, this looks like:

```cpp
// From the MOSEK driver (mosek-modelapi-connect.cc)
void MosekModelAPI::AddConstraint(const LinConRange& lc) {
    // lc contains: variable indices, coefficients, lower bound, upper bound
    // This calls MSK_putarow() or equivalent
    MOSEK_CCALL(MSK_putarow(lp(), row_index,
                            lc.size(),       // number of nonzeros
                            lc.pvars(),      // variable indices
                            lc.pcoefs()));   // coefficient values
    MOSEK_CCALL(MSK_putconbound(lp(), row_index,
                                MSK_BK_RA,
                                lc.lb(), lc.ub()));
}
```

**This is a row-by-row ("row stuffing") approach**, not a monolithic matrix construction. Each constraint is passed to the solver individually. The solver accumulates them internally.

### Constraint Types in MP

MP defines a rich hierarchy of typed constraints (in `constr_std.h`):

- **Linear**: `LinConLE`, `LinConEQ`, `LinConGE`, `LinConRange`
- **Quadratic**: `QuadConLE`, `QuadConEQ`, `QuadConGE`, `QuadConRange`
- **Conic**: Second-order cone, exponential cone, power cone
- **Logical**: `IndicatorConstraintLinLE/EQ/GE`, AND/OR/NOT
- **Counting**: AllDiff, NumberOf, Count
- **Piecewise-linear**: SOS1/SOS2

Each solver driver declares which constraint types it natively accepts via the `ACCEPT_CONSTRAINT` macro:

```cpp
ACCEPT_CONSTRAINT(LinConRange, Recommended, CG_Linear)
ACCEPT_CONSTRAINT(QuadConLE, Recommended, CG_Quadratic)
ACCEPT_CONSTRAINT(ExpConeConstraint, Recommended, CG_Conic)
```

Unsupported constraints are automatically reformulated by `FlatConverter`.

### Memory Preallocation

The MP framework provides `FlatModelInfo` for memory preallocation, which is the one place where aggregate matrix information is available before individual constraint passing:

```cpp
void MosekModelAPI::InitProblemModificationPhase(const FlatModelInfo* info) {
    MOSEK_CCALL(MSK_appendcons(lp(),
        info->GetNumberOfConstraintsOfGroup(CG_Linear) +
        info->GetNumberOfConstraintsOfGroup(CG_Quadratic)));
}
```

---

## 5. Comparison with CVXPY and JuMP/MOI

### CVXPY's Matrix Stuffing
CVXPY performs canonicalization as:
1. Reduce to a standard form via DCP rewriting rules
2. For each atom, extract coefficients into sparse matrices
3. **Stack all constraint matrices into a single A matrix** (the "stuffing" step)
4. Pass the complete (A, b, c, cone_dims) to the solver

### JuMP/MOI's Approach
JuMP/MOI uses:
1. A constraint-by-constraint `MOI.add_constraint` approach
2. Bridges reformulate unsupported constraints
3. Caching optimizer accumulates constraints
4. Final copy to solver is constraint-by-constraint via `MOI.copy_to`

### AMPL's Approach
AMPL is closer to JuMP/MOI than to CVXPY:
1. **No monolithic A matrix construction** — constraints arrive individually
2. **Expression tree flattening** (MP's ProblemFlattener) ≈ MOI bridges
3. **Typed constraint dispatch** (ACCEPT_CONSTRAINT) ≈ MOI's supports mechanism
4. **Row-by-row AddConstraint** ≈ MOI's add_constraint

**Key difference from both**: The AMPL translator (closed-source) performs coefficient extraction during compilation. The NL file already contains the sparse Jacobian structure. Neither ASL nor MP needs to "extract" coefficients from symbolic expressions — they're already extracted.

---

## 6. Coefficient Extraction: Where It Actually Happens

In AMPL's architecture, the coefficient extraction that CVXPY does during matrix stuffing happens in **two separate places**:

### Stage 1: AMPL Translator (Closed-Source)
- Parses the algebraic model
- Performs presolve (bound tightening, constraint elimination, variable substitution)
- **Separates linear and nonlinear parts** of each constraint
- Extracts linear coefficients and writes them to J segments in the NL file
- Computes Jacobian sparsity structure (k segments)

This is analogous to CVXPY's `canonicalize()` method on each atom, but happens inside a proprietary compiler.

### Stage 2: MP's ProblemFlattener + FlatConverter
- Receives the NL data (already has linear coefficients extracted)
- Walks nonlinear expression trees, introducing auxiliary variables
- **Generates new linear constraints** from reformulations (e.g., linearizing logical constraints)
- For these *new* constraints, coefficients are generated during reformulation
- Passes everything via `AddConstraint` to the solver

### What's NOT Open-Source
The actual coefficient extraction from symbolic algebraic expressions (the `sum{i in I, j in J} a[i,j] * x[j]` → sparse vector mapping) happens inside the proprietary AMPL translator. This is the step most analogous to CVXPY's matrix stuffing, and it is **not visible** in either `ampl/mp` or `ampl/asl`.

---

## 7. Sparsity Exploitation in AMPL

### NL File Level
- The NL format is inherently sparse — only nonzero coefficients appear in J segments
- Column-order metadata (k segments) enables CSC reconstruction without full COO→CSC conversion
- The AMPL translator exploits algebraic structure to avoid generating zero coefficients

### MP Level
- `FlatConverter` eliminates duplicate subexpressions ("expression maps")
- Defined variables (common subexpressions) reduce redundant computation
- Presolve operations: constant folding, bound propagation, constraint elimination
- Option `cvt:dvelim` substitutes defined variables into linear/quadratic/polynomial expressions

### What's Missing (Your Research Gap)
AMPL's approach is essentially:
1. Extract coefficients one-by-one during compilation (closed-source)
2. Pass them one-by-one to the solver via AddConstraint

There is **no exploitation of structure in the coefficient matrix itself** (e.g., block structure, repeated patterns across constraints, Kronecker products, low-rank structure). The Jacobian is treated as a generic sparse matrix. This is exactly the "unexploited structure in coefficient extraction" gap you've identified.

---

## 8. Summary Table

| Aspect | AMPL (ASL+MP) | CVXPY | JuMP/MOI |
|--------|---------------|-------|----------|
| **Coefficient extraction** | AMPL translator (closed) | `canonicalize()` per atom | Bridge layer |
| **IR format** | NL file (sparse, row-wise) | Parameter matrix per atom | MOI constraint objects |
| **Matrix assembly** | None (row-by-row to solver) | Monolithic A,b,c stacking | Copy_to (constraint-by-constraint) |
| **Reformulation engine** | MP FlatConverter | DCP reduction rules | MOI Bridges |
| **Constraint dispatch** | ACCEPT_CONSTRAINT macro | Solver-specific reductions | MOI supports/bridges |
| **Sparsity** | COO in NL file, CSC metadata | SciPy sparse throughout | Sparse via MOI |
| **Jacobian structure** | Pre-computed in NL header | Computed during stuffing | Implicit |
| **Open-source coefficient extraction** | No (translator is proprietary) | Yes | Yes |

---

## 9. Internal Data Structures: How Coefficients Are Represented

### In MP's Flat Constraints

The MP library uses **templated algebraic constraints** parameterized by their body type and RHS type. From the CPLEX/HiGHS options and source code, the key types revealed are:

```cpp
// The fundamental linear constraint body type
class LinTerms {
    std::vector<int> vars_;     // variable indices
    std::vector<double> coefs_; // corresponding coefficients
    // Accessed via pvars(), pcoefs(), size()
};

// Quadratic extension
class QuadAndLinTerms : public LinTerms {
    std::vector<int> qvars1_;   // first variable in each quadratic term
    std::vector<int> qvars2_;   // second variable in each quadratic term  
    std::vector<double> qcoefs_; // quadratic coefficients
};

// RHS types
struct RhsLE { double ub; };   // <= ub
struct RhsGE { double lb; };   // >= lb
struct RhsEQ { double rhs; };  // == rhs
struct RhsRange { double lb, ub; };  // lb <= ... <= ub

// Constraint = Body + RHS
// LinConLE  = AlgebraicConstraint<LinTerms, RhsLE>
// QuadConEQ = AlgebraicConstraint<QuadAndLinTerms, RhsEQ>
// etc.
```

This is a **coordinate-like (COO) sparse representation** for each individual constraint row. There is no global matrix object — each constraint independently stores its own variable indices and coefficients.

### In the `BasicProblem` class (`problem.h`)

The intermediate `BasicProblem` representation (used in the older MP NL reader path, still part of master branch) stores linear expressions as:

```cpp
class LinearExpr {
    class Term {
        int var_index_;
        double coef_;
    };
    std::vector<Term> terms_;  // Sorted by var_index for efficient operations
};
```

Each constraint body is a `LinearExpr` (linear part) plus an optional nonlinear expression tree. The `SortTerms()` method suggests that linear terms are sorted by variable index for efficient processing, but this sorting is per-constraint, not across the global matrix.

### In the ASL (C code)

The ASL stores the **complete Jacobian** in CSC (Compressed Sparse Column) format after reading the NL file:

```c
// From ASL structures (asl.h / asl_pfgh.h)
struct ASL_pfgh {
    // Jacobian in CSC format
    int *A_colstarts;   // Column pointers (length n_var + 1)
    int *A_rownos;      // Row indices for each nonzero
    double *A_vals;      // Coefficient values for each nonzero
    int nzc;             // Total number of nonzeros in constraint Jacobian
    
    // Or equivalently for row-wise access:
    cgrad **Cgrad;       // Linked list of gradient terms per constraint
};
```

The `cgrad` structure is a linked list of (variable, coefficient) pairs per constraint row. The NL reader reconstructs the CSC format from the row-wise J segments in the NL file, using the k segment column counts as a guide:

```c
// cgrad: linked list node for constraint gradient
struct cgrad {
    cgrad *next;    // next term in this constraint
    int varno;      // variable number
    int goff;       // offset in Jacobian arrays
    double coef;    // coefficient value
};
```

This is the closest thing to "matrix stuffing" in the ASL path — assembling the CSC Jacobian from the NL file's row-wise data. But it's just a format conversion (COO row-wise → CSC), not coefficient *extraction* from symbolic expressions.

---

## 10. Quadratic Coefficient Extraction: The One Place AMPL Does "Stuff"

The MP documentation reveals one place where AMPL MP *does* perform something resembling CVXPY-style coefficient extraction — **quadratic expression multiplication ("out-multiplication")**:

> "For quadratic expressions of the form `linear * linear` and `linear^2`, the operands are multiplied out so that coefficients of individual quadratic terms can be extracted. For example, `(x-2)(y+3)` is multiplied out as `xy - 2y + 3x - 6`."

This is essentially:
1. Take two `LinTerms` objects
2. Compute all pairwise products of their terms
3. Collect the resulting quadratic coefficients (Q matrix entries) and linear terms
4. Store in a `QuadAndLinTerms` object

This is a small-scale coefficient extraction, and the option `cvt:quadobj`, `cvt:quadcon` controls whether it happens. The option `cvt:multoutcard` limits the size of out-multiplied expressions for performance.

For your thesis, this is notable: even this limited "extraction" doesn't exploit any structure in the Q matrix (symmetry, sparsity patterns, block structure). It's a brute-force expansion.

---

## 11. Historical Context: Fourer 1983 and the Row-vs-Column Debate

Fourer's 1983 paper "Modeling Languages Versus Matrix Generators for Linear Programming" (ACM TOMS) is foundational and directly relevant to your thesis topic:

**Key argument**: Modeling languages should free the user from thinking about matrix generation. The traditional approach was to write "matrix generators" in Fortran that produced MPS files in **column-wise** format (because LP solvers like the simplex method wanted data that way). Fourer argued that a modeling language should use **row-wise** formulation (constraints are naturally expressed row by row) and leave the column-wise conversion to the computer.

**Direct quote from the Fourer 1983 abstract** (paraphrased): A modeling language need not employ the column-wise coefficient ordering of MPS form; instead, it may adopt a row-wise ordering, which is more natural for modelers.

**Implications for your thesis**: 
- AMPL's entire philosophy is that the *modeler's form* (row-wise, constraint-by-constraint) is the natural representation
- The conversion to *algorithm's form* (the A matrix in CSC format for LP, or cone data for conic solvers) should be transparent
- AMPL chose to make this conversion trivial (just reformat COO → CSC) rather than sophisticated
- This means AMPL deliberately avoided the question of *exploiting structure* in the coefficient matrix — it treats matrix assembly as a mechanical data-reformatting step
- Your unified Jacobian abstraction work addresses exactly the gap that AMPL's "matrix generation is just data reformatting" philosophy leaves open

---

## 12. The Presolve Step: AMPL's Hidden Coefficient Optimization

While AMPL doesn't do matrix-level structural exploitation, the AMPL translator does perform a **presolve** step that manipulates coefficients:

- **Variable elimination** (`linelim`, `substout` options): Substitutes fixed or bounded variables, eliminating them from constraints. This modifies coefficients.
- **Constraint elimination**: Drops redundant constraints
- **Bound tightening**: Propagates bounds through linear expressions
- **Coefficient reduction**: Simplifies coefficients (e.g., dividing a constraint by a common factor)

Fourer & Gay's 1994 paper "Experience with a Primal Presolve Algorithm" describes this. The key insight: AMPL's presolve operates at the *individual constraint* level — it doesn't look at the global matrix structure (e.g., it won't detect that a block of constraints forms a network flow or has Kronecker structure).

The MP library adds its own presolve on top:
- `cvt:pre:unnest` — inlining of linear/quadratic subexpressions
- `cvt:pre:sort` — sorting for logical expressions
- `cvt:dvelim` — defined variable elimination into linear/quadratic/polynomial expressions
- Constant folding, bound propagation

---

## 13. Relevant Source Files in ampl/mp (Updated)

For deeper code-level analysis:
- `include/mp/flat/constr_std.h` — Constraint type definitions
- `include/mp/flat/converter.h` — FlatConverter base
- `include/mp/flat/converter_model.h` — Model building
- `include/mp/problem_flattener.h` — NL tree → flat constraints
- `solvers/mosek/mosekmodelapi.h` — MOSEK's AddConstraint implementations
- `solvers/mosek/mosek-modelapi-connect.cc` — MOSEK API calls
- `nl-writer2/` — The lightweight NL writer (for producing NL files programmatically)
- `include/mp/flat/preprocess.h` — Presolve/preprocessing

For the ASL:
- `src/solvers/asl/` — Core ASL C code
- Key files: `jac0dim.c` (Jacobian dimension reading), `jacdim.c`, `fg_read.c` (NL file reader)

---

## 14. The NL Writer (`nl-writer2`): Producing NL Files Programmatically

The `nl-writer2` directory in `ampl/mp` contains a lightweight C++ library for *writing* NL files from external tools (e.g., Python, Julia). This is the reverse path — instead of AMPL translator → NL file, it's your_code → NL file → solver.

Key observation: The NL writer API requires you to provide:
- Jacobian sparsity structure **upfront** (number of nonzeros per constraint)
- Constraint coefficients **row by row** (J segments)
- Column count metadata (k segments)

This means if you're using the NL writer from a system like CVXPY, you would need to have *already done* your own matrix stuffing to know the sparsity structure. The NL writer is just a serialization format, not a computation engine.

This is relevant for your NLP extension work: if CVXPY wants to produce NL files for IPOPT via MP, the coefficient extraction (your Jacobian abstraction) would need to happen *before* calling the NL writer.

---

## 15. Summary: What AMPL Teaches About Canonicalization Design Space

The AMPL ecosystem illustrates one end of a design spectrum for canonicalization:

| Design Choice | AMPL's Position | Alternative (CVXPY-style) |
|---------------|-----------------|---------------------------|
| **When are coefficients extracted?** | During compilation (one-time, per constraint) | During canonicalization (per atom, then stacked) |
| **What is the IR?** | Row-wise sparse (NL file J segments) | Per-atom parameter matrices → global A matrix |
| **Is the global matrix ever assembled?** | No (solver accumulates rows) | Yes (matrix stuffing produces A,b,c) |
| **Is matrix structure exploited?** | No | Partially (sparse formats, but not structural patterns) |
| **Where does reformulation happen?** | After coefficient extraction (MP FlatConverter) | Before/during coefficient extraction (DCP rules) |
| **Is the process differentiable?** | No (ASL provides AD separately) | Yes (CVXPY differentiates through canonicalization) |

**The gap you've identified**: Neither AMPL nor CVXPY exploits the *structure* of the coefficient matrix (block-diagonal, Kronecker, low-rank, repeated submatrices). AMPL doesn't even assemble the matrix. CVXPY assembles it but treats it as a generic sparse matrix. Your unified Jacobian abstraction could bridge this gap by providing a structured representation that both systems could benefit from — AMPL by enabling batch constraint submission to solvers, and CVXPY by avoiding redundant coefficient extraction across structurally similar constraints.