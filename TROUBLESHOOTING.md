# Troubleshooting Guide

## Common Issues and Solutions

### CORS (Cross-Origin Resource Sharing) Issues

**Problem**: Browser console shows CORS errors when the Angular frontend tries to communicate with the Perl backend.

**Symptoms**:
- Error messages like "Access to XMLHttpRequest at 'http://localhost:3000/tasks' from origin 'http://localhost:4200' has been blocked by CORS policy"
- Tasks not loading in the frontend
- Form submissions not working

**Solutions**:

1. **Verify Backend is Running**: Ensure the Perl backend is running on port 3000
   ```bash
   curl http://localhost:3000/tasks
   ```

2. **Test CORS Headers**: Check if CORS headers are being sent
   ```bash
   curl -X OPTIONS http://localhost:3000/tasks \
     -H "Origin: http://localhost:4200" \
     -H "Access-Control-Request-Method: POST" \
     -H "Access-Control-Request-Headers: Content-Type" -v
   ```

3. **Alternative CORS Fix**: If the current implementation doesn't work, try this updated backend.pl:
   ```perl
   # Add this at the top after use statements
   use Mojolicious::Plugin::CORS;
   
   # Add this after app creation
   app->plugin('CORS' => {
       origin => '*',
       credentials => 1,
       headers => ['Content-Type', 'Authorization'],
       methods => ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS']
   });
   ```

4. **Browser Cache**: Clear browser cache and hard refresh (Ctrl+F5)

5. **Development Workaround**: Use browser with disabled security for development:
   ```bash
   # Chrome with disabled security (development only!)
   google-chrome --disable-web-security --user-data-dir="/tmp/chrome_dev"
   ```

### Backend Issues

**Problem**: Backend server won't start

**Solutions**:
1. Check if Perl modules are installed:
   ```bash
   perl -MMojolicious -e "print 'OK'"
   perl -MJSON -e "print 'OK'"
   perl -MFile::Slurp -e "print 'OK'"
   ```

2. Install missing modules:
   ```bash
   cpanm Mojolicious JSON File::Slurp
   ```

3. Check if port 3000 is already in use:
   ```bash
   lsof -i :3000
   ```

### Frontend Issues

**Problem**: Angular development server won't start

**Solutions**:
1. Install dependencies:
   ```bash
   cd frontend
   npm install
   ```

2. Check Node.js version:
   ```bash
   node --version  # Should be v18 or higher
   ```

3. Clear npm cache:
   ```bash
   npm cache clean --force
   ```

4. Reinstall Angular CLI:
   ```bash
   npm uninstall -g @angular/cli
   npm install -g @angular/cli
   ```

### Data Issues

**Problem**: Tasks not persisting or loading

**Solutions**:
1. Check if tasks.json file exists and is writable:
   ```bash
   ls -la tasks.json
   ```

2. Reset data file:
   ```bash
   echo "[]" > tasks.json
   ```

3. Check file permissions:
   ```bash
   chmod 644 tasks.json
   ```

## Testing the Application

### Manual Testing Steps

1. **Start Backend**:
   ```bash
   ./start-backend.sh
   ```

2. **Test Backend API**:
   ```bash
   # Test GET
   curl http://localhost:3000/tasks
   
   # Test POST
   curl -X POST http://localhost:3000/tasks \
     -H "Content-Type: application/json" \
     -d '{"title":"Test Task","priority":"High","category":"Work"}'
   ```

3. **Start Frontend**:
   ```bash
   ./start-frontend.sh
   ```

4. **Test Frontend**:
   - Open http://localhost:4200 in browser
   - Try creating a task
   - Check browser console for errors

### Debug Mode

To run the backend in debug mode with more verbose logging:
```bash
MOJO_LOG_LEVEL=debug ./backend.pl daemon -l http://*:3000
```

## Getting Help

If you continue to experience issues:

1. Check the browser developer console for detailed error messages
2. Check the backend server logs for any Perl errors
3. Verify all dependencies are properly installed
4. Try running the application on a different port if there are conflicts

## Known Limitations

- The current CORS implementation may need refinement for production use
- File-based storage is not suitable for production environments
- No authentication or authorization implemented
- Limited error handling and validation

