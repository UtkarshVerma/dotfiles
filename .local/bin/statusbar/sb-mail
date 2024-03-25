#!/bin/sh
# Display unread email count.

# Check internet connectivity.
if ! wget --quiet --spider https://example.org; then
    exit 1
fi

gmail_count() {
    token="$XDG_CACHE_HOME/qgmail/$1"
    [ ! -r "$token" ] && return 1

    count="$(
        qgmail --token "$token" request users.labels.get me INBOX |
            jq -r '.messagesUnread // empty'
    )"

    [ -z "$count" ] && return

    echo "$count"
}

imap_count() {
    url="$1"
    credentials="$2"
    email="$(gopass show "$credentials" user | tail -n 1)"
    password="$(gopass show --password "$credentials")"

    count="$(
        curl \
            --silent \
            --user "$email:$password" \
            --url "$url" \
            --request 'STATUS INBOX (UNSEEN)' |
            sed 's/^.*(UNSEEN \([[:digit:]]\+\)).*/\1/'
    )"

    [ "$count" -eq 0 ] && return

    echo "$count"
}

# Comma-separated <icon>:<kind>:<credentials> values.
ACCOUNTS="\
 |imaps://imap.purelymail.com|apps/sb-mail,\
 |gmail|token.json"

# Display work email details only during work hours (Mon - Fri; 9 AM - 5 PM).
hour="$(date +%H)"
day_of_the_week="$(date +%u)"
if [ "$day_of_the_week" -lt 6 ] && [ "$hour" -gt 9 ] && [ "$hour" -le 17 ]; then
    ACCOUNTS="$ACCOUNTS, |gmail|work_token.json"
fi

IFS=","
for account in $ACCOUNTS; do
    icon="${account%%|*}"
    service="${account#*|}" && service="${service%|*}"
    credentials="${account##*|}"

    count="$(
        case "$service" in
            gmail) gmail_count "$credentials" ;;
            *) imap_count "$service" "$credentials" ;;
        esac
    )"

    [ -z "$count" ] && continue

    counts="$counts${counts:+" "}$icon$count"
done

[ -z "$counts" ] && exit

. sb-theme
display "$counts"
