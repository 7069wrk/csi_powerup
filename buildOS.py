import argparse
import subprocess

# Usage: python script_name.py my_prefix
# Where "my_prefix" is the prefix for output files.

# Define a function to run a shell command and save its output to a text file
def run_command_and_save_output(command, output_file):
    try:
        # Run the command and capture its output
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, shell=True)
        
        # Check if the command was successful
        if result.returncode == 0:
            # Write the output to the specified text file
            with open(output_file, 'w') as file:
                file.write(result.stdout)
            print(f"Command '{command}' executed successfully. Output saved to '{output_file}'")
        else:
            print(f"Error running command '{command}':\n{result.stderr}")
    
    except Exception as e:
        print(f"An error occurred: {str(e)}")

# Define the commands and corresponding output file names
commands_and_files = [
    ("dpkg --get-selections", "all_packages.txt"),  # List all installed packages
    ("dpkg -l | grep ^ii", "native_packages.txt"),  # List native system packages
    ("apt list --installed", "install_status.txt"),  # List packages by their installation status
    ("dpkg -l | grep ^ii | grep -v 'linux-' | grep -v 'ubuntu-'", "non_native_packages.txt"),  # List non-native packages
    ("apt list --installed | grep -v /auto", "explicitly_installed_packages.txt"),  # List explicitly installed packages
    ("snap list", "snap_installed_packages.txt"),  # List applications installed via snap
    ("flatpak list", "flatpak_installed_packages.txt")  # List applications installed via flatpak
]

# Function to run commands with a specified prefix for output files
def run_commands_with_prefix(prefix):
    for command, output_file in commands_and_files:
        output_file_with_prefix = f"{prefix}_{output_file}"
        run_command_and_save_output(command, output_file_with_prefix)

# Parse command-line arguments to get the prefix
parser = argparse.ArgumentParser(description="Document the creation of a digital forensics operating system.")
parser.add_argument("prefix", help="Prefix for output files")
args = parser.parse_args()

# Run the commands with the specified prefix
run_commands_with_prefix(args.prefix)
