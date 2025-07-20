#!/bin/bash
echo "⚙️ Отчёт о системе — $(date)"
echo

echo "🖥️ Версия ОС:"
uname -a
echo

echo "⏰ Время работы системы:"
if [[ "$(uname)" == "Linux" ]]; then
  uptime -p
elif [[ "$(uname -o 2>/dev/null)" == "Msys" ]]; then
  uptime_sec=$(powershell.exe -Command "(Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime | Select-Object -ExpandProperty TotalSeconds" 2>/dev/null | tr -d '\r' | tr ',' '.')
  if [[ -n "$uptime_sec" ]]; then
    uptime_hours=$(awk "BEGIN {print int($uptime_sec/3600)}")
    echo "$uptime_hours часов"
  else
    echo "Недоступно"
  fi
else
  echo "Команда uptime недоступна"
fi
echo

echo "📊 Загруженность системы:"
if [[ "$(uname)" == "Linux" ]]; then
  uptime | awk -F'load average:' '{ print $2 }' | sed 's/^ *//'
elif [[ "$(uname -o 2>/dev/null)" == "Msys" ]]; then
  cpu_load=$(powershell.exe -Command "Get-Counter '\Processor(_Total)\% Processor Time' | Select -ExpandProperty CounterSamples | Select -ExpandProperty CookedValue" 2>/dev/null | tr -d '\r' | awk '{printf "%.1f%%", $1}')
  echo "${cpu_load:-Недоступно}"
else
  echo "Недоступно"
fi
echo

echo "💾 Занятое дисковое пространство (корневой раздел):"
df -h /
echo

echo "🔝 ТОП 5 процессов по использованию памяти:"
if [[ "$(uname)" == "Linux" ]]; then
  ps aux --sort=-%mem | head -n 6
elif [[ "$(uname -o 2>/dev/null)" == "Msys" ]]; then

powershell.exe -Command "Get-Process | Sort WS -Descending | Select -First 5 | ForEach-Object { \"{0,-6} {1,-25} {2,8} MB\" -f \$_.Id, \$_.ProcessName, [math]::Round(\$_.WS / 1MB, 2) }"

else
  echo "Недоступно"
fi
echo

echo "📈 Количество процессов:"
if [[ "$(uname)" == "Linux" ]]; then
  ps -e --no-headers | wc -l
elif [[ "$(uname -o 2>/dev/null)" == "Msys" ]]; then
  powershell.exe -Command "(Get-Process).Count"
else
  echo "Недоступно"
fi
echo

echo "👥 Количество пользователей в системе:"
if [[ "$(uname)" == "Linux" ]]; then
  who | cut -d' ' -f1 | sort | uniq | wc -l
elif [[ "$(uname -o 2>/dev/null)" == "Msys" ]]; then
  powershell.exe -Command "[Environment]::UserName" 2>/dev/null | tr -d '\r'
else
  echo "Недоступно"
fi
echo

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
    server = smtplib.SMTP("smtp.gmail.com", 587, timeout=10)
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
