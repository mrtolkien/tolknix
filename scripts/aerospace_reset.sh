#!/bin/sh

# Check if AeroSpace is running and responsive
if ! aerospace list-workspaces --focused &> /dev/null; then
    echo "AeroSpace does not seem to be running or responding."
    echo "Please ensure AeroSpace is active and try again."
    exit 1
fi

# Command:
# aerospace list-windows --all --format '%{app-name} | %{app-bundle-id} | %{workspace}'
# Define the layout data based on your command output
LAYOUT_DATA="""
Beeper | com.automattic.beeper.desktop | 1-0
Code | com.microsoft.VSCode | 3-1
Discord | com.hnc.Discord | 1-0
Firefox | org.mozilla.firefox | 2-1
Ghostty | com.mitchellh.ghostty | 2-0
Notion Calendar | com.cron.electron | 1-2
Slack | com.tinyspeck.slackmacgap | 1-1
Spark Desktop | com.readdle.SparkDesktop | 1-2
Todoist | com.todoist.mac.Todoist | 1-0
YouTube Music | com.github.th-ch.youtube-music | 4-0
Zen | app.zen-browser.zen | 1-1
"""

echo "Starting layout restoration..."
echo "---"

echo "$LAYOUT_DATA" | while IFS='|' read -r app_name_field bundle_id_field target_workspace_field; do
    # Trim whitespace from fields
    app_name=$(echo "$app_name_field" | awk '{$1=$1};1')
    bundle_id=$(echo "$bundle_id_field" | awk '{$1=$1};1')
    target_workspace=$(echo "$target_workspace_field" | awk '{$1=$1};1')

    if [ -z "$bundle_id" ] || [ -z "$target_workspace" ]; then
        echo "Skipping line due to missing bundle ID or workspace: '$app_name_field | $bundle_id_field | $target_workspace_field'"
        continue
    fi

    echo "Processing: App '$app_name' (Bundle ID: $bundle_id) -> Workspace '$target_workspace'"

    # 1. Ensure the application is running. 'open -g -b' opens in background.
    echo "  Ensuring $app_name is running..."
    open -g -b "$bundle_id"

    # 2. Wait for the app to launch and have at least one window
    max_attempts=10 # Total wait time: max_attempts * sleep_interval (e.g., 10 * 0.5s = 5 seconds)
    attempt_num=0
    window_ids_output=""
    
    echo "  Waiting for $app_name window(s) to appear..."
    window_ids_output=$(aerospace list-windows --monitor all --app-bundle-id "$bundle_id" --format '%{window-id}' < /dev/null 2>/dev/null)
    until [ -n "$window_ids_output" ] || [ "$attempt_num" -ge "$max_attempts" ]; do
        attempt_num=$((attempt_num + 1))
        sleep 0.5 # Check every 0.5 seconds
        window_ids_output=$(aerospace list-windows --monitor all --app-bundle-id "$bundle_id" --format '%{window-id}' < /dev/null 2>/dev/null)
    done

    if [ -z "$window_ids_output" ]; then
        echo "  No windows found for $app_name (Bundle ID: $bundle_id) after attempting to launch and waiting. Skipping move."
        echo "---"
        continue
    fi

    echo "  Found window(s) for $app_name."

    # 3. Move each window of this application to the target workspace
    for win_id in $(echo "$window_ids_output"); do # Iterate over each line of output
        if [ -z "$win_id" ]; then continue; fi # Skip empty lines if any
        echo "  Moving window ID $win_id of $app_name to workspace $target_workspace..."
        if aerospace move-node-to-workspace --window-id "$win_id" "$target_workspace" < /dev/null; then
            echo "    Successfully moved window ID $win_id."
        else
            echo "    Failed to move window ID $win_id."
        fi
    done
    
    echo "  Finished processing $app_name."
    echo "---"
done

echo "Layout restoration script finished."