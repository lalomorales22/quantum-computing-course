/*
  # Add Content for Courses 8-10

  ## Overview
  Completes the quantum computing course platform with final three courses:
  - Course 8: Variational Quantum Algorithms
  - Course 9: Quantum Machine Learning
  - Course 10: Building Real Quantum Applications

  ## Content Details
  Each course includes comprehensive lessons covering theory, implementation,
  and practical applications of advanced quantum computing topics.
*/

DO $$
DECLARE
  course8_id uuid;
  course9_id uuid;
  course10_id uuid;
BEGIN
  SELECT id INTO course8_id FROM courses WHERE order_index = 8;
  SELECT id INTO course9_id FROM courses WHERE order_index = 9;
  SELECT id INTO course10_id FROM courses WHERE order_index = 10;

  -- Course 8: Variational Quantum Algorithms
  INSERT INTO lessons (course_id, title, order_index, content, code_example, quantum_gates) VALUES
  (course8_id, 'Introduction to VQAs', 1,
  '# Introduction to Variational Quantum Algorithms

VQAs are hybrid quantum-classical algorithms perfect for near-term quantum computers!

## What are VQAs?
Algorithms that:
- Use parameterized quantum circuits
- Optimize parameters classically
- Suited for noisy intermediate-scale quantum (NISQ) devices

## Key Advantages:
- Shallow circuits → less noise
- Tolerant to gate errors
- Flexible problem encoding
- Practical with current hardware

## General Structure:
1. Prepare parameterized quantum state
2. Measure observable
3. Classical optimizer updates parameters
4. Repeat until convergence

## Applications:
- Optimization problems
- Chemistry simulations
- Machine learning
- Financial modeling

## Famous VQAs:
- VQE (Variational Quantum Eigensolver)
- QAOA (Quantum Approximate Optimization Algorithm)

VQAs are the most practical quantum algorithms today!',
  '# VQA structure template
from qiskit import QuantumCircuit
import numpy as np

def vqa_circuit(params):
    """Parameterized quantum circuit"""
    qc = QuantumCircuit(2)
    
    # Variational layer 1
    qc.ry(params[0], 0)
    qc.ry(params[1], 1)
    qc.cx(0, 1)
    
    # Variational layer 2
    qc.ry(params[2], 0)
    qc.ry(params[3], 1)
    
    return qc

# Initial parameters
params = np.random.rand(4) * 2 * np.pi

qc = vqa_circuit(params)
print("Parameterized quantum circuit")
print("Classical optimizer will tune params")
print(qc)',
  '[{"gate": "RY", "qubit": 0, "param": "θ₀"}, {"gate": "RY", "qubit": 1, "param": "θ₁"}, {"gate": "CNOT", "control": 0, "target": 1}]'::jsonb),

  (course8_id, 'VQE: Quantum Chemistry', 2,
  '# Variational Quantum Eigensolver (VQE)

VQE finds ground state energies of molecules - a killer app for quantum computing!

## The Problem:
Find minimum eigenvalue of molecular Hamiltonian H
Ground state energy E₀ = min⟨ψ|H|ψ⟩

## VQE Approach:
1. Prepare trial state |ψ(θ)⟩ with parameters θ
2. Measure energy ⟨ψ(θ)|H|ψ(θ)⟩
3. Classical optimizer adjusts θ to minimize energy
4. Repeat until convergence

## Ansatz Design:
Hardware-efficient ansatz:
- Rotation gates with parameters
- Entangling gates (CNOT)
- Multiple layers

Chemistry-inspired ansatz:
- Unitary coupled cluster (UCC)
- Based on quantum chemistry

## Applications:
- Drug discovery
- Materials science
- Catalyst design

VQE is already running on real quantum computers!',
  '# Simple VQE for H2 molecule
from qiskit import QuantumCircuit
import numpy as np

def h2_ansatz(theta):
    """Ansatz for H2 molecule (2 qubits)"""
    qc = QuantumCircuit(2)
    
    # Initial state
    qc.x(0)
    
    # Variational part
    qc.ry(theta[0], 0)
    qc.ry(theta[1], 1)
    qc.cx(0, 1)
    qc.ry(theta[2], 0)
    qc.ry(theta[3], 1)
    
    return qc

# Hamiltonian (simplified)
# In real VQE, use molecular Hamiltonian

theta = np.random.rand(4) * np.pi
qc = h2_ansatz(theta)

print("VQE circuit for H2 molecule")
print("Finds ground state energy")
print(qc)',
  '[{"gate": "X", "qubit": 0}, {"gate": "RY", "qubit": 0, "param": "θ₀"}, {"gate": "RY", "qubit": 1, "param": "θ₁"}, {"gate": "CNOT", "control": 0, "target": 1}]'::jsonb),

  (course8_id, 'QAOA: Optimization', 3,
  '# Quantum Approximate Optimization Algorithm

QAOA solves combinatorial optimization problems - MaxCut, TSP, scheduling, etc.

## Problem Setup:
Maximize (or minimize) objective function:
C(z) where z is a binary string

## QAOA Circuit:
Alternating layers of:
1. **Problem Hamiltonian**: Encodes objective function
2. **Mixer Hamiltonian**: Explores solution space

## Parameters:
- p layers (depth)
- 2p parameters: γ and β for each layer
- More layers → better approximation

## Algorithm:
1. Start in equal superposition
2. Apply p rounds of problem + mixer
3. Measure to get candidate solution
4. Classical optimizer tunes parameters
5. Repeat for better solutions

## Performance:
- p=1: Often beats random guessing
- p→∞: Approaches optimal solution
- Sweet spot: p=3-5 for NISQ devices

QAOA is one of the most promising near-term quantum algorithms!',
  '# QAOA for MaxCut problem
from qiskit import QuantumCircuit
import numpy as np

def qaoa_circuit(gamma, beta, p=1):
    """QAOA circuit with p layers"""
    qc = QuantumCircuit(4)
    
    # Initial state: equal superposition
    qc.h(range(4))
    
    # QAOA layers
    for layer in range(p):
        # Problem Hamiltonian (example graph)
        qc.rzz(2 * gamma[layer], 0, 1)
        qc.rzz(2 * gamma[layer], 1, 2)
        qc.rzz(2 * gamma[layer], 2, 3)
        
        # Mixer Hamiltonian
        for qubit in range(4):
            qc.rx(2 * beta[layer], qubit)
    
    qc.measure_all()
    return qc

# Parameters for 1 layer
gamma = [0.5]
beta = [0.3]

qc = qaoa_circuit(gamma, beta, p=1)
print("QAOA circuit for optimization")
print(qc)',
  '[{"gate": "H", "qubit": 0}, {"gate": "H", "qubit": 1}, {"gate": "H", "qubit": 2}, {"gate": "H", "qubit": 3}]'::jsonb),

  (course8_id, 'Ansatz Design', 4,
  '# Ansatz Design

Choosing the right ansatz is crucial for VQA performance!

## Hardware-Efficient Ansatz:
Designed for specific quantum hardware
- Uses native gates
- Minimizes circuit depth
- May not have physical meaning

Structure:
- Layers of single-qubit rotations
- Entangling gates
- Repeat

## Problem-Inspired Ansatz:
Based on problem structure
- Chemistry: UCC, UCCSD
- Optimization: Problem-specific symmetries
- Better convergence
- Potentially deeper circuits

## Design Principles:
1. **Expressibility**: Can represent diverse states
2. **Trainability**: Avoid barren plateaus
3. **Efficiency**: Shallow circuits for NISQ
4. **Symmetry**: Respect problem symmetries

## Barren Plateaus:
When gradients vanish exponentially with circuit depth
- Makes optimization impossible
- Careful ansatz design avoids this

Good ansatz design = successful VQA!',
  '# Compare ansatz designs
from qiskit import QuantumCircuit
import numpy as np

def hardware_efficient(params, n_qubits=3, depth=2):
    qc = QuantumCircuit(n_qubits)
    
    idx = 0
    for d in range(depth):
        # Rotation layer
        for q in range(n_qubits):
            qc.ry(params[idx], q)
            idx += 1
        
        # Entanglement layer
        for q in range(n_qubits - 1):
            qc.cx(q, q + 1)
    
    return qc

n_params = 3 * 2  # 3 qubits, 2 layers
params = np.random.rand(n_params) * 2 * np.pi

qc = hardware_efficient(params)
print("Hardware-efficient ansatz")
print("Shallow and practical for NISQ")
print(qc)',
  '[{"gate": "RY", "qubit": 0, "param": "θ₀"}, {"gate": "RY", "qubit": 1, "param": "θ₁"}, {"gate": "RY", "qubit": 2, "param": "θ₂"}]'::jsonb),

  (course8_id, 'Classical Optimization', 5,
  '# Classical Optimization for VQAs

The classical optimizer is half of the VQA - choosing the right one matters!

## Popular Optimizers:
1. **COBYLA**: Gradient-free, robust, slow
2. **SPSA**: Gradient approximation, fewer measurements
3. **Adam**: Gradient-based, fast when gradients available
4. **L-BFGS-B**: Quasi-Newton, good for smooth landscapes

## Measurement Strategy:
Each energy evaluation requires:
- Multiple circuit executions
- Different measurement bases
- Statistical sampling

## Parameter Initialization:
- Random: Simple but may start far from optimum
- Layerwise: Train one layer at a time
- Classical preprocessing: Use classical solutions

## Convergence:
Typical behavior:
- Fast initial improvement
- Slow final convergence
- May get stuck in local minima

## Practical Tips:
- Use SPSA for noisy hardware
- Limit measurements per evaluation
- Multiple random starts
- Combine optimizers

Optimization is critical for VQA success!',
  '# VQA optimization loop (pseudocode)
import numpy as np

def cost_function(params):
    """Evaluate quantum circuit"""
    # 1. Build circuit with params
    # 2. Run on quantum hardware
    # 3. Measure observable
    # 4. Return energy/cost
    return np.random.rand()  # Placeholder

def optimize_vqa(initial_params, max_iter=100):
    """Optimization loop"""
    params = initial_params
    history = []
    
    for iteration in range(max_iter):
        # Evaluate cost
        cost = cost_function(params)
        history.append(cost)
        
        # Update parameters
        # (Using optimizer like COBYLA, SPSA, etc.)
        gradient = np.random.randn(len(params)) * 0.1
        params = params - 0.01 * gradient
        
        print(f"Iter {iteration}: Cost = {cost:.4f}")
    
    return params, history

# Run optimization
params = np.random.rand(6) * 2 * np.pi
final_params, history = optimize_vqa(params, max_iter=10)
print("\\nOptimization complete!")',
  '[]'::jsonb);

  -- Course 9: Quantum Machine Learning
  INSERT INTO lessons (course_id, title, order_index, content, code_example, quantum_gates) VALUES
  (course9_id, 'Quantum ML Overview', 1,
  '# Quantum Machine Learning Overview

Combining quantum computing with machine learning opens exciting possibilities!

## What is Quantum ML?
Using quantum computers to:
- Speed up classical ML algorithms
- Create new quantum-native models
- Process quantum data

## Potential Advantages:
- Exponential speedup for certain problems
- Enhanced feature spaces (quantum kernels)
- Better optimization landscapes
- Natural handling of quantum data

## Categories:
1. **Quantum-enhanced**: Speedup classical ML
2. **Variational**: Parameterized quantum circuits as models
3. **Quantum data**: Learning from quantum systems

## Challenges:
- Limited qubits
- Noisy hardware
- Data loading bottleneck
- Proving quantum advantage

## Applications:
- Pattern recognition
- Generative models
- Quantum chemistry
- Optimization

## Current Status:
Active research, some promising results, no clear advantage yet for classical data

The intersection of quantum and ML is full of potential!',
  '# Quantum circuit as ML model
from qiskit import QuantumCircuit
import numpy as np

def quantum_model(x, weights):
    """
    Quantum circuit that processes input x
    Parameterized by weights (trainable)
    """
    qc = QuantumCircuit(2, 1)
    
    # Encode input data
    qc.ry(x[0], 0)
    qc.ry(x[1], 1)
    
    # Trainable layer
    qc.ry(weights[0], 0)
    qc.ry(weights[1], 1)
    qc.cx(0, 1)
    qc.ry(weights[2], 0)
    
    # Measure for output
    qc.measure(0, 0)
    
    return qc

# Example
x = np.array([0.5, 0.8])
weights = np.array([0.1, 0.3, 0.7])

qc = quantum_model(x, weights)
print("Quantum circuit as ML model")
print(qc)',
  '[{"gate": "RY", "qubit": 0, "param": "x₀"}, {"gate": "RY", "qubit": 1, "param": "x₁"}, {"gate": "RY", "qubit": 0, "param": "w₀"}]'::jsonb),

  (course9_id, 'Quantum Feature Maps', 2,
  '# Quantum Feature Maps

Feature maps encode classical data into quantum states - the first step in quantum ML!

## Why Feature Maps?
Transform classical data x into quantum state |φ(x)⟩
- Access exponentially large feature space
- Non-linear transformations naturally
- Enables quantum kernel methods

## Common Encodings:
1. **Angle encoding**: x → rotation angles
2. **Amplitude encoding**: x → state amplitudes
3. **Basis encoding**: x → computational basis

## ZZFeatureMap:
Popular feature map using ZZ interactions:
- U(x) = H⊗n exp(i Σ x_i x_j Z_i Z_j) H⊗n
- Creates entanglement between features
- Multiple layers for richer encoding

## Design Considerations:
- Number of qubits (dimension)
- Depth (expressiveness)
- Entanglement pattern
- Hardware compatibility

## Quantum Advantage:
Large feature space without explicit computation!

Good feature maps are key to quantum ML success!',
  '# Quantum feature map example
from qiskit import QuantumCircuit
import numpy as np

def feature_map(x, reps=2):
    """
    ZZ-style feature map
    x: input data (2 features)
    reps: number of repetitions
    """
    qc = QuantumCircuit(2)
    
    for rep in range(reps):
        # Encode features as rotations
        qc.h([0, 1])
        qc.rz(2 * x[0], 0)
        qc.rz(2 * x[1], 1)
        
        # Feature interaction
        qc.cx(0, 1)
        qc.rz(2 * x[0] * x[1], 1)
        qc.cx(0, 1)
    
    return qc

# Example data point
x = np.array([0.5, 0.3])
qc = feature_map(x, reps=2)

print("Feature map encodes data into quantum state")
print(qc)',
  '[{"gate": "H", "qubit": 0}, {"gate": "H", "qubit": 1}, {"gate": "RZ", "qubit": 0, "param": "2x₀"}, {"gate": "RZ", "qubit": 1, "param": "2x₁"}]'::jsonb),

  (course9_id, 'Quantum Neural Networks', 3,
  '# Quantum Neural Networks (QNN)

QNNs use parameterized quantum circuits as neural network layers!

## Structure:
Input → Feature Map → Variational Layer → Measurement → Output

## Variational Layer:
Parameterized gates that are trained:
- Rotation gates with trainable angles
- Entangling gates for non-linearity
- Multiple layers for depth

## Training:
Same as classical neural networks:
1. Forward pass: Run circuit, measure
2. Compute loss
3. Backpropagation: Calculate gradients
4. Update parameters

## Gradient Computation:
Parameter shift rule for quantum gradients:
∂⟨H⟩/∂θ = (⟨H⟩(θ+π/2) - ⟨H⟩(θ-π/2)) / 2

## Applications:
- Classification
- Regression  
- Generative modeling
- Reinforcement learning

## Challenges:
- Barren plateaus
- Limited qubits
- Training time

QNNs show promise but need more research!',
  '# Simple quantum neural network
from qiskit import QuantumCircuit
import numpy as np

def qnn(x, weights):
    """
    Quantum neural network
    x: input features
    weights: trainable parameters
    """
    qc = QuantumCircuit(2, 1)
    
    # Feature map (input layer)
    qc.ry(x[0], 0)
    qc.ry(x[1], 1)
    
    # Variational layer (hidden layer)
    qc.ry(weights[0], 0)
    qc.ry(weights[1], 1)
    qc.cx(0, 1)
    
    # Second layer
    qc.ry(weights[2], 0)
    qc.ry(weights[3], 1)
    qc.cx(1, 0)
    
    # Output
    qc.measure(0, 0)
    
    return qc

x = np.array([0.2, 0.8])
weights = np.random.rand(4) * np.pi

qc = qnn(x, weights)
print("Quantum Neural Network")
print(qc)',
  '[{"gate": "RY", "qubit": 0, "param": "x₀"}, {"gate": "RY", "qubit": 1, "param": "x₁"}, {"gate": "RY", "qubit": 0, "param": "w₀"}, {"gate": "RY", "qubit": 1, "param": "w₁"}]'::jsonb),

  (course9_id, 'Quantum Kernels', 4,
  '# Quantum Kernels

Quantum computers can compute kernels in exponentially large feature spaces!

## Kernel Methods:
Instead of explicit features, use kernel function:
K(x, x'') = ⟨φ(x)|φ(x'')⟩

Classical kernels: polynomial, RBF, etc.
Quantum kernels: overlap of quantum states!

## Quantum Kernel:
K_q(x, x'') = |⟨φ(x)|φ(x'')⟩|²

Where |φ(x)⟩ is quantum feature map

## Computing Quantum Kernel:
1. Prepare |φ(x)⟩
2. Apply inverse of feature map for x''
3. Measure overlap
4. Result is kernel value

## Quantum SVM:
Use quantum kernel with classical SVM:
- Compute kernel matrix on quantum computer
- Train SVM classically
- Predict using quantum kernel

## Advantage:
Access to exponentially large feature spaces!

## Practical Use:
Already demonstrated on real quantum hardware!

Quantum kernels are one of the most promising QML approaches!',
  '# Quantum kernel computation
from qiskit import QuantumCircuit
import numpy as np

def quantum_kernel_circuit(x1, x2):
    """
    Circuit to compute kernel K(x1, x2)
    Returns overlap |⟨φ(x1)|φ(x2)⟩|²
    """
    qc = QuantumCircuit(2, 2)
    
    # Prepare |φ(x1)⟩
    qc.ry(x1[0], 0)
    qc.ry(x1[1], 1)
    qc.cx(0, 1)
    
    # Apply inverse of |φ(x2)⟩
    qc.cx(0, 1)
    qc.ry(-x2[1], 1)
    qc.ry(-x2[0], 0)
    
    # Measure: |00⟩ probability = kernel value
    qc.measure([0, 1], [0, 1])
    
    return qc

x1 = np.array([0.3, 0.7])
x2 = np.array([0.4, 0.6])

qc = quantum_kernel_circuit(x1, x2)
print("Quantum kernel between two data points")
print(qc)',
  '[{"gate": "RY", "qubit": 0, "param": "x₁"}, {"gate": "RY", "qubit": 1, "param": "x₂"}, {"gate": "CNOT", "control": 0, "target": 1}]'::jsonb),

  (course9_id, 'Quantum GANs and Future', 5,
  '# Quantum Generative Models

Quantum computers can learn to generate quantum states - opening new possibilities!

## Quantum GANs:
Generator: Creates quantum states
Discriminator: Distinguishes real from generated
- Both are quantum circuits
- Adversarial training
- Can generate complex quantum states

## Quantum Boltzmann Machines:
- Learn probability distributions
- Natural for quantum data
- Potential exponential speedup

## Applications:
1. **Quantum State Preparation**: Learn to prepare complex states
2. **Quantum Data**: Generate synthetic quantum data
3. **Quantum Chemistry**: Learn molecular wavefunctions
4. **Quantum Simulation**: Model quantum systems

## Future Directions:
- Quantum transformers
- Quantum attention mechanisms
- Quantum reinforcement learning
- Hybrid quantum-classical models

## The Road Ahead:
- Need more qubits
- Better error correction
- Clearer quantum advantage
- Real-world applications

Quantum ML is still young but incredibly exciting!

Congratulations on completing Quantum Machine Learning!',
  '# Quantum GAN generator (simplified)
from qiskit import QuantumCircuit
import numpy as np

def quantum_generator(noise, weights):
    """
    Generator circuit for quantum GAN
    noise: random input
    weights: trainable parameters
    """
    qc = QuantumCircuit(3)
    
    # Encode noise
    for i in range(3):
        qc.ry(noise[i], i)
    
    # Trainable layers
    for layer in range(2):
        for i in range(3):
            qc.ry(weights[layer*3 + i], i)
        
        qc.cx(0, 1)
        qc.cx(1, 2)
        qc.cx(2, 0)
    
    return qc

noise = np.random.rand(3) * np.pi
weights = np.random.rand(6) * np.pi

qc = quantum_generator(noise, weights)
print("Quantum GAN generator")
print("Learns to create quantum states")
print(qc)',
  '[{"gate": "RY", "qubit": 0, "param": "z₀"}, {"gate": "RY", "qubit": 1, "param": "z₁"}, {"gate": "RY", "qubit": 2, "param": "z₂"}]'::jsonb);

  -- Course 10: Building Real Applications
  INSERT INTO lessons (course_id, title, order_index, content, code_example, quantum_gates) VALUES
  (course10_id, 'Real-World Quantum Development', 1,
  '# Real-World Quantum Development

Time to bring everything together and build production quantum applications!

## Development Workflow:
1. **Problem formulation**: Map problem to quantum
2. **Algorithm selection**: Choose appropriate algorithm
3. **Circuit design**: Implement and optimize
4. **Simulation**: Test on classical simulators
5. **Hardware execution**: Run on real quantum computers
6. **Error mitigation**: Handle noise and errors
7. **Analysis**: Validate and interpret results

## Tools and Platforms:
- **Qiskit** (IBM): Comprehensive framework
- **Cirq** (Google): Research-focused
- **PennyLane**: Quantum ML
- **Amazon Braket**: Multi-backend access

## Best Practices:
- Start with simulation
- Use noise models
- Implement error mitigation
- Validate results classically
- Document thoroughly

## Production Considerations:
- Job queuing and scheduling
- Cost management
- Result reproducibility
- Version control

You now have the skills to build real quantum applications!',
  '# Production quantum application template
from qiskit import QuantumCircuit, transpile
from qiskit_aer import AerSimulator

def quantum_application(input_data):
    """
    Template for production quantum app
    """
    # 1. Validate input
    assert len(input_data) > 0
    
    # 2. Build circuit
    qc = QuantumCircuit(3, 3)
    qc.h(range(3))
    # ... problem-specific gates
    qc.measure(range(3), range(3))
    
    # 3. Optimize for hardware
    qc_opt = transpile(qc, optimization_level=3)
    
    # 4. Execute
    simulator = AerSimulator()
    job = simulator.run(qc_opt, shots=1000)
    result = job.result()
    
    # 5. Post-process
    counts = result.get_counts()
    
    return counts

# Use the application
result = quantum_application([1, 2, 3])
print("Quantum application result:")
print(result)',
  '[{"gate": "H", "qubit": 0}, {"gate": "H", "qubit": 1}, {"gate": "H", "qubit": 2}]'::jsonb),

  (course10_id, 'Optimization Problem: Portfolio', 2,
  '# Real Application: Portfolio Optimization

Build a quantum application to optimize investment portfolios!

## Problem:
Given assets with expected returns and correlations:
- Maximize return
- Minimize risk
- Respect constraints (budget, diversification)

## Quantum Approach:
Use QAOA to solve quadratic optimization:
- Encode assets as qubits
- Objective function → problem Hamiltonian
- Find optimal allocation

## Implementation Steps:
1. Define asset parameters
2. Construct cost function
3. Build QAOA circuit
4. Optimize parameters
5. Decode solution
6. Validate against constraints

## Real-World Considerations:
- Transaction costs
- Rebalancing frequency
- Risk tolerance
- Market constraints

## Quantum Advantage?
For large portfolios (100+ assets), quantum may help
Currently: proof of concept stage

Let''s implement it!',
  '# Portfolio optimization with QAOA
import numpy as np
from qiskit import QuantumCircuit

def portfolio_qaoa(returns, risk_matrix, budget=2):
    """
    QAOA for portfolio optimization
    returns: expected return per asset
    risk_matrix: covariance matrix
    budget: number of assets to select
    """
    n_assets = len(returns)
    qc = QuantumCircuit(n_assets)
    
    # Initialize superposition
    qc.h(range(n_assets))
    
    # QAOA layers (simplified)
    gamma, beta = 0.5, 0.3
    
    # Problem Hamiltonian (encode risk and return)
    for i in range(n_assets):
        qc.rz(2 * gamma * returns[i], i)
    
    for i in range(n_assets):
        for j in range(i+1, n_assets):
            qc.rzz(2 * gamma * risk_matrix[i,j], i, j)
    
    # Mixer Hamiltonian
    for i in range(n_assets):
        qc.rx(2 * beta, i)
    
    qc.measure_all()
    
    return qc

# Example: 4 assets
returns = np.array([0.05, 0.08, 0.06, 0.09])
risk = np.random.rand(4, 4) * 0.01

qc = portfolio_qaoa(returns, risk)
print("Portfolio optimization circuit")
print(qc)',
  '[{"gate": "H", "qubit": 0}, {"gate": "H", "qubit": 1}, {"gate": "H", "qubit": 2}, {"gate": "H", "qubit": 3}]'::jsonb),

  (course10_id, 'Chemistry: Drug Discovery', 3,
  '# Real Application: Drug Discovery

Use VQE to simulate molecules and discover new drugs!

## The Challenge:
Understanding molecular properties requires solving Schrödinger equation
- Exponentially hard classically
- Natural for quantum computers

## VQE for Molecules:
1. **Map**: Molecule → qubit Hamiltonian
2. **Prepare**: Quantum state ansatz
3. **Measure**: Energy expectation
4. **Optimize**: Find ground state
5. **Analyze**: Extract properties

## Key Properties:
- Binding energy
- Reaction barriers
- Excited states
- Electronic structure

## Real Example: LiH:
Lithium hydride molecule
- 12 spin orbitals → 12 qubits
- VQE finds ground state
- Compare to experimental data

## Drug Discovery Pipeline:
1. Identify drug target
2. Screen candidates
3. Simulate binding
4. Optimize properties
5. Synthesize and test

Quantum computers could accelerate discovery by years!',
  '# VQE for LiH molecule (simplified)
from qiskit import QuantumCircuit
import numpy as np

def lih_vqe_circuit(theta):
    """
    VQE circuit for LiH
    Simplified 4-qubit model
    """
    qc = QuantumCircuit(4)
    
    # Hartree-Fock initial state
    qc.x([0, 1])  # Occupied orbitals
    
    # UCCSD-inspired ansatz
    # Single excitations
    qc.ry(theta[0], 0)
    qc.cx(0, 2)
    qc.ry(theta[1], 1)
    qc.cx(1, 3)
    
    # Double excitations
    qc.cx(0, 1)
    qc.ry(theta[2], 1)
    qc.cx(2, 3)
    qc.ry(theta[3], 3)
    qc.cx(0, 1)
    
    return qc

# Initial parameters
theta = np.array([0.1, 0.2, 0.15, 0.25])

qc = lih_vqe_circuit(theta)
print("VQE circuit for LiH molecule")
print("Finds ground state energy")
print(qc)',
  '[{"gate": "X", "qubit": 0}, {"gate": "X", "qubit": 1}, {"gate": "RY", "qubit": 0, "param": "θ₀"}, {"gate": "CNOT", "control": 0, "target": 2}]'::jsonb),

  (course10_id, 'Machine Learning: Classification', 4,
  '# Real Application: Quantum Classification

Build a quantum classifier for real data!

## Problem:
Classify data points into categories
Example: Fraud detection, image recognition, medical diagnosis

## Quantum Approach:
1. **Feature map**: Encode classical data
2. **Variational circuit**: Parameterized quantum model
3. **Measurement**: Extract prediction
4. **Training**: Optimize parameters

## Architecture:
Input → Feature Map → QNN Layers → Measurement → Prediction

## Loss Function:
- Classification: Cross-entropy
- Regression: Mean squared error

## Training Loop:
1. Forward pass
2. Calculate loss
3. Compute gradients (parameter shift)
4. Update parameters
5. Repeat until convergence

## Evaluation:
- Accuracy on test set
- Compare to classical baseline
- Analyze quantum advantage

Let''s build a complete classifier!',
  '# Complete quantum classifier
from qiskit import QuantumCircuit
import numpy as np

def quantum_classifier(x, weights, n_layers=2):
    """
    Full quantum classifier
    x: input features
    weights: trainable parameters
    """
    n_qubits = len(x)
    qc = QuantumCircuit(n_qubits, 1)
    
    # Feature map layer
    for i in range(n_qubits):
        qc.h(i)
        qc.rz(2 * x[i], i)
    
    # Entangling layer
    for i in range(n_qubits - 1):
        qc.cx(i, i + 1)
    
    # Variational layers
    idx = 0
    for layer in range(n_layers):
        for i in range(n_qubits):
            qc.ry(weights[idx], i)
            idx += 1
        
        for i in range(n_qubits - 1):
            qc.cx(i, i + 1)
    
    # Measurement for classification
    qc.measure(0, 0)
    
    return qc

# Example
x = np.array([0.5, 0.3, 0.8])
weights = np.random.rand(6) * np.pi

qc = quantum_classifier(x, weights)
print("Quantum classifier ready!")
print(qc)',
  '[{"gate": "H", "qubit": 0}, {"gate": "H", "qubit": 1}, {"gate": "H", "qubit": 2}, {"gate": "RZ", "qubit": 0, "param": "2x₀"}]'::jsonb),

  (course10_id, 'Deployment and Production', 5,
  '# Deployment and Production

Taking your quantum application from prototype to production!

## Deployment Checklist:
- ✓ Validated on simulators
- ✓ Tested on real hardware
- ✓ Error mitigation implemented
- ✓ Performance benchmarked
- ✓ Documentation complete
- ✓ Monitoring in place

## Cloud Platforms:
- **IBM Quantum**: Job queue, real devices
- **AWS Braket**: Multiple backends
- **Azure Quantum**: Microsoft ecosystem
- **Google Quantum AI**: Research access

## Production Architecture:
```
Client → API Gateway → Quantum Service → Queue → QPU
                     ↓
                  Classical Post-processing
```

## Monitoring:
- Job success rates
- Queue times
- Circuit fidelity
- Cost tracking

## Continuous Improvement:
- A/B testing circuits
- Error rate monitoring
- Algorithm updates
- Hardware upgrades

## The Future is Quantum:
You now have everything needed to build real quantum applications!
- Keep learning
- Experiment on real hardware
- Join the quantum community
- Build the future

Congratulations on completing the entire quantum computing course!',
  '# Production deployment example
class QuantumApplication:
    """Production-ready quantum app"""
    
    def __init__(self, backend=''simulator''):
        self.backend = backend
        self.circuit_cache = {}
        self.result_history = []
    
    def run(self, input_data, shots=1000):
        """Execute quantum circuit"""
        # 1. Validate input
        self._validate(input_data)
        
        # 2. Get or build circuit
        circuit = self._get_circuit(input_data)
        
        # 3. Execute with error handling
        try:
            result = self._execute(circuit, shots)
            self.result_history.append(result)
            return self._post_process(result)
        except Exception as e:
            self._log_error(e)
            return self._fallback_classical(input_data)
    
    def _validate(self, data):
        """Validate input data"""
        assert data is not None
    
    def _get_circuit(self, data):
        """Build or retrieve circuit"""
        return "circuit"
    
    def _execute(self, circuit, shots):
        """Run on quantum hardware"""
        return {"result": "success"}
    
    def _post_process(self, result):
        """Process quantum results"""
        return result
    
    def _log_error(self, error):
        """Log errors"""
        print(f"Error: {error}")
    
    def _fallback_classical(self, data):
        """Classical fallback"""
        return {"fallback": True}

app = QuantumApplication()
result = app.run([1, 2, 3])
print("Production quantum app ready!")
print(result)',
  '[]'::jsonb);

END $$;
