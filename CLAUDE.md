# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Essential Commands

### Initial Setup
```bash
mix setup  # Install dependencies, setup database, and build assets
```

### Development
```bash
mix phx.server          # Start Phoenix server
iex -S mix phx.server    # Start server with interactive Elixir shell
```
Server runs on `http://localhost:4000`

### Testing
```bash
mix test                    # Run all tests (includes DB setup)
mix test test/path/file.exs # Run specific test file
```

### Database
```bash
mix ecto.migrate   # Run pending migrations
mix ecto.reset     # Drop, create, migrate, and seed database
mix ecto.create    # Create database
mix ecto.drop      # Drop database
```

### Assets
```bash
mix assets.build   # Build CSS and JavaScript
mix assets.deploy  # Build and minify assets for production
```

## Architecture Overview

**Technology Stack:**
- Phoenix Framework 1.8 with LiveView for real-time features
- Elixir 1.15+ for backend logic
- SQLite database with Ecto ORM
- ESBuild for JavaScript bundling
- Tailwind CSS for styling
- Bandit HTTP server

**Key Application Modules:**
- `Hello.Application` - OTP application supervisor
- `Hello.Repo` - Database repository using Ecto
- `HelloWeb.Router` - URL routing (currently single route to PageController)
- `HelloWeb.Endpoint` - HTTP endpoint configuration

## Project Structure

```
lib/
├── hello/              # Core application logic
│   ├── application.ex  # OTP application
│   ├── repo.ex        # Database repository
│   └── mailer.ex      # Email functionality
└── hello_web/         # Web layer
    ├── controllers/    # HTTP controllers
    ├── components/     # Reusable UI components
    ├── layouts/       # Page layouts
    └── router.ex      # URL routing

test/
├── hello_web/         # Web layer tests
├── support/           # Test support modules (conn_case.ex, data_case.ex)
└── test_helper.exs    # Test configuration

config/
├── config.exs         # Main configuration
├── dev.exs           # Development environment
├── prod.exs          # Production environment
└── test.exs          # Test environment

assets/                # Frontend source files
priv/static/          # Compiled static assets
```

## Development Workflow

**Development Tools:**
- Live Dashboard: `http://localhost:4000/dev/dashboard` - Application metrics and debugging
- Mailbox Preview: `http://localhost:4000/dev/mailbox` - Email preview in development

**Hot Reloading:**
- Automatic recompilation for `.ex` and `.heex` files in `lib/hello_web/`
- Live reload for static assets and templates
- ESBuild and Tailwind watchers rebuild assets automatically

**Database:**
- SQLite database stored as `hello_dev.db` in project root
- Database sandbox mode enabled for tests
- Run `mix ecto.reset` to reset database state during development

## Mix Aliases

The project defines these helpful aliases in `mix.exs`:
- `mix setup` - Complete project setup (deps, database, assets)
- `mix ecto.setup` - Database setup only
- `mix assets.setup` - Install asset build tools
- `mix assets.build` - Build assets for development
- `mix assets.deploy` - Build and optimize assets for production