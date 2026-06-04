#!/usr/bin/env bash

set -euo pipefail

interval="$(tmux show-option -gqv @continuum-save-interval 2>/dev/null || true)"
if [[ -z "$interval" || ! "$interval" =~ ^[0-9]+$ || "$interval" -eq 0 ]]; then
  printf 'save off'
  exit 0
fi

saved_at="$(tmux show-option -gqv @resurrect-last-save-finished-at 2>/dev/null || true)"
if [[ -z "$saved_at" || ! "$saved_at" =~ ^[0-9]+$ ]]; then
  printf 'save pending'
  exit 0
fi

now="$(date +%s)"
age="$((now - saved_at))"
if [[ "$age" -lt 0 ]]; then
  age=0
fi

if [[ "$age" -lt 60 ]]; then
  printf 'saved now'
elif [[ "$age" -lt 3600 ]]; then
  printf 'saved %dm ago' "$((age / 60))"
elif [[ "$age" -lt 86400 ]]; then
  printf 'saved %dh ago' "$((age / 3600))"
else
  printf 'saved %dd ago' "$((age / 86400))"
fi
