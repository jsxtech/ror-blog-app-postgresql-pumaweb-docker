# RorApp

Full-featured Ruby on Rails blog application with authentication, authorization, and Docker support.

## Features

### Core Framework
- Rails 7.1
- PostgreSQL (production) / SQLite (development)
- Puma web server (2 workers, 5 threads)
- Docker & Docker Compose support

### User Management
- User registration with email validation
- Secure password authentication (bcrypt, min 6 chars)
- Login/logout with session management
- Session fixation protection
- Password strength requirements

### Posts
- Full CRUD operations (Create, Read, Update, Delete)
- Authorization - only owners can edit/delete
- Search by title or content (SQL injection protected)
- Pagination (10 posts per page via Kaminari)
- Draft/publish workflow
- Post-User associations
- Category filtering
- View counter (unique per session, excludes owner)
- Length validations (title: 200, content: 10000)
- Ordered by newest first
- N+1 query optimization with eager loading

### Categories
- Create and manage categories
- Filter posts by category
- Category-post associations
- Validation (unique names, max 50 chars)

### Comments
- Create and delete comments
- Nested under posts
- Only post owners can delete comments
- Length validation (max 1000 chars)
- Authentication required
- Timestamps display

### API
- RESTful JSON endpoints
- GET /api/posts - List published posts (limit 100)
- GET /api/posts/:id - Show single published post
- Proper 404 error handling
- Eager loading for performance
- Only returns published posts

### Security
- CSRF protection
- SQL injection prevention (sanitize_sql_like)
- Authorization checks on all actions
- Session regeneration on login/logout
- Password strength requirements
- Dependent destroy cascades
- Force SSL in production
- Environment-based secrets

### Performance
- Database indexes on foreign keys and query columns
- Eager loading to prevent N+1 queries
- Pagination limits results
- Thread-safe view counter
- Service objects for business logic
- Scoped queries for efficiency

### UI/UX
- Global navigation with auth state
- Flash messages for user feedback
- Validation error display on forms
- Delete confirmations
- Responsive forms with placeholders
- Content truncation on index (200 chars)
- Timestamps ("X ago" format)
- Comment counts
- View counts
- Draft indicators

## Quick Start

### Local Development

```bash
bundle install
rails db:migrate
rails server
```

Visit `http://localhost:3000`

### Docker (Recommended)

**Development:**
```bash
docker-compose -f docker-compose.dev.yml up
```

**Production:**
```bash
export SECRET_KEY_BASE=$(openssl rand -hex 64)
docker-compose up -d
```

**Quick Start Script:**
```bash
./docker-start.sh
```

## Setup

### Prerequisites
- Ruby 3.2+
- PostgreSQL 15+ (production)
- Docker & Docker Compose (optional)

### Installation

1. Clone repository
2. Install dependencies:
   ```bash
   bundle install
   ```

3. Setup database:
   ```bash
   rails db:create db:migrate
   ```

4. Start server:
   ```bash
   rails server
   ```

### Environment Variables

Create `.env` file (see `.env.example`):
```bash
SECRET_KEY_BASE=your_secret_key
DATABASE_URL=postgresql://user:password@localhost/ror_app_production
RAILS_ENV=production
```

## Routes

### Web Interface
- `GET /` - Home page
- `GET /posts` - List posts (with search ?q=term, filter ?category_id=1)
- `GET /posts/:id` - Show post
- `GET /posts/new` - New post form (auth required)
- `POST /posts` - Create post (auth required)
- `GET /posts/:id/edit` - Edit form (owner only)
- `PATCH /posts/:id` - Update post (owner only)
- `DELETE /posts/:id` - Delete post (owner only)
- `POST /posts/:id/comments` - Add comment (auth required)
- `DELETE /posts/:id/comments/:id` - Delete comment (post owner only)
- `GET /users/new` - Sign up
- `POST /users` - Create account
- `GET /session/new` - Login
- `POST /session` - Authenticate
- `DELETE /session` - Logout
- `GET /categories` - List categories (auth required)
- `GET /categories/new` - New category form (auth required)
- `POST /categories` - Create category (auth required)

### API Endpoints
- `GET /api/posts` - JSON list of published posts (max 100)
- `GET /api/posts/:id` - JSON single published post

## Models

### User
- `email` (required, unique, valid format)
- `password_digest` (min 6 chars)
- `has_many :posts` (dependent: destroy)

### Post
- `title` (required, max 200 chars)
- `content` (required, max 10000 chars)
- `published` (boolean, default: false)
- `views_count` (integer, default: 0)
- `belongs_to :user`
- `belongs_to :category` (optional)
- `has_many :comments` (dependent: destroy)

### Comment
- `body` (required, max 1000 chars)
- `belongs_to :post`

### Category
- `name` (required, unique, max 50 chars)
- `has_many :posts` (dependent: nullify)

## Architecture

```
app/
├── controllers/
│   ├── application_controller.rb
│   ├── home_controller.rb
│   ├── posts_controller.rb
│   ├── comments_controller.rb
│   ├── users_controller.rb
│   ├── sessions_controller.rb
│   ├── categories_controller.rb
│   └── api/
│       └── posts_controller.rb
├── models/
│   ├── user.rb
│   ├── post.rb
│   ├── comment.rb
│   └── category.rb
├── services/
│   └── view_count_service.rb
├── helpers/
│   └── application_helper.rb
└── views/
    ├── layouts/
    ├── home/
    ├── posts/
    ├── users/
    ├── sessions/
    └── categories/
```

## Dependencies

- `rails` ~> 7.1 - Framework
- `pg` - PostgreSQL adapter (production)
- `sqlite3` - SQLite adapter (development/test)
- `puma` - Web server
- `bcrypt` - Password hashing
- `kaminari` - Pagination

## Docker Commands

```bash
# Build
docker-compose build

# Start services
docker-compose up -d

# View logs
docker-compose logs -f web

# Run migrations
docker-compose exec web rails db:migrate

# Rails console
docker-compose exec web rails console

# Stop services
docker-compose down

# Clean up (removes volumes)
docker-compose down -v
```

## Production Deployment

See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed instructions.

**Quick Deploy:**
```bash
export SECRET_KEY_BASE=$(rails secret)
export DATABASE_URL=postgresql://user:pass@host/db
RAILS_ENV=production rails db:migrate
RAILS_ENV=production rails server
```

## Testing

```bash
# Run all tests
rails test

# Run specific test
rails test test/models/post_test.rb
```

## Security Features

✅ SQL injection protection  
✅ CSRF protection  
✅ Session fixation prevention  
✅ Authorization on all mutations  
✅ Password hashing (bcrypt)  
✅ Email validation  
✅ Strong parameters  
✅ Dependent destroy cascades  
✅ Force SSL (production)  

## Performance Optimizations

✅ Database indexes (9 indexes)  
✅ Eager loading (N+1 prevention)  
✅ Pagination (10 per page)  
✅ Thread-safe counters  
✅ Service objects  
✅ Query scopes  
✅ Connection pooling  

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Open Pull Request

## License

MIT License - see LICENSE file for details

## Support

For issues and questions, please open a GitHub issue.
