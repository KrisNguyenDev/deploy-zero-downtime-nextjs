#!/bin/bash

# Tên của thư mục tạm thời
DIR=".next"
TEMP_DIR="temp_next"

# Kiểm tra và xử lý thư mục tạm thời
if [ -d "$TEMP_DIR" ]; then
    echo "Thư mục $TEMP_DIR đã tồn tại. Đang xóa..."
    rm -rf "$TEMP_DIR"
fi

echo "Đang tạo thư mục $TEMP_DIR..."
mkdir "$TEMP_DIR"

# Cài đặt các gói npm
echo "Đang cài đặt các gói npm..."
if npm install; then
    echo "Cài đặt hoàn tất thành công."
else
    echo "Cài đặt thất bại. Hủy bỏ quá trình."
    exit 1
fi

# Build Next.js
echo "Đang build Next.js..."
if npm run build; then
    echo "Build hoàn tất thành công."
else
    echo "Build thất bại. Hủy bỏ quá trình."
    exit 1
fi

# Kiểm tra nếu thư mục .next tồn tại
if [ -d "$DIR" ]; then
    # Xóa thư mục .next cũ
    echo "Đang xóa thư mục $DIR cũ..."
    rm -rf "$DIR"
fi

# Đổi tên thư mục tạm thời thành .next
echo "Đang đổi tên thư mục tạm thời thành $DIR..."
mv "$TEMP_DIR" "$DIR"

# Dừng và khởi động lại server
echo "Dừng server hiện tại và khởi động lại với PM2..."
BUILD_DIR="$DIR" pm2 restart ecosystem.config.js

echo "Hoàn tất! Đã build và chuyển đổi với downtime tối thiểu."