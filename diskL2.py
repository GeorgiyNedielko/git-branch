import smtplib
from email.mime.text import MIMEText

EMAIL_FROM = "georgiynge2025@gmail.com"
EMAIL_PASS = "gzowaxfgswnrtspd"
EMAIL_TO = "georgiynge2025@gmail.com"

msg = MIMEText("Тестовое письмо")
msg["Subject"] = "Тест SMTP"
msg["From"] = EMAIL_FROM
msg["To"] = EMAIL_TO

try:
    server = smtplib.SMTP("smtp.gmail.com", 587)
    server.starttls()
    server.login(EMAIL_FROM, EMAIL_PASS)
    server.sendmail(EMAIL_FROM, EMAIL_TO, msg.as_string())
    server.quit()
    print("Письмо отправлено успешно")
except Exception as e:
    print("Ошибка:", e)

# import shutil
# import os
# import smtplib
# from email.mime.text import MIMEText
# from email.mime.multipart import MIMEMultipart

# # === НАСТРОЙКИ ===
# THRESHOLD = 30  # порог заполнения в процентах
# EMAIL_TO = "georgiynge2025@gmail.com"
# EMAIL_FROM = "georgiynge2025@gmail.com"  # Твой Gmail
# EMAIL_PASS = "gzowaxfgswnrtspd"      # App Password без пробелов!
# SMTP_SERVER = "smtp.gmail.com"
# SMTP_PORT = 587
# ROOT_PATH = "/"  # Или "C:\\" для Windows
#
# # === Проверка заполненности диска ===
# total, used, free = shutil.disk_usage(ROOT_PATH)
# percent_used = used / total * 100
#
# if percent_used < THRESHOLD:
#     print(f"✅ Диск {ROOT_PATH} заполнен на {percent_used:.0f}%. Всё в порядке.")
#     exit(0)
#
# # === Функции для поиска больших директорий и файлов ===
# def get_top_dirs(path, top_n=10):
#     sizes = []
#     try:
#         for entry in os.scandir(path):
#             if entry.is_dir(follow_symlinks=False):
#                 size = get_dir_size(entry.path)
#                 sizes.append((size, entry.path))
#     except PermissionError:
#         pass
#     sizes.sort(reverse=True)
#     return sizes[:top_n]
#
# def get_dir_size(path):
#     total_size = 0
#     try:
#         for dirpath, dirnames, filenames in os.walk(path, onerror=lambda e: None):
#             for f in filenames:
#                 fp = os.path.join(dirpath, f)
#                 try:
#                     total_size += os.path.getsize(fp)
#                 except Exception:
#                     pass
#     except Exception:
#         pass
#     return total_size
#
# def get_top_files(path, top_n=10):
#     files = []
#     try:
#         for dirpath, dirnames, filenames in os.walk(path, onerror=lambda e: None):
#             for f in filenames:
#                 fp = os.path.join(dirpath, f)
#                 try:
#                     size = os.path.getsize(fp)
#                     files.append((size, fp))
#                 except Exception:
#                     pass
#     except Exception:
#         pass
#     files.sort(reverse=True)
#     return files[:top_n]
#
# def sizeof_fmt(num, suffix='B'):
#     for unit in ['','K','M','G','T']:
#         if num < 1024:
#             return f"{num:.1f}{unit}{suffix}"
#         num /= 1024
#     return f"{num:.1f}P{suffix}"
#
# # === Формируем отчёт ===
# report = []
# report.append(f"⚠️ Диск {ROOT_PATH} заполнен на {percent_used:.0f}%. Порог: {THRESHOLD}%\n")
#
# report.append("📁 ТОП-10 самых больших директорий:\n")
# for size, path in get_top_dirs(ROOT_PATH):
#     report.append(f"{sizeof_fmt(size):>10} — {path}")
#
# report.append("\n📄 ТОП-10 самых больших файлов:\n")
# for size, path in get_top_files(ROOT_PATH):
#     report.append(f"{sizeof_fmt(size):>10} — {path}")
#
# full_report = "\n".join(report)
# print(full_report)
#
# # === Отправка email ===
# msg = MIMEMultipart()
# msg["From"] = EMAIL_FROM
# msg["To"] = EMAIL_TO
# msg["Subject"] = f"⚠️ Диск {ROOT_PATH} заполнен на {percent_used:.0f}%"
# msg.attach(MIMEText(full_report, "plain"))
#
# try:
#     with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
#         server.starttls()
#         server.login(EMAIL_FROM, EMAIL_PASS)
#         server.send_message(msg)
#         print("📧 Email отправлен.")
# except Exception as e:
#     print(f"❌ Ошибка отправки email: {e}")