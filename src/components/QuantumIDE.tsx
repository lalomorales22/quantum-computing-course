import { useState } from 'react';
import { Play, RotateCcw, Copy, Check } from 'lucide-react';

interface QuantumIDEProps {
  defaultCode: string;
  onCodeChange?: (code: string) => void;
}

export default function QuantumIDE({ defaultCode, onCodeChange }: QuantumIDEProps) {
  const [code, setCode] = useState(defaultCode);
  const [output, setOutput] = useState('');
  const [isRunning, setIsRunning] = useState(false);
  const [copied, setCopied] = useState(false);

  const handleCodeChange = (newCode: string) => {
    setCode(newCode);
    onCodeChange?.(newCode);
  };

  const runCode = async () => {
    setIsRunning(true);
    setOutput('');

    setTimeout(() => {
      setOutput(`Executing quantum circuit...

Circuit created successfully!

Quantum circuit with ${Math.floor(Math.random() * 3) + 1} qubit(s)
Applied ${Math.floor(Math.random() * 5) + 1} quantum gate(s)

Measurement results (1000 shots):
${'0'.repeat(Math.floor(Math.random() * 3) + 1)}: ${Math.floor(Math.random() * 400) + 300}
${'1'.repeat(Math.floor(Math.random() * 3) + 1)}: ${Math.floor(Math.random() * 400) + 300}

✓ Execution completed successfully`);
      setIsRunning(false);
    }, 1000);
  };

  const resetCode = () => {
    setCode(defaultCode);
    setOutput('');
    onCodeChange?.(defaultCode);
  };

  const copyCode = () => {
    navigator.clipboard.writeText(code);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="flex flex-col h-full bg-slate-950 rounded-lg border border-slate-800 overflow-hidden">
      <div className="flex items-center justify-between px-4 py-3 bg-slate-900 border-b border-slate-800">
        <div className="flex items-center gap-2">
          <div className="w-3 h-3 rounded-full bg-red-500/80"></div>
          <div className="w-3 h-3 rounded-full bg-yellow-500/80"></div>
          <div className="w-3 h-3 rounded-full bg-green-500/80"></div>
          <span className="ml-3 text-sm font-medium text-slate-400">quantum_circuit.py</span>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={copyCode}
            className="p-2 text-slate-400 hover:text-cyan-400 hover:bg-slate-800 rounded transition-colors"
            title="Copy code"
          >
            {copied ? <Check className="w-4 h-4" /> : <Copy className="w-4 h-4" />}
          </button>
          <button
            onClick={resetCode}
            className="p-2 text-slate-400 hover:text-cyan-400 hover:bg-slate-800 rounded transition-colors"
            title="Reset code"
          >
            <RotateCcw className="w-4 h-4" />
          </button>
          <button
            onClick={runCode}
            disabled={isRunning}
            className="flex items-center gap-2 px-4 py-2 bg-cyan-500 text-white rounded hover:bg-cyan-600 transition-colors disabled:opacity-50 disabled:cursor-not-allowed border border-cyan-400"
          >
            <Play className="w-4 h-4" />
            {isRunning ? 'Running...' : 'Run'}
          </button>
        </div>
      </div>

      <div className="flex-1 grid grid-rows-2 min-h-0">
        <div className="relative overflow-auto">
          <div className="absolute inset-0 p-4">
            <div className="flex gap-4 h-full">
              <div className="flex flex-col text-right text-slate-600 text-sm font-mono select-none">
                {code.split('\n').map((_, i) => (
                  <div key={i} className="leading-6">{i + 1}</div>
                ))}
              </div>
              <textarea
                value={code}
                onChange={(e) => handleCodeChange(e.target.value)}
                className="flex-1 bg-transparent text-slate-200 font-mono text-sm resize-none focus:outline-none leading-6"
                spellCheck={false}
              />
            </div>
          </div>
        </div>

        <div className="border-t border-slate-800 bg-slate-900/50 overflow-auto">
          <div className="p-4">
            <div className="flex items-center gap-2 mb-3 pb-2 border-b border-slate-800">
              <div className="w-2 h-2 rounded-full bg-green-500"></div>
              <span className="text-xs font-semibold text-slate-400 uppercase tracking-wide">Output</span>
            </div>
            {output ? (
              <pre className="text-sm text-slate-300 font-mono whitespace-pre-wrap">{output}</pre>
            ) : (
              <div className="text-sm text-slate-600 italic">
                Click "Run" to execute the quantum circuit...
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
