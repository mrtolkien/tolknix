#!/bin/sh

# Get all non-empty workspaces
workspaces=$(aerospace list-workspaces --all --format '%{workspace}')

# Iterate over each workspace
for ws in $workspaces; do
  echo "Processing workspace: $ws"

  # Get the number of windows in the current workspace
  num_windows=$(aerospace list-windows --workspace "$ws" --count)

  echo "\tNumber of windows in workspace '$ws': $num_windows"

  aerospace flatten-workspace-tree --workspace "$ws"

  # Get one window ID in the current workspace
  window_id=$(aerospace list-windows --workspace "$ws" --format '%{window-id}' | head -n 1)

  echo "\tUsing window ID: $window_id"

  # Apply layout based on the number of windows
  if [ "$num_windows" -eq 1 ] || [ "$num_windows" -eq 2 ]; then
    aerospace layout --window-id "$window_id" h_tiles
  elif [ "$num_windows" -ge 3 ]; then
    aerospace layout --window-id "$window_id" h_accordion
  fi

done