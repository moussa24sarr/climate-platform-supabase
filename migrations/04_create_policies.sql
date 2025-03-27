-- Storage policies for project and profile images
CREATE POLICY "Anyone can view project images"
    ON storage.objects FOR SELECT
    USING (bucket_id = 'projects');

CREATE POLICY "Project owners can upload project images"
    ON storage.objects FOR INSERT
    WITH CHECK (
        bucket_id = 'projects' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "Project owners can update their project images"
    ON storage.objects FOR UPDATE
    USING (
        bucket_id = 'projects' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "Project owners can delete their project images"
    ON storage.objects FOR DELETE
    USING (
        bucket_id = 'projects' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );

-- Profile image policies
CREATE POLICY "Anyone can view profile images"
    ON storage.objects FOR SELECT
    USING (bucket_id = 'profiles');

CREATE POLICY "Users can upload their own profile image"
    ON storage.objects FOR INSERT
    WITH CHECK (
        bucket_id = 'profiles' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "Users can update their own profile image"
    ON storage.objects FOR UPDATE
    USING (
        bucket_id = 'profiles' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "Users can delete their own profile image"
    ON storage.objects FOR DELETE
    USING (
        bucket_id = 'profiles' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );

-- Function to check if a user is a mentor
CREATE OR REPLACE FUNCTION is_mentor(user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM profiles
        WHERE id = user_id
        AND role = 'mentor'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if a user is a partner
CREATE OR REPLACE FUNCTION is_partner(user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM profiles
        WHERE id = user_id
        AND role = 'partner'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update project funding
CREATE OR REPLACE FUNCTION update_project_funding(
    project_id UUID,
    amount NUMERIC
)
RETURNS VOID AS $$
BEGIN
    UPDATE projects
    SET funding_raised = funding_raised + amount
    WHERE id = project_id
    AND funding_raised + amount <= funding_goal;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;