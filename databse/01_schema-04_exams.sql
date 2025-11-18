-- =============================================
-- 01_schema/04_exams.sql - 考试系统表
-- =============================================

-- 8. 考试表 (Exams)
CREATE TABLE exams (
    exam_id SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL REFERENCES courses(course_id) ON DELETE CASCADE,
    exam_title VARCHAR(200) NOT NULL,
    description TEXT,
    exam_type VARCHAR(20) DEFAULT 'Mixed' CHECK (exam_type IN ('MCQ', 'Short Answer', 'Mixed')),
    duration INTEGER, -- 考试时长（分钟）
    total_marks DECIMAL(5,2) DEFAULT 0,
    passing_marks DECIMAL(5,2) DEFAULT 0,
    created_by INTEGER NOT NULL REFERENCES users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    allow_review BOOLEAN DEFAULT TRUE,
    shuffle_questions BOOLEAN DEFAULT FALSE
);

-- 9. 题目表 (Questions)
CREATE TABLE questions (
    question_id SERIAL PRIMARY KEY,
    exam_id INTEGER NOT NULL REFERENCES exams(exam_id) ON DELETE CASCADE,
    question_type VARCHAR(20) NOT NULL CHECK (question_type IN ('MCQ', 'Short Answer')),
    question_text TEXT NOT NULL,
    marks DECIMAL(5,2) NOT NULL DEFAULT 1,
    sequence_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. 选择题选项表 (MCQ_Options)
CREATE TABLE mcq_options (
    option_id SERIAL PRIMARY KEY,
    question_id INTEGER NOT NULL REFERENCES questions(question_id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    sequence_order INTEGER DEFAULT 0
);

-- 11. 简答题答案表 (Short_Answer_Keys)
CREATE TABLE short_answer_keys (
    answer_key_id SERIAL PRIMARY KEY,
    question_id INTEGER NOT NULL REFERENCES questions(question_id) ON DELETE CASCADE,
    model_answer TEXT NOT NULL,
    keywords TEXT[] -- 关键词数组，用于评分参考
);

-- 12. 考试尝试表 (Exam_Attempts)
CREATE TABLE exam_attempts (
    attempt_id SERIAL PRIMARY KEY,
    exam_id INTEGER NOT NULL REFERENCES exams(exam_id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP,
    score DECIMAL(5,2),
    total_marks DECIMAL(5,2),
    status VARCHAR(20) DEFAULT 'In Progress' CHECK (status IN ('In Progress', 'Completed', 'Abandoned')),
    is_passed BOOLEAN,
    graded_by INTEGER REFERENCES users(user_id),
    graded_at TIMESTAMP
);

-- 13. 学生答案表 (Student_Answers)
CREATE TABLE student_answers (
    answer_id SERIAL PRIMARY KEY,
    attempt_id INTEGER NOT NULL REFERENCES exam_attempts(attempt_id) ON DELETE CASCADE,
    question_id INTEGER NOT NULL REFERENCES questions(question_id) ON DELETE CASCADE,
    answer_text TEXT, -- 用于简答题
    selected_option_id INTEGER REFERENCES mcq_options(option_id), -- 用于选择题
    marks_obtained DECIMAL(5,2),
    is_correct BOOLEAN,
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(attempt_id, question_id)
);

-- 添加注释
COMMENT ON TABLE exams IS '考试信息表';
COMMENT ON TABLE questions IS '考试题目表';
COMMENT ON TABLE mcq_options IS '选择题选项表';
COMMENT ON TABLE short_answer_keys IS '简答题参考答案表';
COMMENT ON TABLE exam_attempts IS '学生考试尝试记录表';
COMMENT ON TABLE student_answers IS '学生答题记录表';

COMMENT ON COLUMN exams.exam_type IS '考试类型:MCQ(选择题), Short Answer(简答题), Mixed(混合)';
COMMENT ON COLUMN exams.duration IS '考试时长（分钟）';
COMMENT ON COLUMN exams.allow_review IS '是否允许学生查看答案和解析';
COMMENT ON COLUMN exams.shuffle_questions IS '是否随机打乱题目顺序';
COMMENT ON COLUMN questions.question_type IS '题目类型:MCQ 或 Short Answer';
COMMENT ON COLUMN mcq_options.is_correct IS '该选项是否为正确答案';
COMMENT ON COLUMN short_answer_keys.keywords IS '关键词数组，用于自动评分或人工评分参考';
COMMENT ON COLUMN exam_attempts.status IS '考试状态:In Progress(进行中), Completed(已完成), Abandoned(已放弃)';
COMMENT ON COLUMN exam_attempts.graded_by IS '评分教师(用于简答题人工评分)';
COMMENT ON COLUMN student_answers.answer_text IS '简答题的文本答案';
COMMENT ON COLUMN student_answers.selected_option_id IS '选择题所选的选项ID';