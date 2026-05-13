#!/bin/bash
# Auto-reassembler that cleans up chunks after success

echo "🔧 Reassembling: 17111_1080p.mp4"

# Combine chunks
cat "17111_1080p.mp4".part.* > "17111_1080p.mp4"

# Verify checksum
if command -v sha256sum >/dev/null 2>&1; then
    if sha256sum -c "17111_1080p.mp4".sha256 2>/dev/null; then
        echo "✅ Success! File: 17111_1080p.mp4"
        echo "Size: $(du -h "17111_1080p.mp4" | cut -f1)"
        echo ""
        echo "🧹 Cleaning up chunks..."
        rm "17111_1080p.mp4".part.*
        echo "✅ Chunks deleted. Only the final file remains."
    else
        rm "17111_1080p.mp4"
        echo "❌ Checksum verification failed!"
        exit 1
    fi
elif command -v shasum >/dev/null 2>&1; then
    # macOS
    expected=$(cut -d' ' -f1 < "17111_1080p.mp4.sha256")
    actual=$(shasum -a 256 "17111_1080p.mp4" | cut -d' ' -f1)
    if [ "$actual" = "$expected" ]; then
        echo "✅ Success! File: 17111_1080p.mp4"
        echo "Size: $(du -h "17111_1080p.mp4" | cut -f1)"
        echo ""
        echo "🧹 Cleaning up chunks..."
        rm "17111_1080p.mp4".part.*
        echo "✅ Chunks deleted. Only the final file remains."
    else
        rm "17111_1080p.mp4"
        echo "❌ Checksum verification failed!"
        exit 1
    fi
else
    echo "⚠️  No checksum tool found, skipping verification"
    echo "✅ File reassembled: 17111_1080p.mp4"
    echo ""
    echo "🧹 Cleaning up chunks..."
    rm "17111_1080p.mp4".part.*
    echo "✅ Chunks deleted. Only the final file remains."
fi
