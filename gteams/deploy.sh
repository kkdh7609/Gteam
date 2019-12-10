SLACK_KEY="xoxp-755490221190-753275073456-866523130101-6d045dfb7f0933643f372bb36a32b132"
SLACK_TEXT="New APK"

curl \
  -F "token=$SLACK_KEY" \
  -F "channels=#capstone-project" \
  -F "initial_comment=$SLACK_TEXT" \
  -F "file=@build/app/outputs/apk/release/app-release.apk" \
  https://slack.com/api/files.upload
