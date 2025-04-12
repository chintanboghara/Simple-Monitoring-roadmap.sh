# Simple Monitoring with Netdata

This project demonstrates how to set up a basic monitoring dashboard using [Netdata](https://www.netdata.cloud/), a powerful tool for real-time performance and health monitoring of systems and applications.

## Repository Structure

The repository is organized as follows:

```bash
.
├── README.md          # Project documentation (this file)
├── Explanation.md     # Explanation of Scripts
├── setup.sh           # Script to install Netdata
├── test_dashboard.sh  # Script to test the monitoring dashboard by generating system load
└── cleanup.sh         # Script to remove Netdata from the system
```

## Setup Instructions

### Step 1: Install Netdata

To install Netdata manually, follow these steps:

1. Open a terminal on the Linux system.
2. Run the official Netdata installation command:

   ```bash
   bash <(curl -Ss https://my-netdata.io/kickstart.sh)
   ```

3. Follow any prompts to complete the installation process.

Alternatively, use the provided `setup.sh` script for an automated installation:

```bash
chmod +x setup.sh
./setup.sh
```

### Step 2: Access the Netdata Dashboard

After installation, access the Netdata dashboard via a web browser:

- Navigate to:
  ```
  http://localhost:19999
  ```
- If accessing remotely, replace `localhost` with the server’s IP address (e.g., `http://192.168.1.100:19999`).

The dashboard provides real-time visualizations of CPU, memory, disk I/O, network activity, and more.

### Step 3: Customize the Dashboard

Netdata allows extensive customization. For this project, enable the CPU frequency collector:

1. Edit the `cpufreq` configuration file:

   ```bash
   sudo nano /etc/netdata/python.d/cpufreq.conf
   ```

2. Ensure it includes:

   ```yaml
   update_every: 1
   priority: 60000
   autodetection_retry: 0
   chart_type: line
   name: cpufreq
   ```

3. Restart Netdata to apply changes:

   ```bash
   sudo systemctl restart netdata
   ```

A CPU frequency chart will now appear under the CPU section of the dashboard.

### Step 4: Set Up an Alert

Netdata supports health monitoring with customizable alerts. Here, configure an alert for CPU usage exceeding 80%:

1. Edit the CPU alert configuration:

   ```bash
   sudo nano /etc/netdata/health.d/cpu.conf
   ```

2. Add or update the following:

   ```yaml
   alarm: cpu_usage_high
   on: system.cpu
   lookup: average -3s %user+%system+%nice+%iowait+%irq+%softirq
   units: %
   every: 10s
   warn: $this > 80
   info: CPU usage exceeds 80%
   ```

3. Restart Netdata:

   ```bash
   sudo systemctl restart netdata
   ```

The alert will trigger when CPU usage exceeds 80% and appear in the "Alarms" section of the dashboard.

## Automation Scripts

The project includes three shell scripts to streamline setup, testing, and cleanup:

### 1. `setup.sh`

- **Purpose**: Installs Netdata on a Linux system.
- **Usage**:

  ```bash
  chmod +x setup.sh
  ./setup.sh
  ```

### 2. `test_dashboard.sh`

- **Purpose**: Generates system load to test the Netdata dashboard and verify metrics and alerts.
- **Requirements**: Requires the `stress` tool. Install it with:

  ```bash
  sudo apt-get install stress
  ```

- **Usage**:

  ```bash
  chmod +x test_dashboard.sh
  ./test_dashboard.sh
  ```

- **Behavior**:
  - Simulates CPU load with 4 workers.
  - Generates disk I/O by writing a 1GB file.
  - Runs for 60 seconds to allow observation of dashboard changes.
  - Cleans up by stopping the stress test and deleting the test file.

### 3. `cleanup.sh`

- **Purpose**: Uninstalls Netdata from the system.
- **Usage**:

  ```bash
  chmod +x cleanup.sh
  ./cleanup.sh
  ```

- **Note**: This uses `apt-get remove netdata`. For a complete removal including configuration files, edit the script to use `apt-get purge netdata`.

## How to Use This Project

### Option 1: Manual Setup
- Follow the "Setup Instructions" to install Netdata, customize the dashboard, and configure an alert.
- Open the dashboard to explore real-time metrics manually.

### Option 2: Automated Workflow
- Execute the scripts in order:

  ```bash
  ./setup.sh
  ./test_dashboard.sh
  ./cleanup transformations.sh
  ```

- While `test_dashboard.sh` runs, visit the dashboard to observe the effects of the load and check if the CPU alert triggers.
