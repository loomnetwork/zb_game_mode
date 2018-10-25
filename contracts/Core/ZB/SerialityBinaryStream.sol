pragma solidity ^0.4.24;

import "./../../3rdParty/Seriality/BytesToTypes.sol";
import "./../../3rdParty/Seriality/SizeOf.sol";
import "./../../3rdParty/Seriality/TypesToBytes.sol";

library SerialityBinaryStream {
    struct BinaryStream {
        bytes buffer;
        uint remainingBytes;
    }

    function readBytes(BinaryStream memory self) internal pure returns (bytes) {
        uint length = BytesToTypes.getStringSize(self.remainingBytes, self.buffer);
        bytes memory value = new bytes(length);
        BytesToTypes.bytesToString(self.remainingBytes, self.buffer, value);
        self.remainingBytes -= length;

        return value;
    }

    function readString(BinaryStream memory self) internal pure returns (string) {
        return string(readBytes(self));
    }

    function readBool(BinaryStream memory self) internal pure returns (bool) {
        bool value = BytesToTypes.bytesToBool(self.remainingBytes, self.buffer);
        self.remainingBytes -= SizeOf.sizeOfBool();
        return value;
    }

    function readInt8(BinaryStream memory self) internal pure returns (int8) {
        int8 value = BytesToTypes.bytesToInt8(self.remainingBytes, self.buffer);
        self.remainingBytes -= SizeOf.sizeOfInt(8);
        return value;
    }

    function readInt16(BinaryStream memory self) internal pure returns (int16) {
        int16 value = BytesToTypes.bytesToInt16(self.remainingBytes, self.buffer);
        self.remainingBytes -= SizeOf.sizeOfInt(16);
        return value;
    }

    function readInt32(BinaryStream memory self) internal pure returns (int32) {
        int32 value = BytesToTypes.bytesToInt32(self.remainingBytes, self.buffer);
        self.remainingBytes -= SizeOf.sizeOfInt(32);
        return value;
    }

    function readInt64(BinaryStream memory self) internal pure returns (int64) {
        int64 value = BytesToTypes.bytesToInt64(self.remainingBytes, self.buffer);
        self.remainingBytes -= SizeOf.sizeOfInt(64);
        return value;
    }

    function readUint8(BinaryStream memory self) internal pure returns (uint8) {
        uint8 value = BytesToTypes.bytesToUint8(self.remainingBytes, self.buffer);
        self.remainingBytes -= SizeOf.sizeOfInt(8);
        return value;
    }

    function readUint16(BinaryStream memory self) internal pure returns (uint16) {
        uint16 value = BytesToTypes.bytesToUint16(self.remainingBytes, self.buffer);
        self.remainingBytes -= SizeOf.sizeOfInt(16);
        return value;
    }

    function readUint32(BinaryStream memory self) internal pure returns (uint32) {
        uint32 value = BytesToTypes.bytesToUint32(self.remainingBytes, self.buffer);
        self.remainingBytes -= SizeOf.sizeOfInt(32);
        return value;
    }

    function readUint64(BinaryStream memory self) internal pure returns (uint64) {
        uint64 value = BytesToTypes.bytesToUint64(self.remainingBytes, self.buffer);
        self.remainingBytes -= SizeOf.sizeOfInt(64);
        return value;
    }

    function writeBool(BinaryStream memory self, bool value) internal pure {
        uint size = SizeOf.sizeOfBool();
        resizeIfNeeded(self, size);
        TypesToBytes.boolToBytes(self.remainingBytes, value, self.buffer);
        self.remainingBytes -= size;
    }

    function writeInt8(BinaryStream memory self, int8 value) internal pure {
        uint size = SizeOf.sizeOfInt(8);
        resizeIfNeeded(self, size);
        TypesToBytes.intToBytes(self.remainingBytes, value, self.buffer);
        self.remainingBytes -= size;
    }

    function writeInt16(BinaryStream memory self, int16 value) internal pure {
        uint size = SizeOf.sizeOfInt(16);
        resizeIfNeeded(self, size);
        TypesToBytes.intToBytes(self.remainingBytes, value, self.buffer);
        self.remainingBytes -= size;
    }

    function writeInt32(BinaryStream memory self, int32 value) internal pure {
        uint size = SizeOf.sizeOfInt(32);
        resizeIfNeeded(self, size);
        TypesToBytes.intToBytes(self.remainingBytes, value, self.buffer);
        self.remainingBytes -= size;
    }

    function writeInt64(BinaryStream memory self, int64 value) internal pure {
        uint size = SizeOf.sizeOfInt(64);
        resizeIfNeeded(self, size);
        TypesToBytes.intToBytes(self.remainingBytes, value, self.buffer);
        self.remainingBytes -= size;
    }

    function writeUint8(BinaryStream memory self, uint8 value) internal pure {
        uint size = SizeOf.sizeOfInt(8);
        resizeIfNeeded(self, size);
        TypesToBytes.uintToBytes(self.remainingBytes, value, self.buffer);
        self.remainingBytes -= size;
    }

    function writeUint16(BinaryStream memory self, uint16 value) internal pure {
        uint size = SizeOf.sizeOfInt(16);
        resizeIfNeeded(self, size);
        TypesToBytes.uintToBytes(self.remainingBytes, value, self.buffer);
        self.remainingBytes -= size;
    }

    function writeUint32(BinaryStream memory self, uint32 value) internal pure {
        uint size = SizeOf.sizeOfInt(32);
        resizeIfNeeded(self, size);
        TypesToBytes.uintToBytes(self.remainingBytes, value, self.buffer);
        self.remainingBytes -= size;
    }

    function writeUint64(BinaryStream memory self, uint64 value) internal pure {
        uint size = SizeOf.sizeOfInt(64);
        resizeIfNeeded(self, size);
        TypesToBytes.uintToBytes(self.remainingBytes, value, self.buffer);
        self.remainingBytes -= size;
    }

    function writeBytes(BinaryStream memory self, bytes value) internal pure {
        uint size = SizeOf.sizeOfString(string(value));
        resizeIfNeeded(self, size);
        TypesToBytes.stringToBytes(self.remainingBytes, value, self.buffer);
        self.remainingBytes -= size;
    }

    function writeString(BinaryStream memory self, string value) internal pure {
        writeBytes(self, bytes(value));
    }

    function resizeIfNeeded(BinaryStream memory self, uint addedSize) private pure {
        // Seriality writes all data in 32-byte words, so we have to reserve 32 bytes
        // even if writing a single byte
        uint words = addedSize / 32;
        if (addedSize % 32 != 0) {
            words++;
        }

        uint size = words * 32;

        int newOffset = int(self.remainingBytes) - int(size);
        if (newOffset >= 0)
            return;

        uint oldLength = self.buffer.length;
        uint minNewLength = oldLength + uint(-newOffset);
        uint newLength;
        if (oldLength == 0) {
            newLength = minNewLength;
        } else {
            newLength = oldLength;
        }

        while (newLength < minNewLength) {
            newLength *= 2;
        }

        bytes memory newBuffer = new bytes(newLength);
        memcpy(self.buffer, newBuffer, newLength - oldLength, oldLength);
        self.remainingBytes += newLength - oldLength;
        self.buffer = newBuffer;
    }

    function memcpy(bytes src, bytes dest, uint len, uint destStartIndex) private pure {
        uint destPtr;
        uint srcPtr;
        assembly {
            destPtr := add(dest, 0x20)
            destPtr := add(destPtr, destStartIndex)
            srcPtr := add(src, 0x20)
        }
        memcpy(srcPtr, destPtr, len);
    }

    function memcpy(uint src, uint dest, uint len) private pure {
        // Copy word-length chunks while possible
        for(; len >= 32; len -= 32) {
            assembly {
                mstore(dest, mload(src))
            }
            dest += 32;
            src += 32;
        }

        // Copy remaining bytes
        uint mask = 256 ** (32 - len) - 1;
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }
}