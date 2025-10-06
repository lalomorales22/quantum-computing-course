import { useState, useEffect } from 'react';
import { supabase, type Course } from './lib/supabase';
import CourseList from './components/CourseList';
import CourseView from './components/CourseView';

function App() {
  const [courses, setCourses] = useState<Course[]>([]);
  const [selectedCourseId, setSelectedCourseId] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadCourses();
  }, []);

  const loadCourses = async () => {
    try {
      const { data, error } = await supabase
        .from('courses')
        .select('*')
        .order('order_index');

      if (error) throw error;
      setCourses(data || []);
    } catch (error) {
      console.error('Error loading courses:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-slate-950 flex items-center justify-center">
        <div className="text-slate-400 text-lg">Loading quantum courses...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-950">
      {!selectedCourseId ? (
        <CourseList
          courses={courses}
          onSelectCourse={setSelectedCourseId}
        />
      ) : (
        <CourseView
          courseId={selectedCourseId}
          onBack={() => setSelectedCourseId(null)}
        />
      )}
    </div>
  );
}

export default App;
