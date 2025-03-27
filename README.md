# Climate Platform Supabase Setup

This repository contains the SQL migrations and setup instructions for the Climate Innovation Platform's Supabase database.

## Database Schema

The database consists of three main tables:

1. `profiles` - User profiles and authentication
2. `projects` - Climate innovation projects
3. `chapters` - University chapters and communities

## Setup Instructions

1. Create a new Supabase project
2. Run the migrations in the following order:
   - `01_create_profiles.sql`
   - `02_create_projects.sql`
   - `03_create_chapters.sql`
   - `04_create_policies.sql`

## Row Level Security (RLS) Policies

The database uses RLS policies to ensure:
- Users can only read public data
- Users can only modify their own data
- Admins have full access to all data

## Enums and Custom Types

- Project Status: `draft`, `active`, `completed`
- User Roles: `student`, `mentor`, `partner`