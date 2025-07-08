#!/usr/bin/env perl
use strict;
use warnings;
use Mojolicious::Lite;
use JSON;
use File::Slurp;

# Enable CORS for all routes
plugin 'CORS', {
    origins => ['http://localhost:4200'], # Allow specific origin
    methods => ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    headers => ['Content-Type'],
};
hook after => sub {
    my $c = shift;
    $c->res->headers->header('Access-Control-Allow-Origin' => '*');
    $c->res->headers->header('Access-Control-Allow-Origin' => 'http://localhost:4200');
    $c->res->headers->header('Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS');
    $c->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type, Authorization');
};

# Handle preflight OPTIONS requests
options '*' => sub {
    my $c = shift;
    $c->res->headers->header('Access-Control-Allow-Origin' => '*');
    $c->res->headers->header('Access-Control-Allow-Origin' => 'http://localhost:4200');
    $c->res->headers->header('Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS');
    $c->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type, Authorization');
    $c->render(text => '', status => 200);
};

# Data file path
my $data_file = 'tasks.json';

# Initialize data file if it doesn't exist
unless (-e $data_file) {
    write_file($data_file, encode_json([]));
}

# Helper function to read tasks
sub read_tasks {
    my $json_text = read_file($data_file);
    return decode_json($json_text);
}

# Helper function to write tasks
sub write_tasks {
    my ($tasks) = @_;
    write_file($data_file, encode_json($tasks));
}

# Helper function to generate unique ID
sub generate_id {
    my $tasks = read_tasks();
    my $max_id = 0;
    for my $task (@$tasks) {
        $max_id = $task->{id} if $task->{id} > $max_id;
    }
    return $max_id + 1;
}

# GET /tasks - Get all tasks
get '/tasks' => sub {
    my $c = shift;
    my $tasks = read_tasks();
    $c->render(json => $tasks);
};

# GET /tasks/:id - Get a specific task
get '/tasks/:id' => sub {
    my $c = shift;
    my $id = $c->param('id');
    my $tasks = read_tasks();
    
    my ($task) = grep { $_->{id} == $id } @$tasks;
    
    if ($task) {
        $c->render(json => $task);
    } else {
        $c->render(json => { error => 'Task not found' }, status => 404);
    }
};

# POST /tasks - Create a new task
post '/tasks' => sub {
    my $c = shift;
    my $new_task = $c->req->json;
    
    # Validate required fields
    unless ($new_task->{title}) {
        $c->render(json => { error => 'Title is required' }, status => 400);
        return;
    }
    
    # Set defaults and generate ID
    $new_task->{id} = generate_id();
    $new_task->{description} //= '';
    $new_task->{due_date} //= '';
    $new_task->{priority} //= 'Medium';
    $new_task->{category} //= 'Personal';
    $new_task->{completed} //= JSON::false;
    $new_task->{created_at} = time();
    
    # Add to tasks
    my $tasks = read_tasks();
    push @$tasks, $new_task;
    write_tasks($tasks);
    
    $c->render(json => $new_task, status => 201);
};

# PUT /tasks/:id - Update a task
put '/tasks/:id' => sub {
    my $c = shift;
    my $id = $c->param('id');
    my $updated_task = $c->req->json;
    my $tasks = read_tasks();
    
    my $task_index = -1;
    for my $i (0..$#$tasks) {
        if ($tasks->[$i]{id} == $id) {
            $task_index = $i;
            last;
        }
    }
    
    if ($task_index >= 0) {
        # Update the task while preserving id and created_at
        my $existing_task = $tasks->[$task_index];
        $updated_task->{id} = $existing_task->{id};
        $updated_task->{created_at} = $existing_task->{created_at};
        $updated_task->{updated_at} = time();
        
        $tasks->[$task_index] = $updated_task;
        write_tasks($tasks);
        
        $c->render(json => $updated_task);
    } else {
        $c->render(json => { error => 'Task not found' }, status => 404);
    }
};

# DELETE /tasks/:id - Delete a task
del '/tasks/:id' => sub {
    my $c = shift;
    my $id = $c->param('id');
    my $tasks = read_tasks();
    
    my $task_index = -1;
    for my $i (0..$#$tasks) {
        if ($tasks->[$i]{id} == $id) {
            $task_index = $i;
            last;
        }
    }
    
    if ($task_index >= 0) {
        splice @$tasks, $task_index, 1;
        write_tasks($tasks);
        $c->render(json => { message => 'Task deleted successfully' });
    } else {
        $c->render(json => { error => 'Task not found' }, status => 404);
    }
};

# Start the application
app->start;

