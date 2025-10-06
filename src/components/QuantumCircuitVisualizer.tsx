interface Gate {
  gate: string;
  qubit?: number;
  control?: number;
  target?: number;
  qubits?: number[];
  param?: string;
}

interface QuantumCircuitVisualizerProps {
  gates: Gate[];
}

export default function QuantumCircuitVisualizer({ gates }: QuantumCircuitVisualizerProps) {
  if (!gates || gates.length === 0) {
    return (
      <div className="h-full flex items-center justify-center bg-slate-900 rounded-lg border border-slate-800">
        <div className="text-center">
          <div className="text-slate-600 text-6xl mb-4">◯━━━━━◯</div>
          <p className="text-slate-400 text-lg">No quantum circuit to visualize</p>
          <p className="text-slate-500 text-sm mt-2">Gates will appear here when available</p>
        </div>
      </div>
    );
  }

  const maxQubit = Math.max(
    ...gates.map(g =>
      Math.max(
        g.qubit ?? -1,
        g.control ?? -1,
        g.target ?? -1,
        ...(g.qubits || [])
      )
    )
  );
  const numQubits = maxQubit + 1;
  const qubitLines = Array.from({ length: numQubits }, (_, i) => i);

  return (
    <div className="h-full flex flex-col bg-slate-900 rounded-lg border border-slate-800 overflow-auto">
      <div className="p-6 border-b border-slate-800">
        <h3 className="text-lg font-semibold text-white mb-2">Quantum Circuit Visualization</h3>
        <p className="text-sm text-slate-400">
          Visual representation of the quantum gates and operations in this lesson
        </p>
      </div>

      <div className="flex-1 p-8">
        <div className="inline-block min-w-full">
          <div className="relative">
            {qubitLines.map(qubit => (
              <div key={qubit} className="flex items-center mb-8 last:mb-0">
                <div className="w-16 text-cyan-400 font-mono text-sm font-semibold">
                  |q{qubit}⟩
                </div>

                <div className="flex-1 flex items-center gap-8">
                  <div className="flex-1 h-0.5 bg-slate-700 relative"></div>

                  {gates.map((gate, gateIdx) => {
                    const isOnThisQubit =
                      gate.qubit === qubit ||
                      gate.control === qubit ||
                      gate.target === qubit ||
                      gate.qubits?.includes(qubit);

                    if (!isOnThisQubit) return null;

                    const isControl = gate.control === qubit;
                    const isTarget = gate.target === qubit;

                    return (
                      <div
                        key={gateIdx}
                        className="absolute"
                        style={{ left: `${(gateIdx + 1) * 120}px` }}
                      >
                        {gate.gate === 'CNOT' && isControl && (
                          <div className="relative">
                            <div className="w-4 h-4 rounded-full bg-cyan-400 border-2 border-cyan-300 absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2"></div>
                            {gate.target !== undefined && (
                              <div
                                className="absolute left-1/2 w-0.5 bg-cyan-400"
                                style={{
                                  top: '50%',
                                  height: `${Math.abs((gate.target - qubit) * 64)}px`,
                                  transform: gate.target > qubit ? 'translateX(-50%)' : 'translateX(-50%) translateY(-100%)'
                                }}
                              ></div>
                            )}
                          </div>
                        )}

                        {gate.gate === 'CNOT' && isTarget && (
                          <div className="relative">
                            <div className="w-8 h-8 rounded-full border-2 border-cyan-400 bg-slate-900 flex items-center justify-center absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2">
                              <div className="text-cyan-400 font-bold text-lg">⊕</div>
                            </div>
                          </div>
                        )}

                        {gate.gate !== 'CNOT' && (gate.qubit === qubit || gate.qubits?.includes(qubit)) && (
                          <div className="relative">
                            <div className="px-4 py-2 bg-cyan-500 text-white font-bold text-sm rounded border-2 border-cyan-400 absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 whitespace-nowrap shadow-lg">
                              {gate.gate}
                              {gate.param && (
                                <span className="text-xs ml-1">({gate.param})</span>
                              )}
                            </div>
                          </div>
                        )}

                        {gate.gate === 'CCZ' && gate.qubits?.includes(qubit) && (
                          <div className="relative">
                            <div className="w-4 h-4 rounded-full bg-purple-400 border-2 border-purple-300 absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2"></div>
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>

                <div className="w-12 text-slate-600 font-mono text-sm text-right">
                  q{qubit}
                </div>
              </div>
            ))}
          </div>

          <div className="mt-12 pt-6 border-t border-slate-800">
            <div className="text-sm text-slate-400 space-y-2">
              <div className="font-semibold text-slate-300 mb-3">Gate Legend:</div>
              <div className="grid grid-cols-2 gap-4">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-8 bg-cyan-500 rounded border-2 border-cyan-400 flex items-center justify-center">
                    <span className="text-white font-bold text-xs">H</span>
                  </div>
                  <span>Hadamard Gate - Creates superposition</span>
                </div>
                <div className="flex items-center gap-3">
                  <div className="w-12 h-8 bg-cyan-500 rounded border-2 border-cyan-400 flex items-center justify-center">
                    <span className="text-white font-bold text-xs">X</span>
                  </div>
                  <span>Pauli-X Gate - Quantum NOT</span>
                </div>
                <div className="flex items-center gap-3">
                  <div className="flex items-center gap-1">
                    <div className="w-3 h-3 rounded-full bg-cyan-400 border-2 border-cyan-300"></div>
                    <div className="w-6 h-6 rounded-full border-2 border-cyan-400 flex items-center justify-center">
                      <span className="text-cyan-400 font-bold text-sm">⊕</span>
                    </div>
                  </div>
                  <span>CNOT - Controlled NOT</span>
                </div>
                <div className="flex items-center gap-3">
                  <div className="w-12 h-8 bg-cyan-500 rounded border-2 border-cyan-400 flex items-center justify-center">
                    <span className="text-white font-bold text-xs">Z</span>
                  </div>
                  <span>Pauli-Z Gate - Phase flip</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
