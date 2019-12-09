SLACK_KEY="xoxp-755490221190-753275073456-868464454406-17e43a7715b1ffee8645f68f6a139317"
SLACK_TEXT="New APK"

curl \
  -F "token=$SLACK_KEY" \
  -F "channels=capstone-project" \
  -F "initial_comment=$SLACK_TEXT" \
  -F "file=@build/app/outputs/apk/app.apk" \
  https://slack.com/api/files.upload
