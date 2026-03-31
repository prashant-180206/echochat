# EchoChat

EchoChat is a Flutter chat application powered by Supabase for authentication, realtime updates, database access, and media storage.

## Overview

EchoChat focuses on a clean messaging experience with account management and profile discovery. The app supports login/signup flows, conversation management, direct messaging, profile editing, and light/dark theme switching.

## Main Features

- Email/password authentication with user profile creation
- Realtime conversation and message updates
- Chat list with unread indicators and last-message preview
- One-to-one chat screen with message history pagination
- Send text messages and image messages
- Edit and delete sent messages
- Discover users and start new conversations
- View user profile details
- Edit own profile (name, bio, gender, avatar)
- Theme toggle (light/dark mode)
- Skeleton loading states and basic error displays

## Tech Stack

- Flutter (Material 3)
- Supabase (Auth, Postgres, Realtime, Storage)
- Riverpod + Hooks (state management)
- Freezed + JSON Serializable (models)
- Image Picker (media selection)
- Logger (debug logging)

## Supported Platforms

This Flutter app is configured for Android, iOS, Web, Windows, macOS, and Linux.

## Getting Started

### Prerequisites

- Flutter SDK (3.10+)
- A Supabase project

### Environment Variables

Create a `.env` file in the project root with:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

## Backend Notes

- Supabase migrations are included under `supabase/migrations`.
- Storage buckets used by the app include avatar uploads and chat image uploads.

## Project Status

Active development project for learning and building a production-style chat workflow with Flutter + Supabase.
