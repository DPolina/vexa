cd ~/vexa/hub/models--dvislobokov--faster-whisper-large-v3-turbo-russian

# Создаем стандартную структуру
mkdir -p blobs refs snapshots
SNAPSHOT_HASH=$(git hash-object -t tree --stdin < /dev/null | cut -c 1-7)
mkdir snapshots/$SNAPSHOT_HASH

# Перемещаем файлы в blobs с хешированными именами
mv added_tokens.json        blobs/$(sha1sum added_tokens.json | cut -d' ' -f1)
mv config.json              blobs/$(sha1sum config.json | cut -d' ' -f1)
mv model.bin                blobs/$(sha1sum model.bin | cut -d' ' -f1)
mv preprocessor_config.json blobs/$(sha1sum preprocessor_config.json | cut -d' ' -f1)
mv README.md                blobs/$(sha1sum README.md | cut -d' ' -f1)
mv special_tokens_map.json  blobs/$(sha1sum special_tokens_map.json | cut -d' ' -f1)
mv tokenizer_config.json    blobs/$(sha1sum tokenizer_config.json | cut -d' ' -f1)
mv vocab.json               blobs/$(sha1sum vocab.json | cut -d' ' -f1)
mv vocabulary.json          blobs/$(sha1sum vocabulary.json | cut -d' ' -f1)

# Создаем симлинки в snapshots
cd snapshots/$SNAPSHOT_HASH
ln -s ../../../blobs/* .
for file in *; do
    original_name=$(echo $file | grep -oE '[a-zA-Z0-9_-]+\.[a-z]+')
    [ -n "$original_name" ] && mv $file $original_name
done

# Создаем ссылку на текущий снапшот
echo $SNAPSHOT_HASH > ../../refs/main
