#!/bin/bash

TODO_FILE='todo.txt'

# Function to load tasks from the file into an associative array
load_tasks() {
    if [ ! -f "$TODO_FILE" ]; then
        touch "$TODO_FILE"
    fi
}

# Function to save tasks from the file
save_tasks() {
    > "$TODO_FILE"
    for id in "${!tasks[@]}"; do
        echo "${tasks[$id]}" >> "$TODO_FILE"
    done
}

# Function to create a new task
create_task() {
    load_tasks
    if [ ${#tasks[@]} -eq 0 ]; then
        task_id=1
    else
        last_task_id=$(tail -n 1 "$TODO_FILE" | cut -d '|' -f 1)
        task_id=$((last_task_id + 1))
    fi
    read -p "Enter task title: " title
    if [ -z "$title" ]; then
        echo "Error: Task title is required."
        return
    fi
    read -p "Enter task description (optional): " description
    read -p "Enter task location (optional): " location
    read -p "Enter task due date (YYYY-MM-DD): " due_date
    if ! date -d "$due_date" &>/dev/null; then
        echo "Error: Invalid date format. Please use YYYY-MM-DD."
        return
    fi
    read -p "Enter task due time (HH:MM, optional): " due_time
    completion_marker="pending"
    task="$task_id|$title|$description|$location|$due_date|$due_time|$completion_marker"
    tasks["$task_id"]="$task"
    save_tasks
    echo "Task '$title' created successfully with ID '$task_id'."
}

# Function to update a task
update_task() {
    load_tasks
    read -p "Enter the ID of the task to update: " task_id
    if [ -z "${tasks[$task_id]}" ]; then
        echo "Error: Task with ID '$task_id' not found."
        return
    fi
    task="${tasks[$task_id]}"
    IFS='|' read -r id title description location due_date due_time completed <<< "$task"
    read -p "Enter the new task title ($title): " new_title
    read -p "Enter the new task description ($description): " new_description
    read -p "Enter the new task location ($location): " new_location
    read -p "Enter the new task due date ($due_date): " new_due_date
    if ! date -d "$new_due_date" &>/dev/null; then
        echo "Error: Invalid date format. Please use YYYY-MM-DD."
        return
    fi
    read -p "Enter the new task due time ($due_time): " new_due_time
    read -p "Is the task completed? (y/n) (${completed/pending/no}/${completed/completed/yes}): " new_completed
    if [ "$new_completed" == "y" ]; then
        new_completed="completed"
    else
        new_completed="pending"
    fi
    tasks["$task_id"]="$task_id|${new_title:-$title}|${new_description:-$description}|${new_location:-$location}|${new_due_date:-$due_date}|${new_due_time:-$due_time}|$new_completed"
    save_tasks
    echo "Task '$title' updated successfully."
}

# Function to delete a task
delete_task() {
    load_tasks
    read -p "Enter the ID of the task to delete: " task_id
    if [ -z "${tasks[$task_id]}" ]; then
        echo "Error: Task with ID '$task_id' not found."
        return
    fi
    unset 'tasks[$task_id]'
    save_tasks
    echo "Task with ID '$task_id' deleted successfully."
}

# Function to show a task
show_task() {
    load_tasks
    read -p "Enter the ID of the task to show: " task_id
    if [ -z "${tasks[$task_id]}" ]; then
        echo "Error: Task with ID '$task_id' not found."
        return
    fi
    task="${tasks[$task_id]}"
    IFS='|' read -r id title description location due_date due_time completed <<< "$task"
    echo "ID: $id"
    echo "Title: $title"
    echo "Description: $description"
    echo "Location: $location"
    echo "Due Date: $due_date"
    echo "Due Time: $due_time"
    echo "Status: $completed"
}

# Function to list tasks
list_tasks() {
    load_tasks
    if [ ${#tasks[@]} -eq 0 ]; then
        echo "No tasks found."
        return
    fi
    echo "Tasks:"
    for id in "${!tasks[@]}"; do
        task="${tasks[$id]}"
        IFS='|' read -r id title description location due_date due_time completed <<< "$task"
        echo "ID: $id - Title: $title - Due Date: $due_date - Status: $completed"
    done
}

# Function to search tasks by title
search_task() {
    load_tasks
    read -p "Enter the title to search: " search_title
    found=false
    for id in "${!tasks[@]}"; do
        task="${tasks[$id]}"
        IFS='|' read -r id title description location due_date due_time completed <<< "$task"
        if [[ "$title" == *"$search_title"* ]]; then
            echo "ID: $id - Title: $title - Due Date: $due_date - Status: $completed"
            found=true
        fi
    done
    if ! $found; then
        echo "No tasks found with title containing '$search_title'."
    fi
}

# Main function to process commands
main() {
    declare -A tasks
    case "$1" in
        create)
            create_task
            ;;
        update)
            update_task
            ;;
        delete)
            delete_task
            ;;
        show)
            show_task
            ;;
        list)
            list_tasks
            ;;
        search)
            search_task
            ;;
        *)
            echo "Usage: $0 {create|update|delete|show|list|search}"
            ;;
    esac
}

main "$@"

