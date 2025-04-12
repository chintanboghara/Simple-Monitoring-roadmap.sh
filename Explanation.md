## setup.sh

- **Description**: This script automates the installation of Netdata on your Linux system.
- **Purpose**: To simplify the process of setting up Netdata, ensuring that all necessary dependencies are installed and the service is started.
- **How to Run**: 
  1. Make the script executable: `chmod +x setup.sh`
  2. Run it: `./setup.sh` (you may need to use `sudo ./setup.sh` if elevated privileges are required).
- **Notes**: 
  - The script uses the official Netdata installation command, which requires an active internet connection to download the necessary files.
  - Sudo privileges might be necessary depending on your system configuration.

## test_dashboard.sh

- **Description**: This script generates system load to test the Netdata monitoring dashboard.
- **Purpose**: To simulate high CPU and disk I/O activity, allowing you to observe how Netdata displays these metrics in real-time and how alerts (e.g., CPU usage above 80%) are triggered.
- **How to Run**: 
  1. Ensure the `stress` tool is installed: `sudo apt-get install stress`
  2. Make the script executable: `chmod +x test_dashboard.sh`
  3. Run it: `./test_dashboard.sh`
- **Notes**: 
  - The script runs for a specified duration (e.g., 60 seconds). During this time, you should access the Netdata dashboard (typically at `http://localhost:19999`) to see the effects of the load and check for triggered alerts.
  - After the test, the script cleans up by stopping the stress test and removing any temporary files.
  - The `stress` tool must be installed prior to running the script.

## cleanup.sh

- **Description**: This script removes Netdata from your system.
- **Purpose**: To uninstall Netdata after testing or when it is no longer needed, freeing up system resources.
- **How to Run**: 
  1. Make the script executable: `chmod +x cleanup.sh`
  2. Run it: `./cleanup.sh` (you may need to use `sudo ./cleanup.sh` if elevated privileges are required).
- **Notes**: 
  - The script uses `apt-get remove netdata -y` to uninstall the Netdata package automatically (the `-y` flag confirms the removal without prompting).
  - If you want to remove configuration files as well, you can modify the script to use `apt-get purge netdata -y` instead.
  - Sudo privileges might be required depending on your system.

## Using the Scripts Together

These scripts are designed to be used in sequence to simulate a complete workflow:

1. **Install Netdata**: Run `setup.sh` to install Netdata on your system.
2. **Test the Dashboard**: Run `test_dashboard.sh` to generate system load. While the script is running, open the Netdata dashboard in a web browser (e.g., `http://localhost:19999`) to observe real-time metrics and check if any configured alerts (such as high CPU usage) are triggered.
3. **Remove Netdata**: After testing, run `cleanup.sh` to uninstall Netdata and clean up your system.
