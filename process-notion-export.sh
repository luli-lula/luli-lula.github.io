#!/bin/bash

# Notion导出处理脚本
# 用法: ./process-notion-export.sh

set -e

# 配置路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NOTION_DIR="$SCRIPT_DIR/notion-import"
POSTS_DIR="$SCRIPT_DIR/content/posts"
IMAGES_DIR="$SCRIPT_DIR/assets/images"
TEMP_DIR="$NOTION_DIR/temp"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 获取下一个文章编号
get_next_number() {
    cd "$POSTS_DIR"
    # 直接从文件名开头提取数字，避免处理特殊字符
    LAST_NUMBER=$(ls -1 [0-9][0-9][0-9]-*.md 2>/dev/null | sed 's/^\([0-9]\{3\}\)-.*/\1/' | sort -n | tail -1)
    if [ -z "$LAST_NUMBER" ] || ! [[ "$LAST_NUMBER" =~ ^[0-9]+$ ]]; then
        echo "001"
    else
        # 去掉前导零，然后加1
        LAST_NUMBER=$((10#$LAST_NUMBER))
        printf "%03d" $((LAST_NUMBER + 1))
    fi
}

# 清理文件名中的特殊字符
sanitize_filename() {
    local title="$1"
    # 替换或删除文件名中不安全的字符
    title="${title//&/and}"           # & -> and
    title="${title//\"/}"             # 删除引号
    title="${title//\'/}"             # 删除单引号
    title="${title//\</}"             # 删除 <
    title="${title//\>/}"             # 删除 >
    title="${title//\|/}"             # 删除 |
    title="${title//\?/}"             # 删除 ?
    title="${title//\*/}"             # 删除 *
    title="${title//:/}"              # 删除 :
    title="${title//\\\\/}"           # 删除反斜杠
    title="${title//\//}"             # 删除正斜杠
    echo "$title"
}

# 复制并重命名图片
copy_and_rename_images() {
    local md_file="$1"
    local post_number="$2"
    local image_counter=1
    
    log_info "处理图片..."
    
    # 获取解压目录路径
    local temp_dir=$(dirname "$md_file")
    
    # 创建临时映射文件用于批量替换
    local temp_mapping="/tmp/image_mapping_$$"
    > "$temp_mapping"
    
    # 首先分析文章中的图片引用顺序
    log_info "分析文章中的图片引用顺序..."
    local image_order=()
    local temp_order_file="/tmp/image_order_$$"
    
    # 提取文章中的图片引用，保持顺序
    grep -o '!\[[^]]*\]([^)]*)' "$md_file" | sed 's/!\[[^]]*\]//g' | sed 's/[()]//g' > "$temp_order_file"
    
    # 读取图片引用顺序
    while IFS= read -r image_ref; do
        if [[ -n "$image_ref" ]]; then
            # 提取文件名（去掉路径和URL编码）
            local filename=$(basename "$image_ref" | sed 's/%20/ /g')
            image_order+=("$filename")
        fi
    done < "$temp_order_file"
    
    # 如果没有找到图片引用，回退到原来的方法
    if [ ${#image_order[@]} -eq 0 ]; then
        log_warning "未找到图片引用，使用文件系统顺序..."
        while IFS= read -r -d '' image_file; do
            if [[ -f "$image_file" ]]; then
                local filename=$(basename "$image_file")
                image_order+=("$filename")
            fi
        done < <(find "$temp_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.heic" \) -print0 2>/dev/null)
    fi
    
    log_info "找到 ${#image_order[@]} 张图片，按文章顺序处理..."
    
    # 按文章中的顺序处理图片
    for filename in "${image_order[@]}"; do
        # 在临时目录中查找对应的图片文件
        local image_file=""
        while IFS= read -r -d '' found_file; do
            local found_filename=$(basename "$found_file")
            if [[ "$found_filename" == "$filename" ]]; then
                image_file="$found_file"
                break
            fi
        done < <(find "$temp_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.heic" \) -print0 2>/dev/null)
        
        if [[ -n "$image_file" && -f "$image_file" ]]; then
            local extension="${image_file##*.}"
            local new_image_name=""
            local local_path=""
            
            # 处理HEIC格式，转换为JPEG
            if [[ "${extension}" == "heic" ]] || [[ "${extension}" == "HEIC" ]]; then
                new_image_name="${post_number}-image-$(printf "%02d" $image_counter).jpeg"
                local_path="$IMAGES_DIR/$new_image_name"
                
                log_info "转换HEIC图片 $image_counter: $(basename "$image_file") -> $new_image_name"
                
                # 使用sips转换HEIC到JPEG
                if command -v sips &> /dev/null; then
                    if sips -s format jpeg "$image_file" --out "$local_path" &>/dev/null; then
                        log_success "HEIC转换成功: $new_image_name"
                    else
                        log_warning "HEIC转换失败，尝试直接复制..."
                        if cp "$image_file" "$local_path" 2>/dev/null; then
                            log_success "图片已保存: $new_image_name"
                        else
                            log_warning "图片复制失败: $image_file"
                            continue
                        fi
                    fi
                else
                    log_warning "sips命令不可用，尝试直接复制HEIC文件..."
                    if cp "$image_file" "$local_path" 2>/dev/null; then
                        log_success "图片已保存: $new_image_name"
                    else
                        log_warning "图片复制失败: $image_file"
                        continue
                    fi
                fi
            else
                # 处理其他格式的图片
                new_image_name="${post_number}-image-$(printf "%02d" $image_counter).${extension}"
                local_path="$IMAGES_DIR/$new_image_name"
                
                log_info "处理图片 $image_counter: $(basename "$image_file") -> $new_image_name"
                
                # 复制图片到assets/images/
                if cp "$image_file" "$local_path" 2>/dev/null; then
                    log_success "图片已保存: $new_image_name"
                else
                    log_warning "图片复制失败: $image_file"
                    continue
                fi
            fi
            
            # 记录原始文件名和新文件名的映射关系
            echo "$filename|/images/$new_image_name" >> "$temp_mapping"
            
            ((image_counter++))
        else
            log_warning "未找到对应的图片文件: $filename"
        fi
    done
    
    # 批量替换图片引用
    if [[ -s "$temp_mapping" ]]; then
        log_info "更新图片引用..."
        while IFS='|' read -r original_name new_path; do
            # 处理各种可能的引用格式
            local encoded_name=$(echo "$original_name" | sed 's/ /%20/g')
            
            # 更全面的替换模式，处理所有可能的图片引用格式
            sed -i '' \
                -e "s|!\[[^]]*\]([^)]*/${original_name})|![图片](${new_path})|g" \
                -e "s|!\[[^]]*\]([^)]*/${encoded_name})|![图片](${new_path})|g" \
                -e "s|!\[${original_name}\]([^)]*)|![图片](${new_path})|g" \
                -e "s|!\[[^]]*\](${original_name})|![图片](${new_path})|g" \
                -e "s|!\[[^]]*\](${encoded_name})|![图片](${new_path})|g" \
                "$md_file"
        done < "$temp_mapping"
        
        # 记录处理完成
        log_success "图片引用更新完成"
    fi
    
    # 清理临时文件
    rm -f "$temp_mapping"
    rm -f "$temp_order_file"
}

# 修复frontmatter格式
fix_frontmatter() {
    local md_file="$1"
    local title="$2"
    local post_number="$3"
    
    log_info "修复frontmatter格式..."
    
    # 获取当前时间
    local current_date=$(date -u +"%Y-%m-%dT%H:%M:%S+00:00")
    
    # 创建新的frontmatter (不包含cover)
    local new_frontmatter="---
title: \"$title\"
date: $current_date
tags: [\"Life\"]
author: \"Me\"
showToc: false
TocOpen: false
draft: false
UseHugoToc: false
---"
    
    # 如果文件有frontmatter，替换它；如果没有，添加到开头
    if grep -q "^---" "$md_file"; then
        # 删除现有的frontmatter
        sed -i '' '1,/^---$/d' "$md_file"
        sed -i '' '1,/^---$/d' "$md_file"
    fi
    
    # 删除文件开头的标题行和Notion元数据
    # 删除以 # 开头的标题行
    sed -i '' '/^# /d' "$md_file"
    # 删除 Tags: 行
    sed -i '' '/^Tags:/d' "$md_file"
    # 删除 Date: 行
    sed -i '' '/^Date:/d' "$md_file"
    # 删除空行（连续的空行合并为一个）
    sed -i '' '/^$/N;/^\n$/d' "$md_file"
    
    # 添加新的frontmatter
    echo -e "$new_frontmatter\n$(cat "$md_file")" > "$md_file"
    
    # 最后清理图片引用格式，将长文件名作为alt text改为简洁描述
    sed -i '' 's/!\[[0-9]\+-[^]]*\.\(jpg\|jpeg\|png\|gif\|webp\|heic\)\]/![图片]/g' "$md_file"
    
    # 清理可能的HEIC引用，确保都指向JPEG文件
    sed -i '' 's|/images/[0-9]\+-image-[0-9]\+\.heic|/images/&|g' "$md_file"
    sed -i '' 's|\.heic|.jpeg|g' "$md_file"
}

# 主处理函数
process_notion_export() {
    log_info "开始处理Notion导出文件..."
    
    # 检查notion-import文件夹中的zip文件
    cd "$NOTION_DIR"
    ZIP_FILES=(*.zip)
    
    if [ ! -f "${ZIP_FILES[0]}" ]; then
        log_error "在 $NOTION_DIR 中没有找到zip文件"
        log_info "请将Notion导出的zip文件放到: $NOTION_DIR"
        exit 1
    fi
    
    # 处理第一个zip文件
    ZIP_FILE="${ZIP_FILES[0]}"
    log_info "找到zip文件: $ZIP_FILE"
    
    # 创建临时目录
    rm -rf "$TEMP_DIR"
    mkdir -p "$TEMP_DIR"
    
    # 解压文件 - 处理中文字符编码问题
    log_info "解压文件..."
    
    # 检查是否有python可以用来解压（处理编码更好）
    if command -v python3 &> /dev/null; then
        log_info "使用Python解压以处理中文文件名..."
        python3 -c "
import zipfile
import os
import sys

zip_path = '$ZIP_FILE'
extract_path = '$TEMP_DIR'

try:
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        for member in zip_ref.namelist():
            # 尝试不同的编码
            try:
                filename = member.encode('cp437').decode('utf-8')
            except:
                try:
                    filename = member.encode('cp437').decode('gbk')
                except:
                    filename = member
            
            # 创建正确的路径
            target_path = os.path.join(extract_path, filename)
            
            # 确保目录存在
            os.makedirs(os.path.dirname(target_path), exist_ok=True)
            
            # 如果是文件，解压
            if not member.endswith('/'):
                with zip_ref.open(member) as source, open(target_path, 'wb') as target:
                    target.write(source.read())
                    
    print('SUCCESS')
except Exception as e:
    print(f'ERROR: {e}')
    sys.exit(1)
" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            log_success "Python解压成功"
        else
            log_warning "Python解压失败，尝试unzip..."
            # 回退到unzip
            unzip -q "$ZIP_FILE" -d "$TEMP_DIR" 2>/dev/null || {
                log_error "解压失败，请检查zip文件"
                exit 1
            }
        fi
    else
        # 尝试不同的unzip选项
        if ! unzip -O UTF-8 -q "$ZIP_FILE" -d "$TEMP_DIR" 2>/dev/null; then
            log_warning "UTF-8解压失败，尝试默认解压..."
            if ! unzip -q "$ZIP_FILE" -d "$TEMP_DIR" 2>/dev/null; then
                log_error "解压失败，请检查zip文件是否损坏"
                exit 1
            fi
        fi
    fi
    
    # 查找md文件，处理可能的编码问题
    MD_FILES=()
    while IFS= read -r -d '' file; do
        MD_FILES+=("$file")
    done < <(find "$TEMP_DIR" -name "*.md" -print0 2>/dev/null)
    
    # 如果没找到.md文件，尝试查找所有文件并过滤
    if [ ${#MD_FILES[@]} -eq 0 ]; then
        log_warning "没有找到.md文件，尝试查找所有文件..."
        while IFS= read -r -d '' file; do
            if [[ "$file" == *.md ]]; then
                MD_FILES+=("$file")
            fi
        done < <(find "$TEMP_DIR" -type f -print0 2>/dev/null)
    fi
    
    if [ ${#MD_FILES[@]} -eq 0 ]; then
        log_error "在解压后的文件中没有找到.md文件"
        exit 1
    fi
    
    # 处理每个md文件
    for md_file in "${MD_FILES[@]}"; do
        log_info "处理文件: $(basename "$md_file")"
        
        # 获取文章编号
        POST_NUMBER=$(get_next_number)
        
        # 从文件名或内容中提取标题
        RAW_TITLE=$(basename "$md_file" .md)
        
        # 移除文件名末尾的UUID部分
        RAW_TITLE=$(echo "$RAW_TITLE" | sed 's/ [a-f0-9]\{32\}$//g')
        
        # 如果标题看起来像UUID，尝试从文件内容中获取标题
        if [[ $RAW_TITLE =~ ^[a-f0-9-]{36}$ ]] || [[ -z "$RAW_TITLE" ]]; then
            # 尝试从文件第一行获取标题
            FIRST_LINE=$(head -n 1 "$md_file")
            if [[ $FIRST_LINE =~ ^#\ (.+)$ ]]; then
                RAW_TITLE="${BASH_REMATCH[1]}"
            else
                # 提示用户输入标题
                echo -n "请输入文章标题: "
                read RAW_TITLE
            fi
        fi
        
        # 清理文件名中的特殊字符
        TITLE=$(sanitize_filename "$RAW_TITLE")
        
        log_info "原始标题: $RAW_TITLE"
        log_info "清理后标题: $TITLE"
        log_info "文章编号: $POST_NUMBER"
        
        # 复制并重命名图片
        copy_and_rename_images "$md_file" "$POST_NUMBER"
        
        # 修复frontmatter (使用原始标题，不是清理后的)
        fix_frontmatter "$md_file" "$RAW_TITLE" "$POST_NUMBER"
        
        # 生成最终文件名
        FINAL_FILENAME="${POST_NUMBER}-${TITLE}.zh.md"
        FINAL_PATH="$POSTS_DIR/$FINAL_FILENAME"
        
        # 移动文件到posts目录
        cp "$md_file" "$FINAL_PATH"
        log_success "文章已创建: $FINAL_FILENAME"
        
        # 显示文件路径
        log_info "文件路径: $FINAL_PATH"
        
        # 不自动打开文件，只显示路径
        log_info "可使用以下命令编辑文件: code \"$FINAL_PATH\""
    done
    
    # 清理临时文件
    log_info "清理临时文件..."
    rm -rf "$TEMP_DIR"
    
    # 保留zip文件用于调试
    log_info "zip文件已保留: $ZIP_FILE"
    
    log_success "处理完成！"
}

# 检查依赖
check_dependencies() {
    if ! command -v unzip &> /dev/null; then
        log_error "需要unzip来解压文件"
        exit 1
    fi
}

# 主程序
main() {
    echo "==================================="
    echo "  Notion导出文件处理脚本"
    echo "==================================="
    
    check_dependencies
    process_notion_export
    
    echo "==================================="
    echo "  处理完成！"
    echo "==================================="
}

# 如果脚本被直接执行（不是被source）
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi