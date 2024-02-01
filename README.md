# JSON Schema Validator written in Dart/Flutter

# Application on Vercel

[JSON Schema Validator](https://json-schema-validator.vercel.app/)

# Remote schemas

To preload schema defined on some resource you can add `/validate?schema=<url>` to application address

Example: [https://json-schema-validator.vercel.app/validate?schema=https://json.schemastore.org/vsconfig.json](https://json-schema-validator.vercel.app/validate?schema=https://json.schemastore.org/vsconfig.json)

Probably you will encounter CORS errors - see next example

CORS Proxy Example: [https://json-schema-validator.vercel.app/validate?schema=https://corsproxy.io?https://json.schemastore.org/vsconfig.json](https://json-schema-validator.vercel.app/validate?schema=https://corsproxy.io?https://json.schemastore.org/vsconfig.json)
