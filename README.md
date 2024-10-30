# KKloud Command Line Tool

`kkloud` is a command-line tool designed to simplify cloud resource management. This tool allows you to interact with your cloud infrastructure using an intuitive CLI.

## Prerequisites

- Python 3.7 or higher
- `pip` (Python package installer)

## Installation

Follow these steps to set up `kkloud` on your machine.

### 1. Get the cli 

```bash
curl -L -o kkloud-cli.tar.gz https://github.com/dataunits/kkloud/releases/download/v1.0.0/kkloud-cli.tar.gz
# Extract the .tar.gz file
tar -xzf kkloud-cli.tar.gz

cd kkloud-cli && ./get-kkloud.sh

cd .. && rm kkloud-cli.tar.gz && rm -r kkloud-cli

### 1. Get the cli for windows 

```bash
Download this link https://github.com/dataunits/kkloud/releases/download/v1.0.0/kkloud-cli.tar.gz
unzip the package and run get-kkloud.ps1
