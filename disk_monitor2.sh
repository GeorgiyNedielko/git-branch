#!/bin/bash

# Порог
THRESHOLD=70

# Email уведомления
EMAIL="your_email@example.com"

# Telegram уведомления
BOT_TOKEN="123456789:ABCDEF_YOUR_BOT_TOKEN"
CHAT_ID="123456789"

# Временный файл для отчёта
REPORT=$(mktemp)

# Получаем процент использования корневого раздела
USAGE=$(df / | awk 'NR==2 {gsub("%",""); print $5}')

# Проверка
if [ "$USAGE" -gt "$THRESHOLD" ]; then
    echo "🛑 Диск / заполнен на $USAGE%. Порог: $THRESHOLD%" | tee -a "$REPORT"
    echo -e "\n📁 ТОП-10 директорий в /:" >> "$REPORT"
    du -xh / 2>/dev/null | sort -rh | head -n 10 >> "$REPORT"

    echo -e "\n📄 ТОП-10 файлов в /:" >> "$REPORT"
    find / -type f -exec du -h {} + 2>/dev/null | sort -rh | head -n 10 >> "$REPORT"

    # Отправка Email
    if command -v mail >/dev/null 2>&1; then
        cat "$REPORT" | mail -s "⚠️ Внимание: диск / переполнен на $USAGE%" "$EMAIL"
    else
        echo "✉️ mail не установлен — пропущено уведомление по email"
    fi

    # Отправка Telegram
    if [ -n "$BOT_TOKEN" ] && [ -n "$CHAT_ID" ]; then
        curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
             -d chat_id="${CHAT_ID}" \
             -d text="⚠️ Диск / заполнен на ${USAGE}%. Проверьте сервер!"
    fi
else
    echo "✅ Использование диска ($USAGE%) в норме"
fi

# Удаляем отчёт
rm -f "$REPORT"
