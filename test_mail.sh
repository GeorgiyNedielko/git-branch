#!/bin/bash

# Путь до Python интерпретатора
PYTHON="/c/Users/georg/PyCharmMiscProject/.venv/Scripts/python.exe"

# Временный Python-скрипт
TMP_SCRIPT=$(mktemp --suffix=.py)

# Создаем временный Python-скрипт
cat <<EOF > "$TMP_SCRIPT"
import smtplib
from email.mime.text import MIMEText

EMAIL_FROM = "georgiynge2025@gmail.com"
EMAIL_PASS = "gzowaxfgswnrtspd"
EMAIL_TO = "georgiynge2025@gmail.com"

msg = MIMEText("📬 Это тестовое письмо из Bash через Python!")
msg["Subject"] = "✅ Тест из Git Bash"
msg["From"] = EMAIL_FROM
msg["To"] = EMAIL_TO

try:
    server = smtplib.SMTP("smtp.gmail.com", 587)
    server.starttls()
    server.login(EMAIL_FROM, EMAIL_PASS)
    server.sendmail(EMAIL_FROM, EMAIL_TO, msg.as_string())
    server.quit()
    print("📧 Письмо отправлено!")
except Exception as e:
    print("❌ Ошибка:", e)
EOF

# Запускаем Python-скрипт
"$PYTHON" "$TMP_SCRIPT"

# Удаляем временный файл
rm "$TMP_SCRIPT"
