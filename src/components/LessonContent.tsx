import { useState } from 'react';
import { type Lesson } from '../lib/supabase';
import QuantumIDE from './QuantumIDE';
import QuantumCircuitVisualizer from './QuantumCircuitVisualizer';

interface LessonContentProps {
  lesson: Lesson;
}

export default function LessonContent({ lesson }: LessonContentProps) {
  const [activeTab, setActiveTab] = useState<'content' | 'circuit'>('content');

  const renderMarkdown = (content: string) => {
    const lines = content.split('\n');
    const elements: JSX.Element[] = [];
    let i = 0;

    while (i < lines.length) {
      const line = lines[i];

      if (line.startsWith('# ')) {
        elements.push(
          <h1 key={i} className="text-3xl font-bold text-white mb-4 mt-6">
            {line.replace('# ', '')}
          </h1>
        );
      } else if (line.startsWith('## ')) {
        elements.push(
          <h2 key={i} className="text-2xl font-semibold text-white mb-3 mt-6">
            {line.replace('## ', '')}
          </h2>
        );
      } else if (line.startsWith('### ')) {
        elements.push(
          <h3 key={i} className="text-xl font-semibold text-cyan-400 mb-2 mt-4">
            {line.replace('### ', '')}
          </h3>
        );
      } else if (line.startsWith('- ')) {
        const listItems: string[] = [];
        while (i < lines.length && lines[i].startsWith('- ')) {
          listItems.push(lines[i].replace('- ', ''));
          i++;
        }
        elements.push(
          <ul key={i} className="list-disc list-inside space-y-2 mb-4 text-slate-300">
            {listItems.map((item, idx) => {
              const boldRegex = /\*\*(.*?)\*\*/g;
              const parts: (string | JSX.Element)[] = [];
              let lastIndex = 0;
              let match;

              while ((match = boldRegex.exec(item)) !== null) {
                if (match.index > lastIndex) {
                  parts.push(item.substring(lastIndex, match.index));
                }
                parts.push(
                  <strong key={match.index} className="font-semibold text-white">
                    {match[1]}
                  </strong>
                );
                lastIndex = match.index + match[0].length;
              }

              if (lastIndex < item.length) {
                parts.push(item.substring(lastIndex));
              }

              return <li key={idx}>{parts}</li>;
            })}
          </ul>
        );
        continue;
      } else if (line.startsWith('```')) {
        const codeLines: string[] = [];
        i++;
        while (i < lines.length && !lines[i].startsWith('```')) {
          codeLines.push(lines[i]);
          i++;
        }
        elements.push(
          <pre key={i} className="bg-slate-900 rounded-lg p-4 mb-4 overflow-x-auto border border-slate-800">
            <code className="text-sm text-slate-300 font-mono">
              {codeLines.join('\n')}
            </code>
          </pre>
        );
      } else if (line.trim()) {
        const boldRegex = /\*\*(.*?)\*\*/g;
        const parts: (string | JSX.Element)[] = [];
        let lastIndex = 0;
        let match;

        while ((match = boldRegex.exec(line)) !== null) {
          if (match.index > lastIndex) {
            parts.push(line.substring(lastIndex, match.index));
          }
          parts.push(
            <strong key={match.index} className="font-semibold text-white">
              {match[1]}
            </strong>
          );
          lastIndex = match.index + match[0].length;
        }

        if (lastIndex < line.length) {
          parts.push(line.substring(lastIndex));
        }

        elements.push(
          <p key={i} className="text-slate-300 mb-4 leading-relaxed">
            {parts}
          </p>
        );
      }
      i++;
    }

    return elements;
  };

  return (
    <div className="h-screen flex flex-col">
      <div className="border-b border-slate-800 bg-slate-900">
        <div className="flex">
          <button
            onClick={() => setActiveTab('content')}
            className={`px-6 py-4 font-medium transition-all border-b-2 ${
              activeTab === 'content'
                ? 'text-cyan-400 border-cyan-400'
                : 'text-slate-400 border-transparent hover:text-slate-300'
            }`}
          >
            Lesson Content
          </button>
          <button
            onClick={() => setActiveTab('circuit')}
            className={`px-6 py-4 font-medium transition-all border-b-2 ${
              activeTab === 'circuit'
                ? 'text-cyan-400 border-cyan-400'
                : 'text-slate-400 border-transparent hover:text-slate-300'
            }`}
          >
            Quantum Circuit
          </button>
        </div>
      </div>

      <div className="flex-1 overflow-hidden">
        {activeTab === 'content' ? (
          <div className="h-full grid grid-cols-2 gap-6 p-6">
            <div className="overflow-auto pr-4">
              <div className="max-w-3xl">
                {renderMarkdown(lesson.content)}
              </div>
            </div>
            <div className="h-full">
              <QuantumIDE defaultCode={lesson.code_example} />
            </div>
          </div>
        ) : (
          <div className="h-full p-6">
            <QuantumCircuitVisualizer gates={lesson.quantum_gates || []} />
          </div>
        )}
      </div>
    </div>
  );
}
