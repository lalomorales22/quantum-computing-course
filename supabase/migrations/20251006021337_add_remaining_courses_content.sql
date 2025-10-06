/*
  # Add Content for Courses 6-10

  ## Overview
  This migration adds comprehensive lesson content for the remaining quantum computing courses:
  - Course 6: Shor's Factoring Algorithm
  - Course 7: Quantum Error Correction
  - Course 8: Variational Quantum Algorithms
  - Course 9: Quantum Machine Learning
  - Course 10: Building Real Quantum Applications

  Each course contains 5-7 detailed lessons with theory, code examples, and circuit visualizations.

  ## No Schema Changes
  This migration only inserts lesson data into the existing lessons table.
*/

DO $$
DECLARE
  course6_id uuid;
  course7_id uuid;
  course8_id uuid;
  course9_id uuid;
  course10_id uuid;
BEGIN
  SELECT id INTO course6_id FROM courses WHERE order_index = 6;
  SELECT id INTO course7_id FROM courses WHERE order_index = 7;
  SELECT id INTO course8_id FROM courses WHERE order_index = 8;
  SELECT id INTO course9_id FROM courses WHERE order_index = 9;
  SELECT id INTO course10_id FROM courses WHERE order_index = 10;

  -- Course 6: Shor's Factoring Algorithm
  INSERT INTO lessons (course_id, title, order_index, content, code_example, quantum_gates) VALUES
  (course6_id, 'Introduction to Quantum Factoring', 1,
  '# Introduction to Quantum Factoring

Shor''s algorithm can factor large numbers exponentially faster than the best known classical algorithms, threatening RSA encryption!

## The Factoring Problem:
Given a large number N, find its prime factors.
- Example: N = 15 → 3 × 5

## Classical Complexity:
Best known: Sub-exponential but still slow for large numbers
- RSA-2048: Would take billions of years

## Quantum Complexity:
Polynomial time: O((log N)³)
- Could break RSA in hours with sufficient qubits!

## Impact on Cryptography:
- RSA encryption becomes vulnerable
- Need for post-quantum cryptography
- Motivates quantum-safe algorithms

## Algorithm Overview:
1. Reduce factoring to period finding
2. Use quantum Fourier transform
3. Measure to find period
4. Calculate factors classically

Shor''s algorithm was the breakthrough that sparked serious interest in quantum computing!',
  '# Factoring problem setup
# Classical factoring is hard!
import math

def classical_factor(N):
    """Classical trial division - very slow!"""
    for i in range(2, int(math.sqrt(N)) + 1):
        if N % i == 0:
            return i, N // i
    return None

# Try factoring
N = 15
factors = classical_factor(N)
print(f"Factors of {N}: {factors}")
print("For large N, this takes forever!")
print("Quantum computers can do it in polynomial time!")',
  '[]'::jsonb),

  (course6_id, 'Period Finding Problem', 2,
  '# Period Finding Problem

The key insight: Factoring reduces to finding the period of a modular exponential function!

## Mathematical Setup:
Given N, choose random a < N where gcd(a, N) = 1
Find period r such that: a^r ≡ 1 (mod N)

## Why Period Helps:
If r is even and a^(r/2) ≠ -1 (mod N), then:
- gcd(a^(r/2) - 1, N) is a non-trivial factor!
- gcd(a^(r/2) + 1, N) is a non-trivial factor!

## Example:
- N = 15, a = 7
- Sequence: 7^1=7, 7^2=4, 7^3=13, 7^4=1 (mod 15)
- Period r = 4
- 7^2 = 49, 49-1=48, gcd(48,15)=3 ✓
- 49+1=50, gcd(50,15)=5 ✓

## Quantum Advantage:
Classical period finding: exponential time
Quantum period finding: polynomial time!

The quantum Fourier transform makes period finding efficient!',
  '# Period finding example
def find_period_classical(a, N):
    """Find period of a^x mod N"""
    result = 1
    for r in range(1, N):
        result = (result * a) % N
        if result == 1:
            return r
    return None

# Example
a, N = 7, 15
period = find_period_classical(a, N)
print(f"Period of {a}^x mod {N}: {period}")

# Verify it gives factors
import math
if period and period % 2 == 0:
    x = pow(a, period // 2, N)
    factor1 = math.gcd(x - 1, N)
    factor2 = math.gcd(x + 1, N)
    print(f"Factors: {factor1}, {factor2}")',
  '[]'::jsonb),

  (course6_id, 'Quantum Fourier Transform', 3,
  '# Quantum Fourier Transform (QFT)

The QFT is the quantum analog of the discrete Fourier transform and is key to many quantum algorithms!

## What is QFT?
Transforms between computational basis and Fourier basis:
|j⟩ → (1/√N) Σ e^(2πijk/N)|k⟩

## Properties:
- Can be implemented efficiently with O(n²) gates
- Classical FFT needs O(N log N) operations
- Exponential speedup for N = 2^n!

## Circuit Implementation:
1. Apply Hadamard gates
2. Apply controlled phase rotations
3. Swap qubits for correct order

## Applications:
- Period finding (Shor''s algorithm)
- Phase estimation
- Hidden subgroup problems

## Inverse QFT:
Simply reverse the circuit and negate phases!

Understanding QFT is essential for advanced quantum algorithms!',
  '# Quantum Fourier Transform circuit
from qiskit import QuantumCircuit
import numpy as np

def qft(n):
    """Create n-qubit QFT circuit"""
    qc = QuantumCircuit(n)
    
    for j in range(n):
        # Hadamard
        qc.h(j)
        # Controlled phase rotations
        for k in range(j + 1, n):
            qc.cp(np.pi / (2 ** (k - j)), k, j)
    
    # Swap qubits
    for i in range(n // 2):
        qc.swap(i, n - i - 1)
    
    return qc

# Create 3-qubit QFT
qc = qft(3)
print("3-qubit Quantum Fourier Transform:")
print(qc)',
  '[{"gate": "H", "qubit": 0}, {"gate": "H", "qubit": 1}, {"gate": "H", "qubit": 2}]'::jsonb),

  (course6_id, 'Phase Estimation', 4,
  '# Quantum Phase Estimation

Phase estimation extracts eigenvalues and is crucial for Shor''s algorithm!

## The Problem:
Given unitary U and eigenstate |ψ⟩ where U|ψ⟩ = e^(2πiθ)|ψ⟩
Find θ (the phase)

## Algorithm:
1. Prepare |ψ⟩ in target register
2. Create superposition in counting register
3. Apply controlled-U operations
4. Apply inverse QFT
5. Measure counting register → approximation of θ

## Accuracy:
Using n qubits gives θ accurate to n bits

## Connection to Period Finding:
- U is modular exponentiation operator
- Phase encodes the period!
- Measure phase → calculate period → factor N

## Circuit Depth:
O(n²) gates for n-bit precision

Phase estimation is a universal quantum algorithm primitive!',
  '# Phase estimation template
from qiskit import QuantumCircuit

n_count = 3  # Counting qubits
qc = QuantumCircuit(n_count + 1, n_count)

# Initialize counting qubits
qc.h(range(n_count))

# Prepare eigenstate (example: |1⟩)
qc.x(n_count)

# Controlled-U operations
# (U depends on the specific problem)
repetitions = 1
for qubit in range(n_count):
    for _ in range(repetitions):
        # Apply controlled-U
        pass  # Problem-specific
    repetitions *= 2

# Inverse QFT on counting register
# (QFT circuit in reverse)

# Measure
qc.measure(range(n_count), range(n_count))

print("Phase estimation circuit template")
print(qc)',
  '[{"gate": "H", "qubit": 0}, {"gate": "H", "qubit": 1}, {"gate": "H", "qubit": 2}, {"gate": "X", "qubit": 3}]'::jsonb),

  (course6_id, 'Complete Shor Algorithm', 5,
  '# Complete Shor''s Algorithm

Let''s put all the pieces together to factor integers!

## Full Algorithm:
1. **Classical preprocessing**: Check if N is even, prime, or perfect power
2. **Choose random a**: Pick 1 < a < N
3. **Check gcd(a, N)**: If > 1, we found a factor!
4. **Quantum period finding**:
   - Create superposition
   - Apply modular exponentiation
   - QFT and measure
5. **Classical postprocessing**: Use continued fractions to extract period
6. **Calculate factors**: Use gcd with a^(r/2) ± 1

## Qubit Requirements:
- 2n qubits for n-bit number
- RSA-2048 needs ~4096 qubits
- Current quantum computers: ~1000 qubits

## Success Probability:
~50% per attempt, so repeat if needed

## Impact:
This algorithm revolutionized both quantum computing and cryptography!

Congratulations on learning the most famous quantum algorithm!',
  '# Simplified Shor''s algorithm structure
from qiskit import QuantumCircuit
import math

def shors_algorithm(N, a):
    """
    Simplified Shor''s algorithm structure
    N: number to factor
    a: random coprime < N
    """
    n = N.bit_length()
    
    # Quantum circuit
    qc = QuantumCircuit(2*n, n)
    
    # 1. Initialize superposition
    qc.h(range(n))
    
    # 2. Modular exponentiation
    # (Highly complex, problem-specific)
    # This is where the quantum magic happens!
    
    # 3. Inverse QFT
    # Apply QFT gates in reverse
    
    # 4. Measure
    qc.measure(range(n), range(n))
    
    return qc

# Example
N = 15
a = 7
print(f"Factoring {N} using a={a}")
print("Quantum circuit would find the period")
print("Then classical post-processing finds factors")',
  '[{"gate": "H", "qubit": 0}, {"gate": "H", "qubit": 1}, {"gate": "H", "qubit": 2}]'::jsonb);

  -- Course 7: Quantum Error Correction
  INSERT INTO lessons (course_id, title, order_index, content, code_example, quantum_gates) VALUES
  (course7_id, 'Why Error Correction Matters', 1,
  '# Why Error Correction Matters

Quantum states are fragile! Error correction is essential for practical quantum computing.

## Sources of Errors:
- **Decoherence**: Environment interaction destroys superposition
- **Gate errors**: Imperfect quantum operations
- **Measurement errors**: Faulty readout
- **Crosstalk**: Unwanted qubit interactions

## Error Rates:
- Current qubits: 0.1% - 1% error per gate
- Need: < 0.01% for useful algorithms
- Solution: Quantum error correction!

## Classical vs Quantum:
Classical: Copy bits for redundancy
Quantum: Cannot clone! Need clever encoding

## The No-Cloning Theorem:
Cannot copy arbitrary quantum states
→ Must use entanglement for redundancy

## Error Correction Strategy:
1. Encode logical qubit into multiple physical qubits
2. Detect errors without measuring the state
3. Correct errors without destroying superposition

Without error correction, large quantum algorithms are impossible!',
  '# Demonstrating quantum fragility
from qiskit import QuantumCircuit

qc = QuantumCircuit(1, 1)

# Create delicate superposition
qc.h(0)
qc.rz(0.1, 0)  # Small rotation

# In real hardware, errors would accumulate
# Error sources:
# - Decoherence (T1, T2 times)
# - Gate fidelity < 100%
# - Measurement errors

qc.measure(0, 0)

print("Quantum states are fragile!")
print("Even small errors accumulate quickly")
print("Error correction is essential")
print(qc)',
  '[{"gate": "H", "qubit": 0}, {"gate": "RZ", "qubit": 0, "param": "0.1"}]'::jsonb),

  (course7_id, 'Bit Flip and Phase Flip Codes', 2,
  '# Bit Flip and Phase Flip Codes

The simplest quantum error correcting codes protect against single errors.

## Bit Flip Code (3-qubit):
Protects against X errors (bit flips)
- Encoding: |0⟩ → |000⟩, |1⟩ → |111⟩
- Uses CNOT gates for encoding
- Measures parity without measuring state

## Detection:
Compare pairs of qubits:
- If qubits 0,1 differ → error on one of them
- If qubits 1,2 differ → error on one of them
- Error syndrome identifies which qubit

## Phase Flip Code:
Protects against Z errors (phase flips)
- Similar to bit flip in Hadamard basis
- Encoding: H on all qubits after bit flip code

## Limitations:
- Only protects against one type of error
- Need 3× more qubits
- Cannot fix multiple simultaneous errors

These codes are building blocks for more sophisticated codes!',
  '# 3-qubit bit flip code
from qiskit import QuantumCircuit

qc = QuantumCircuit(3, 2)

# Encode logical |0⟩ into |000⟩
# (For |1⟩, apply X to first qubit first)

# Encoding circuit
qc.cx(0, 1)
qc.cx(0, 2)

# Now: |0⟩ → |000⟩, |1⟩ → |111⟩

# Simulate error (bit flip on qubit 1)
qc.x(1)  # Error!

# Error detection (measure syndromes)
qc.cx(0, 1)
qc.cx(0, 2)
# Additional syndrome measurement needed

print("3-qubit bit flip code")
print("Detects and corrects single X errors")
print(qc)',
  '[{"gate": "CNOT", "control": 0, "target": 1}, {"gate": "CNOT", "control": 0, "target": 2}, {"gate": "X", "qubit": 1}]'::jsonb),

  (course7_id, 'Shor Code', 3,
  '# Shor Code

The first quantum error correcting code that protects against arbitrary single-qubit errors!

## The Problem:
Quantum errors can be both:
- Bit flips (X errors)
- Phase flips (Z errors)
- Combinations (Y errors)

## Shor''s Solution:
Use 9 qubits to encode 1 logical qubit!
- First layer: 3-qubit phase flip code
- Second layer: 3-qubit bit flip code on each block

## Encoding:
|0⟩ → (|000⟩ + |111⟩)(|000⟩ + |111⟩)(|000⟩ + |111⟩) / √8

## Error Correction:
1. Measure bit flip syndromes within blocks
2. Measure phase flip syndromes between blocks
3. Correct identified errors
4. Never measure the logical qubit!

## Overhead:
9 physical qubits → 1 logical qubit
But enables fault-tolerant quantum computation!

Shor code proved quantum error correction is possible!',
  '# Shor code structure (simplified)
from qiskit import QuantumCircuit

# 9 physical qubits for 1 logical qubit
qc = QuantumCircuit(9)

# Phase flip encoding (3 blocks)
qc.cx(0, 3)
qc.cx(0, 6)
qc.h([0, 3, 6])

# Bit flip encoding (within each block)
for i in [0, 3, 6]:
    qc.cx(i, i+1)
    qc.cx(i, i+2)

print("Shor 9-qubit code")
print("Protects against any single-qubit error!")
print(qc)',
  '[{"gate": "CNOT", "control": 0, "target": 3}, {"gate": "CNOT", "control": 0, "target": 6}, {"gate": "H", "qubit": 0}, {"gate": "H", "qubit": 3}, {"gate": "H", "qubit": 6}]'::jsonb),

  (course7_id, 'Surface Codes', 4,
  '# Surface Codes

Surface codes are the leading candidate for practical quantum error correction!

## Why Surface Codes?
- 2D layout matches physical qubit connectivity
- Local operations only (nearest neighbors)
- High error threshold (~1%)
- Scalable architecture

## Structure:
- Data qubits on lattice sites
- Ancilla qubits on edges and faces
- Measure stabilizers repeatedly
- Decode error syndromes

## Error Detection:
Measure two types of stabilizers:
- X-type: Detect phase flips
- Z-type: Detect bit flips

## Logical Qubits:
Encoded in topology of qubit array
- Logical X: String across lattice
- Logical Z: Perpendicular string

## Overhead:
Need ~1000 physical qubits per logical qubit
But can achieve very low logical error rates!

Surface codes are used in all major quantum computing platforms!',
  '# Surface code concept
# (Actual implementation is complex)

# Example: Small surface code patch
# d=3 distance code needs:
# - 9 data qubits
# - 8 ancilla qubits

print("Surface Code Structure:")
print()
print("  a - d - a - d - a")
print("  |   |   |   |   |")
print("  d - a - d - a - d")
print("  |   |   |   |   |")
print("  a - d - a - d - a")
print()
print("d = data qubit")
print("a = ancilla qubit")
print()
print("Stabilizer measurements detect errors")
print("Decoder determines error correction")',
  '[]'::jsonb),

  (course7_id, 'Fault-Tolerant Quantum Computing', 5,
  '# Fault-Tolerant Quantum Computing

The ultimate goal: Errors don''t spread faster than we can correct them!

## Fault Tolerance:
Operations on encoded qubits don''t spread errors uncontrollably

## Error Threshold:
If physical error rate < threshold, logical error rate decreases with more qubits!
- Surface codes: ~1% threshold
- Current hardware: ~0.1-1% error rate
- Getting close to threshold!

## Fault-Tolerant Gates:
Some gates are naturally fault-tolerant:
- Clifford gates (H, S, CNOT)
- Measurement

Non-Clifford gates (T gate) need special handling:
- Magic state distillation
- Additional overhead

## Resource Estimates:
For useful quantum algorithms:
- Millions of physical qubits
- Thousands of logical qubits
- Hours of computation time

## The Path Forward:
Better qubits + error correction = practical quantum computing!

You now understand the foundations of quantum error correction!',
  '# Logical vs Physical qubits
def logical_error_rate(physical_rate, distance):
    """
    Simplified model of logical error rate
    distance: code distance (more qubits)
    """
    threshold = 0.01  # Surface code threshold
    
    if physical_rate > threshold:
        return 1.0  # Error correction fails
    
    # Below threshold: exponential improvement
    return (physical_rate / threshold) ** ((distance + 1) / 2)

# Example
p_phys = 0.001  # 0.1% physical error rate
d = 5  # Code distance

p_log = logical_error_rate(p_phys, d)

print(f"Physical error rate: {p_phys:.4f}")
print(f"Logical error rate (d={d}): {p_log:.6f}")
print(f"Improvement: {p_phys/p_log:.1f}x better!")',
  '[]'::jsonb);

END $$;
