#!/usr/bin/env bash
#
# apply_screenshots.sh — Menaruh screenshot desain TARA ke repo Flutter.
#
# Jalankan dari DALAM repo Flutter Anda (folder yang berisi pubspec.yaml), mis:
#   bash apply_screenshots.sh
#
# Skrip ini:
#   1. Menyalin 28 PNG ke  docs/design/screenshots/  (folder aset referensi).
#   2. Merename dari  NN-nama.png  ->  <snake_case>_screen.png .
#   3. Jika folder lib/screens (atau screens) ada, ia mencocokkan nama file
#      Dart yang ada supaya penamaan PNG persis sama dengan screen-nya.
#
set -eo pipefail

# Lokasi PNG sumber = folder tempat skrip ini berada.
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Folder tujuan di repo Flutter (ubah bila perlu).
DEST_DIR="${1:-docs/design/screenshots}"

# Peta: nama-file-screenshot  ->  basis nama screen (snake_case, tanpa _screen).
# Sesuaikan sisi kanan bila nama screen di repo Anda berbeda.
declare -A MAP=(
  [01-splash]=splash
  [02-onboarding]=onboarding
  [03-login]=login
  [04-register]=register
  [05-verify]=verify
  [06-consent]=consent
  [07-forgot]=forgot_password
  [08-reset]=reset_password
  [09-profile-setup]=profile_setup
  [10-accessibility]=accessibility
  [11-home]=home
  [12-checkin]=checkin
  [13-tara-ai]=tara_ai
  [14-agent-process]=agent_process
  [15-tara-space]=tara_space
  [16-followup]=followup
  [17-journal]=journal
  [18-bisindo]=bisindo
  [19-garden]=garden
  [20-screening]=screening
  [21-care]=care
  [22-safety]=safety
  [23-profile]=profile
  [24-edit-profile]=edit_profile
  [25-help]=help
  [26-about]=about
  [27-privacy]=privacy
  [28-notifications]=notifications
)

if [ ! -f pubspec.yaml ]; then
  echo "PERINGATAN: pubspec.yaml tidak ditemukan di direktori ini."
  echo "Jalankan skrip ini dari root repo Flutter Anda. Lanjut? (Ctrl+C untuk batal)"
  read -r _
fi

# Cari folder screens untuk memvalidasi nama (opsional).
SCREENS_DIR=""
for d in lib/screens lib/src/screens lib/presentation/screens screens; do
  [ -d "$d" ] && SCREENS_DIR="$d" && break
done
[ -n "$SCREENS_DIR" ] && echo "Folder screens terdeteksi: $SCREENS_DIR"

mkdir -p "$DEST_DIR"
count=0

for png in "$SRC_DIR"/[0-9][0-9]-*.png; do
  base="$(basename "$png" .png)"          # mis. 11-home
  target="${MAP[$base]:-}"                 # mis. home
  [ -z "$target" ] && { echo "lewati (tak dipetakan): $base"; continue; }

  name="${target}_screen"                  # konvensi Flutter: home_screen.png

  # Jika ada file Dart yang cocok, pakai basename-nya persis.
  if [ -n "$SCREENS_DIR" ]; then
    match="$(find "$SCREENS_DIR" -maxdepth 2 -name "${target}*.dart" 2>/dev/null | head -n1 || true)"
    [ -n "$match" ] && name="$(basename "$match" .dart)"
  fi

  cp "$png" "$DEST_DIR/${name}.png"
  echo "  $base.png  ->  $DEST_DIR/${name}.png"
  count=$((count+1))
done

echo ""
echo "Selesai: $count screenshot disalin ke $DEST_DIR"
