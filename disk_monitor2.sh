
#!/bin/bash

# Порог
THRESHOLD=70

# Email уведомления
EMAIL="georgiynge2025@gmail.com"

# Временный файл для отчёта
REPORT=$(mktemp)

# Получаем процент использования корневого раздела
USAGE=$(df -P / | tail -1 | awk '{print $(NF-1)}' | tr -d '%')

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

else
    echo "✅ Использование диска ($USAGE%) в норме"
fi

# Удаляем отчёт
rm -f "$REPORT"
