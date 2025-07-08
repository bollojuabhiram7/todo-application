# Todo App - Angular + Perl

A simple but interesting todo application demonstrating full-stack development with Angular frontend and Perl backend.

## Project Overview

This project implements a complete todo list application with the following features:

### Features
- **Task Management**: Create, read, update, and delete tasks
- **Task Details**: Each task includes title, description, due date, priority (Low/Medium/High), and category (Work/Personal/Shopping)
- **Filtering & Sorting**: Filter tasks by category and sort by various criteria
- **Responsive Design**: Clean, modern UI that works on desktop and mobile
- **RESTful API**: Well-structured backend API with proper HTTP methods

### Technology Stack
- **Frontend**: Angular (latest version) with TypeScript
- **Backend**: Perl with Mojolicious framework
- **Data Storage**: JSON file-based storage (easily replaceable with database)
- **Styling**: Custom CSS with responsive design

## Project Structure

```
todo-app/
├── backend.pl              # Perl backend server
├── tasks.json              # Data storage file (auto-generated)
├── frontend/                # Angular frontend application
│   ├── src/
│   │   ├── app/
│   │   │   ├── app.ts              # Main app component
│   │   │   ├── app.html            # App template
│   │   │   ├── app.css             # App styles
│   │   │   ├── app.config.ts       # App configuration
│   │   │   ├── task.interface.ts   # Task interface definition
│   │   │   ├── task.ts             # Task service
│   │   │   ├── task-list/          # Task list component
│   │   │   │   ├── task-list.ts
│   │   │   │   ├── task-list.html
│   │   │   │   └── task-list.css
│   │   │   └── task-form/          # Task form component
│   │   │       ├── task-form.ts
│   │   │       ├── task-form.html
│   │   │       └── task-form.css
│   │   ├── main.ts                 # Angular bootstrap
│   │   ├── index.html              # Main HTML file
│   │   └── styles.css              # Global styles
│   ├── angular.json                # Angular configuration
│   ├── package.json                # Dependencies
│   └── tsconfig.json               # TypeScript configuration
└── README.md                       # This file
```

## Installation & Setup

### Prerequisites
- Node.js (v18 or higher)
- Perl (v5.34 or higher)
- npm or yarn

### Backend Setup
1. Install Perl dependencies:
   ```bash
   # Install cpanminus if not available
   sudo apt-get install cpanminus
   
   # Install required Perl modules
   cpanm Mojolicious JSON File::Slurp
   ```

2. Make the backend script executable:
   ```bash
   chmod +x backend.pl
   ```

### Frontend Setup
1. Install Angular CLI globally:
   ```bash
   npm install -g @angular/cli
   ```

2. Navigate to frontend directory and install dependencies:
   ```bash
   cd frontend
   npm install
   ```

## Running the Application

### Start the Backend Server
```bash
# From the todo-app directory
./backend.pl daemon -l http://*:3000
```
The backend will be available at `http://localhost:3000`

### Start the Frontend Development Server
```bash
# From the frontend directory
ng serve --host 0.0.0.0 --port 4200
```
The frontend will be available at `http://localhost:4200`

## API Endpoints

The Perl backend provides the following RESTful API endpoints:

- `GET /tasks` - Retrieve all tasks
- `GET /tasks/:id` - Retrieve a specific task
- `POST /tasks` - Create a new task
- `PUT /tasks/:id` - Update an existing task
- `DELETE /tasks/:id` - Delete a task

### Example API Usage

#### Create a Task
```bash
curl -X POST http://localhost:3000/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Sample Task",
    "description": "This is a sample task",
    "priority": "High",
    "category": "Work",
    "due_date": "2025-07-10"
  }'
```

#### Get All Tasks
```bash
curl http://localhost:3000/tasks
```

## Architecture Details

### Frontend Architecture
- **Component-based**: Modular Angular components for different UI sections
- **Service Layer**: Centralized HTTP service for API communication
- **Reactive Forms**: Form handling with validation
- **TypeScript**: Strong typing for better development experience

### Backend Architecture
- **Mojolicious Framework**: Lightweight Perl web framework
- **RESTful Design**: Standard HTTP methods and status codes
- **JSON Storage**: Simple file-based storage for demonstration
- **CORS Support**: Cross-origin resource sharing for frontend integration

## Known Issues & Future Improvements

### Current Issues
1. **CORS Configuration**: The CORS headers need fine-tuning for proper frontend-backend communication
2. **Error Handling**: Could be enhanced with more comprehensive error messages
3. **Data Validation**: Additional input validation on both frontend and backend

### Potential Improvements
1. **Database Integration**: Replace JSON file storage with PostgreSQL or MongoDB
2. **Authentication**: Add user authentication and authorization
3. **Real-time Updates**: Implement WebSocket for real-time task updates
4. **Testing**: Add unit and integration tests
5. **Deployment**: Docker containerization for easy deployment
6. **Performance**: Add caching and pagination for large datasets

## Development Notes

### Angular Components
- **TaskListComponent**: Displays tasks with filtering and sorting capabilities
- **TaskFormComponent**: Handles task creation with form validation
- **TaskService**: Manages HTTP communication with the backend

### Perl Backend Features
- **Mojolicious::Lite**: Simplified web framework for rapid development
- **JSON Handling**: Automatic JSON serialization/deserialization
- **File Operations**: Safe file I/O for data persistence
- **Error Handling**: Proper HTTP status codes and error responses

## Contributing

To contribute to this project:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is created for demonstration purposes. Feel free to use and modify as needed.

## Contact

For questions or support, please refer to the project documentation or create an issue in the repository.

