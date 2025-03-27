-- Create chapters table
CREATE TABLE chapters (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    university TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL,
    leader_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    member_count INTEGER NOT NULL DEFAULT 0,
    image_url TEXT,
    CONSTRAINT member_count_positive CHECK (member_count >= 0)
);

-- Enable Row Level Security
ALTER TABLE chapters ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Chapters are viewable by everyone"
    ON chapters FOR SELECT
    USING (true);

CREATE POLICY "Only chapter leaders can create chapters"
    ON chapters FOR INSERT
    WITH CHECK (
        auth.uid() = leader_id AND 
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() 
            AND (role = 'mentor' OR role = 'partner')
        )
    );

CREATE POLICY "Only chapter leaders can update their chapters"
    ON chapters FOR UPDATE
    USING (auth.uid() = leader_id)
    WITH CHECK (auth.uid() = leader_id);

CREATE POLICY "Only chapter leaders can delete their chapters"
    ON chapters FOR DELETE
    USING (auth.uid() = leader_id);

-- Create indexes
CREATE INDEX chapters_leader_id_idx ON chapters(leader_id);
CREATE INDEX chapters_university_idx ON chapters(university);