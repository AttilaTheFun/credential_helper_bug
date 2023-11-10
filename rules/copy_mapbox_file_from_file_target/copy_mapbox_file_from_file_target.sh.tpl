#!/bin/sh

# Save the runfile root:
runfile_root=$(pwd)
runfile_relative_source_file_paths=({{runfile_relative_source_file_paths}})
workspace_relative_source_file_paths=({{workspace_relative_source_file_paths}})

# When run from a test, build workspace directory is not set. 
# In that case the source copy just happens in the sandbox.
if [[ ! -z "${BUILD_WORKSPACE_DIRECTORY}" ]]; then
  cd "${BUILD_WORKSPACE_DIRECTORY}"
fi

# Copy the files into the workspace:
for i in ${!runfile_relative_source_file_paths[@]}; do
  cp -f "${runfile_root}/${runfile_relative_source_file_paths[$i]}" "${workspace_relative_source_file_paths[$i]}"
done
