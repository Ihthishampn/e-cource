import 'dart:developer';
import 'dart:typed_data';

int getMp4Duration(Uint8List bytes) {
  try {
    int offset = 0;
    while (offset < bytes.length - 8) {
      int size = bytes[offset] << 24 | bytes[offset + 1] << 16 | bytes[offset + 2] << 8 | bytes[offset + 3];
      String type = String.fromCharCodes(bytes.sublist(offset + 4, offset + 8));
      
      log("Found atom: $type, size: $size, offset: $offset");

      int atomHeaderSize = 8;
      if (size == 1) { // 64-bit size
        int low = bytes[offset + 12] << 24 | bytes[offset + 13] << 16 | bytes[offset + 14] << 8 | bytes[offset + 15];
        size = low; // Ignore high for < 4GB files
        atomHeaderSize = 16;
      }

      if (type == 'moov') {
        offset += atomHeaderSize;
        continue;
      }

      if (type == 'mvhd') {
        int version = bytes[offset + atomHeaderSize];
        int timeScaleOffset = offset + atomHeaderSize + 4; 
        if (version == 1) {
          timeScaleOffset += 16; 
        } else {
          timeScaleOffset += 8; 
        }
        
        int timeScale = bytes[timeScaleOffset] << 24 | bytes[timeScaleOffset + 1] << 16 | bytes[timeScaleOffset + 2] << 8 | bytes[timeScaleOffset + 3];
        
        int durationOffset = timeScaleOffset + 4;
        int duration = 0;
        if (version == 1) {
          int low = bytes[durationOffset + 4] << 24 | bytes[durationOffset + 5] << 16 | bytes[durationOffset + 6] << 8 | bytes[durationOffset + 7];
          duration = low;
        } else {
          duration = bytes[durationOffset] << 24 | bytes[durationOffset + 1] << 16 | bytes[durationOffset + 2] << 8 | bytes[durationOffset + 3];
        }
        log("Duration: $duration, TimeScale: $timeScale");
        
        if (timeScale > 0) {
          return (duration / timeScale).round();
        }
        return 0;
      }
      offset += size;
    }
  } catch (e) {
    log("Error: $e");
  }
  return 0;
}

void main() async {
  // we just compile it to ensure syntax is ok. We can't run it without a file.
}
