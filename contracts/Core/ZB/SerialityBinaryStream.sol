pragma solidity ^0.4.24;

import "./../../3rdParty/Seriality/BytesToTypes.sol";
import "./../../3rdParty/Seriality/SizeOf.sol";
import "./../../3rdParty/Seriality/TypesToBytes.sol";

library SerialityBinaryStream {
    struct BinaryStream {
        bytes buffer;
        uint offset;
    }

    function readString(BinaryStream memory self) internal pure returns (string) {
        uint stringLength = BytesToTypes.getStringSize(self.offset, self.buffer);
        string memory value = new string(stringLength);
        BytesToTypes.bytesToString(self.offset, self.buffer, bytes(value));
        self.offset -= stringLength;

        return value;
    }

    function readBool(BinaryStream memory self) internal pure returns (bool) {
        bool value = BytesToTypes.bytesToBool(self.offset, self.buffer);
        self.offset -= SizeOf.sizeOfBool();
        return value;
    }

    function readInt8(BinaryStream memory self) internal pure returns (int8) {
        int8 value = BytesToTypes.bytesToInt8(self.offset, self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);
        return value;
    }

    function readInt32(BinaryStream memory self) internal pure returns (int32) {
        int32 value = BytesToTypes.bytesToInt32(self.offset, self.buffer);
        self.offset -= SizeOf.sizeOfInt(32);
        return value;
    }

    function readInt64(BinaryStream memory self) internal pure returns (int64) {
        int64 value = BytesToTypes.bytesToInt64(self.offset, self.buffer);
        self.offset -= SizeOf.sizeOfInt(64);
        return value;
    }

    function readUint8(BinaryStream memory self) internal pure returns (uint8) {
        uint8 value = BytesToTypes.bytesToUint8(self.offset, self.buffer);
        self.offset -= SizeOf.sizeOfInt(8);
        return value;
    }

    function readUint32(BinaryStream memory self) internal pure returns (uint32) {
        uint32 value = BytesToTypes.bytesToUint32(self.offset, self.buffer);
        self.offset -= SizeOf.sizeOfInt(32);
        return value;
    }

    function readUint64(BinaryStream memory self) internal pure returns (uint64) {
        uint64 value = BytesToTypes.bytesToUint64(self.offset, self.buffer);
        self.offset -= SizeOf.sizeOfInt(64);
        return value;
    }

    function writeBool(BinaryStream memory self, bool value) internal pure {
        uint size = SizeOf.sizeOfBool();
        TypesToBytes.boolToBytes(self.offset, value, self.buffer);
        self.offset -= size;
    }

    function writeInt8(BinaryStream memory self, int8 value) internal pure {
        uint size = SizeOf.sizeOfInt(8);
        TypesToBytes.intToBytes(self.offset, value, self.buffer);
        self.offset -= size;
    }

    function writeInt32(BinaryStream memory self, int32 value) internal pure {
        uint size = SizeOf.sizeOfInt(32);
        TypesToBytes.intToBytes(self.offset, value, self.buffer);
        self.offset -= size;
    }

    function writeInt64(BinaryStream memory self, int64 value) internal pure {
        uint size = SizeOf.sizeOfInt(64);
        TypesToBytes.intToBytes(self.offset, value, self.buffer);
        self.offset -= size;
    }

    function writeUint8(BinaryStream memory self, uint8 value) internal pure {
        uint size = SizeOf.sizeOfInt(8);
        TypesToBytes.uintToBytes(self.offset, value, self.buffer);
        self.offset -= size;
    }

    function writeUint32(BinaryStream memory self, uint32 value) internal pure {
        uint size = SizeOf.sizeOfInt(32);
        TypesToBytes.uintToBytes(self.offset, value, self.buffer);
        self.offset -= size;
    }

    function writeUint64(BinaryStream memory self, uint64 value) internal pure {
        uint size = SizeOf.sizeOfInt(64);
        TypesToBytes.uintToBytes(self.offset, value, self.buffer);
        self.offset -= size;
    }

    function writeString(BinaryStream memory self, string value) internal pure {
        uint size = SizeOf.sizeOfString(value);
        TypesToBytes.stringToBytes(self.offset, bytes(value), self.buffer);
        self.offset -= size;
    }

    function memcpy(bytes src, bytes dest, uint len, uint offset) private pure {
        uint destPtr;
        uint srcPtr;
        assembly {
            destPtr := add(dest, 0x20)
            destPtr := add(destPtr, offset)
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