# Simple Monitoring with Netdata

This project demonstrates how to set up a basic monitoring dashboard using [Netdata](https://www.netdata.cloud/). Netdata is a powerful tool for real-time performance and health monitoring of systems and applications.

## Repository Structure

```plaintext
.
├── README.md          # Project documentation (this file)
├── Explanation.md     # Detailed explanation of the scripts
├── setup.sh           # Script to install Netdata
├── test_dashboard.sh  # Script to generate system load and test the dashboard
└── cleanup.sh         # Script to remove Netdata from the system
```

## Setup Instructions

### Step 1: Install Netdata

You can install Netdata manually or by using the provided automated script.

#### Manual Installation

1. Open a terminal on your Linux system.
2. Run the official Netdata installation command:

   ```bash
   bash <(curl -Ss https://my-netdata.io/kickstart.sh)
   ```

3. Follow the prompts to complete the installation process.

#### Automated Installation

Alternatively, make the provided `setup.sh` script executable and run it:

```bash
chmod +x setup.sh
./setup.sh
```

This script automates the installation process of Netdata.

### Step 2: Access the Netdata Dashboard

After installation, open your web browser and navigate to:

```plaintext
http://localhost:19999
```

If accessing Netdata remotely, replace `localhost` with your server’s IP address (e.g., `http://192.168.1.100:19999`).

The dashboard will display real-time visualizations for CPU, memory, disk I/O, network activity, and more.

### Step 3: Customize the Dashboard

For this project, customize the dashboard by enabling the CPU frequency collector:

1. Open the `cpufreq` configuration file:

   ```bash
   sudo nano /etc/netdata/python.d/cpufreq.conf
   ```

2. Add or ensure the file contains the following configuration:

   ```yaml
   update_every: 1
   priority: 60000
   autodetection_retry: 0
   chart_type: line
   name: cpufreq
   ```

3. Restart Netdata to apply the changes:

   ```bash
   sudo systemctl restart netdata
   ```

A new CPU frequency chart will appear in the CPU section of the dashboard.

### Step 4: Set Up an Alert

Configure an alert to monitor if CPU usage exceeds 80%.

1. Edit the CPU alert configuration file:

   ```bash
   sudo nano /etc/netdata/health.d/cpu.conf
   ```

2. Add or update the configuration with the following settings:

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

When CPU usage exceeds 80%, the alert will trigger and appear in the "Alarms" section of the dashboard.

## Automation Scripts

This project includes three shell scripts to streamline setup, testing, and cleanup.

### 1. `setup.sh`

- **Purpose:** Installs Netdata on the system.
- **Usage:**

  ```bash
  chmod +x setup.sh
  ./setup.sh
  ```

### 2. `test_dashboard.sh`

- **Purpose:** Simulates system load to test the Netdata dashboard and verify metrics and alerts.
- **Requirements:** The `stress` tool must be installed. Install it with:

  ```bash
  sudo apt-get install stress
  ```

- **Usage:**

  ```bash
  chmod +x test_dashboard.sh
  ./test_dashboard.sh
  ```

- **Behavior:**  
  - Simulates CPU load with 4 workers.
  - Generates disk I/O by writing a 1GB file.
  - Runs for 60 seconds to allow sufficient time to observe dashboard changes.
  - Cleans up by stopping the stress test and removing the test file.

### 3. `cleanup.sh`

- **Purpose:** Uninstalls Netdata from the system.
- **Usage:**

  ```bash
  chmod +x cleanup.sh
  ./cleanup.sh
  ```

- **Note:** By default, the script uses `apt-get remove netdata`. For a complete removal, including configuration files, modify it to use `apt-get purge netdata`.

## How to Use This Project

You have two main options:

### Option 1: Manual Setup

- Follow the setup instructions above to install Netdata, customize the dashboard, and configure alerts.
- Open the dashboard and monitor system metrics in real time.

### Option 2: Automated Workflow

- Execute the scripts in order:

  ```bash
  ./setup.sh
  ./test_dashboard.sh
  ./cleanup.sh
  ```

- While `test_dashboard.sh` is running, visit the dashboard to observe load-induced changes and verify the CPU alert.
