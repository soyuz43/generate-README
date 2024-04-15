# README
**Limitations:** Right now the script only concatenates .js and .jsx files, I plan to add other filetypes, as well as allowing the users to specify those filetypes, in future updates.

**Experimental:** may not function as intended. You need to have Ollama installed and have pulled `mistral-openorca:7b-q6_K`. This takes at least 16GB of Ram in my experience.

## Description

This script consolidates JavaScript and JSX files from a specified directory into a single text file, incorporating content from all files found. This tool is particularly useful for developers needing a consolidated view of scripts for review or archival purposes.

## Installation

No installation is required for this script beyond having Bash available on your system. Ensure you have `jq` and `curl` installed as these are used for JSON processing and sending data to external APIs, respectively.

## Usage

To use this script, simply run it from your command line with an optional directory parameter. If no directory is specified, the script uses the current directory by default.

```bash
./Plaintext-and-Prompt.sh [path_to_directory]
```

# Script Functionality Overview


## Execution Steps:
1. **Check for Output File Existence**:
    - Verifies whether the output file already exists.
2. **Handle Existing Output File**:
    - Offers options to either remove or rename the existing file.
3. **Search and Concatenate**:
    - Locates `.js` and `.jsx` files.
    - Merges these files into a single output file.
4. **Append Prompt Template**:
    - Adds a prompt template at the end of the file to facilitate the generation of a README displayed in the terminal.
5. **Optional API Integration**:
    - With user consent, sends the merged content to the Ollama API.

## Features
- **File Aggregation**: Merges all `.js` and `.jsx` files into one, simplifying file management.
- **Error Checking**: Prevents accidental overwrites by ensuring no pre-existing output file.
- **API Integration**: Offers optional integration with the Ollama API for enhanced functionality.

## Contributing
- Contribute to this project by forking the repository and submitting a pull request. Raise issues and suggestions via the GitHub issue tracker.

## Notes
- **Dependencies**: Requires `jq` and `curl`.
- **API Integration**: Must be properly configured if using the Ollama API feature.

## Version
- **Development Phase**: Alpha
- Note: This alpha version may contain incomplete features and bugs.

## License
- **MIT License**:
    - This script is open-sourced under the MIT License, permitting modification and distribution for any purpose, provided the original copyright notice and the license are included.

---
