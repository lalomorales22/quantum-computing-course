import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export type Course = {
  id: string;
  title: string;
  description: string;
  order_index: number;
  icon: string;
  duration: string;
  created_at: string;
};

export type Lesson = {
  id: string;
  course_id: string;
  title: string;
  order_index: number;
  content: string;
  code_example: string;
  quantum_gates: Array<{
    gate: string;
    qubit?: number;
    control?: number;
    target?: number;
    qubits?: number[];
    param?: string;
  }>;
  created_at: string;
};

export type UserProgress = {
  id: string;
  user_id: string;
  lesson_id: string;
  completed: boolean;
  code_snapshot: string;
  completed_at: string | null;
  created_at: string;
};
