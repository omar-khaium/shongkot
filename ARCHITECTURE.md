# Architecture Documentation

## System Overview

Shongkot is a mobile-first emergency response application built with a modern, scalable architecture using Flutter for the frontend and ASP.NET Core for the backend API.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Mobile Application                       │
│                        (Flutter)                            │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ Presentation │  │   Business   │  │     Data     │    │
│  │    Layer     │  │    Logic     │  │    Layer     │    │
│  │   (UI/Bloc)  │  │  (Use Cases) │  │ (Repository) │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
└───────────────────────────┬─────────────────────────────────┘
                           │ HTTPS/REST
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                     Backend API                              │
│                  (ASP.NET Core 9.0)                         │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ Controllers  │  │  Application │  │     Domain   │    │
│  │   (API)      │  │   Services   │  │   Entities   │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
│           │                │                  │            │
│           └────────────────┴──────────────────┘            │
│                           │                                │
│                  ┌────────┴────────┐                       │
│                  │ Infrastructure  │                       │
│                  │    (Data/IO)    │                       │
│                  └─────────────────┘                       │
└───────────────────────────┬─────────────────────────────────┘
                           │
            ┌──────────────┴──────────────┐
            │                             │
            ▼                             ▼
    ┌───────────────┐           ┌─────────────────┐
    │   Database    │           │  External APIs  │
    │ (SQL Server)  │           │  (Maps, SMS)    │
    └───────────────┘           └─────────────────┘
```

## Backend Architecture

### Clean Architecture Layers

#### 1. **API Layer (Shongkot.Api)**
- **Controllers**: HTTP endpoints
- **Middleware**: Authentication, logging, error handling
- **DTOs**: Data transfer objects for API contracts

**Responsibilities:**
- Handle HTTP requests/responses
- Input validation
- Authentication/Authorization
- API versioning
- Swagger documentation

#### 2. **Application Layer (Shongkot.Application)**
- **Services**: Business logic orchestration
- **DTOs**: Internal data transfer objects
- **Interfaces**: Service contracts
- **Validators**: Business rule validation

**Responsibilities:**
- Coordinate business operations
- Implement use cases
- Handle transactions
- Business rule enforcement

#### 3. **Domain Layer (Shongkot.Domain)**
- **Entities**: Core business objects
- **Value Objects**: Domain primitives
- **Interfaces**: Repository contracts
- **Domain Services**: Pure business logic

**Responsibilities:**
- Define core business entities
- Enforce business invariants
- Domain logic (framework-independent)

#### 4. **Infrastructure Layer (Shongkot.Infrastructure)**
- **Data**: Database context, migrations
- **Repositories**: Data access implementations
- **External Services**: Third-party integrations
- **Caching**: In-memory/distributed cache

**Responsibilities:**
- Database operations
- External API calls
- File system operations
- Caching implementations

### Dependency Flow
```
API → Application → Domain
         ↓
   Infrastructure
```

**Key Principle:** Dependencies point inward. Domain has no dependencies.

## Frontend Architecture

### Clean Architecture (Flutter)

#### 1. **Presentation Layer**
```
lib/features/{feature}/presentation/
├── bloc/           # State management (BLoC pattern)
├── pages/          # Full screen widgets
└── widgets/        # Reusable UI components
```

**Responsibilities:**
- UI rendering
- User input handling
- State management
- Navigation

#### 2. **Domain Layer**
```
lib/features/{feature}/domain/
├── entities/       # Business objects
├── repositories/   # Repository interfaces
└── usecases/       # Business logic
```

**Responsibilities:**
- Define business entities
- Define repository contracts
- Implement use cases
- Business rules

#### 3. **Data Layer**
```
lib/features/{feature}/data/
├── models/         # Data models (JSON serialization)
├── repositories/   # Repository implementations
└── datasources/    # API clients, local storage
```

**Responsibilities:**
- Data fetching
- Data caching
- Data transformation
- API communication

### State Management (BLoC)

```
User Action → Event → BLoC → State → UI Update
```

**Example:**
```dart
// Event
class TriggerEmergency extends EmergencyEvent {}

// State
class EmergencyTriggered extends EmergencyState {}

// BLoC
class EmergencyBloc extends Bloc<EmergencyEvent, EmergencyState> {
  EmergencyBloc() {
    on<TriggerEmergency>(_onTriggerEmergency);
  }
}
```

## Data Flow

### Emergency Trigger Flow

```
1. User presses SOS button
   ↓
2. UI dispatches TriggerEmergency event
   ↓
3. EmergencyBloc processes event
   ↓
4. Use case executes business logic
   ↓
5. Repository calls API
   ↓
6. Backend API receives request
   ↓
7. Controller validates input
   ↓
8. Service processes emergency
   ↓
9. Notifications sent to contacts
   ↓
10. Location shared with responders
   ↓
11. Response returned to client
   ↓
12. BLoC emits new state
   ↓
13. UI updates to show active emergency
```

## Technology Stack

### Backend
- **Framework**: ASP.NET Core 9.0
- **Language**: C# 12
- **Testing**: xUnit, Moq
- **Documentation**: Swagger/OpenAPI
- **Database**: SQL Server (planned)
- **Caching**: In-Memory Cache
- **Hosting**: Azure App Service

### Frontend
- **Framework**: Flutter 3.19+
- **Language**: Dart 3.0+
- **State Management**: flutter_bloc
- **Navigation**: go_router
- **Local Storage**: Hive, SharedPreferences
- **HTTP Client**: Dio
- **Maps**: Google Maps
- **Notifications**: Firebase Cloud Messaging
- **Testing**: flutter_test, mockito, flutter_gherkin

### DevOps
- **CI/CD**: GitHub Actions
- **Code Coverage**: Codecov
- **App Distribution**: Firebase App Distribution
- **Monitoring**: Firebase Crashlytics
- **Analytics**: Firebase Analytics

## Security Architecture

### API Security
1. **HTTPS Only**: All communications encrypted
2. **CORS Configuration**: Restricted origins
3. **Input Validation**: All inputs validated
4. **Rate Limiting**: Prevent abuse
5. **Authentication**: JWT tokens (future)
6. **Authorization**: Role-based access (future)

### Mobile Security
1. **Secure Storage**: Encrypted local data
2. **Certificate Pinning**: API trust validation
3. **Biometric Auth**: Device authentication
4. **Obfuscation**: Code protection
5. **No Sensitive Data in Logs**: Privacy protection

## Scalability Considerations

### Backend Scalability
- **Stateless API**: Horizontal scaling
- **Caching Strategy**: Reduce database load
- **Database Optimization**: Indexes, query optimization
- **Load Balancing**: Azure App Service
- **CDN**: Static asset delivery

### Frontend Performance
- **Lazy Loading**: Load data on demand
- **Image Optimization**: Compressed assets
- **Widget Rebuilding**: Minimize rebuilds
- **State Management**: Efficient state updates
- **Caching**: Cache API responses

## Monitoring & Observability

### Backend Monitoring
- Application Insights
- Structured logging (Serilog)
- Performance metrics
- Error tracking

### Frontend Monitoring
- Firebase Crashlytics
- Firebase Performance
- Analytics events
- User behavior tracking

## Future Enhancements

### Planned Features
1. **Real-time Communication**: WebSockets/SignalR
2. **Offline Support**: Local-first architecture
3. **AI/ML Integration**: Smart responder matching
4. **Multi-language Support**: i18n/l10n
5. **Advanced Analytics**: Predictive insights

### Technical Debt
- Implement Entity Framework
- Add authentication/authorization
- Implement proper database migrations
- Add more comprehensive logging
- Implement circuit breakers
- Add API versioning

## Development Principles

1. **SOLID Principles**: Clean, maintainable code
2. **DRY**: Don't Repeat Yourself
3. **KISS**: Keep It Simple, Stupid
4. **YAGNI**: You Aren't Gonna Need It
5. **Test-Driven Development**: Tests first
6. **Continuous Integration**: Automated testing
7. **Clean Code**: Readable, understandable

## References

- [ASP.NET Core Documentation](https://docs.microsoft.com/aspnet/core/)
- [Flutter Architecture](https://docs.flutter.dev/resources/architectural-overview)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [BLoC Pattern](https://bloclibrary.dev/)
