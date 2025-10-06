import { useState, useEffect } from 'react';
import { ArrowLeft, BookOpen, CheckCircle2, Circle } from 'lucide-react';
import { supabase, type Course, type Lesson } from '../lib/supabase';
import LessonContent from './LessonContent';

interface CourseViewProps {
  courseId: string;
  onBack: () => void;
}

export default function CourseView({ courseId, onBack }: CourseViewProps) {
  const [course, setCourse] = useState<Course | null>(null);
  const [lessons, setLessons] = useState<Lesson[]>([]);
  const [selectedLessonId, setSelectedLessonId] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadCourseAndLessons();
  }, [courseId]);

  const loadCourseAndLessons = async () => {
    try {
      const [courseResult, lessonsResult] = await Promise.all([
        supabase.from('courses').select('*').eq('id', courseId).maybeSingle(),
        supabase.from('lessons').select('*').eq('course_id', courseId).order('order_index')
      ]);

      if (courseResult.error) throw courseResult.error;
      if (lessonsResult.error) throw lessonsResult.error;

      setCourse(courseResult.data);
      setLessons(lessonsResult.data || []);

      if (lessonsResult.data && lessonsResult.data.length > 0) {
        setSelectedLessonId(lessonsResult.data[0].id);
      }
    } catch (error) {
      console.error('Error loading course:', error);
    } finally {
      setLoading(false);
    }
  };

  const selectedLesson = lessons.find(l => l.id === selectedLessonId);

  if (loading) {
    return (
      <div className="min-h-screen bg-slate-950 flex items-center justify-center">
        <div className="text-slate-400 text-lg">Loading course...</div>
      </div>
    );
  }

  if (!course) {
    return (
      <div className="min-h-screen bg-slate-950 flex items-center justify-center">
        <div className="text-slate-400 text-lg">Course not found</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-950 flex">
      <div className="w-80 bg-slate-900 border-r border-slate-800 flex flex-col">
        <div className="p-6 border-b border-slate-800">
          <button
            onClick={onBack}
            className="flex items-center gap-2 text-slate-400 hover:text-cyan-400 transition-colors mb-4"
          >
            <ArrowLeft className="w-4 h-4" />
            Back to Courses
          </button>
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-cyan-500/10 flex items-center justify-center border border-cyan-500/20">
              <BookOpen className="w-5 h-5 text-cyan-400" />
            </div>
            <div>
              <div className="text-xs text-cyan-400 font-semibold">
                COURSE {course.order_index}
              </div>
              <h2 className="text-lg font-bold text-white">
                {course.title}
              </h2>
            </div>
          </div>
        </div>

        <div className="flex-1 overflow-auto">
          <div className="p-4">
            <div className="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-3">
              Lessons
            </div>
            <div className="space-y-1">
              {lessons.map((lesson, index) => (
                <button
                  key={lesson.id}
                  onClick={() => setSelectedLessonId(lesson.id)}
                  className={`w-full text-left p-3 rounded-lg transition-all border ${
                    selectedLessonId === lesson.id
                      ? 'bg-cyan-500/10 border-cyan-500/30 text-white'
                      : 'bg-slate-800/50 border-slate-800 text-slate-400 hover:bg-slate-800 hover:text-slate-300'
                  }`}
                >
                  <div className="flex items-start gap-3">
                    <div className="flex-shrink-0 mt-0.5">
                      {selectedLessonId === lesson.id ? (
                        <CheckCircle2 className="w-4 h-4 text-cyan-400" />
                      ) : (
                        <Circle className="w-4 h-4" />
                      )}
                    </div>
                    <div className="flex-1">
                      <div className="text-xs font-semibold mb-1 opacity-60">
                        Lesson {index + 1}
                      </div>
                      <div className="text-sm font-medium">
                        {lesson.title}
                      </div>
                    </div>
                  </div>
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>

      <div className="flex-1">
        {selectedLesson ? (
          <LessonContent lesson={selectedLesson} />
        ) : (
          <div className="h-full flex items-center justify-center text-slate-400">
            Select a lesson to begin
          </div>
        )}
      </div>
    </div>
  );
}
