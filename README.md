# Task Manager Script

This is a simple Bash script for managing tasks. The script allows you to create, update, delete, show, list, and search tasks. Each task includes a title, description, location, due date, due time, and completion status.


### Data Storage

- **Plain Text File**: The script utilizes a plain text file (`todo.txt`) to store task information. Each task is recorded as a single line in the following format:
This format is chosen for its simplicity, allowing easy parsing and modification with basic Bash string manipulation commands.

- **Associative Array**: Tasks are loaded into an associative array (`tasks`) within the script. The task ID serves as the key, and the task details are stored as the value. This allows for efficient access and modification of tasks by their ID.

### Code Organization

The script is organized into functions, each responsible for a specific operation. This modular design enhances maintainability and extensibility. The key functions are:

- **`load_tasks`**: This function retrieves tasks from the todo.txt file and stores them in the associative array tasks.
- **`save_tasks`**: After modifications are made to tasks, this function writes the updated tasks from the tasks array back to the todo.txt file.
- **`create_task`**: Interactively prompts the user to input task details and then creates a new task based on the provided information.
- **`update_task`**: nteractively prompts the user to update an existing task by providing new details.
- **`delete_task`**:Allows the user to delete a task by specifying its ID.
- **`show_task`**: Displays the details of a specific task by its ID
- **`list_tasks`**: Displays a list of all tasks stored in the system.
- **`search_task`**: Allows the user to search for tasks based on their title.
- 
### User Interaction

- The script uses `read -p` to interactively prompt the user for input when creating or updating tasks.
- Date validation is performed using the `date` command to ensure dates are entered in the correct format (`YYYY-MM-DD`).

## Installation

1. Ensure you have a Bash environment. 
2. Clone this repository or download the script `todo.sh` and make it executable: chmod +x projet.sh
## Usage
Run the script with the desired command:
./todo.sh {create|update|delete|show|list|search}


