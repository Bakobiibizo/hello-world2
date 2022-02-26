# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: signing.proto
"""Generated protocol buffer code."""
from google.protobuf import descriptor as _descriptor
from google.protobuf import descriptor_pool as _descriptor_pool
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database


# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


DESCRIPTOR = _descriptor_pool.Default().AddSerializedFile(
    b'\n\rsigning.proto\x12\x1b\x61\x65\x61.open_aea.signing.v1_0_0"\xbc\x0c\n\x0eSigningMessage\x12O\n\x05\x65rror\x18\x05 \x01(\x0b\x32>.aea.open_aea.signing.v1_0_0.SigningMessage.Error_PerformativeH\x00\x12]\n\x0csign_message\x18\x06 \x01(\x0b\x32\x45.aea.open_aea.signing.v1_0_0.SigningMessage.Sign_Message_PerformativeH\x00\x12\x65\n\x10sign_transaction\x18\x07 \x01(\x0b\x32I.aea.open_aea.signing.v1_0_0.SigningMessage.Sign_Transaction_PerformativeH\x00\x12\x61\n\x0esigned_message\x18\x08 \x01(\x0b\x32G.aea.open_aea.signing.v1_0_0.SigningMessage.Signed_Message_PerformativeH\x00\x12i\n\x12signed_transaction\x18\t \x01(\x0b\x32K.aea.open_aea.signing.v1_0_0.SigningMessage.Signed_Transaction_PerformativeH\x00\x1a\xbd\x01\n\tErrorCode\x12W\n\nerror_code\x18\x01 \x01(\x0e\x32\x43.aea.open_aea.signing.v1_0_0.SigningMessage.ErrorCode.ErrorCodeEnum"W\n\rErrorCodeEnum\x12 \n\x1cUNSUCCESSFUL_MESSAGE_SIGNING\x10\x00\x12$\n UNSUCCESSFUL_TRANSACTION_SIGNING\x10\x01\x1a!\n\nRawMessage\x12\x13\n\x0braw_message\x18\x01 \x01(\x0c\x1a)\n\x0eRawTransaction\x12\x17\n\x0fraw_transaction\x18\x01 \x01(\x0c\x1a\'\n\rSignedMessage\x12\x16\n\x0esigned_message\x18\x01 \x01(\x0c\x1a/\n\x11SignedTransaction\x12\x1a\n\x12signed_transaction\x18\x01 \x01(\x0c\x1a\x16\n\x05Terms\x12\r\n\x05terms\x18\x01 \x01(\x0c\x1a\xb6\x01\n\x1dSign_Transaction_Performative\x12@\n\x05terms\x18\x01 \x01(\x0b\x32\x31.aea.open_aea.signing.v1_0_0.SigningMessage.Terms\x12S\n\x0fraw_transaction\x18\x02 \x01(\x0b\x32:.aea.open_aea.signing.v1_0_0.SigningMessage.RawTransaction\x1a\xaa\x01\n\x19Sign_Message_Performative\x12@\n\x05terms\x18\x01 \x01(\x0b\x32\x31.aea.open_aea.signing.v1_0_0.SigningMessage.Terms\x12K\n\x0braw_message\x18\x02 \x01(\x0b\x32\x36.aea.open_aea.signing.v1_0_0.SigningMessage.RawMessage\x1a|\n\x1fSigned_Transaction_Performative\x12Y\n\x12signed_transaction\x18\x01 \x01(\x0b\x32=.aea.open_aea.signing.v1_0_0.SigningMessage.SignedTransaction\x1ap\n\x1bSigned_Message_Performative\x12Q\n\x0esigned_message\x18\x01 \x01(\x0b\x32\x39.aea.open_aea.signing.v1_0_0.SigningMessage.SignedMessage\x1a_\n\x12\x45rror_Performative\x12I\n\nerror_code\x18\x01 \x01(\x0b\x32\x35.aea.open_aea.signing.v1_0_0.SigningMessage.ErrorCodeB\x0e\n\x0cperformativeb\x06proto3'
)


_SIGNINGMESSAGE = DESCRIPTOR.message_types_by_name["SigningMessage"]
_SIGNINGMESSAGE_ERRORCODE = _SIGNINGMESSAGE.nested_types_by_name["ErrorCode"]
_SIGNINGMESSAGE_RAWMESSAGE = _SIGNINGMESSAGE.nested_types_by_name["RawMessage"]
_SIGNINGMESSAGE_RAWTRANSACTION = _SIGNINGMESSAGE.nested_types_by_name["RawTransaction"]
_SIGNINGMESSAGE_SIGNEDMESSAGE = _SIGNINGMESSAGE.nested_types_by_name["SignedMessage"]
_SIGNINGMESSAGE_SIGNEDTRANSACTION = _SIGNINGMESSAGE.nested_types_by_name[
    "SignedTransaction"
]
_SIGNINGMESSAGE_TERMS = _SIGNINGMESSAGE.nested_types_by_name["Terms"]
_SIGNINGMESSAGE_SIGN_TRANSACTION_PERFORMATIVE = _SIGNINGMESSAGE.nested_types_by_name[
    "Sign_Transaction_Performative"
]
_SIGNINGMESSAGE_SIGN_MESSAGE_PERFORMATIVE = _SIGNINGMESSAGE.nested_types_by_name[
    "Sign_Message_Performative"
]
_SIGNINGMESSAGE_SIGNED_TRANSACTION_PERFORMATIVE = _SIGNINGMESSAGE.nested_types_by_name[
    "Signed_Transaction_Performative"
]
_SIGNINGMESSAGE_SIGNED_MESSAGE_PERFORMATIVE = _SIGNINGMESSAGE.nested_types_by_name[
    "Signed_Message_Performative"
]
_SIGNINGMESSAGE_ERROR_PERFORMATIVE = _SIGNINGMESSAGE.nested_types_by_name[
    "Error_Performative"
]
_SIGNINGMESSAGE_ERRORCODE_ERRORCODEENUM = _SIGNINGMESSAGE_ERRORCODE.enum_types_by_name[
    "ErrorCodeEnum"
]
SigningMessage = _reflection.GeneratedProtocolMessageType(
    "SigningMessage",
    (_message.Message,),
    {
        "ErrorCode": _reflection.GeneratedProtocolMessageType(
            "ErrorCode",
            (_message.Message,),
            {
                "DESCRIPTOR": _SIGNINGMESSAGE_ERRORCODE,
                "__module__": "signing_pb2"
                # @@protoc_insertion_point(class_scope:aea.open_aea.signing.v1_0_0.SigningMessage.ErrorCode)
            },
        ),
        "RawMessage": _reflection.GeneratedProtocolMessageType(
            "RawMessage",
            (_message.Message,),
            {
                "DESCRIPTOR": _SIGNINGMESSAGE_RAWMESSAGE,
                "__module__": "signing_pb2"
                # @@protoc_insertion_point(class_scope:aea.open_aea.signing.v1_0_0.SigningMessage.RawMessage)
            },
        ),
        "RawTransaction": _reflection.GeneratedProtocolMessageType(
            "RawTransaction",
            (_message.Message,),
            {
                "DESCRIPTOR": _SIGNINGMESSAGE_RAWTRANSACTION,
                "__module__": "signing_pb2"
                # @@protoc_insertion_point(class_scope:aea.open_aea.signing.v1_0_0.SigningMessage.RawTransaction)
            },
        ),
        "SignedMessage": _reflection.GeneratedProtocolMessageType(
            "SignedMessage",
            (_message.Message,),
            {
                "DESCRIPTOR": _SIGNINGMESSAGE_SIGNEDMESSAGE,
                "__module__": "signing_pb2"
                # @@protoc_insertion_point(class_scope:aea.open_aea.signing.v1_0_0.SigningMessage.SignedMessage)
            },
        ),
        "SignedTransaction": _reflection.GeneratedProtocolMessageType(
            "SignedTransaction",
            (_message.Message,),
            {
                "DESCRIPTOR": _SIGNINGMESSAGE_SIGNEDTRANSACTION,
                "__module__": "signing_pb2"
                # @@protoc_insertion_point(class_scope:aea.open_aea.signing.v1_0_0.SigningMessage.SignedTransaction)
            },
        ),
        "Terms": _reflection.GeneratedProtocolMessageType(
            "Terms",
            (_message.Message,),
            {
                "DESCRIPTOR": _SIGNINGMESSAGE_TERMS,
                "__module__": "signing_pb2"
                # @@protoc_insertion_point(class_scope:aea.open_aea.signing.v1_0_0.SigningMessage.Terms)
            },
        ),
        "Sign_Transaction_Performative": _reflection.GeneratedProtocolMessageType(
            "Sign_Transaction_Performative",
            (_message.Message,),
            {
                "DESCRIPTOR": _SIGNINGMESSAGE_SIGN_TRANSACTION_PERFORMATIVE,
                "__module__": "signing_pb2"
                # @@protoc_insertion_point(class_scope:aea.open_aea.signing.v1_0_0.SigningMessage.Sign_Transaction_Performative)
            },
        ),
        "Sign_Message_Performative": _reflection.GeneratedProtocolMessageType(
            "Sign_Message_Performative",
            (_message.Message,),
            {
                "DESCRIPTOR": _SIGNINGMESSAGE_SIGN_MESSAGE_PERFORMATIVE,
                "__module__": "signing_pb2"
                # @@protoc_insertion_point(class_scope:aea.open_aea.signing.v1_0_0.SigningMessage.Sign_Message_Performative)
            },
        ),
        "Signed_Transaction_Performative": _reflection.GeneratedProtocolMessageType(
            "Signed_Transaction_Performative",
            (_message.Message,),
            {
                "DESCRIPTOR": _SIGNINGMESSAGE_SIGNED_TRANSACTION_PERFORMATIVE,
                "__module__": "signing_pb2"
                # @@protoc_insertion_point(class_scope:aea.open_aea.signing.v1_0_0.SigningMessage.Signed_Transaction_Performative)
            },
        ),
        "Signed_Message_Performative": _reflection.GeneratedProtocolMessageType(
            "Signed_Message_Performative",
            (_message.Message,),
            {
                "DESCRIPTOR": _SIGNINGMESSAGE_SIGNED_MESSAGE_PERFORMATIVE,
                "__module__": "signing_pb2"
                # @@protoc_insertion_point(class_scope:aea.open_aea.signing.v1_0_0.SigningMessage.Signed_Message_Performative)
            },
        ),
        "Error_Performative": _reflection.GeneratedProtocolMessageType(
            "Error_Performative",
            (_message.Message,),
            {
                "DESCRIPTOR": _SIGNINGMESSAGE_ERROR_PERFORMATIVE,
                "__module__": "signing_pb2"
                # @@protoc_insertion_point(class_scope:aea.open_aea.signing.v1_0_0.SigningMessage.Error_Performative)
            },
        ),
        "DESCRIPTOR": _SIGNINGMESSAGE,
        "__module__": "signing_pb2"
        # @@protoc_insertion_point(class_scope:aea.open_aea.signing.v1_0_0.SigningMessage)
    },
)
_sym_db.RegisterMessage(SigningMessage)
_sym_db.RegisterMessage(SigningMessage.ErrorCode)
_sym_db.RegisterMessage(SigningMessage.RawMessage)
_sym_db.RegisterMessage(SigningMessage.RawTransaction)
_sym_db.RegisterMessage(SigningMessage.SignedMessage)
_sym_db.RegisterMessage(SigningMessage.SignedTransaction)
_sym_db.RegisterMessage(SigningMessage.Terms)
_sym_db.RegisterMessage(SigningMessage.Sign_Transaction_Performative)
_sym_db.RegisterMessage(SigningMessage.Sign_Message_Performative)
_sym_db.RegisterMessage(SigningMessage.Signed_Transaction_Performative)
_sym_db.RegisterMessage(SigningMessage.Signed_Message_Performative)
_sym_db.RegisterMessage(SigningMessage.Error_Performative)

if _descriptor._USE_C_DESCRIPTORS == False:

    DESCRIPTOR._options = None
    _SIGNINGMESSAGE._serialized_start = 47
    _SIGNINGMESSAGE._serialized_end = 1643
    _SIGNINGMESSAGE_ERRORCODE._serialized_start = 551
    _SIGNINGMESSAGE_ERRORCODE._serialized_end = 740
    _SIGNINGMESSAGE_ERRORCODE_ERRORCODEENUM._serialized_start = 653
    _SIGNINGMESSAGE_ERRORCODE_ERRORCODEENUM._serialized_end = 740
    _SIGNINGMESSAGE_RAWMESSAGE._serialized_start = 742
    _SIGNINGMESSAGE_RAWMESSAGE._serialized_end = 775
    _SIGNINGMESSAGE_RAWTRANSACTION._serialized_start = 777
    _SIGNINGMESSAGE_RAWTRANSACTION._serialized_end = 818
    _SIGNINGMESSAGE_SIGNEDMESSAGE._serialized_start = 820
    _SIGNINGMESSAGE_SIGNEDMESSAGE._serialized_end = 859
    _SIGNINGMESSAGE_SIGNEDTRANSACTION._serialized_start = 861
    _SIGNINGMESSAGE_SIGNEDTRANSACTION._serialized_end = 908
    _SIGNINGMESSAGE_TERMS._serialized_start = 910
    _SIGNINGMESSAGE_TERMS._serialized_end = 932
    _SIGNINGMESSAGE_SIGN_TRANSACTION_PERFORMATIVE._serialized_start = 935
    _SIGNINGMESSAGE_SIGN_TRANSACTION_PERFORMATIVE._serialized_end = 1117
    _SIGNINGMESSAGE_SIGN_MESSAGE_PERFORMATIVE._serialized_start = 1120
    _SIGNINGMESSAGE_SIGN_MESSAGE_PERFORMATIVE._serialized_end = 1290
    _SIGNINGMESSAGE_SIGNED_TRANSACTION_PERFORMATIVE._serialized_start = 1292
    _SIGNINGMESSAGE_SIGNED_TRANSACTION_PERFORMATIVE._serialized_end = 1416
    _SIGNINGMESSAGE_SIGNED_MESSAGE_PERFORMATIVE._serialized_start = 1418
    _SIGNINGMESSAGE_SIGNED_MESSAGE_PERFORMATIVE._serialized_end = 1530
    _SIGNINGMESSAGE_ERROR_PERFORMATIVE._serialized_start = 1532
    _SIGNINGMESSAGE_ERROR_PERFORMATIVE._serialized_end = 1627
# @@protoc_insertion_point(module_scope)
