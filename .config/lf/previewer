#!/bin/sh

TMPDIR="$XDG_CACHE_HOME"
LF_PREVIEWDIR="${LF_PREVIEWDIR:-$TMPDIR/lf/previews}"
LF_PREVIEWWIDTH="${LF_PREVIEWWIDTH:-1000}"
LF_PREVIEWHEIGHT="${LF_PREVIEWHEIGHT:-560}"

exists() { type "$1" >/dev/null 2>&1; }

batorcat() {
    if exists bat; then
        bat --terminal-width="$((cols - 3))" --line-range ":$lines" \
            --style=snip --decorations=always --color=always \
            --paging=never "$@"
    else
        cat "$@"
    fi
}

pager() {
    "$@" 2>&1 | batorcat
}

# Binary file: show file info inside the pager
print_bin_info() {
    printf -- "-------- \033[1;31mBinary file\033[0m --------\n"
    if exists mediainfo; then
        mediainfo "$1" | sed "s/\s\{20\}:/:/"
    else
        file -b "$1"
    fi
}

handle_mime() {
    case "$2" in
        image/jpeg) image_preview "$cols" "$lines" "$1" ;;
        image/vnd.djvu) generate_preview "$cols" "$lines" "$1" "djvu" ;;
        image/*) generate_preview "$cols" "$lines" "$1" "image" ;;
        video/*) generate_preview "$cols" "$lines" "$1" "video" ;;
        audio/*) generate_preview "$cols" "$lines" "$1" "audio" ;;
        application/font* | application/*opentype | font/*) generate_preview "$cols" "$lines" "$1" "font" ;;
        */*office* | */*document*) generate_preview "$cols" "$lines" "$1" "office" ;;
        application/zip) unzip -l "$1" ;;
        text/troff)
            if exists man; then
                man -Pcat -l "$1"
            else
                batorcat "$1"
            fi
            ;;
        *) handle_ext "$1" "$3" "$4" ;;
    esac
}

handle_ext() {
    case "$2" in
        epub) generate_preview "$cols" "$lines" "$1" "epub" ;;
        pdf) generate_preview "$cols" "$lines" "$1" "pdf" ;;
        gz | bz2) pager tar -tvf "$1" ;;
        md) if exists glow; then
            pager glow -s dark "$1"
        elif exists lowdown; then
            pager lowdown -Tterm "$1"
        else
            batorcat "$1"
        fi ;;
        htm | html | xhtml)
            if exists w3m; then
                pager w3m "$1"
            elif exists lynx; then
                pager lynx "$1"
            elif exists elinks; then
                pager elinks "$1"
            else
                batorcat "$1"
            fi
            ;;
        7z | a | ace | alz | arc | arj | bz | cab | cpio | deb | jar | lha | lz | lzh | lzma | lzo | rar | rpm | rz | t7z | tar | tbz | tbz2 | tgz | tlz | txz | tZ | tzo | war | xpi | xz | Z)
            if exists atool; then
                pager atool -l "$1"
            elif exists bsdtar; then
                pager bsdtar -tvf "$1"
            fi
            ;;
        *) if [ "$3" = "bin" ]; then
            pager print_bin_info "$1"
        else
            batorcat "$1"
        fi ;;
    esac
}

generate_preview() {
    if [ ! -f "$LF_PREVIEWDIR/$3.jpg" ] || [ -n "$(find -L "$3" -newer "$LF_PREVIEWDIR/$3.jpg")" ]; then
        mkdir -p "$LF_PREVIEWDIR/${3%/*}"
        case $4 in
            audio) ffmpeg -i "$3" -filter_complex "scale=iw*min(1\,min($LF_PREVIEWWIDTH/iw\,ih)):-1" "$LF_PREVIEWDIR/$3.jpg" -y ;;
            epub) gnome-epub-thumbnailer "$3" "$LF_PREVIEWDIR/$3.jpg" ;;
            font) fontpreview -i "$3" -o "$LF_PREVIEWDIR/$3.jpg" ;;
            image)
                if exists convert; then
                    convert "$3" -flatten -resize "$LF_PREVIEWWIDTH"x"$LF_PREVIEWHEIGHT"\> "$LF_PREVIEWDIR/$3.jpg" >/dev/null 2>&1
                else
                    image_preview "$1" "$2" "$3"
                fi
                ;;
            office)
                libreoffice --convert-to jpg "$3" --outdir "$LF_PREVIEWDIR/${3%/*}" >/dev/null 2>&1
                filename="$(printf "%s" "${3##*/}" | cut -d. -f1)"
                mv "$LF_PREVIEWDIR/${3%/*}/$filename.jpg" "$LF_PREVIEWDIR/$3.jpg"
                ;;
            pdf) pdftoppm -jpeg -f 1 -singlefile "$3" "$LF_PREVIEWDIR/$3" ;;
            djvu) ddjvu -format=ppm -page=1 "$3" "$LF_PREVIEWDIR/$3.jpg" ;;
            video) ffmpegthumbnailer -m -s0 -i "$3" -o "$LF_PREVIEWDIR/$3.jpg" || rm "$LF_PREVIEWDIR/$3.jpg" ;;
        esac
    fi
    if [ -f "$LF_PREVIEWDIR/$3.jpg" ]; then
        image_preview "$1" "$2" "$LF_PREVIEWDIR/$3.jpg"
    else
        pager print_bin_info "$3"
    fi
}

image_preview() {
    if [ -n "$FIFO_UEBERZUG" ] && exists ueberzug; then
        ueberzug_layer "$3" "$cols" "$lines" "$x_offset" "$y_offset" && return 1
    elif exists chafa; then
        chafa -s "${cols}x${lines}" "$3"
    else
        pager print_bin_info "$3"
    fi
}

ueberzug_layer() {
    printf '{"action": "add", "identifier": "PREVIEW", "x": %d, "y": %d, "width": "%d", "height": "%d", "scaler": "contain", "path": "%s"}\n' \
        "$4" "$5" "$(($2 - 1))" "$(($3 - 1))" "$1" >"$FIFO_UEBERZUG"
}

# Detecting the exact type of the file: the encoding, mime type, and extension in lowercase.
encoding="$(file -bL --mime-encoding -- "$1")"
mimetype="$(file -bL --mime-type -- "$1")"
ext="${1##*.}"
[ -n "$ext" ] && ext="$(printf "%s" "${ext}" | tr '[:upper:]' '[:lower:]')"

file="$1"
cols="$2"
lines="$3"
x_offset="$4"
y_offset="$5"

if [ "${encoding#*)}" = "binary" ]; then
    handle_mime "$file" "$mimetype" "$ext" "bin"
else
    handle_mime "$file" "$mimetype" "$ext"
fi
