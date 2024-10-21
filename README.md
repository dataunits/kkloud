# KKCloud Command Line Tool

`kkloud` is a command-line tool designed to simplify cloud resource management. This tool allows you to interact with your cloud infrastructure using an intuitive CLI.

## Prerequisites

- Python 3.7 or higher
- `pip` (Python package installer)

## Installation

Follow these steps to set up `kkloud` on your machine.

### 1. Get the cli 

First, clone the repository to your local machine:

```bash
curl -L -o kkloud.tar.gz "$REPO_URL"
# Extract the .tar.gz file
tar -xzf kkloud.tar.gz

cd kkloud

./get-kkloud.sh && rm kkloud.tar.gz
