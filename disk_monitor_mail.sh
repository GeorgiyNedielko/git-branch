#!/bin/bash

# Порог использования в процентах
THRESHOLD=20

# Email для уведомлений
EMAIL="georgiynge2025@gmail.com"

# Временный файл для отчета
REPORT=$(mktemp)

# Получаем процент использования /
USAGE=$(df -P / | tail -1 | awk '{print $(NF-1)}' | tr -d '%')

# Проверка: если использование больше порога
if [ "$USAGE" -gt "$THRESHOLD" ]; then
    echo "⚠️ Диск / заполнен на ${USAGE}%. Порог: ${THRESHOLD}%" | tee -a "$REPORT"

    echo -e "\n🔍 ТОП-10 самых больших директорий в /home /var /opt:" >> "$REPORT"
    du -xh /home /var /opt 2>/dev/null | sort -rh | head -n 10 >> "$REPORT"

    echo -e "\n📦 ТОП-10 самых больших файлов в /home /var /opt:" >> "$REPORT"
    find /home /var /opt -type f -exec du -h {} + 2>/dev/null | sort -rh | head -n 10 >> "$REPORT"

    # Проверка наличия утилиты mail и отправка письма
    if command -v mail >/dev/null 2>&1; then
        mail -s "⚠️ Диск / заполнен на ${USAGE}%" "$EMAIL" < "$REPORT"
    else
        echo "❗ Утилита 'mail' не найдена. Установите её для отправки уведомлений." | tee -a "$REPORT"
    fi
else
    echo "✅ Диск / заполнен на ${USAGE}%. Всё в порядке." | tee -a "$REPORT"
fi

# Вывод отчета на экран
cat "$REPORT"

# Удаляем временный файл
rm -f "$REPORT"

