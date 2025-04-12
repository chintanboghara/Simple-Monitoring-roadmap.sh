#!/bin/bash
# Check if stress is installed
if ! command -v stress &> /dev/null; then
    echo "stress is not installed. Please install it with 'sudo apt-get install stress'."
    exit 1
fi

# Generate CPU load with 4 workers
stress --cpu 4 &
STRESS_PID=$!

# Generate disk I/O (1GB file)
dd if=/dev/zero of=/tmp/testfile bs=1M count=1024

# Wait 60 seconds to observe dashboard
sleep 60

# Clean up
kill $STRESS_PID
rm /tmp/testfile
