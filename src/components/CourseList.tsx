import { type Course } from '../lib/supabase';
import * as LucideIcons from 'lucide-react';

interface CourseListProps {
  courses: Course[];
  onSelectCourse: (courseId: string) => void;
}

export default function CourseList({ courses, onSelectCourse }: CourseListProps) {
  const getIcon = (iconName: string) => {
    const Icon = (LucideIcons as any)[iconName] || LucideIcons.BookOpen;
    return Icon;
  };

  return (
    <div className="min-h-screen bg-slate-950 p-8">
      <div className="max-w-7xl mx-auto">
        <div className="mb-12">
          <div className="flex items-center gap-3 mb-4">
            <LucideIcons.Sparkles className="w-10 h-10 text-cyan-400" />
            <h1 className="text-5xl font-bold text-white">
              Quantum Computing Course
            </h1>
          </div>
          <p className="text-slate-400 text-lg max-w-3xl">
            Master quantum computing from the ground up. Learn quantum mechanics principles,
            quantum algorithms, and build real quantum applications with hands-on coding experience.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {courses.map((course, index) => {
            const Icon = getIcon(course.icon);
            return (
              <button
                key={course.id}
                onClick={() => onSelectCourse(course.id)}
                className="group bg-slate-900 rounded-lg p-6 text-left transition-all duration-200 hover:bg-slate-800 border border-slate-800 hover:border-cyan-500/30"
              >
                <div className="flex items-start gap-4 mb-4">
                  <div className="flex-shrink-0 w-12 h-12 rounded-lg bg-cyan-500/10 flex items-center justify-center border border-cyan-500/20 group-hover:border-cyan-500/40 transition-colors">
                    <Icon className="w-6 h-6 text-cyan-400" />
                  </div>
                  <div className="flex-1">
                    <div className="text-xs font-semibold text-cyan-400 mb-1">
                      COURSE {index + 1}
                    </div>
                    <h3 className="text-lg font-semibold text-white mb-2 group-hover:text-cyan-400 transition-colors">
                      {course.title}
                    </h3>
                  </div>
                </div>

                <p className="text-slate-400 text-sm mb-4 leading-relaxed">
                  {course.description}
                </p>

                <div className="flex items-center justify-between pt-4 border-t border-slate-800">
                  <div className="flex items-center gap-2 text-xs text-slate-500">
                    <LucideIcons.Clock className="w-3.5 h-3.5" />
                    {course.duration}
                  </div>
                  <div className="flex items-center gap-1 text-xs text-cyan-400 font-medium group-hover:gap-2 transition-all">
                    Start Learning
                    <LucideIcons.ArrowRight className="w-3.5 h-3.5" />
                  </div>
                </div>
              </button>
            );
          })}
        </div>

        <div className="mt-12 p-6 bg-slate-900 rounded-lg border border-slate-800">
          <div className="flex items-start gap-4">
            <div className="flex-shrink-0 w-12 h-12 rounded-lg bg-cyan-500/10 flex items-center justify-center border border-cyan-500/20">
              <LucideIcons.Lightbulb className="w-6 h-6 text-cyan-400" />
            </div>
            <div>
              <h3 className="text-lg font-semibold text-white mb-2">
                Interactive Learning Experience
              </h3>
              <p className="text-slate-400 text-sm leading-relaxed">
                Each course includes comprehensive theory, practical code examples, and an integrated
                quantum IDE for hands-on practice. Write and execute quantum circuits directly in your browser.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
