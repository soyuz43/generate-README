#!/bin/bash


set -eo pipefail


Green='\033[0;32m'            # ${Green}
Yellow='\033[0;33m'           # ${Yellow}
Blue='\033[0;34m'             # ${Blue}
Purple='\033[0;35m'           # ${Purple}
Cyan='\033[0;36m'             # ${Cyan}
White='\033[0;37m'            # ${White}
# Function to extract contents of .js and .jsx files and dump into a single file
dump_jsx_js_contents() {
  local target_directory="$1"
  local output_file="$2"
  local directory_name=$(basename "$target_directory")

  # Ensure the output file does not already exist
  if [[ -f "$output_file" ]]; then
    echo "Output file $output_file already exists. Please remove or rename it and try again." >&2
    return 1
  fi

  # Create or clear the output file
  > "$output_file"

  # Find all .js and .jsx files and append their contents to the output file
  find "$target_directory" -type f \( -name "*.js" -o -name "*.jsx" \) | while read -r file; do
    echo '```' >> "$output_file"
    cat "$file" >> "$output_file"
    echo '```' >> "$output_file"
  done


  # Append the project information template
  cat >> "$output_file" <<- EOF
---
Title: $directory_name
Description:
(Generate a brief description about the purpose and main functions of the project based on the provided source code.)

Contents:
- Table of Contents generated from modules and files mentioned in the code.

Installation:
1. (List installation steps if needed, including dependencies and library requirements)
2.
3.

Usage:
1. (Describe how to use the project based on the provided source code)
2.
3.

Contributing:
1. (Include guidelines for contributing to the project, such as submitting issues or pull requests)
2.

License: (Insert License Information Here)
Version: (Insert Project Version Here)
Date: $(date +%Y-%m-%d)

replace the placeholders based on the source code provided.


Create a README in Markdown format that aligns with the simplicity of the described project, adhering to GitHub documentation standards. The README should concisely cover:

Sections to potentially omit based on content availability:
- **License**: Only include a license section if the source code specifies licensing information.
- **Acknowledgments**: Include acknowledgments only if they are explicitly mentioned in the project documentation or source code.

Ensure all content is structured using appropriate GitHub Markdown syntax:
- Use headings correctly (e.g., `#` for Level 1, `##` for Level 2).
- Use numbered lists for instructions and bullet points for lists of features or requirements.
- Implement internal links to navigate to different sections within the document efficiently.

The language should remain professional yet accessible, aiming for clarity and brevity to match the project's complexity. Avoid overcomplicating the documentation to ensure it is as straightforward as the project it describes.

---mm

EOF

  echo "All contents have been dumped into $output_file"
}

send_to_ollama() {
  local input_file="$1"
  local model="mistral-openorca:7b-q6_K"
  local api_url="http://localhost:11434/api/chat" # Ensure this is the correct API URL

  # Read the file content into a variable, escaping newlines and double quotes correctly for JSON
  local file_content=$(<"$input_file" awk '{printf "%s\\n", $0}' | sed 's/"/\\"/g')

  # Create the JSON payload with the file content embedded within
  local json_payload=$(jq -nc --arg model "$model" --arg content "$file_content" \
    '{
      model: $model,
      messages: [
        {role: "user", content: $content}
      ],
      stream: false
    }')

  # Send the data to the Ollama API using the constructed JSON payload
  curl -X POST "$api_url" -H "Content-Type: application/json" -d "$json_payload" | \
  jq --unbuffered -r '.message.content'
  echo ""
  echo ${Green}"Processed data from the Ollama API."
}


  echo ""


main() {
  local root_directory="${1:-.}" # Use current directory if not specified
  local output_filename="all_jsx_js_contents.txt"

  dump_jsx_js_contents "$root_directory" "$output_filename" || return 1

  # Ask user if they want to send the contents to the Ollama API
  read -p "Would you like to send the script to Ollama? (y/[n]): " user_response
  case "$user_response" in
    [yY][eE][sS]|[yY])
      send_to_ollama "$output_filename"
      ;;
    *)
      echo "Exiting without sending to Ollama."
      exit 0
      ;;
  esac
}

# Execute the main function with all arguments
main "$@"
