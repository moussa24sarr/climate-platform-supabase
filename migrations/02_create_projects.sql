-- Create enum for project status
CREATE TYPE project_status AS ENUM ('draft', 'active', 'completed');

-- Create projects table
CREATE TABLE projects (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    status project_status NOT NULL DEFAULT 'draft',
    creator_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    image_url TEXT,
    funding_goal NUMERIC(10,2),
    funding_raised NUMERIC(10,2) NOT NULL DEFAULT 0,
    category TEXT NOT NULL,
    university TEXT NOT NULL,
    CONSTRAINT funding_goal_positive CHECK (funding_goal > 0),
    CONSTRAINT funding_raised_positive CHECK (funding_raised >= 0),
    CONSTRAINT funding_raised_not_exceed_goal CHECK (funding_raised <= funding_goal)
);

-- Enable Row Level Security
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Public projects are viewable by everyone"
    ON projects FOR SELECT
    USING (status = 'active' OR auth.uid() = creator_id);

CREATE POLICY "Users can create their own projects"
    ON projects FOR INSERT
    WITH CHECK (auth.uid() = creator_id);

CREATE POLICY "Users can update their own projects"
    ON projects FOR UPDATE
    USING (auth.uid() = creator_id)
    WITH CHECK (auth.uid() = creator_id);

CREATE POLICY "Users can delete their own projects"
    ON projects FOR DELETE
    USING (auth.uid() = creator_id);

-- Create indexes
CREATE INDEX projects_creator_id_idx ON projects(creator_id);
CREATE INDEX projects_category_idx ON projects(category);
CREATE INDEX projects_university_idx ON projects(university);
CREATE INDEX projects_status_idx ON projects(status);